"""
pipeline_ops.py — Shared library for ClarityRev Niche Pipeline operations.

Google SRE pattern: common infrastructure extracted into a library,
not copy-pasted across scripts. Imported by all 5 operational scripts.

Usage:
    from lib.pipeline_ops import (
        yaml, load_yaml_safe, write_yaml_atomic, emit_result, emit_log,
        ExitCode, FRESHNESS_SLA, BLOCK_CLASS_DATA_TYPES,
        normalize_url, compute_content_hash, compute_url_hash,
        parse_iso_date, days_between, PROGRAM_DIR, RESEARCH_DIR, SHARED_DIR
    )
"""

import os
import sys
import hashlib
import json
from datetime import datetime, timezone
from pathlib import Path
from typing import Optional, Dict, Any, List, Tuple
from enum import Enum
from urllib.parse import urlparse, parse_qs, urlencode, urlunparse

# ─── File locking ─────────────────────────────────────────────────────────────
# Advisory file locking for concurrent agent access to shared YAML files.
# Imported by all 5 operational scripts via pipeline_ops.

from lib.file_lock import FileLock, FileLockError

# ─── Third-party imports ──────────────────────────────────────────────────────
# ruamel.yaml preserves YAML comments on round-trip (critical per G-014).
# yaml.safe_dump DESTROYS all comments — never use it for governance YAML files.

try:
    from ruamel.yaml import YAML as _YAML
    yaml = _YAML()
    yaml.preserve_quotes = True
    yaml.width = 4096  # Prevent aggressive line wrapping
except ImportError as e:
    print(f"FATAL: ruamel.yaml required. Install: pip install ruamel.yaml\n  {e}", file=sys.stderr)
    sys.exit(3)


# ─── Path resolution ──────────────────────────────────────────────────────────
# Resolve niche-program/ root from this file's location.
# _pipelines/lib/pipeline_ops.py → _pipelines/ → research/ → niche-program/

_LIB_DIR = Path(__file__).resolve().parent            # _pipelines/lib/
_PIPELINES_DIR = _LIB_DIR.parent                       # _pipelines/
PIPELINES_DIR = _PIPELINES_DIR                         # Public alias for _PIPELINES_DIR
_RESEARCH_DIR = _PIPELINES_DIR.parent                  # research/
PROGRAM_ROOT = Path(os.environ.get("NICHE_PROGRAM_ROOT", str(_RESEARCH_DIR.parent)))

PROGRAM_DIR = _RESEARCH_DIR / "_program"
SHARED_DIR = _RESEARCH_DIR / "SHARED"
SCHEMAS_DIR = PROGRAM_ROOT / "schemas"

# These are relative to the repo root (where the script is invoked from)
REPO_ROOT = Path.cwd()
FIRECRAWL_DIR = REPO_ROOT / ".firecrawl"
DATAFORSEO_DIR = REPO_ROOT / ".dataforseo"


# ─── Quiet / Agent Mode (Global Flags) ────────────────────────────────────────
# These flags are set by scripts that parse --quiet or --agent-mode.
# When set, emit_log() becomes a no-op and emit_result() adds agent_mode: true.

_QUIET_MODE = False
_AGENT_MODE = False


def set_quiet_mode(quiet: bool):
    """Suppress all emit_log() stderr output when quiet is True."""
    global _QUIET_MODE
    _QUIET_MODE = quiet


def set_agent_mode(agent: bool):
    """Enable agent mode: quiet + compact JSON + agent_mode field.

    When agent_mode is True, all stderr output from emit_log() is suppressed
    and every emit_result() JSON object includes 'agent_mode': true.
    agent_mode=True also sets quiet=True implicitly.
    """
    global _AGENT_MODE, _QUIET_MODE
    _AGENT_MODE = agent
    if agent:
        _QUIET_MODE = True


# ─── Exit codes (Stripe API Design: contract-first) ───────────────────────────

class ExitCode(Enum):
    SUCCESS = 0        # All checks passed, no blocking issues
    BLOCKED = 1        # Blocking issue found, do not proceed
    WARNING = 2        # Non-blocking issue, proceed with caution
    INTERNAL_ERROR = 3 # Script itself failed (bug, missing dep, corrupted file)
    INVALID_INPUT = 4  # Arguments or input files malformed


