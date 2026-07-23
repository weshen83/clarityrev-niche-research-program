# Workstream C Execution Plan — Reliability & Concurrency

**Date:** 2026-07-23
**Engineer:** SRE + Python Infrastructure (Netflix Chaos Engineering discipline)
**Spec reference:** `TOOL-LANDSCAPE-FIX-SPEC-COMPLETE.md` items #41-73 + Quick Wins touching reliability

---

## Overview

33 findings in Workstream C + ~12 Quick Wins touching reliability. Organized into 9 execution waves for parallelizability and dependency ordering.

---

## Wave 1: TIMEOUT_CONFIG.yaml — Structured Restructure (SRE-C01, SRE-MB4, SRE-MB5, SRE-MB6)

**File:** `_program/TIMEOUT_CONFIG.yaml`

| Fix | Change | Est. Time |
|---|---|---|
| SRE-C01 (CRITICAL) | Change dataforseo.serp.standard.total: 30s → 310s | 1 min |
| SRE-MB4 (MEDIUM) | Restructure to 3-level (connect + read + total) per tool | 10 min |
| SRE-MB5 (MEDIUM) | Firecrawl /scrape js_rendered: 60s → 90s; add `static`/`js_rendered` sub-keys | 3 min |
| SRE-MB6 (MEDIUM) | Add `free_apis:` section with connect/read/total per API | 5 min |

**Verification:** `python3 -c "import yaml; d=yaml.safe_load(open('...')); assert d['dataforseo']['serp']['standard']['total'] == 310"`

---

## Wave 2: SLI_DEFINITIONS.yaml — Fix Unachievable SLIs (SRE-M01, SRE-M02, SRE-M03)

**File:** `_program/SLI_DEFINITIONS.yaml`

| Fix | Change | Est. Time |
|---|---|---|
| SRE-M01 (MEDIUM) | credit_forecast_accuracy target: "Within 20%" → "Within 50%" for first 5 niches | 2 min |
| SRE-M02 (MEDIUM) | fetch_success_rate: exclude 401/402/403/404 from denominator; split into RETRYABLE/NON_RETRYABLE | 3 min |
| SRE-M03 (MEDIUM) | evidence_quality: add single_source_ratio qualifier; adjust target if >50% single-source | 3 min |

**Verification:** Valid YAML, all fields parse correctly. Run `python3 -c "import yaml; yaml.safe_load(open('...'))"`

---

## Wave 3: RUNBOOK.md — Fix Firecrawl Status Page + --force Flag (SRE-C03, SRE-L07)

**File:** `_pipelines/RUNBOOK.md`

| Fix | Change | Est. Time |
|---|---|---|
| SRE-C03 (CRITICAL) | Replace `status.firecrawl.com` with `firecrawl --status` test + DataForSEO health endpoint | 5 min |
| SRE-L07 (LOW) | Document `--force` flag for BLOCKED freshness override | 3 min |

**Verification:** Read through — no parsing needed, human-readable markdown.

---

## Wave 4: DATA-OPERATIONS-ARCHITECTURE.md — Rate Limit Corrections (8 fixes)

**File:** `DATA-OPERATIONS-ARCHITECTURE.md`

| Fix | Change | Est. Time |
|---|---|---|
| SRE-C05 (CRITICAL) | OECD API: 20 req/min (not "unlimited") | 3 min |
| SRE-CB1 (CRITICAL) | Firecrawl /crawl: 50 starts/min (not "50 concurrent") | 3 min |
| SRE-H01 (HIGH) | IMF API: 50 req/s (not "unlimited") + 1.5s delay | 3 min |
| SRE-H02 (HIGH) | TED API: undocumented per-IP limits, 429 handling | 3 min |
| SRE-H03 (HIGH) | Wikidata SPARQL: 5 concurrent/IP, timeout 60s not 5s | 3 min |
| SRE-H04 (HIGH) | OpenRegistry MCP: 3 countries/60s free tier + 5 req/min throttle | 3 min |
| SRE-H11 (HIGH) | DataForSEO Google Ads Live: 12 req/min limit | 2 min |
| SRE-H12 (HIGH) | Currents API: add Firecrawl-only fallback note | 2 min |

**Verification:** grep for changed strings confirms fixes applied.

---

## Wave 5: Preflight-check Operational Readiness (SRE-C08, SRE-C06, SRE-H09, SRE-H10, SRE-H14)

**File:** `_pipelines/preflight-check` (Python)

| Fix | Change | Est. Time |
|---|---|---|
| SRE-C08 (CRITICAL) | Add GATE functions: ping_firecrawl(), ping_dataforseo(), ping_mcp_servers(), check_disk_space(), check_python_deps(). Integrate into main() flow. | 20 min |
| SRE-C06 (CRITICAL) | Add dead-host registry WRITE logic: 3 consecutive failures → write to DEAD_HOST_REGISTRY.yaml using atomic tmp+mv | 10 min |
| SRE-H09 (HIGH) | Add check_disk_space(): BLOCKED if <100MB, WARNING 100-500MB | 5 min |
| SRE-H10 (HIGH) | Add check_python_deps(): verify ruamel.yaml, requests, urllib3, pyyaml, jsonschema can import | 5 min |
| SRE-H14 (HIGH) | Fix CREDIT_BUDGET error message: "Phase 0 calibration NOT run" instead of INTERNAL_ERROR | 2 min |
| SRE-HB2 (HIGH) | Add per-call DataForSEO balance check before DFS API calls | 5 min |
| SRE-L05 (LOW) | Add firecrawl credit-usage parsing to preflight | 5 min |

**Verification:** `python3 _pipelines/preflight-check --self-check` exits 0. Python syntax valid.

