# Operational Scripts — Implementation Specification

**Status:** BINDING — Implement exactly as specified. Deviations require pre-registered waivers.
**Version:** 1.0
**Date:** 2026-07-23
**Source:** 6-lens audit synthesis + DATA-OPERATIONS-ARCHITECTURE.md v1.1

---

## TABLE OF CONTENTS

1. [Design Philosophy](#1-design-philosophy)
2. [Shared Infrastructure](#2-shared-infrastructure)
3. [Script 1: preflight-check](#3-script-1-preflight-check)
4. [Script 2: freshness-audit](#4-script-2-freshness-audit)
5. [Script 3: validate-schema](#5-script-3-validate-schema)
6. [Script 4: clean-raw-fetches](#6-script-4-clean-raw-fetches)
7. [Script 5: generate-quality-dashboard](#7-script-5-generate-quality-dashboard)
8. [Integration Testing](#8-integration-testing)
9. [Acceptance Criteria](#9-acceptance-criteria)

---

## 1. Design Philosophy

### 1.1 The Google SRE Approach: Software Engineering for Operations

These scripts are NOT shell one-liners. They are production software that happens to be written in bash/Python. Every script follows the **Google SRE model** of treating operations as a software engineering problem:

1. **Idempotent by design.** Running the same script twice with the same inputs produces the same result and does not corrupt state. Scripts can be safely re-run after a crash.
2. **Explicit error boundaries.** Every external call (file read, YAML parse, HTTP request) has a defined failure mode. Errors are caught, logged, and surfaced — never silently swallowed.
3. **Observable outputs.** Scripts emit structured output (JSON lines to stdout, structured YAML to files) that machines can parse. Human-readable messages go to stderr. Never mix the two.
4. **Graceful degradation.** If a non-critical dependency is unavailable, the script continues with a degraded result and logs the gap. Critical failures exit with a non-zero code and a machine-parseable error object.
5. **Testable in isolation.** Every script accepts a `--dry-run` flag that validates inputs, checks dependencies, and reports what WOULD happen without mutating state.

### 1.2 The Stripe API Design Principle: Contract-First

Every script has a **contract** — a defined input schema, output schema, exit code convention, and error schema. The contract is the source of truth. Implementation follows contract.

**Exit code convention (standardized across all 5 scripts):**

| Exit Code | Meaning | Machine Action |
|---|---|---|
| 0 | SUCCESS — all checks passed, no blocking issues | Proceed |
| 1 | BLOCKED — blocking issue found, do not proceed | Halt pipeline |
| 2 | WARNING — non-blocking issue found, proceed with caution | Proceed, log warning |
| 3 | INTERNAL_ERROR — script itself failed (bug, missing dependency) | Escalate to Wesley |
| 4 | INVALID_INPUT — arguments or input files malformed | Fix inputs, re-run |

### 1.3 The Netflix Chaos Engineering Principle: Assume Failure

Every script is built with the assumption that the filesystem might be corrupted, YAML might be malformed, and dependencies might be missing. The scripts are designed to:

1. **Validate inputs before processing.** Check that files exist, are parseable, and contain required fields BEFORE iterating.
2. **Fail fast on corruption.** If a critical data file is corrupted, exit immediately with a specific error — do not process partial data.
3. **Leave a forensic trail.** Every mutation logs: timestamp, script name, action taken, before-state, after-state. The trail is append-only and human-readable.

### 1.4 Language Choice

**Python 3.10+** for all 5 scripts. Rationale:
- YAML parsing: Python's `ruamel.yaml` preserves comments and maintains round-trip fidelity (critical for files like CREDIT_BUDGET.yaml that carry inline comments — per G-014, `yaml.safe_dump` destroys comments).
- JSON Schema validation: Python's `jsonschema` library is the reference implementation.
- Content hashing: Python's `hashlib` provides SHA-256 with a clean API.
- Date arithmetic: Python's `datetime` + `dateutil` handle ISO 8601, SLA duration parsing, and timezone awareness correctly.
- Testability: Python scripts are trivially importable as modules for pytest-based testing.

**Exception:** If Python 3.10+ is unavailable in the execution environment, fall back to bash 5.0+ with `yq` (the Go-based YAML processor, not the Python wrapper) for YAML operations. The bash fallback is documented inline.

---

## 2. Shared Infrastructure

### 2.1 Common Library Module

All 5 scripts share a common Python module at `_pipelines/lib/pipeline_ops.py`. This module provides:

```python
"""
pipeline_ops.py — Shared library for ClarityRev Niche Pipeline operations.
Google SRE pattern: common infrastructure extracted into a library,
not copy-pasted across scripts.
"""

import os
import sys
import hashlib
import json
import subprocess
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Optional, Dict, Any, List, Tuple
from enum import Enum

# Third-party (install via pip in virtualenv)
try:
    from ruamel.yaml import YAML
    yaml = YAML()
    yaml.preserve_quotes = True
    yaml.width = 4096  # Prevent line wrapping
except ImportError:
    print("FATAL: ruamel.yaml required. Install: pip install ruamel.yaml", file=sys.stderr)
    sys.exit(3)

# --- Constants ---

PROGRAM_ROOT = Path(os.environ.get(
    "NICHE_PROGRAM_ROOT",
    Path(__file__).resolve().parent.parent.parent  # _pipelines/ -> research/ -> niche-program/
))

RESEARCH_DIR = PROGRAM_ROOT / "research"
PROGRAM_DIR = RESEARCH_DIR / "_program"
SHARED_DIR = RESEARCH_DIR / "SHARED"
PIPELINES_DIR = RESEARCH_DIR / "_pipelines"
SCHEMAS_DIR = PROGRAM_ROOT / "schemas"
FIRECRAWL_DIR = Path(".firecrawl")   # Relative to repo root
DATAFORSEO_DIR = Path(".dataforseo") # Relative to repo root

# --- Exit Codes (Stripe API Design: contract-first) ---

class ExitCode(Enum):
    SUCCESS = 0
    BLOCKED = 1
    WARNING = 2
    INTERNAL_ERROR = 3
    INVALID_INPUT = 4

# --- Freshness SLA Table (from DATA-OPERATIONS-ARCHITECTURE.md §6.1) ---

FRESHNESS_SLA = {
    "D-01": {"data_type": "competitor_pricing",       "class": "PRICING",    "max_age_days": 90,  "staleness_action": "RE_FETCH",      "re_fetch_priority": "HIGH"},
    "D-02": {"data_type": "competitor_positioning",    "class": "CAPABILITY", "max_age_days": 90,  "staleness_action": "RE_FETCH",      "re_fetch_priority": "MEDIUM"},
    "D-03": {"data_type": "reviews_voc",              "class": "REVIEW",     "max_age_days": 180, "staleness_action": "PASS_FLAG",      "re_fetch_priority": "LOW"},
    "D-04": {"data_type": "news_intent",              "class": "INTENT",     "max_age_days": 14,  "staleness_action": "RE_FETCH_BLOCK", "re_fetch_priority": "HIGHEST"},
    "D-05": {"data_type": "job_postings",             "class": "JOB",        "max_age_days": 7,   "staleness_action": "RE_FETCH_BLOCK", "re_fetch_priority": "HIGHEST"},
    "D-06": {"data_type": "market_sizing",            "class": "MARKET",     "max_age_days": 180, "staleness_action": "PASS_FLAG",      "re_fetch_priority": "LOW"},
    "D-07": {"data_type": "technographics",           "class": "TECHNO",     "max_age_days": 180, "staleness_action": "RE_FETCH",      "re_fetch_priority": "LOW"},
    "D-08": {"data_type": "company_registry",         "class": "REGISTRY",   "max_age_days": 90,  "staleness_action": "RE_FETCH",      "re_fetch_priority": "MEDIUM"},
    "D-09": {"data_type": "seo_keyword",              "class": "SEO",        "max_age_days": 90,  "staleness_action": "RE_FETCH",      "re_fetch_priority": "MEDIUM"},
    "D-10": {"data_type": "job_role_data",            "class": "PROFILE",    "max_age_days": 30,  "staleness_action": "RE_FETCH",      "re_fetch_priority": "HIGH"},
    "D-11": {"data_type": "funding_financial",        "class": "FUNDING",    "max_age_days": 90,  "staleness_action": "RE_FETCH",      "re_fetch_priority": "MEDIUM"},
    "D-12": {"data_type": "hiring_signals",           "class": "HIRING",     "max_age_days": 7,   "staleness_action": "RE_FETCH_BLOCK", "re_fetch_priority": "HIGHEST"},
    "D-13": {"data_type": "competitor_positioning",    "class": "POSITION",   "max_age_days": 90,  "staleness_action": "PASS_FLAG",      "re_fetch_priority": "LOW"},
    "D-14": {"data_type": "regulatory_data",          "class": "REGULATORY", "max_age_days": 365, "staleness_action": "PASS_FLAG",      "re_fetch_priority": "LOW"},
    "D-15": {"data_type": "certifications",           "class": "CERT",       "max_age_days": 365, "staleness_action": "PASS_FLAG",      "re_fetch_priority": "LOW"},
}

# BLOCK-class data types: stale + re-fetch failure = BLOCKED (hard enforcement)
BLOCK_CLASS_DATA_TYPES = {"INTENT", "JOB", "HIRING"}

# Data types eligible for stale-but-unchanged re-certification (SLA >= 90 days)
RECERTIFIABLE_CLASSES = {"MARKET", "REVIEW", "CERT", "REGULATORY", "POSITION", "TECHNO", "FUNDING"}

# --- URL Normalization (for cache-key computation) ---

def normalize_url(url: str) -> str:
    """
    Canonicalize a URL for cache-key purposes.
    Strips: tracking params (utm_*, fbclid, gclid, ref, source),
    session IDs, timestamps. Sorts remaining query params.
    """
    from urllib.parse import urlparse, parse_qs, urlencode, urlunparse
    parsed = urlparse(url)
    # Strip tracking params
    TRACKING_PARAMS = {'utm_source', 'utm_medium', 'utm_campaign', 'utm_term',
                       'utm_content', 'fbclid', 'gclid', 'ref', 'source', '_ga',
                       '_gl', 'mc_cid', 'mc_eid', 'session_id', 'timestamp', 't'}
    query_params = {k: v for k, v in parse_qs(parsed.query).items()
                    if k not in TRACKING_PARAMS}
    # Sort for deterministic output
    sorted_query = urlencode(sorted(query_params.items()), doseq=True)
    normalized = urlunparse((
        parsed.scheme.lower(),
        parsed.netloc.lower(),
        parsed.path.rstrip('/') or '/',
        parsed.params,
        sorted_query,
        ''  # Drop fragment
    ))
    return normalized

# --- Content Hashing ---

def compute_content_hash(file_path: Path) -> str:
    """SHA-256 hash of file contents. Returns 'sha256:hexdigest'."""
    sha = hashlib.sha256()
    with open(file_path, 'rb') as f:
        for chunk in iter(lambda: f.read(8192), b''):
            sha.update(chunk)
    return f"sha256:{sha.hexdigest()}"

def compute_url_hash(url: str) -> str:
    """SHA-256 hash of a normalized URL string. Used for cache-manifest keys."""
    normalized = normalize_url(url)
    return f"sha256:{hashlib.sha256(normalized.encode()).hexdigest()}"

# --- YAML Helpers ---

def load_yaml_safe(file_path: Path) -> Optional[Dict[str, Any]]:
    """
    Load a YAML file with ruamel.yaml (comment-preserving).
    Returns None if file doesn't exist. Raises on parse error.
    """
    if not file_path.exists():
        return None
    try:
        with open(file_path, 'r') as f:
            return yaml.load(f)
    except Exception as e:
        raise ValueError(f"YAML parse error in {file_path}: {e}")

def write_yaml_atomic(data: Dict[str, Any], file_path: Path):
    """
    Atomic write pattern (Design Principle 7):
    Write to .tmp, validate, then rename.
    """
    tmp_path = file_path.with_suffix(file_path.suffix + '.tmp')
    try:
        with open(tmp_path, 'w') as f:
            yaml.dump(data, f)
        # Validate: re-read the tmp file to confirm it's valid YAML
        with open(tmp_path, 'r') as f:
            yaml.load(f)
        # Atomic rename
        tmp_path.rename(file_path)
    except Exception as e:
        # Clean up tmp file on failure
        if tmp_path.exists():
            tmp_path.unlink()
        raise ValueError(f"Atomic write failed for {file_path}: {e}")

# --- Structured Output (JSON Lines to stdout) ---

def emit_result(exit_code: ExitCode, data: Dict[str, Any]):
    """Emit a structured result line to stdout. Machine-parseable."""
    result = {
        "script": Path(sys.argv[0]).name,
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "exit_code": exit_code.value,
        "exit_code_name": exit_code.name,
        **data
    }
    print(json.dumps(result))
    sys.exit(exit_code.value)

def emit_log(level: str, message: str):
    """Emit a human-readable log line to stderr."""
    ts = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    print(f"[{ts}] [{level}] {message}", file=sys.stderr)

# --- Date Helpers ---

def parse_iso_date(date_str: str) -> datetime:
    """Parse ISO 8601 date string to datetime. Handles YYYY-MM-DD and full ISO."""
    # Strip time if present, keep only date portion for SLA calculations
    date_str = date_str.strip()[:10]
    return datetime.strptime(date_str, "%Y-%m-%d").replace(tzinfo=timezone.utc)

def days_between(d1: datetime, d2: datetime) -> int:
    """Absolute days between two datetimes."""
    return abs((d2 - d1).days)

def parse_sla_duration(duration_str: str) -> int:
    """Parse SLA duration string like '90d', '180d', '365d', '14d' to days."""
    if duration_str.endswith('d'):
        return int(duration_str[:-1])
    raise ValueError(f"Cannot parse SLA duration: {duration_str}")

def parse_max_age(max_age_str) -> int:
    """Parse max_age from SLA table — may be int or string like '90d'."""
    if isinstance(max_age_str, int):
        return max_age_str
    return parse_sla_duration(str(max_age_str))

# --- Argument Parsing ---

def parse_args(script_name: str, usage: str, required_args: List[str] = None):
    """
    Standardized argument parsing with --dry-run support.
    Returns (args_dict, dry_run: bool).
    """
    args = sys.argv[1:]
    dry_run = False
    if '--dry-run' in args:
        dry_run = True
        args.remove('--dry-run')

    if required_args and len(args) < len(required_args):
        emit_log("ERROR", f"Usage: {usage}")
        emit_result(ExitCode.INVALID_INPUT, {"error": f"Expected {len(required_args)} arguments, got {len(args)}"})

    return {name: args[i] if i < len(args) else None for i, name in enumerate(required_args or [])}, dry_run
```

### 2.2 Directory Structure After Implementation

```
niche-program/research/_pipelines/
├── IMPLEMENTATION-SPEC.md           # This document
├── lib/
│   ├── __init__.py
│   └── pipeline_ops.py             # Shared library (above)
├── preflight-check                 # Script 1 (Python, executable)
├── freshness-audit                 # Script 2 (Python, executable)
├── validate-schema                 # Script 3 (Python, executable)
├── clean-raw-fetches               # Script 4 (Python, executable)
├── generate-quality-dashboard      # Script 5 (Python, executable)
├── CACHE_MANIFEST.yaml             # Cache manifest (created by preflight-check)
├── dedup-manifest.yaml             # Deduplication manifest (existing)
├── RUNBOOK.md                      # Incident recovery procedures (existing)
└── test/
    ├── test_preflight_check.py
    ├── test_freshness_audit.py
    ├── test_validate_schema.py
    ├── test_clean_raw_fetches.py
    └── test_quality_dashboard.py
```

---

## 3. Script 1: preflight-check

### 3.1 Contract

**Purpose:** Determine whether a credit-consuming fetch operation should proceed. Answers three questions:
1. Is fresh data already cached? → Skip fetch, save credits.
2. Are sufficient credits available? → Block fetch if below threshold.
3. Is the target host dead? → Block fetch if host is in dead-host registry.

**Invocation:**
```bash
./preflight-check NICHE_ID DATA_TYPE [--target-url URL] [--dry-run]
```

**Input:**
| Parameter | Required | Description |
|---|---|---|
| `NICHE_ID` | Yes | Niche identifier (N-001 through N-025, or CAL-A, CAL-B) |
| `DATA_TYPE` | Yes | Controlled vocabulary from §3.2 file naming convention (e.g., `competitor-pricing`, `review-corpus`, `market-sizing`) |
| `--target-url URL` | No | URL being fetched. Required for dead-host check + URL-normalized cache lookup. If omitted, dead-host check is skipped. |
| `--dry-run` | No | Validate inputs, report what WOULD happen, exit 0. No state mutation. |

**Output (stdout):** JSON Lines object with fields:
```json
{
  "script": "preflight-check",
  "timestamp": "2026-07-23T14:30:00Z",
  "exit_code": 0,
  "exit_code_name": "SUCCESS",
  "verdict": "PROCEED",
  "cache_status": "MISS",
  "credit_check": "PASS",
  "dead_host_check": "PASS",
  "niche_id": "N-001",
  "data_type": "competitor-pricing",
  "estimated_credits": 15,
  "credits_remaining": 98500
}
```

**Verdict values:** `PROCEED` (go ahead), `SKIP_CACHE_HIT` (fresh data exists, skip fetch), `BLOCKED_CREDITS` (insufficient credits), `BLOCKED_DEAD_HOST` (target host is dead), `BLOCKED_STALE_UNRECOVERABLE` (data is stale AND re-fetch previously failed for BLOCK-class data type).

### 3.2 Implementation Specification

#### Step 1: Input Validation

```
FUNCTION validate_inputs(niche_id, data_type, target_url):
    1. Verify NICHE_ID matches pattern: ^(N-\d{3}|CAL-[AB])$
       - If no match → emit_result(INVALID_INPUT, {error: "Invalid NICHE_ID format"})
    2. Verify DATA_TYPE is in the controlled vocabulary list
       - Load CONTROLLED_VOCABULARY from pipeline_ops.py
       - If not found → emit_result(INVALID_INPUT, {error: "Unknown DATA_TYPE", valid_values: [...]})
    3. If --target-url provided:
       - Parse with urllib.parse.urlparse()
       - Verify scheme is http or https
       - If invalid → emit_result(INVALID_INPUT, {error: "Invalid URL format"})
    4. Verify NICHE_ID directory exists: niche-program/research/{NICHE_ID}/
       - If not → emit_result(INVALID_INPUT, {error: "Niche directory not found"})
```

#### Step 2: Cache Check (URL-Normalized, Content-Addressed)

This is the critical improvement over the DRAFT stub. The DRAFT used file-name-pattern matching (`ls N-XXX/*/N-XXX-{DATA_TYPE}-*.yaml`) which fails when:
- Dynamically generated URLs produce new file names (cache key never matches)
- Partial files from crashed writes pass the existence check
- Two different URLs could produce the same file name pattern

**The Netflix Chaos Engineering fix:** Replace file-name-pattern with URL-normalized content-addressed cache.

```
FUNCTION check_cache(niche_id, data_type, target_url):
    1. Load CACHE_MANIFEST from _pipelines/CACHE_MANIFEST.yaml
       - If file doesn't exist → CREATE empty manifest: {entries: {}}
       - If file exists but fails YAML parse → emit_result(INTERNAL_ERROR, {error: "CACHE_MANIFEST.yaml corrupted"})

    2. IF target_url IS provided:
       a. Compute url_hash = compute_url_hash(target_url)  # Normalized URL → SHA-256
       b. Look up url_hash in manifest.entries
       c. IF entry found:
          - Check if the structured data file referenced by the entry EXISTS
          - If file exists:
            * Read fetch_date from the structured data file
            * Look up SLA max_age for this data_type from FRESHNESS_SLA table
            * Compute fresh_until = fetch_date + max_age_days
            * If now() < fresh_until:
              → Return CACHE_HIT: {verdict: "SKIP_CACHE_HIT", structured_file: path, fresh_until: date}
            * Else:
              → Return CACHE_STALE: {verdict: "PROCEED", reason: "Data expired on {fresh_until}"}
          - If file does NOT exist (orphaned manifest entry):
            * Remove the orphaned entry from manifest
            * Write updated manifest
            → Return CACHE_MISS: {verdict: "PROCEED", reason: "Cached file missing"}
       c. ELSE (no manifest entry for this URL):
          → Return CACHE_MISS: {verdict: "PROCEED", reason: "No cache entry for URL"}

    3. ELSE (no target_url provided):
       a. Fall back to file-name-pattern check (legacy behavior):
          - Glob: niche-program/research/{NICHE_ID}/*/_{NICHE_ID}-{DATA_TYPE}-*.yaml
          - For each matching file:
            * Check if file is a valid YAML
            * Check if file has fresh_until field and is not .tmp
            * If fresh → Return CACHE_HIT
          - If no fresh file found → Return CACHE_MISS
       b. emit_log("WARNING", "No --target-url provided; using legacy file-pattern cache check. This is less reliable. Provide --target-url for URL-normalized cache lookups.")
```

**Cache manifest schema (`_pipelines/CACHE_MANIFEST.yaml`):**
```yaml
# CACHE_MANIFEST.yaml — URL-normalized cache index
# Maps url_hash → structured_data_file. Used by preflight-check for cache-hit decisions.
# url_hash = SHA-256(normalize_url(url))
entries:
  "sha256:a1b2c3...":  # url_hash
    structured_file: "N-001/02-competitor-intel/N-001-competitor-profile-syncgtm-v1.yaml"
    original_url: "https://syncgtm.com"
    normalized_url: "https://syncgtm.com/"
    fetch_date: "2026-07-23"
    fresh_until: "2026-10-21"
    content_hash: "sha256:e5f6g7h8..."
    created_by: "preflight-check"
    created_at: "2026-07-23T14:30:00Z"
```

#### Step 3: Credit Balance Check

```
FUNCTION check_credits(data_type):
    1. Load CREDIT_BUDGET.yaml from _program/CREDIT_BUDGET.yaml
       - If file doesn't exist → emit_result(INTERNAL_ERROR, {error: "CREDIT_BUDGET.yaml not found. Has Phase 0 been run?"})
       - If file fails YAML parse → emit_result(INTERNAL_ERROR, {error: "CREDIT_BUDGET.yaml corrupted"})

    2. Extract firecrawl_remaining and dataforseo_remaining
       - If fields are missing → emit_result(INTERNAL_ERROR, {error: "CREDIT_BUDGET.yaml missing required fields"})

    3. Look up estimated cost for this DATA_TYPE from the TOOL-TO-TASK cost table:
       - Load from pipeline_ops.py ESTIMATED_COSTS dict (derived from DATA-OPERATIONS-ARCHITECTURE.md §2.3)
       - If DATA_TYPE not in table → assume 5 credits (conservative default)

    4. Check thresholds:
       - Firecrawl remaining < 2000 → WARNING (exit code 2): "Credit balance below 2,000. Request replenishment."
       - Firecrawl remaining < estimated_cost → BLOCKED (exit code 1): "Insufficient credits for this operation."
       - Firecrawl remaining < 5000 AND this is a Phase 2 operation → WARNING: "Approaching GATE-1→2 threshold."

    5. Return {credits_remaining, estimated_cost, threshold_status}
```

#### Step 4: Dead-Host Registry Check

```
FUNCTION check_dead_host(target_url):
    1. IF target_url IS None → SKIP (return PASS with note: "No URL provided, dead-host check skipped")

    2. Load DEAD_HOST_REGISTRY.yaml from _program/DEAD_HOST_REGISTRY.yaml
       - If file doesn't exist → CREATE empty registry → return PASS
       - If file fails YAML parse → emit_result(INTERNAL_ERROR, {error: "DEAD_HOST_REGISTRY.yaml corrupted"})

    3. Extract hostname from target_url
    4. Check if hostname is in the registry:
       - For each entry, check if current_date < blocked_until
       - If match found:
         * Check if host is Firecrawl or DataForSEO base URL:
           → NEVER auto-block primary tools. Manual confirmation required.
           → Return WARNING: "Host matches dead-host registry but is a primary tool. Manual review required."
         * Otherwise:
           → Return BLOCKED: "Host {hostname} is in dead-host registry until {blocked_until}."

    5. Return PASS
```

#### Step 5: Verdict Assembly

```
FUNCTION assemble_verdict():
    Combine results from Steps 2-4:
    - If cache_status == CACHE_HIT → VERDICT = SKIP_CACHE_HIT (exit 0)
    - If credit_check == BLOCKED → VERDICT = BLOCKED_CREDITS (exit 1)
    - If dead_host_check == BLOCKED → VERDICT = BLOCKED_DEAD_HOST (exit 1)
    - If all PASS → VERDICT = PROCEED (exit 0)
    - If any WARNING → VERDICT = PROCEED_WITH_WARNINGS (exit 2)

    Emit structured result JSON to stdout.
    Log human-readable summary to stderr.
```

### 3.3 Test Cases

```
TEST 1: Fresh cache hit → SKIP_CACHE_HIT
  - Setup: Create CACHE_MANIFEST.yaml with a fresh entry for target URL
  - Run: ./preflight-check N-001 competitor-pricing --target-url "https://syncgtm.com/pricing"
  - Expect: exit 0, verdict=SKIP_CACHE_HIT

TEST 2: Stale cache → PROCEED
  - Setup: Create CACHE_MANIFEST.yaml with an entry whose fresh_until is in the past
  - Run: Same as above
  - Expect: exit 0, verdict=PROCEED, reason contains "Data expired"

TEST 3: Insufficient credits → BLOCKED_CREDITS
  - Setup: Set CREDIT_BUDGET.yaml firecrawl_remaining to 100
  - Run: Same as above
  - Expect: exit 1, verdict=BLOCKED_CREDITS

TEST 4: Dead host → BLOCKED_DEAD_HOST
  - Setup: Add target hostname to DEAD_HOST_REGISTRY.yaml with blocked_until in the future
  - Run: Same as above
  - Expect: exit 1, verdict=BLOCKED_DEAD_HOST

TEST 5: No target URL → legacy file-pattern fallback
  - Run: ./preflight-check N-001 competitor-pricing
  - Expect: exit 0 (or 1 if no cached data), stderr contains "legacy file-pattern"

TEST 6: Corrupted YAML → INTERNAL_ERROR
  - Setup: Write invalid YAML to CREDIT_BUDGET.yaml
  - Run: Same as above
  - Expect: exit 3, error contains "corrupted"

TEST 7: --dry-run → no mutation
  - Run: ./preflight-check N-001 competitor-pricing --target-url "https://example.com" --dry-run
  - Expect: exit 0, no changes to CACHE_MANIFEST.yaml, stderr shows what would happen

TEST 8: Orphaned manifest entry → auto-clean
  - Setup: Create CACHE_MANIFEST.yaml entry pointing to a non-existent file
  - Run: Same as Test 1
  - Expect: exit 0, verdict=PROCEED, orphaned entry removed from manifest
```

---

## 4. Script 2: freshness-audit

### 4.1 Contract

**Purpose:** Audit a completed niche canvas for source data freshness before finalization. Implements:
1. Source-count-based staleness ratio (per §6.4)
2. Claim-weighted staleness ratio (per §6.4 — the Eye Security bug fix)
3. BLOCK-class hard enforcement for JOB/HIRING/INTENT data types (per §6.1)
4. Retroactive content-hash comparison for HIGHEST-priority data types (per §6.5)

**Invocation:**
```bash
./freshness-audit NICHE_ID [--force] [--dry-run]
```

**Input:**
| Parameter | Required | Description |
|---|---|---|
| `NICHE_ID` | Yes | Niche identifier |
| `--force` | No | Override BLOCK enforcement for emergency cases. Logs a waiver event. |
| `--dry-run` | No | Validate inputs and trace-map, report staleness, exit 0. |

**Output (stdout):** JSON Lines object:
```json
{
  "script": "freshness-audit",
  "timestamp": "2026-07-23T15:00:00Z",
  "exit_code": 0,
  "exit_code_name": "SUCCESS",
  "verdict": "PASS",
  "niche_id": "N-001",
  "total_sources": 45,
  "stale_sources": 2,
  "stale_ratio": 0.044,
  "claim_weighted_stale_ratio": 0.02,
  "block_class_violations": 0,
  "retroactive_mismatches": 0,
  "blocked": false,
  "stale_details": [
    {
      "source_file": "N-001/02-competitor-intel/N-001-competitor-pricing-syncgtm-v1.yaml",
      "data_type": "competitor_pricing",
      "sla_class": "PRICING",
      "fetch_date": "2026-04-01",
      "max_age_days": 90,
      "actual_age_days": 113,
      "staleness_action": "RE_FETCH",
      "resolution": "DEMOTED"
    }
  ]
}
```

### 4.2 Implementation Specification

#### Step 1: Load and Validate Trace Map

```
FUNCTION load_trace_map(niche_id):
    1. Locate trace-map: niche-program/research/{NICHE_ID}/_canvas/evidence/trace-map.yaml
    2. If file doesn't exist:
       → emit_result(INVALID_INPUT, {error: "trace-map.yaml not found. Has the canvas been authored?"})
    3. Load with ruamel.yaml
    4. Validate required structure:
       - Must have top-level 'claims' key that is a list
       - Each claim must have: claim_id, sources (list)
       - Each source must have: source_file, fetch_date, freshness_status, fresh_until
       - If validation fails → emit_result(INVALID_INPUT, {error: "trace-map.yaml schema violation", details: [...]})
    5. Return parsed claims list
```

#### Step 2: Source-Count-Based Staleness Check

```
FUNCTION compute_source_count_staleness(claims):
    1. Collect all unique source files across all claims
       - Use a Set to deduplicate (same source file referenced by multiple claims counts once)
    2. For each unique source file:
       a. Resolve the file path: niche-program/research/{NICHE_ID}/.../source_file
       b. If the file doesn't exist on disk → flag as ORPHAN (stale, severity HIGH)
       c. Read fetch_date and fresh_until from the source file
       d. If now() > fresh_until → flag as STALE
       e. Determine staleness_action from FRESHNESS_SLA table:
          - Match source data_type to SLA entry
          - Record action: RE_FETCH, RE_FETCH_BLOCK, PASS_FLAG, DEMOTE
    3. Compute stale_ratio = stale_count / total_unique_sources
    4. Return {total_unique_sources, stale_sources_list, stale_ratio}
```

#### Step 3: Claim-Weighted Staleness Check (The Eye Security Fix)

This implements the fix for the Gapstars demo bug: a single stale source that supplies >20% of claims blocks the canvas, even if the source-count ratio is <10%.

```
FUNCTION compute_claim_weighted_staleness(claims, stale_sources):
    1. For each stale source file:
       a. Count how many claims reference this source
       b. Compute: claim_ratio = claims_referencing_this_source / total_claims
    2. If ANY stale source has claim_ratio > 0.20:
       → BLOCKED (regardless of source-count-based ratio)
       → Flag: "Single stale source {file} supplies {pct}% of claims. Canvas BLOCKED."
    3. Compute claim_weighted_stale_ratio:
       - Sum of (claims_referencing_stale_source) / total_claims
       - This is the proportion of claims that depend on stale data
    4. Return {claim_weighted_stale_ratio, blocking_source: null or file_path}
```

#### Step 4: BLOCK-Class Hard Enforcement

BLOCK-class data types (INTENT, JOB, HIRING — D-04, D-05, D-12) have HARD enforcement. If stale AND re-fetch fails, the canvas cannot be finalized.

```
FUNCTION enforce_block_class(stale_sources, force_flag):
    1. Filter stale_sources for BLOCK-class data types (class in {"INTENT", "JOB", "HIRING"})
    2. For each BLOCK-class stale source:
       a. Check if a re-fetch was attempted (look for re_fetch_attempted flag in source metadata)
       b. If re-fetch was attempted AND failed:
          → This source is BLOCKED: STALE_UNRECOVERABLE
          → Canvas section relying on this source is INCOMPLETE
       c. If re-fetch was NOT attempted:
          → This source needs re-fetch before canvas can be finalized
    3. If any BLOCK-class source is STALE_UNRECOVERABLE AND force_flag is False:
       → BLOCKED. emit_result(BLOCKED, {verdict: "BLOCKED", reason: "BLOCK-class data stale and unrecoverable"})
    4. If force_flag is True:
       → Log waiver event to PIPELINE_CHECKPOINTS.yaml:
         {timestamp, niche_id, waiver_type: "BLOCK_CLASS_OVERRIDE", sources: [...], reason: "--force flag"}
       → Continue with WARNING
    5. Return {block_violations_count, blocked: bool}
```

#### Step 5: Retroactive Freshness Check (§6.5)

For HIGHEST-priority data types, re-fetch and compare content hashes. This catches changes between fetch time and canvas finalization (the Eye Security bug: vacancy count was 10 at fetch, 28 on the live page).

```
FUNCTION retroactive_check(claims, niche_id):
    1. Filter claims for HIGHEST-priority data types (D-04 INTENT, D-05 JOB, D-12 HIRING)
    2. For each qualifying claim:
       a. Extract the original source URL from the trace-map
       b. Emit instruction to stderr: "RETROACTIVE_CHECK: Re-fetch {url} and compare hash"
       c. This step requires network access — the script itself does NOT re-fetch.
          Instead, it prints the list of URLs that need retroactive checking.
          The calling agent handles the actual re-fetch.
    3. If a retroactive check file exists from a prior run:
       - Compare original content_hash with retroactive content_hash
       - If mismatch → flag as VERIFIED_STALE
       - Downgrade the claim's evidence grade to [H]
       - Log: "Source changed between fetch ({fetch_date}) and finalization ({now}). Downgraded."
    4. Return {retroactive_mismatches_count, verified_stale_claims: [...]}
```

**Design note:** The retroactive check requires network I/O. The script emits the list of URLs that need checking; the calling agent performs the actual re-fetches and writes a `retroactive-check-results.yaml` file. On subsequent runs, the script reads this file for comparison. This separation keeps the script fast and testable — network I/O is the agent's responsibility.

#### Step 6: Verdict Assembly

```
FUNCTION assemble_verdict():
    Rules (in priority order):
    1. If BLOCK-class enforcement fires AND --force not set → BLOCKED (exit 1)
    2. If claim-weighted ratio has a blocking source (>20%) → BLOCKED (exit 1)
    3. If source-count stale_ratio > 0.10 → BLOCKED (exit 1)
    4. If source-count stale_ratio > 0 AND ≤ 0.10 → PASS_WITH_WARNING (exit 2)
    5. If source-count stale_ratio == 0 → PASS (exit 0)

    For BLOCKED verdicts, the output includes:
    - Which sources are stale
    - The re-fetch commands needed
    - Whether a --force override is available

    For PASS_WITH_WARNING verdicts:
    - Stale sources are flagged
    - No [P] claims may depend on stale sources
    - The canvas can proceed but the staleness is documented
```

### 4.3 Test Cases

```
TEST 1: All sources fresh → PASS
  - Setup: trace-map with 20 sources, all fresh_until in the future
  - Run: ./freshness-audit N-001
  - Expect: exit 0, stale_ratio=0.0, verdict=PASS

TEST 2: 5% stale → PASS_WITH_WARNING
  - Setup: trace-map with 20 sources, 1 stale
  - Run: Same
  - Expect: exit 2, stale_ratio=0.05

TEST 3: 15% stale → BLOCKED
  - Setup: trace-map with 20 sources, 3 stale
  - Run: Same
  - Expect: exit 1, verdict=BLOCKED

TEST 4: Single source >20% of claims → BLOCKED (claim-weighted)
  - Setup: trace-map with 50 claims, 1 stale source referenced by 15 claims (30%)
  - Run: Same
  - Expect: exit 1, claim_weighted_stale_ratio > 0.20

TEST 5: BLOCK-class stale + unrecoverable → BLOCKED
  - Setup: trace-map with JOB data type source, fetch_date 10 days ago, re_fetch_attempted=true, re_fetch_success=false
  - Run: Same
  - Expect: exit 1, block_class_violations > 0

TEST 6: BLOCK-class with --force → PASS_WITH_WARNING
  - Setup: Same as Test 5
  - Run: ./freshness-audit N-001 --force
  - Expect: exit 2, waiver logged to PIPELINE_CHECKPOINTS.yaml

TEST 7: trace-map.yaml missing → INVALID_INPUT
  - Setup: No trace-map file
  - Run: Same
  - Expect: exit 4

TEST 8: trace-map.yaml corrupted → INTERNAL_ERROR
  - Setup: Invalid YAML in trace-map
  - Run: Same
  - Expect: exit 3
```

---

## 5. Script 3: validate-schema

### 5.1 Contract

**Purpose:** Validate structured data files against their schema definitions before the data enters canvas authoring. Catches schema violations at ingestion time, not mid-canvas.

**Invocation:**
```bash
./validate-schema DATA_TYPE FILE_PATH [--schema-dir PATH] [--dry-run]
```

**Input:**
| Parameter | Required | Description |
|---|---|---|
| `DATA_TYPE` | Yes | One of: `competitor-profile`, `review-corpus`, `market-sizing`, `canvas-frontmatter` |
| `FILE_PATH` | Yes | Path to the structured data file to validate |
| `--schema-dir PATH` | No | Path to schema directory (default: `niche-program/schemas/`) |
| `--dry-run` | No | Load schema and file, report what would be checked, exit 0. |

**Output (stdout):** JSON Lines object:
```json
{
  "script": "validate-schema",
  "timestamp": "2026-07-23T15:30:00Z",
  "exit_code": 0,
  "exit_code_name": "SUCCESS",
  "verdict": "PASS",
  "data_type": "competitor-profile",
  "file_path": "N-001/02-competitor-intel/N-001-competitor-profile-syncgtm-v1.yaml",
  "schema_file": "schemas/competitor-profile-schema.yaml",
  "required_fields_present": 28,
  "required_fields_missing": 0,
  "optional_fields_missing": 3,
  "enum_violations": 0,
  "type_violations": 0,
  "warnings": [
    "Optional field 'estimated_customers' is missing",
    "Optional field 'vulnerabilities' is empty list"
  ]
}
```

### 5.2 Implementation Specification

#### Step 1: Schema Loading and Validation

The schema files in `niche-program/schemas/` use a structured YAML format (not JSON Schema). The validator implements a **YAML Schema → runtime validator** pattern inspired by Stripe's schema-driven API validation.

```
FUNCTION load_schema(data_type, schema_dir):
    1. Map data_type to schema file:
       - competitor-profile → competitor-profile-schema.yaml
       - review-corpus → review-corpus-schema.yaml
       - market-sizing → market-sizing-schema.yaml
       - canvas-frontmatter → canvas-frontmatter-schema.yaml
    2. Load schema YAML with ruamel.yaml
    3. Validate schema structure:
       - Must have 'schema' key with 'name', 'version', 'source'
       - Must have 'fields' key that is a list
       - Each field must have: field (name), type, required (bool)
    4. Return parsed schema as a dict of field_name → field_spec
```

#### Step 2: Field-by-Field Validation

The schema files use YAML with field descriptions, NOT JSON Schema. The validator applies these checks:

```
FUNCTION validate_field(value, field_spec, path):
    Checks applied (in order):
    1. REQUIRED check:
       - If field_spec.required is true AND value is missing/null → REQUIRED_MISSING

    2. TYPE check:
       - If field_spec.type is "string" → verify isinstance(value, str)
       - If field_spec.type is "string (ISO 8601 date)" → verify str + matches date pattern
       - If field_spec.type is "string (URL)" → verify str + urllib.parse.urlparse() succeeds
       - If field_spec.type is "string (duration)" → verify str matches \d+d pattern
       - If field_spec.type is "integer" → verify isinstance(value, int) and not bool
       - If field_spec.type is "float" → verify isinstance(value, (int, float))
       - If field_spec.type is "boolean" → verify isinstance(value, bool)
       - If field_spec.type is "list" → verify isinstance(value, list)
       - If field_spec.type is "dict" or "object" → verify isinstance(value, dict)

    3. ENUM check:
       - If field_spec has 'enum' list → verify value is in enum
       - Case-sensitive comparison

    4. RANGE check (for numeric types):
       - If field_spec has 'min'/'max' → verify value is within range

    5. NESTED check:
       - If field_spec.type is dict/object AND has 'children' → recursively validate children
       - If field_spec.type is list AND has 'item_schema' → validate each list item

    6. CUSTOM VALIDATION rules (data_type specific):
       - competitor-profile: pricing array must have >=1 entry for DEEP depth
       - review-corpus: total_reviews must equal sum(sources.*.count)
       - review-corpus: rating must be integer 1-5
       - market-sizing: companies_range must match pattern "N,N-N,N"
       - canvas-frontmatter: composite_score must be 0-10
       - canvas-frontmatter: each sub-score must be 1-10
       - canvas-frontmatter: if high_uncertainty is true, evidence_quality should be <0.50
```

#### Step 3: Nested Structure Traversal

```
FUNCTION validate_recursive(data, schema_fields, path_prefix=""):
    For each field_spec in schema_fields:
        field_name = field_spec.field
        full_path = path_prefix + "." + field_name if path_prefix else field_name

        # Resolve nested path (e.g., 'profile.pricing[0].price_monthly_eur')
        value = resolve_nested_path(data, field_name)

        IF field_spec has 'children':
            # Recurse into nested object
            validate_recursive(value, field_spec.children, full_path)
        ELSE IF field_spec has 'item_schema' AND value is list:
            # Validate each list item against item_schema
            for i, item in enumerate(value):
                validate_recursive(item, field_spec.item_schema, f"{full_path}[{i}]")
        ELSE:
            # Leaf field — validate
            errors = validate_field(value, field_spec, full_path)
```

#### Step 4: Result Assembly

```
FUNCTION assemble_result():
    Count violations by type:
    - required_fields_missing
    - type_violations
    - enum_violations
    - range_violations
    - custom_rule_violations

    IF any required_fields_missing OR type_violations OR enum_violations:
        → FAIL (exit 1)
    ELSE IF any optional_fields_missing OR warnings:
        → PASS_WITH_WARNINGS (exit 2)
    ELSE:
        → PASS (exit 0)

    Emit structured result with full violation details for machine consumption.
```

### 5.3 Test Cases

```
TEST 1: Valid competitor profile → PASS
  - Setup: Create a valid competitor-profile YAML with all required fields
  - Run: ./validate-schema competitor-profile valid-profile.yaml
  - Expect: exit 0, verdict=PASS

TEST 2: Missing required field → FAIL
  - Setup: Remove 'competitor_id' from valid profile
  - Run: Same
  - Expect: exit 1, required_fields_missing >= 1

TEST 3: Invalid enum value → FAIL
  - Setup: Set delivery_model to "INVALID_VALUE"
  - Run: Same
  - Expect: exit 1, enum_violations >= 1

TEST 4: Rating out of range → FAIL
  - Setup: Set review rating to 6
  - Run: ./validate-schema review-corpus invalid-review.yaml
  - Expect: exit 1, range_violations >= 1

TEST 5: Missing optional fields → PASS_WITH_WARNINGS
  - Setup: Omit 'estimated_customers' and 'vulnerabilities'
  - Run: Same as Test 1
  - Expect: exit 2, optional_fields_missing > 0

TEST 6: total_reviews mismatch → FAIL
  - Setup: Set total_reviews=30 but sources sum to 25
  - Run: ./validate-schema review-corpus inconsistent-review.yaml
  - Expect: exit 1, custom_rule_violations >= 1

TEST 7: Corrupted YAML file → INTERNAL_ERROR
  - Setup: Write invalid YAML
  - Run: Same
  - Expect: exit 3

TEST 8: --dry-run → no mutation
  - Run: ./validate-schema competitor-profile valid-profile.yaml --dry-run
  - Expect: exit 0, stderr shows validation plan
```

---

## 6. Script 4: clean-raw-fetches

### 6.1 Contract

**Purpose:** Remove raw fetched content older than 30 days from `.firecrawl/` and `.dataforseo/` directories. Implements the data retention policy from §9.4.

**Invocation:**
```bash
./clean-raw-fetches [--older-than DAYS] [--dry-run]
```

**Input:**
| Parameter | Required | Description |
|---|---|---|
| `--older-than DAYS` | No | Remove files older than this many days (default: 30) |
| `--dry-run` | No | List files that WOULD be removed, exit 0. No deletes. |

**Output (stdout):** JSON Lines object:
```json
{
  "script": "clean-raw-fetches",
  "timestamp": "2026-07-23T16:00:00Z",
  "exit_code": 0,
  "exit_code_name": "SUCCESS",
  "verdict": "CLEANED",
  "older_than_days": 30,
  "cutoff_date": "2026-06-23",
  "firecrawl_files_removed": 145,
  "firecrawl_bytes_freed": 52428800,
  "dataforseo_files_removed": 32,
  "dataforseo_bytes_freed": 8192000,
  "total_bytes_freed": 60620800,
  "errors": []
}
```

### 6.2 Implementation Specification

```
FUNCTION clean_directory(directory, cutoff_date, dry_run):
    1. Verify directory exists
       - If not → log warning, return {files_removed: 0, bytes_freed: 0}
    2. Walk the directory tree (recursive)
    3. For each file:
       a. Get file modification time (mtime) or birth time (btime) if available
       b. If file_age > cutoff_date:
          - If dry_run: log "[DRY-RUN] Would remove: {file_path}"
          - If not dry_run: remove file, log "Removed: {file_path}"
       c. Track: files_removed, bytes_freed
    4. After file removal:
       a. Remove empty directories (walk bottom-up)
       b. If a directory is empty after file removal, remove it too
    5. Return {files_removed, bytes_freed, errors: []}

FUNCTION main():
    1. Parse --older-than (default 30 days) and --dry-run
    2. Validate --older-than is a positive integer
    3. Compute cutoff_date = now() - older_than_days
    4. Clean .firecrawl/ directory
    5. Clean .dataforseo/ directory
    6. Emit structured result

    SAFETY CHECKS:
    - Minimum --older-than value is 7 days (prevent accidental deletion of fresh data)
    - If --older-than < 7 → emit_result(INVALID_INPUT, {error: "Minimum retention is 7 days"})
    - Verify we're cleaning the CORRECT directories (contain 'firecrawl' or 'dataforseo' in path)
    - Never clean niche-program/research/ directories (structured data has different retention)
    - Never clean _program/ or _pipelines/ directories

    ATOMICITY:
    - This script is NOT atomic (file deletions are irreversible)
    - --dry-run mode is recommended before actual cleaning
    - The script logs every deletion to stderr for forensic audit
```

### 6.3 Test Cases

```
TEST 1: Clean files older than 30 days → CLEANED
  - Setup: Create test files with mtime 35 days ago
  - Run: ./clean-raw-fetches
  - Expect: exit 0, files_removed >= 1

TEST 2: No old files → CLEANED (nothing to do)
  - Setup: All files have recent mtime
  - Run: Same
  - Expect: exit 0, files_removed=0

TEST 3: --dry-run → no deletions
  - Setup: Create test files with old mtime
  - Run: ./clean-raw-fetches --dry-run
  - Expect: exit 0, files_removed=0 (but logged as would-remove)

TEST 4: --older-than 7 (minimum) → works
  - Run: ./clean-raw-fetches --older-than 7
  - Expect: exit 0

TEST 5: --older-than 3 (below minimum) → INVALID_INPUT
  - Run: ./clean-raw-fetches --older-than 3
  - Expect: exit 4, error contains "Minimum retention"

TEST 6: Missing directories → no error
  - Setup: Remove .firecrawl/ directory
  - Run: ./clean-raw-fetches
  - Expect: exit 0, firecrawl_files_removed=0, log warning about missing dir
```

---

## 7. Script 5: generate-quality-dashboard

### 7.1 Contract

**Purpose:** Read the three quality tracking files and produce a human-readable summary YAML report. Run after every 5th niche or on demand. This is the data quality dashboard that answers: "How healthy is the pipeline?"

**Invocation:**
```bash
./generate-quality-dashboard [--output FILE] [--format yaml|json|text] [--since NICHE_ID] [--dry-run]
```

**Input:**
| Parameter | Required | Description |
|---|---|---|
| `--output FILE` | No | Write dashboard to file (default: stdout) |
| `--format FORMAT` | No | Output format: `yaml` (default), `json`, or `text` (human-readable) |
| `--since NICHE_ID` | No | Only include data from this niche onward (for incremental dashboards) |
| `--dry-run` | No | Validate inputs and data sources, report what would be generated. |

**Output (YAML format, default):**
```yaml
dashboard:
  generated_at: "2026-07-23T16:30:00Z"
  generated_by: "generate-quality-dashboard"
  data_sources:
    quality_metrics: "_program/QUALITY_METRICS.yaml"
    freshness_violations: "_program/FRESHNESS_VIOLATION_LOG.yaml"
    tool_errors: "_program/TOOL_ERROR_LOG.yaml"
    sli_definitions: "_program/SLI_DEFINITIONS.yaml"

  summary:
    total_niches_completed: 6
    aggregate_evidence_quality: 0.72
    aggregate_staleness_rate: 0.04
    pipeline_uptime_pct: 98.5

  sli_compliance:
    - sli: "fetch_success_rate"
      target: ">95%"
      actual: "96.2%"
      status: "COMPLIANT"
    - sli: "freshness_compliance"
      target: ">90%"
      actual: "96.0%"
      status: "COMPLIANT"
    - sli: "credit_forecast_accuracy"
      target: "Within 20%"
      actual: "15.3% deviation"
      status: "COMPLIANT"
    - sli: "per_niche_wall_clock"
      target: "<45 min"
      actual_p50: "22 min"
      actual_p95: "38 min"
      status: "COMPLIANT"
    - sli: "evidence_quality"
      target: ">50%"
      actual: "72%"
      status: "COMPLIANT"
    - sli: "pipeline_availability"
      target: ">95%"
      actual: "98.5%"
      status: "COMPLIANT"

  staleness_hotspots:
    - data_type: "competitor_pricing"
      staleness_rate: 0.12
      trend: "IMPROVING"
    - data_type: "job_postings"
      staleness_rate: 0.08
      trend: "STABLE"

  error_prone_tools:
    - tool: "firecrawl"
      total_errors: 23
      error_rate: 0.02
      top_error: "TIMEOUT (15 occurrences)"
    - tool: "openregistry_mcp"
      total_errors: 8
      error_rate: 0.05
      top_error: "CONNECTION_REFUSED (5 occurrences)"

  evidence_quality_trend:
    - niche_id: "N-001"
      evidence_quality: 0.65
    - niche_id: "N-002"
      evidence_quality: 0.68
    - niche_id: "N-003"
      evidence_quality: 0.71
    - niche_id: "N-004"
      evidence_quality: 0.73
    - niche_id: "N-005"
      evidence_quality: 0.72
    trend: "IMPROVING"

  wall_clock_drift:
    - niche_id: "N-001"
      estimated_minutes: 25
      actual_minutes: 31
    - niche_id: "N-005"
      estimated_minutes: 25
      actual_minutes: 19
    trend: "IMPROVING (learning curve effect)"

  alert_status:
    firecrawl_error_rate: {current: 2.1, warning: 10, critical: 30, status: "OK"}
    dataforseo_error_rate: {current: 0.0, warning: 10, critical: 30, status: "OK"}
    staleness_rate: {current: 4.0, warning: 10, critical: 20, status: "OK"}
    credit_burn_rate: {current: 850, warning: 2000, critical: 4000, status: "OK"}
    niche_wall_clock: {current: 22, warning: 35, critical: 45, status: "OK"}

  recommendations:
    - "Evidence quality is improving across niches — methodology consistency is good."
    - "Firecrawl timeout errors increased in N-004/N-005. Consider increasing read timeout for JS-rendered pages."
    - "Competitor pricing staleness is above 10%. Schedule re-fetch for N-001..N-003 pricing data."
```

### 7.2 Implementation Specification

```
FUNCTION load_all_data():
    1. Load QUALITY_METRICS.yaml → per_data_type_staleness, per_tool_errors, per_niche_evidence, per_niche_wall_clock, cross_niche_summary
    2. Load FRESHNESS_VIOLATION_LOG.yaml → violations list
    3. Load TOOL_ERROR_LOG.yaml → errors list
    4. Load SLI_DEFINITIONS.yaml → slis, alert_thresholds
    5. For each file:
       - If missing → log warning, use empty defaults
       - If corrupted → log error, skip that data source
    6. If --since NICHE_ID is specified:
       - Filter all per-niche data to only include niches >= the specified ID

FUNCTION compute_sli_compliance():
    For each SLI in SLI_DEFINITIONS.yaml:
    1. Compute actual value:
       - fetch_success_rate: (total_operations - errors) / total_operations from TOOL_ERROR_LOG
       - freshness_compliance: 1.0 - aggregate_staleness_rate from QUALITY_METRICS
       - credit_forecast_accuracy: abs(actual - estimated) / estimated from CREDIT_BUDGET
       - per_niche_wall_clock: p50 and p95 from per_niche_wall_clock data
       - evidence_quality: aggregate from cross_niche_summary
       - pipeline_availability: uptime from TOOL_ERROR_LOG system-level errors
    2. Compare against target:
       - If actual meets target → COMPLIANT
       - If within 10% of target → AT_RISK
       - If exceeds threshold → NON_COMPLIANT

FUNCTION compute_trends():
    1. For each data type staleness rate:
       - Compare current rate vs. rate from 5 niches ago
       - IMPROVING (rate decreasing), STABLE (±10%), DEGRADING (rate increasing)
    2. For evidence quality:
       - Plot per-niche evidence_quality in sequence
       - Fit linear trend
    3. For wall-clock:
       - Compare actual vs. estimated per niche
       - Check for learning curve (decreasing time) or drift (increasing time)

FUNCTION check_alerts():
    1. Load current values for each alert threshold
    2. Compare against warning and critical levels
    3. If any value exceeds critical → status=CRITICAL
    4. If any value exceeds warning → status=WARNING
    5. Otherwise → status=OK

FUNCTION generate_recommendations():
    Heuristic rules:
    1. If any SLI is AT_RISK or NON_COMPLIANT → recommend investigation
    2. If any data type staleness_rate > 10% → recommend re-fetch
    3. If any tool error_rate > 5% → recommend timeout/config review
    4. If wall_clock p95 > 40 min (approaching 45 min hard timeout) → recommend concurrency reduction
    5. If evidence_quality trend is DEGRADING → recommend calibration re-check
    6. If credit_forecast_accuracy > 30% deviation → recommend estimate recalibration
```

### 7.3 Test Cases

```
TEST 1: All data sources present → full dashboard
  - Setup: All 4 YAML files populated with realistic data
  - Run: ./generate-quality-dashboard
  - Expect: exit 0, all sections populated

TEST 2: Missing data sources → degraded dashboard
  - Setup: Remove TOOL_ERROR_LOG.yaml
  - Run: Same
  - Expect: exit 2, dashboard generated but with "MISSING_DATA" markers

TEST 3: --format json → JSON output
  - Run: ./generate-quality-dashboard --format json
  - Expect: exit 0, valid JSON, machine-parseable

TEST 4: --format text → human-readable
  - Run: ./generate-quality-dashboard --format text
  - Expect: exit 0, formatted text with colors (if terminal supports)

TEST 5: --output file → write to file
  - Run: ./generate-quality-dashboard --output /tmp/dashboard.yaml
  - Expect: exit 0, file created, valid YAML

TEST 6: --since N-003 → incremental dashboard
  - Setup: QUALITY_METRICS has data for N-001 through N-006
  - Run: ./generate-quality-dashboard --since N-003
  - Expect: Only N-003..N-006 data included

TEST 7: Empty data sources → minimal dashboard
  - Setup: All YAML files initialized but empty (no niches completed)
  - Run: Same
  - Expect: exit 0, dashboard shows "NO_DATA" for most sections
```

---

## 8. Integration Testing

### 8.1 End-to-End Test Scenario

```
SCENARIO: Complete niche pipeline with all 5 scripts

GIVEN:
  - Calibration niche CAL-A has been evaluated
  - CREDIT_BUDGET.yaml shows 98,500 Firecrawl credits remaining
  - DEAD_HOST_REGISTRY.yaml has 3 dead hosts
  - CACHE_MANIFEST.yaml has 15 cache entries from calibration
  - QUALITY_METRICS.yaml, FRESHNESS_VIOLATION_LOG.yaml, TOOL_ERROR_LOG.yaml exist

WHEN processing a new niche N-001:

  # Before Phase 2 (credit-consuming fetch)
  1. ./preflight-check N-001 competitor-pricing --target-url "https://syncgtm.com/pricing"
     → Expect: PROCEED (cache miss, credits sufficient, host not dead)

  # After structured data write
  2. ./validate-schema competitor-profile N-001/02-competitor-intel/N-001-competitor-profile-syncgtm-v1.yaml
     → Expect: PASS (all required fields present)

  # Before canvas finalization
  3. ./freshness-audit N-001
     → Expect: PASS (all sources fresh from recent fetches)

  # Weekly maintenance
  4. ./clean-raw-fetches --dry-run
     → Expect: Lists files that would be removed

  # After 5 niches completed
  5. ./generate-quality-dashboard --output _program/DASHBOARD_AFTER_N-005.yaml
     → Expect: Full dashboard with trends across 5 niches

THEN:
  - All scripts exit with expected codes
  - No data corruption
  - Audit trail is complete (log entries for all operations)
```

### 8.2 Regression Test Suite

```bash
#!/bin/bash
# test/run_all_tests.sh — Run the full test suite

set -e

echo "=== preflight-check tests ==="
python -m pytest test/test_preflight_check.py -v

echo "=== freshness-audit tests ==="
python -m pytest test/test_freshness_audit.py -v

echo "=== validate-schema tests ==="
python -m pytest test/test_validate_schema.py -v

echo "=== clean-raw-fetches tests ==="
python -m pytest test/test_clean_raw_fetches.py -v

echo "=== generate-quality-dashboard tests ==="
python -m pytest test/test_quality_dashboard.py -v

echo "=== integration tests ==="
python -m pytest test/test_integration.py -v

echo "ALL TESTS PASSED"
```

---

## 9. Acceptance Criteria

### 9.1 Per-Script Criteria

All 5 scripts must satisfy these before being declared operational:

| Criterion | preflight-check | freshness-audit | validate-schema | clean-raw-fetches | quality-dashboard |
|---|---|---|---|---|---|
| All test cases pass (from §3-7 above) | 8/8 | 8/8 | 8/8 | 6/6 | 7/7 |
| --dry-run mode works | ✓ | ✓ | ✓ | ✓ | ✓ |
| Idempotent (re-run produces same result) | ✓ | ✓ | ✓ | ✓ | ✓ |
| Structured JSON output to stdout | ✓ | ✓ | ✓ | ✓ | ✓ |
| Human-readable logs to stderr | ✓ | ✓ | ✓ | ✓ | ✓ |
| Corrupted YAML → INTERNAL_ERROR (exit 3) | ✓ | ✓ | ✓ | ✓ | ✓ |
| Missing file → INVALID_INPUT (exit 4) | ✓ | ✓ | ✓ | ✓ | ✓ |
| YAML round-trip preserves comments | ✓ | ✓ | ✓ | N/A | N/A |
| Atomic writes for all file mutations | ✓ | ✓ | N/A | N/A | ✓ |
| Works with Python 3.10+ | ✓ | ✓ | ✓ | ✓ | ✓ |

### 9.2 Integration Criteria

1. **End-to-end scenario (§8.1) passes** — all 5 scripts execute in sequence against a calibration niche without errors.
2. **Calibration niche data** — scripts tested against real data from the first calibration niche evaluation, not just synthetic test data.
3. **Performance** — each script completes in <5 seconds for a typical niche (20-50 source files). Dashboard generation for 25 niches completes in <30 seconds.
4. **Documentation** — each script has a `--help` flag that prints usage, examples, and exit code meanings.

### 9.3 Rollout Plan

**Phase 1 (immediate):** Implement `preflight-check` and `validate-schema` first. These provide immediate value (credit savings + data quality) and have no dependencies on other scripts.

**Phase 2 (within 1 week):** Implement `freshness-audit`. This is the most complex script but provides the critical BLOCK enforcement and retroactive freshness checking.

**Phase 3 (within 2 weeks):** Implement `clean-raw-fetches` and `generate-quality-dashboard`. These are lower priority — the pipeline operates without them, but quality visibility and disk management degrade over time.

**Phase 4 (ongoing):** Add tests for edge cases discovered during live pipeline operation. The test suite grows with operational experience.

---

*End of IMPLEMENTATION-SPEC.md — This document is the binding specification for all 5 operational scripts. It is referenced by DATA-OPERATIONS-ARCHITECTURE.md Appendices A & B.*