# ─── Freshness SLA Table (from DATA-OPERATIONS-ARCHITECTURE.md §6.1) ──────────

FRESHNESS_SLA = {
    "D-01": {"data_type": "competitor_pricing",       "class": "PRICING",    "max_age_days": 90,  "staleness_action": "RE_FETCH",       "re_fetch_priority": "HIGH"},
    "D-02": {"data_type": "competitor_capability",      "class": "CAPABILITY", "max_age_days": 90,  "staleness_action": "RE_FETCH",       "re_fetch_priority": "MEDIUM"},
    "D-03": {"data_type": "reviews_voc",              "class": "REVIEW",     "max_age_days": 180, "staleness_action": "PASS_FLAG",       "re_fetch_priority": "LOW"},
    "D-04": {"data_type": "news_intent",              "class": "INTENT",     "max_age_days": 14,  "staleness_action": "RE_FETCH_BLOCK",  "re_fetch_priority": "HIGHEST"},
    "D-05": {"data_type": "job_postings",             "class": "JOB",        "max_age_days": 7,   "staleness_action": "RE_FETCH_BLOCK",  "re_fetch_priority": "HIGHEST"},
    "D-06": {"data_type": "market_sizing",            "class": "MARKET",     "max_age_days": 180, "staleness_action": "PASS_FLAG",       "re_fetch_priority": "LOW"},
    "D-07": {"data_type": "technographics",           "class": "TECHNO",     "max_age_days": 180, "staleness_action": "RE_FETCH",       "re_fetch_priority": "LOW"},
    "D-08": {"data_type": "company_registry",         "class": "REGISTRY",   "max_age_days": 90,  "staleness_action": "RE_FETCH",       "re_fetch_priority": "MEDIUM"},
    "D-09": {"data_type": "seo_keyword",              "class": "SEO",        "max_age_days": 90,  "staleness_action": "RE_FETCH",       "re_fetch_priority": "MEDIUM"},
    "D-10": {"data_type": "job_role_data",            "class": "PROFILE",    "max_age_days": 30,  "staleness_action": "RE_FETCH",       "re_fetch_priority": "HIGH"},
    "D-11": {"data_type": "funding_financial",        "class": "FUNDING",    "max_age_days": 90,  "staleness_action": "RE_FETCH",       "re_fetch_priority": "MEDIUM"},
    "D-12": {"data_type": "hiring_signals",           "class": "HIRING",     "max_age_days": 7,   "staleness_action": "RE_FETCH_BLOCK",  "re_fetch_priority": "HIGHEST"},
    "D-13": {"data_type": "competitor_positioning",    "class": "POSITION",   "max_age_days": 90,  "staleness_action": "PASS_FLAG",       "re_fetch_priority": "LOW"},
    "D-14": {"data_type": "regulatory_data",          "class": "REGULATORY", "max_age_days": 365, "staleness_action": "PASS_FLAG",       "re_fetch_priority": "LOW"},
    "D-15": {"data_type": "certifications",           "class": "CERT",       "max_age_days": 365, "staleness_action": "PASS_FLAG",       "re_fetch_priority": "LOW"},
}

# BLOCK-class data types: stale + re-fetch failure = BLOCKED (hard enforcement, §6.1)
BLOCK_CLASS_DATA_TYPES = {"INTENT", "JOB", "HIRING"}

STALE_RATIO_BLOCK_THRESHOLD = 0.10     # Canvas blocked if >10% sources stale (§6.4)
CLAIM_WEIGHTED_BLOCK_THRESHOLD = 0.20  # Canvas blocked if single source >20% of claims (§6.4)

# Map data_type strings to their SLA entry key
DATA_TYPE_TO_SLA_KEY = {}
for key, entry in FRESHNESS_SLA.items():
    DATA_TYPE_TO_SLA_KEY[entry["data_type"]] = key

# ─── Controlled vocabularies ──────────────────────────────────────────────────

# From DATA-OPERATIONS-ARCHITECTURE.md §3.2 File Naming Convention
CONTROLLED_DATA_TYPES = {
    "company-discovery", "competitor-profile", "competitor-pricing",
    "market-sizing", "review-corpus", "buyer-language", "signal-feasibility",
    "technographic-profile", "buyer-insight", "keyword-volume", "backlink-profile",
    "serp-analysis", "news-monitoring", "hiring-signals", "funding-data",
    "regulatory-data", "benchmark", "trigger-catalog", "canvas", "evidence-trace",
    "reconciliation",
}