---

## Wave 6: Create Missing Infrastructure Files (SRE-C04, SRE-M05, SRE-M06, SRE-M07, SRE-L02, SRE-L04, SRE-H10)

| Fix | New File | Content | Est. Time |
|---|---|---|---|
| SRE-C04 (CRITICAL) | `_program/_CONCURRENCY_LOCK.yaml` | Lock schema with acquire/release protocol, tool_limits | 5 min |
| SRE-M05 (MEDIUM) | `_program/MCP_SCHEDULE.yaml` | Per-server concurrent capacity, last-access timestamps | 5 min |
| SRE-M06 (MEDIUM) | `_program/TOOL_VERSIONS.yaml` | Pinned API versions from calibration | 5 min |
| SRE-M07 (MEDIUM) | `SHARED/_REGISTRY.yaml` + dirs | Register, benchmarks/, competitors/, triggers/ | 5 min |
| SRE-L02 (LOW) | `_program/_postmortems/` + INDEX.yaml | PIR directory + index | 3 min |
| SRE-L04 (LOW) | Update `_program/PIPELINE_CHECKPOINTS.yaml` | Add PHASE_0_DELTA_COUNTER field | 2 min |
| SRE-H10 (HIGH) | `requirements.txt` | Pinned versions (pyyaml, requests, urllib3, certifi, jsonschema, ruamel.yaml) | 3 min |

---

## Wave 7: Freshness Audit — ETag/Last-Modified Fix (SRE-M04, FM-4)

**File:** `_pipelines/freshness-audit` + `DATA-OPERATIONS-ARCHITECTURE.md §6.4a`

| Fix | Change | Est. Time |
|---|---|---|
| SRE-M04 (MEDIUM) | Replace HEAD + content hash comparison with "ETag or Last-Modified header comparison" in freshness-audit re-certification | 5 min |
| SRE-M04 doc | Update DATA-OPERATIONS-ARCHITECTURE.md §6.4a: "HEAD + hash" → "ETag or Last-Modified" | 3 min |

**Verification:** `python3 _pipelines/freshness-audit --help` works. Python syntax valid.

---

## Wave 8: GDELT Retry Logic + Hiring Signal Fallback Chain (SRE-C02, SRE-C07)

**Files:** `DATA-OPERATIONS-ARCHITECTURE.md` §2.3 Tool-to-Task Master Matrix

| Fix | Change | Est. Time |
|---|---|---|
| SRE-C02 (CRITICAL) | Add exponential backoff + 3 retries (1s/2s/4s + jitter) instruction to any script/instruction calling GDELT | 5 min |
| SRE-C07 (CRITICAL) | Fix hiring signal fallback: remove GDELT as hiring fallback. Add Greenhouse.io + Lever.co public API calls. Accept SOURCE_UNAVAILABLE as final path. | 10 min |

---

## Wave 9: Additional HIGH remaining items (SRE-H05, SRE-H06, SRE-H07, SRE-H08, SRE-H13, SRE-HB1)

**Files:** `DATA-OPERATIONS-ARCHITECTURE.md` + agent prompt docs

| Fix | Change | Est. Time |
|---|---|---|
| SRE-H05 (HIGH) | Reddit Research MCP per-agent throttle: 2 concurrent calls max | 3 min |
| SRE-H06 (HIGH) | Registry Lookup API fallback: add to CREDENTIALS.yaml or accept OpenRegistry-only | 3 min |
| SRE-H07 (HIGH) | BuiltWith fallback: register or accept DataForSEO-only | 3 min |
| SRE-H08 (HIGH) | Per-niche wall-clock: update to 45 min hard limit, note as uncalibrated | 3 min |
| SRE-H13 (HIGH) | Pricing data fallback: add DataForSEO OnPage API as tool-diverse fallback | 3 min |
| SRE-HB1 (HIGH) | Market sizing fallback: add DATA_TYPE_MISMATCH flag | 3 min |

---

## Execution Order

```
Wave 1: TIMEOUT_CONFIG.yaml  --> DONE (already started)
Wave 2: SLI_DEFINITIONS.yaml
Wave 3: RUNBOOK.md
Wave 4: DATA-OPERATIONS-ARCHITECTURE.md (§2.1 + §2.3 rate limit fixes)
Wave 5: preflight-check (complex — do after simple edits)
Wave 6: New infrastructure files (no dependencies)
Wave 7: freshness-audit ETag fix
Wave 8: GDELT + Hiring signal doc fixes
Wave 9: Remaining HIGH items

VERIFY: python3 -c "import py_compile; py_compile.compile('...')" for all .py scripts
VERIFY: yaml.safe_load() for all .yaml files
VERIFY: requirements.txt pip install --dry-run
```

## Concurrency Model Changes

- `_CONCURRENCY_LOCK.yaml` creation affects §4.6 concurrency management
- Preflight-check gains GATE functions that consume 0 credits but add ~2s per check
- Dead-host registry WRITE logic changes the pipeline from read-only to read-write
- DataForSEO balance per-call check (SRE-HB2) adds try/except around DFS calls

## Risk Items

| Risk | Mitigation |
|---|---|
| Preflight-check PYTHON parsing fails after heavy edits | Test with py_compile after every major edit block |
| TIMEOUT_CONFIG.yaml has YAML syntax error after restructure | Run python3 -c "import yaml; yaml.safe_load(open(...))" |
| freshness-audit breakage from ETag changes | Only update the re-certification comment/docs, not the Python logic itself (HEAD hash not actually in code — already using ETag-like logic) |
| FILE NOT FOUND for paths that don't exist yet | Create directories before writing files |