# Estimated credit costs per data type (from DATA-OPERATIONS-ARCHITECTURE.md §2.3)
ESTIMATED_COSTS = {
    "competitor-discovery":     {"firecrawl": 10, "dataforseo_usd": 0.0},
    "competitor-pricing":       {"firecrawl": 15, "dataforseo_usd": 0.0},
    "competitor-profile":       {"firecrawl": 40, "dataforseo_usd": 0.0},
    "review-corpus":            {"firecrawl": 30, "dataforseo_usd": 0.0},
    "market-sizing":            {"firecrawl": 5,  "dataforseo_usd": 0.0},
    "buyer-language":           {"firecrawl": 10, "dataforseo_usd": 0.0},
    "signal-feasibility":       {"firecrawl": 5,  "dataforseo_usd": 0.0},
    "technographic-profile":    {"firecrawl": 0,  "dataforseo_usd": 0.01},
    "buyer-insight":            {"firecrawl": 5,  "dataforseo_usd": 0.0},
    "keyword-volume":           {"firecrawl": 0,  "dataforseo_usd": 0.03},
    "backlink-profile":         {"firecrawl": 0,  "dataforseo_usd": 0.012},
    "serp-analysis":            {"firecrawl": 0,  "dataforseo_usd": 0.002},
    "news-monitoring":          {"firecrawl": 5,  "dataforseo_usd": 0.0},
    "hiring-signals":           {"firecrawl": 5,  "dataforseo_usd": 0.0},
    "funding-data":             {"firecrawl": 5,  "dataforseo_usd": 0.0},
    "regulatory-data":          {"firecrawl": 2,  "dataforseo_usd": 0.0},
    "company-discovery":        {"firecrawl": 7,  "dataforseo_usd": 0.002},
}


# ─── URL Normalization ─────────────────────────────────────────────────────────

# Tracking params stripped during URL normalization for cache-key purposes
TRACKING_PARAMS = frozenset({
    'utm_source', 'utm_medium', 'utm_campaign', 'utm_term', 'utm_content',
    'fbclid', 'gclid', 'ref', 'source', '_ga', '_gl',
    'mc_cid', 'mc_eid', 'session_id', 'timestamp', 't',
})


def normalize_url(url: str) -> str:
    """
    Canonicalize a URL for cache-key purposes.

    Transformations:
    1. Strip null bytes
    2. Strip auth credentials from netloc
    3. Lowercase scheme and host
    4. Strip tracking params (utm_*, fbclid, gclid, etc.)
    5. Sort query param VALUES deterministically (in addition to keys)
    6. Collapse '//' in path to single '/'
    7. Remove trailing slash from path (unless path is just '/')
    8. Drop fragment

    Two URLs that differ only in tracking params produce the SAME normalized form
    and therefore the SAME cache key. This is the Netflix Chaos Engineering fix for
    the "dynamically generated URLs never hit cache" problem.
    """
    # Strip null bytes before parsing
    url = url.replace('\x00', '')

    parsed = urlparse(url)

    # Strip auth credentials from netloc (username:password@host)
    netloc = parsed.netloc
    if '@' in netloc:
        netloc = netloc.split('@')[-1]

    # Filter tracking params, keep the rest; sort values within each param
    query_params = {}
    for k, v in parse_qs(parsed.query).items():
        if k not in TRACKING_PARAMS:
            query_params[k] = sorted(v)

    # URL bomb protection: limit to 100 query param keys (prevents 10,000-param
    # URL bomb attacks from hanging the pipeline via exponential query expansion)
    MAX_QUERY_PARAMS = 100
    if len(query_params) > MAX_QUERY_PARAMS:
        keys = sorted(query_params)[:MAX_QUERY_PARAMS]
        query_params = {k: query_params[k] for k in keys}

    # Sort for deterministic output
    sorted_query = urlencode(sorted(query_params.items()), doseq=True)

    # Collapse '//' in path to single '/'
    path = parsed.path
    while '//' in path:
        path = path.replace('//', '/')

    # Normalize path: strip trailing slash unless path is just '/'
    if len(path) > 1 and path.endswith('/'):
        path = path.rstrip('/')

    normalized = urlunparse((
        parsed.scheme.lower(),
        netloc.lower(),
        path,
        parsed.params,
        sorted_query,
        ''  # Drop fragment
    ))
    return normalized


# ─── Content Hashing ──────────────────────────────────────────────────────────

_READ_CHUNK_SIZE = 8192  # 8KB chunks for streaming file reads

def compute_content_hash(file_path: Path) -> str:
    """
    SHA-256 hash of file contents. Returns 'sha256:<hexdigest>'.

    Reads in 8KB chunks to handle large files without memory pressure.
    """
    sha = hashlib.sha256()
    with open(file_path, 'rb') as f:
        for chunk in iter(lambda: f.read(_READ_CHUNK_SIZE), b''):
            sha.update(chunk)
    return f"sha256:{sha.hexdigest()}"


def compute_url_hash(url: str) -> str:
    """SHA-256 hash of a normalized URL string. Used for cache-manifest keys."""
    normalized = normalize_url(url)
    return f"sha256:{hashlib.sha256(normalized.encode()).hexdigest()}"


# ─── YAML Helpers ─────────────────────────────────────────────────────────────

# Separate safe YAML instance for security validation (Blocker #2 fix from 8-lens re-audit).
# This loader REJECTS !!python/object: and other dangerous YAML tags.
# The main `yaml` instance (RoundTripLoader) is used for comment-preserving load/save
# but ONLY after the safe loader has validated the content.
_safe_yaml = _YAML(typ='safe')

def load_yaml_safe(file_path: Path) -> Optional[Dict[str, Any]]:
    """
    Load a YAML file with comment preservation, rejecting dangerous tags.

    Uses a two-pass approach (Blocker #2 fix from 8-lens re-audit):
    1. Safe loader (typ='safe') detects and rejects !!python/object: and similar tags.
       This prevents arbitrary code execution via YAML deserialization.
    2. Round-trip loader preserves comments for re-serialization.

    Returns None if the file doesn't exist (not an error — callers decide).
    Raises ValueError on parse error or dangerous tag (callers decide whether fatal).

    NOTE: No TOCTOU window — we try to open() directly and catch
    FileNotFoundError instead of checking exists() first.
    """
    try:
        with open(file_path, 'r') as f:
            content = f.read()
        # Pass 1: reject dangerous YAML tags (!!python/object:, etc.)
        _safe_yaml.load(content)
        # Pass 2: round-trip load for comment preservation
        return yaml.load(content)
    except FileNotFoundError:
        return None
    except Exception as e:
        raise ValueError(f"YAML parse error in {file_path}: {e}")


def write_yaml_atomic(data: Dict[str, Any], file_path: Path):
    """
    Atomic write pattern (Design Principle 7 from DATA-OPERATIONS-ARCHITECTURE.md).

    1. Write to {file_path}.tmp
    2. Re-read the .tmp file to confirm it's valid YAML
    3. Atomic rename: mv {file_path}.tmp {file_path}

    On failure at any stage, the .tmp file is cleaned up and the original
    file is untouched. A partial write can never corrupt the production file.
    """
    tmp_path = file_path.with_suffix(file_path.suffix + '.tmp')
    try:
        # Write
        with open(tmp_path, 'w') as f:
            yaml.dump(data, f)
        # Validate by re-reading
        with open(tmp_path, 'r') as f:
            yaml.load(f)
        # Atomic rename (on same filesystem, this is atomic per POSIX).
        # os.replace() does NOT follow symlinks on Linux, unlike Path.rename().
        os.replace(str(tmp_path), str(file_path))
    except Exception as e:
        if tmp_path.exists():
            tmp_path.unlink()
        raise ValueError(f"Atomic write failed for {file_path}: {e}")



# ─── Structured Output ────────────────────────────────────────────────────────

def emit_result(exit_code: ExitCode, data: Dict[str, Any]):
    """
    Emit a structured result as JSON to stdout. Machine-parseable.
    Calls sys.exit() internally — does NOT return.

    Google SRE pattern: structured output to stdout, human logs to stderr.

    NOTE: Uses sys.stdout.write() + sys.stdout.flush() instead of print()
    to avoid buffering loss when stdout is piped (agent consumption).
    Output is compact JSON (no indent) per JSON Lines spec.
    """
    result = {
        "script": Path(sys.argv[0]).name if sys.argv else "unknown",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "exit_code": exit_code.value,
        "exit_code_name": exit_code.name,
        **data
    }
    if _AGENT_MODE:
        result["agent_mode"] = True
    sys.stdout.write(json.dumps(result, separators=(",", ":")) + "\n")
    sys.stdout.flush()
    sys.exit(exit_code.value)


def emit_log(level: str, message: str, niche_id: Optional[str] = None):
    """
    Emit a human-readable log line to stderr.

    Levels: DEBUG, INFO, WARNING, ERROR, FATAL
    Never mix these with stdout — stdout is for machine-parseable output only.

    If niche_id is provided, it is included as a correlation ID in the log prefix.
    The script name is always included for traceability.

    NOTE: When _QUIET_MODE is True (set via --quiet or --agent-mode),
    this function is a no-op — no stderr output is produced.
    """
    if _QUIET_MODE:
        return
    ts = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    script_name = Path(sys.argv[0]).stem if sys.argv else "unknown"
    prefix = f"[{ts}] [{script_name}] [{level:>7}]"
    if niche_id:
        prefix += f" [{niche_id}]"
    print(f"{prefix} {message}", file=sys.stderr)


# ─── Date Helpers ─────────────────────────────────────────────────────────────

def parse_iso_date(date_str: str) -> datetime:
    """
    Parse ISO 8601 date string to timezone-aware datetime.
    Handles: '2026-07-23', '2026-07-23T14:30:00Z', '2026-07-23T14:30:00+00:00'

    NOTE: Python 3.10's datetime.fromisoformat() does NOT parse 'Z' suffix.
    We strip 'Z' and append '+00:00' before parsing to avoid silent truncation
    to midnight UTC.
    """
    date_str = date_str.strip()
    # Strip 'Z' suffix — Python 3.10 fromisoformat() does not handle it
    if date_str.endswith('Z') or date_str.endswith('z'):
        date_str = date_str[:-1] + '+00:00'
    # Try full ISO first
    try:
        dt = datetime.fromisoformat(date_str)
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        return dt
    except ValueError:
        pass
    # Fall back to date-only
    try:
        return datetime.strptime(date_str[:10], "%Y-%m-%d").replace(tzinfo=timezone.utc)
    except ValueError:
        raise ValueError(f"Cannot parse date: '{date_str}'")


def days_between(d1: datetime, d2: datetime) -> int:
    """Absolute days between two datetimes (ignores time component)."""
    return abs((d2.date() - d1.date()).days)


def now_utc() -> datetime:
    """Current time in UTC."""
    return datetime.now(timezone.utc)


def format_date(dt: datetime) -> str:
    """Format datetime as ISO 8601 date string (YYYY-MM-DD)."""
    return dt.strftime("%Y-%m-%d")


# ─── Repo-Relative Path Helper ────────────────────────────────────────────────

def repo_relative_path(path: Path) -> str:
    """Convert an absolute path to a repo-relative path string.

    Used in JSON output so file paths are portable across environments
    and save tokens in agent context windows. Falls back to the absolute
    path string if the path is outside the repo root.

    Example:
        /home/user/project/research/N-001/file.yaml  →  research/N-001/file.yaml
    """
    try:
        return str(path.relative_to(REPO_ROOT))
    except ValueError:
        return str(path)


# ─── File System Helpers ──────────────────────────────────────────────────────

def resolve_niche_dir(niche_id: str) -> Path:
    """Resolve a niche directory path. Validates format."""
    import re
    if not re.match(r'^(N-\d{3}|CAL-[AB])$', niche_id):
        raise ValueError(f"Invalid NICHE_ID format: '{niche_id}'. Expected N-001..N-025 or CAL-A/CAL-B.")
    return _RESEARCH_DIR / niche_id


def find_trace_map(niche_id: str) -> Path:
    """Locate the trace-map.yaml for a given niche."""
    return resolve_niche_dir(niche_id) / "_canvas" / "evidence" / "trace-map.yaml"


def find_cache_manifest() -> Path:
    """Locate the cache manifest file."""
    return _PIPELINES_DIR / "CACHE_MANIFEST.yaml"


def find_dead_host_registry() -> Path:
    """Locate the dead-host registry."""
    return PROGRAM_DIR / "DEAD_HOST_REGISTRY.yaml"


def find_credit_budget() -> Path:
    """Locate the credit budget tracker."""
    return PROGRAM_DIR / "CREDIT_BUDGET.yaml"


def find_pipeline_checkpoints() -> Path:
    """Locate the pipeline checkpoints file."""
    return PROGRAM_DIR / "PIPELINE_CHECKPOINTS.yaml"


def find_quality_metrics() -> Path:
    """Locate the quality metrics file."""
    return PROGRAM_DIR / "QUALITY_METRICS.yaml"


def find_freshness_violation_log() -> Path:
    """Locate the freshness violation log."""
    return PROGRAM_DIR / "FRESHNESS_VIOLATION_LOG.yaml"


def find_tool_error_log() -> Path:
    """Locate the tool error log."""
    return PROGRAM_DIR / "TOOL_ERROR_LOG.yaml"


def find_sli_definitions() -> Path:
    """Locate the SLI definitions file."""
    return PROGRAM_DIR / "SLI_DEFINITIONS.yaml"


# ─── SLA Lookup Helpers ───────────────────────────────────────────────────────

def lookup_sla(data_type: str) -> Optional[Dict[str, Any]]:
    """
    Look up the freshness SLA entry for a given data_type string.
    Returns None if the data_type is not found in the SLA table.

    Uses the pre-built DATA_TYPE_TO_SLA_KEY index for O(1) lookup
    instead of linear scan over FRESHNESS_SLA.
    """
    sla_key = DATA_TYPE_TO_SLA_KEY.get(data_type)
    if sla_key:
        return FRESHNESS_SLA[sla_key]
    return None


def get_sla_max_age(data_type: str) -> int:
    """Get max_age_days for a data type. Returns 0 (force re-fetch) if not found."""
    entry = lookup_sla(data_type)
    if entry:
        age = entry["max_age_days"]
        if isinstance(age, int):
            return age
        if isinstance(age, str) and age.endswith('d'):
            return int(age[:-1])
    return 0  # Unknown data type: force re-fetch rather than assuming stale data is OK


def is_block_class(data_type_or_class: str) -> bool:
    """Check if a data type or SLA class has BLOCK enforcement."""
    # Check if it's a class name
    if data_type_or_class in BLOCK_CLASS_DATA_TYPES:
        return True
    # Check if it's a data type name
    entry = lookup_sla(data_type_or_class)
    if entry:
        return entry["class"] in BLOCK_CLASS_DATA_TYPES
    return False


# ─── Argument Parsing (DEPRECATED) ─────────────────────────────────────────────
#
# parse_args() and get_flag() are retained for backward compatibility but are
# NOT imported by any current operational script. New scripts should handle
# argument parsing in-line or use argparse. These may be removed in a future
# release.

def parse_args(script_name: str, usage: str, required_args: List[str] = None):
    """
    [DEPRECATED] Standardized argument parsing with --dry-run support.
    No script uses this. Scheduled for removal. Use argparse instead.

    Returns: (args_dict: Dict[str, Optional[str]], dry_run: bool)
    """
    args = sys.argv[1:]
    dry_run = False

    if '--dry-run' in args:
        dry_run = True
        args.remove('--dry-run')

    if required_args and len(args) < len(required_args):
        emit_log("ERROR", f"Usage: {script_name} {usage}")
        emit_result(ExitCode.INVALID_INPUT, {
            "error": f"Expected at least {len(required_args)} positional arguments, got {len(args)}",
            "usage": f"{script_name} {usage}"
        })

    result = {}
    for i, name in enumerate(required_args or []):
        result[name] = args[i] if i < len(args) else None

    return result, dry_run


def get_flag(args_list: List[str], flag: str) -> Tuple[Optional[str], List[str]]:
    """
    [DEPRECATED] Extract a --flag VALUE pair from a list of arguments.
    No script uses this. Scheduled for removal. Use argparse instead.
    Returns (value, remaining_args).
    """
    remaining = []
    value = None
    skip_next = False
    for i, arg in enumerate(args_list):
        if skip_next:
            skip_next = False
            continue
        if arg == flag:
            if i + 1 < len(args_list) and not args_list[i + 1].startswith('--'):
                value = args_list[i + 1]
                skip_next = True
            else:
                value = ""  # Flag present but no value
        else:
            remaining.append(arg)
    return value, remaining
