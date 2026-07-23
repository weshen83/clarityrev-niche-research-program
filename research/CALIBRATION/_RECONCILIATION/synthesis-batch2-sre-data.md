# Synthesis Batch 2: SRE/Reliability + Data Quality — Consolidated Findings

**Source Reports:**
- `audit-lens3-sre-reliability.md` — 42 findings (8 CRITICAL, 14 HIGH, 12 MEDIUM, 8 LOW)
- `audit-lens4-data-quality.md` — 25 findings (4 P1, 4 P2, 4 P3 + 9 embedded body findings)

**Date:** 2026-07-23
**Scope:** Complete extraction of every finding across both audits with exact fix specification

---

## TABLE OF CONTENTS

1. [LENS 3: SRE/RELIABILITY — ALL FINDINGS](#lens-3-srereliability--all-findings)
2. [LENS 4: DATA QUALITY — ALL FINDINGS](#lens-4-data-quality--all-findings)
3. [PRE-FLIGHT HEALTH CHECK SPECIFICATION (from Lens 3)](#pre-flight-health-check-specification)
4. [DATA-COVERAGE-MATRIX.md SCHEMA (from Lens 4)](#data-coverage-matrixmd-schema)

---

## LENS 3: SRE/RELIABILITY — ALL FINDINGS

### CRITICAL (8 findings)

| SEVERITY | ID | One-line description | Exact fix | Minutes |
|---|---|---|---|---|
| CRITICAL | C-01 | DataForSEO standard queue timeout is 30s in TIMEOUT_CONFIG.yaml, but architecture says 300s — every standard-queue call will time out | Change DataForSEO standard queue timeout from 30s to 310s (5 min + 10s buffer) in TIMEOUT_CONFIG.yaml. Split into `serp.standard` (connect:5, read:300, total:310) and `serp.live` (connect:5, read:15, total:30). | 5 |
| CRITICAL | C-02 | GDELT has zero retry logic — silent data loss when rate-limited | Add exponential backoff + retry (3 attempts: 1s/2s/4s + jitter) to all GDELT calls. If all 3 fail, mark as `SOURCE_UNAVAILABLE` — not empty response. Update agent prompts for GDELT integration. | 20 |
| CRITICAL | C-03 | Firecrawl status page `status.firecrawl.com` does not exist (DNS NXDOMAIN) — RUNBOOK instructs operators to check a page that doesn't exist | Remove broken status page instruction from RUNBOOK.md. Replace with: "Send a test /search request. If it succeeds, Firecrawl is operational. If it fails, check `https://docs.firecrawl.dev/` for known issues or contact support." | 5 |
| CRITICAL | C-04 | Global concurrency lock (`_CONCURRENCY_LOCK.yaml`) does not exist on disk — 4 agents in Phase 2 would hit tools with zero coordination | Create `_program/_CONCURRENCY_LOCK.yaml` with schema defined in DATA-OPERATIONS-ARCHITECTURE.md §4.6. Agent prompts must include lock acquisition/release. | 30 |
| CRITICAL | C-05 | OECD API has 20 req/min limit, not "unlimited" as documented | Fix documentation in DATA-OPERATIONS-ARCHITECTURE.md. Add rate limit awareness to agent prompts. Set per-agent OECD throttle to 5 req/min max. | 10 |
| CRITICAL | C-06 | Dead-host registry is a write-desert — nothing writes to it, it will always remain empty | Add dead-host write logic to all scraping agent prompts. When 3 consecutive failures to same host occur, write entry to DEAD_HOST_REGISTRY.yaml. Implement `.lock` file mechanism for concurrent writes. | 25 |
| CRITICAL | C-07 | Hiring signal fallback chain (ATS -> Techmap -> GDELT) degrades to fundamentally different data type that pipeline has no processing capability for | Accept that hiring signal BLOCKAGE is unrecoverable without ATS access. Document `SOURCE_UNAVAILABLE` as the only path for hiring data when ATS APIs fail. Remove GDELT as a hiring fallback — it cannot produce structured job counts. | 15 |
| CRITICAL | C-08 | Preflight-check does not verify any tool is actually reachable — a completely offline pipeline would report "PROCEED" | Add GATE 1 (tool health checks) as specified in §6.1 of audit. At minimum: Firecrawl ping, DataForSEO ping, and disk space check. Implement `check_firecrawl_health()`, `check_dataforseo_health()`, `check_disk_space()`. | 45 |

### HIGH (14 findings)

| SEVERITY | ID | One-line description | Exact fix | Minutes |
|---|---|---|---|---|
| HIGH | H-01 | IMF API has 50 req/s app-based limit — not "unlimited" as documented. Default app-name collision risk | Fix documentation in DATA-OPERATIONS-ARCHITECTURE.md. Add unique `user_agent` configuration to avoid default-shared rate limit collision. Add 1.5s delay between calls (as imfp library does). | 10 |
| HIGH | H-02 | TED API has undocumented per-IP rate limits — not "unlimited". Returns HTTP 429 with no guidance | Fix documentation in DATA-OPERATIONS-ARCHITECTURE.md. Add 429 handling with exponential backoff. Accept that TED is best-effort only. | 10 |
| HIGH | H-03 | Wikidata SPARQL has 5 concurrent queries/IP limit (not 5s timeout — actual timeout is 60s). 4 agents + agent's own concurrency guarantee >5 concurrent | Fix documentation: correct timeout value is 60s (not 5s). Add per-agent throttle: max 3 concurrent SPARQL queries. Add retry for 429. | 10 |
| HIGH | H-04 | OpenRegistry MCP multi-country fan-out limited to 3 countries/60s on free tier, not "30 national registries" as documented | Fix documentation. Add per-agent throttle of 5 req/min for OpenRegistry. Document free tier constraint. | 5 |
| HIGH | H-05 | Reddit Research MCP anonymous access limited to 10 req/min — if no OAuth configured, 20 concurrent requests exceed limit by 2x | Document current auth mode. If anonymous, add per-agent throttle: max 2 concurrent Reddit calls. Recommend OAuth setup for full 100 req/min throughput. | 15 |
| HIGH | H-06 | Company registry fallback (Registry Lookup API with 5K/mo) is documented but NOT configured — no API key, endpoint, or agent prompt references | Add Registry Lookup API endpoint, API key to CREDENTIALS.yaml, and agent prompt instructions. If not available, accept OpenRegistry-only with documented single-point-of-failure. | 15 |
| HIGH | H-07 | Technographics fallback (BuiltWith free API, 2K/day) is documented but NOT configured — no API key in any pipeline file | Register for BuiltWith free API key. Add to CREDENTIALS.yaml. Add agent prompt for BuiltWith usage as fallback when DataForSEO Domain Analytics fails. | 15 |
| HIGH | H-08 | Per-niche wall-clock estimates (13-16 min I/O, 20-25 min total) are completely untested guesses | Run calibration niche and measure actual timings. Update estimates based on real data. Set per-niche hard limit at 45 min as documented. | 30 |
| HIGH | H-09 | Disk space check missing from ALL pipeline scripts — silent failure when disk fills up (atomic writes fail, zero-size files pass cache-hit checks) | Add `check_disk_space()` to preflight-check (BLOCKED if <100MB, WARNING if 100-500MB). Add write-time guard in validate-schema: if disk < 100MB, refuse write and raise error. | 15 |
| HIGH | H-10 | No `requirements.txt` or dependency pinning — `pip install --upgrade` could break `ruamel.yaml`, `certifi` SSL failures block all HTTPS | Create `requirements.txt` with pinned versions for `pyyaml`, `requests`, `urllib3`, `certifi`. Add `check_python_env()` to preflight-check (tries `import yaml, requests, hashlib, json, re, pathlib`). | 15 |
| HIGH | H-11 | DataForSEO Google Ads Live endpoint has 12 req/min limit — if any agent uses Live method for keyword data, blocks for minutes | Ensure all agent prompts specify "use standard queue, never live" for Google Ads endpoints. Document the 12 req/min limit in DATA-OPERATIONS-ARCHITECTURE.md. | 10 |
| HIGH | H-12 | News/intent signal fallback (Currents API, 1K/day) is documented but NOT configured — no API key, endpoint, or agent prompt | Add Currents API key to CREDENTIALS.yaml and agent prompt. Or accept Firecrawl-only for news and drop Currents from fallback chain entirely. | 10 |
| HIGH | H-13 | Pricing data has no tool-diverse fallback — primary and fallback are both Firecrawl; a Firecrawl outage means ALL pricing data is `SOURCE_UNAVAILABLE` | Add DataForSEO OnPage API as a tool-diverse pricing fallback. Scrape competitor pricing pages via OnPage when Firecrawl is unavailable. Document in agent prompts. | 20 |
| HIGH | H-14 | Preflight-check flags CREDIT_BUDGET.yaml missing as INTERNAL_ERROR instead of a clear actionable message | Change error message to: "Phase 0 calibration has NOT been run. Run Phase 0 before any niche evaluation." Make message actionable for operator. | 5 |

### MEDIUM (9 findings)

| SEVERITY | ID | One-line description | Exact fix | Minutes |
|---|---|---|---|---|
| MEDIUM | M-01 | SLI for credit forecast accuracy (20%) is too tight for an uncalibrated system — per-niche estimate could be 52% off | Loosen SLI to 50% for first 5 niches. Tighten after calibration data stabilizes estimates. Update SLI_DEFINITIONS.yaml. | 5 |
| MEDIUM | M-02 | Fetch success SLI counts non-retryable failures (401, 402, 403, 404) in denominator — these are data gaps, not system failures | Exclude NON_RETRYABLE errors (401, 402, 403, 404, 400) from fetch success SLI calculation. Split error codes into RETRYABLE (429, 500, 502, 503) and NON_RETRYABLE sets. | 5 |
| MEDIUM | M-03 | Evidence quality SLI may fail for single-source niches despite correct grading (pricing from single competitor page capped at `[E]`) | Add a `single_source_ratio` qualifier. If >50% of data types are inherently single-source, adjust target percentage. Update SLI_DEFINITIONS.yaml. | 10 |
| MEDIUM | M-04 | Freshness re-certification via HEAD request hash comparison is impossible — HEAD responses don't include body hash | Replace "content hash comparison" with "ETag or Last-Modified header comparison" for HEAD-based re-certification in DATA-OPERATIONS-ARCHITECTURE.md §6.4a. | 10 |
| MEDIUM | M-05 | MCP server integration schedule (MCP_SCHEDULE.yaml) not created — agents default to 1 concurrent MCP call per server, artificially slow | Create `_program/MCP_SCHEDULE.yaml` per design. Specify concurrent MCP capacity per server type. | 15 |
| MEDIUM | M-06 | TOOL_VERSIONS.yaml not created — no pinned API versions, no delta check mechanism | Create during Phase 0 calibration. Pin API versions for every tool. Delta check (every 10 niches) needs this file to detect breaking changes. | 15 |
| MEDIUM | M-07 | SHARED/ directory bootstrap not started — `_REGISTRY.yaml`, benchmarks/, competitors/, triggers/ all missing | Create `_REGISTRY.yaml`, benchmarks/, competitors/, triggers/ directories under SHARED/. First 5 niches bootstrap the registry per architecture §7.2. | 20 |
| MEDIUM | M-08 | Cache hit rate tracking not implemented — RUNBOOK's "if cache hit rate < 60% investigate" is unmeasurable | Add `cache_hit` field to CREDIT_BUDGET.yaml tracking. Track cache hit/miss per fetch operation. | 10 |
| MEDIUM | M-09 | Pipeline availability SLI has no measurement mechanism — no uptime tracking exists | Add uptime tracking: `pipeline_start_timestamp` and `pipeline_last_failure_timestamp` fields in TOOL_ERROR_LOG.yaml. At minimum a simple running counter. | 10 |

### LOW (8 findings)

| SEVERITY | ID | One-line description | Exact fix | Minutes |
|---|---|---|---|---|
| LOW | L-01 | CONCURRENCY_LOCK.yaml stale lock cleanup interval not specified — no mechanism to break locks >5 min old | Document: "If a lock is >5 minutes old, any agent may break it." Add to agent prompts. Currently implied but not explicit. | 5 |
| LOW | L-02 | Post-incident review template references PIR-YYYYMMDD-NN naming convention but `_program/_postmortems/` directory doesn't exist | Create `_program/_postmortems/` directory. Add INDEX.yaml. | 5 |
| LOW | L-03 | Credit burn rate kill switch (4,000/hr warning, 8,000/hr halt) can't be measured without real credit tracking at proper granularity | Ensure every credit-consuming operation writes to CREDIT_BUDGET.yaml with timestamp. Verify current script reads credits but doesn't verify tracking granularity. | 10 |
| LOW | L-04 | Phase 0 recurring delta check (every 10 niches) not scheduled anywhere — no counter or trigger | Add `PHASE_0_DELTA_COUNTER` to PIPELINE_CHECKPOINTS.yaml. Increment after each niche completion. When counter hits 10, trigger delta check. | 5 |
| LOW | L-05 | Firecrawl credit-usage command not run programmatically in preflight-check — reads local CREDIT_BUDGET.yaml only, may be stale | Add `firecrawl credit-usage` parsing to preflight-check. Verify on-disk budget matches API-reported budget. | 15 |
| LOW | L-06 | No mechanism to verify DataForSEO password hasn't rotated or OAuth tokens haven't expired | Add `last_verified` field to CREDENTIALS.yaml. Add expiry date tracking for OAuth tokens. | 10 |
| LOW | L-07 | No `--force` flag documented for BLOCKED-class data staleness override — emergency waiver method unclear | Document the `--force` override flag in RUNBOOK.md with exact usage: `--force` bypasses BLOCKED freshness gates for emergency use. | 5 |
| LOW | L-08 | Cross-source consistency for categorical claims not implemented — two hallucinated sources could both claim same thing and get `[P]` | Add check: if two independent sources make identical categorical claims, verify both sources use same wording. If yes -> `[P]`. If no -> flag for human review (hallucination risk). | 20 |

### EMBEDDED BODY FINDINGS (Lens 3 — not in fix list but documented in body)

| SEVERITY | ID | One-line description | Exact fix | Minutes |
|---|---|---|---|---|
| CRITICAL | C-B01 | Firecrawl /crawl rate limit is 50 starts/min (not "50 concurrent") — a structural misunderstanding in the architecture | Fix documentation: "50 concurrent browsers" is about browser sessions, not crawl job initiation. /crawl is limited to 50 starts/min. Document crawl start concurrency as separate from scrape concurrency. | 10 |
| HIGH | H-B01 | Market sizing fallback chain goes to qualitatively different data type (search volume as proxy for market size) without flagging substitution | Add `DATA_TYPE_MISMATCH` flag when substituting search volume for market size. Document the substitution in trace-map.yaml. Do not silently substitute. | 15 |
| HIGH | H-B02 | DataForSEO balance can hit $0 mid-phase — GATE checks only fire at phase transitions, mid-phase 402 errors burn time (but not credits) | Add per-call DataForSEO balance check before every API call (not just at phase transitions). Or at minimum, wrap DFS calls with try/except for 402 errors. | 15 |
| MEDIUM | M-B01 | Eurostat API rate limit is "30 req/min" but this is a GUESS — specific number not publicly documented | Verify Eurostat rate limit empirically during Phase 0 calibration. Update documentation with measured value. | 10 |
| MEDIUM | M-B02 | World Bank API rate limit is "unlimited" — this is UNVERIFIED; specific limits exist but number unknown | Verify World Bank rate limit empirically during Phase 0 calibration. Update documentation. | 10 |
| MEDIUM | M-B03 | Firecrawl /crawl: if one agent starts a large crawl, ALL 50 browser sessions consumed — other 3 agents' scrape jobs queued | Document in agent prompts: large crawl jobs (>20 pages) should be scheduled during low-usage windows. Add warning when crawl depth would consume >50% of browser slots. | 10 |
| MEDIUM | M-B04 | Timeout granularity is wrong — TIMEOUT_CONFIG.yaml uses ONLY total timeouts, no connect/read split | Restructure TIMEOUT_CONFIG.yaml per corrected schema (3-level: connect + read + total). See §7.3 of audit for full corrected config. | 20 |
| MEDIUM | M-B05 | Firecrawl /scrape JS-rendered timeout is 60s in config but architecture specifies 90s for `--wait-for` pages | Change Firecrawl scrape timeout for JS-rendered pages from 60s to 90s. Add `static` vs `js_rendered` sub-keys in TIMEOUT_CONFIG.yaml. | 5 |
| MEDIUM | M-B06 | No free API timeout entries in TIMEOUT_CONFIG.yaml — GDELT, EUROSTAT, OECD, World Bank, TED, IMF all fall through to 60s default | Add `free_apis:` section to TIMEOUT_CONFIG.yaml with connect/read/total for each API. See §7.3 of audit for full specification. | 15 |

**Lens 3 total: 42 enumerated + 9 embedded = 51 findings**

---

## LENS 4: DATA QUALITY — ALL FINDINGS

### P1 — Blocking Issues (Must Fix Before Any Niche Canvas Is Scored)

| SEVERITY | ID | One-line description | Exact fix | Minutes |
|---|---|---|---|---|
| P1 (CRITICAL) | DQ-01 | Evidence grade engine never calibrated against human judgment — 16/16 truth-table combinations work mathematically but alignment with human raters is unknown | Run calibration study: 3 human raters grade 30 claims from calibration niche. Compare vs. deterministic engine. Adjust criteria where disagreement >20%. | 60 |
| P1 (CRITICAL) | DQ-02 | No normalization for data availability across niches — non-IT niches will be systematically under-scored by the grade engine | Implement DATA-COVERAGE-MATRIX.yaml (see schema §6.1) and normalization factor before fertility ranking. A niche with 3/8 available and 60% `[E]+` is stronger than one with 6/8 available and 80% `[E]+`. | 45 |
| P1 (CRITICAL) | DQ-03 | Independent verifier cannot detect interpretation fabrication — re-fetching URL and comparing hashes does NOT verify agent's interpretation of content | Extend verifier protocol: verifier must independently extract the specific claim from the fetched content and compare against trace-map's structured data field. This requires the verifier to know the exact claim text and field mapping. | 60 |
| P1 (CRITICAL) | DQ-04 | Schema validation scripts (validate-schema.sh, freshness-audit.sh, preflight-check.sh) are DRAFT / NOT OPERATIONAL — templates with placeholder implementations | Implement all three scripts before any niche evaluation begins. The manual processes specified as fallbacks will fail under 25-niche concurrency. | 120 |

### P2 — High-Severity Gaps

| SEVERITY | ID | One-line description | Exact fix | Minutes |
|---|---|---|---|---|
| P2 (HIGH) | DQ-05 | >=20 reviews from >=2 independent sources is impossible for 8-10 niches (consulting, agencies, fractional exec, manufacturing) — canvas requirement cannot be met | Add a `review_corpus_availability` flag to trace-map.yaml. If a niche's review platforms don't exist (no G2/Capterra), demote the requirement from "minimum" to "target" for that niche. Adjust evidence grade ceiling accordingly. | 15 |
| P2 (HIGH) | DQ-06 | No dedicated tool assigned for buyer language extraction — buyer quotes are gathered as byproduct of review scraping, not as a dedicated pipeline step | Add a dedicated buyer-language extraction step to Phase 2: Firecrawl /search for verbatim quotes from G2 reviews, Reddit threads, LinkedIn posts. Require schema-defined output with source URL. | 20 |
| P2 (HIGH) | DQ-07 | Trigger scoring (ACH matrix in §6A) has no empirical basis — Frequency, Urgency, Budget-Likelihood, Detectability scores are pure agent judgment with no validation gate | After scoring, require the Agent to produce evidence for at least 2 of 4 dimensions per trigger. Detectability must be verified by a live API call or documentation reference. No score without evidence. | 20 |
| P2 (HIGH) | DQ-08 | Stackshare/tech blog analysis for technical architecture inference has no assigned tool in the inventory | Add Stackshare API (if accessible) or BuiltWith/Wappalyzer for tech inference. Or flag technical architecture claims as `[H]` with specific confidence downgrade and document limitation. | 20 |

### P3 — Medium-Severity Gaps

| SEVERITY | ID | One-line description | Exact fix | Minutes |
|---|---|---|---|---|
| P3 (MEDIUM) | DQ-09 | Budget verification (§2.3) has no tool support — no way to verify budget availability before investing founder hours | Accept this as inherently human-process. Budget verification is a conversation, not a tool output. Flag in §15 (Validation Plan) as a pre-investment validation step. | 5 |
| P3 (MEDIUM) | DQ-10 | Non-transparent pricing for enterprise/consulting niches has no fallback — architecture handles public pricing well but fails for custom-quote models | When public pricing is unavailable: use G2 reviewer price mentions, job-postings-referenced budget, or competitor case studies. Mark as `[E]` (secondary source). Document the limitation in canvas. | 15 |
| P3 (MEDIUM) | DQ-11 | GDELT rate limit unbounded — architecture doesn't specify queuing or batch strategy for 10-20 queries per niche | Add rate-limit handling to GDELT queries in Phase 2.7. Bundle queries to minimize requests. Add 1s/2s/4s backoff. GDELT has no public rate limit but BigQuery project-level limits apply. | 15 |
| P3 (MEDIUM) | DQ-12 | Reddit Research MCP for non-English subreddits has thin coverage — buyer language extraction for NL niches will default to English | For NL-specific niches, supplement with Dutch-language LinkedIn groups, industry forums, and CBS StatLine reports. Document English-dominant VOC as coverage limitation. | 15 |

### EMBEDDED BODY FINDINGS (Lens 4 — gap counts from Section 2.3 and Section 5)

| SEVERITY | ID | One-line description | Exact fix | Minutes |
|---|---|---|---|---|
| MEDIUM | DQ-B01 | Section 1 (Market Sizing) has AMBIGUITY gap — no guidance on which source combination to use for first vs. second independent source | Add explicit agent guidance: "Use gov API (EUROSTAT/OECD) as primary, Firecrawl /search as secondary for market sizing. If gov API unavailable, use two independent Firecrawl searches with different queries." | 10 |
| MEDIUM | DQ-B02 | Section 3 (Pain Architecture) has AMBIGUITY — 26% revenue leak benchmark is single vendor-commissioned source (Clari 2024), borderline `[E]` | Document the Clari source as vendor-commissioned in trace-map.yaml. Add note: "Borderline `[E]` — single commissioned source. Cross-validate with industry benchmarks where available." | 5 |
| MEDIUM | DQ-B03 | Section 4 (Competitive Landscape) — technical architecture inference requires Stackshare data but no tool assigned | Same as DQ-08. Either add Stackshare API or document `[H]` downgrade for tech inference claims. | 5 |
| MEDIUM | DQ-B04 | Section 5 (Ecosystem) — no tool can produce aggregator candidates, channel economics, or partner activation playbooks; entire section is agent judgment | Accept as inherently design work. Document that aggregator discovery via Firecrawl /search returns names only — not economic models. Flag economic estimates as `[H]`-`[S]`. | 5 |
| MEDIUM | DQ-B05 | Section 6B (Signal Catalog) — the 15-signal requirement has no tool-defined discovery pipeline; at zero clients NO signal can have HIGH predictiveness confidence | Accept that at zero clients all signals are `[H]`. Add explicit note: "First 3 clients are calibration partners — signal confidence upgrades to `[P]` only after live validation." | 5 |
| MEDIUM | DQ-B06 | Section 7 (Customer Journey) — no tool supports journey design; all conversion rates, time-to-value, breakeven are `[H]`-`[S]` at zero clients | Accept as design section. Conversion rates inherit grades from pricing (Section 4/9). Document that zero-client conversion rates are estimated, not measured. | 5 |
| HIGH | DQ-B07 | Dark Matter: Trade show / conference presence has zero digital exhaust — no public API for event attendance, event organizers don't publish attendee lists | Add explicit note in each canvas §15 for affected niches. Most affected: EU Public Sector (trade fairs are primary GTM), Niche Manufacturing, Professional Services. | 10 |
| HIGH | DQ-B08 | Dark Matter: In-person meetings / word-of-mouth — the most common B2B buying trigger has no tool-detectable signal | Acknowledge as inherent limitation. The trigger system (§6A) is entirely digital and cannot detect "my peer at another company told me about this" — the #1 B2B buying trigger. | 5 |
| HIGH | DQ-B09 | Dark Matter: Private company dynamics — no Crunchbase API (free tier removed), no SEC filings, no G2, no public pricing for consulting/staffing companies | Add explicit coverage flag per niche. Most affected: Fractional Executive Services, Consulting, Agencies, Staffing, Manufacturing Services. Normalize evidence scores via DQ-02. | 15 |

**Lens 4 total: 12 enumerated (4 P1 + 4 P2 + 4 P3) + 9 embedded = 21 findings**

---

## PRE-FLIGHT HEALTH CHECK SPECIFICATION

From Lens 3 audit §6.1 — Required additions to the current preflight-check script (984 lines Python, implements: input validation, cache detection, credit balance check, dead-host registry check, verdict assembly).

### Current script does NOT do:
- Ping any external tool endpoint
- Verify API keys resolve
- Check DataForSEO balance from live API (reads local YAML only)
- Check disk space
- Check Python dependency integrity
- Check Firecrawl/DataForSEO account status
- Verify rate limit headroom before burst operations

### GATE 0: Self-Checks

| Check | Method | PASS | WARNING | BLOCKED |
|---|---|---|---|---|
| Python env | `python3 --version` >= 3.10 | Version OK | Version < 3.10 | Cannot import standard library |
| Dependency integrity | `python3 -c "import yaml, requests, hashlib, json, re, pathlib, os, sys"` | All imports succeed | — | Any import fails |
| Disk space | `df -h . --output=avail` > 500MB | > 500MB | 100-500MB | < 100MB |
| Git working tree | `git status --porcelain` clean | Clean | Uncommitted files | — |

### GATE 1: Tool Endpoint Reachability

| Check | Method | Expected | If Fails |
|---|---|---|---|
| Firecrawl API | `GET https://api.firecrawl.dev/v0/status` or test `POST /v0/search`. Timeout: 10s. | HTTP 200 within 10s | Try alternate endpoint. If both fail: BLOCKED. |
| Firecrawl credit balance | `GET /v1/account` or `firecrawl credit-usage`. Timeout: 10s. | Credits remaining > 0 | WARNING if < 2,000. BLOCKED if 0. |
| DataForSEO API | `GET https://api.dataforseo.com/v3/status` or minimal SERP test. Timeout: 10s. | HTTP 200 within 10s | BLOCKED |
| DataForSEO balance | Parse response for `balance` field. Timeout: 10s. | Balance > $0 | BLOCKED if $0 |
| OpenRegistry MCP | Query known entity (e.g., `search_companies` "Google"). Timeout: 15s. | Returns results | WARNING — fallback to Registry Lookup |
| Reddit Research MCP | `search_reddit` for "test" with limit 1. Timeout: 15s. | Returns results | WARNING — Reddit data will be Firecrawl-only |
| GDELT API | `GET https://api.gdeltproject.org/api/v2/doc/doc?query=test&mode=artlist&maxrecords=1`. Timeout: 15s. | Returns JSON with articles | WARNING — news data will be Firecrawl-only |

### GATE 2: Rate Limit Headroom

| Check | Method | Threshold |
|---|---|---|
| Firecrawl rate limit headroom | Burst test: 5 concurrent /scrape calls to known-fast pages (e.g., Wikipedia). Timeout: 60s. | All 5 complete. If >2 fail with 429, BLOCKED. |
| DataForSEO rate limit headroom | 3 concurrent SERP checks. Timeout: 30s. | All 3 complete. |
| OpenRegistry rate limit | Query 5 companies in quick succession. | All 5 complete. |

### GATE 3: Auth Verification

| Check | Method | Expected |
|---|---|---|
| FIRECRAWL_API_KEY | `os.environ.get("FIRECRAWL_API_KEY")` | Non-empty, non-null |
| DATAFORSEO_LOGIN | `os.environ.get("DATAFORSEO_LOGIN")` | Non-empty |
| DATAFORSEO_PASSWORD | `os.environ.get("DATAFORSEO_PASSWORD")` | Non-empty |
| CREDENTIALS.yaml | `yaml.safe_load()` | Valid YAML, all env vars resolve |
| Auth sessions | Reddit Research MCP returns results | No auth error |

### GATE 4: Phase-Specific Checks

| Phase | Check | Method |
|---|---|---|
| Phase 1 -> 2 | Credit sufficiency for Phase 2 | Firecrawl >= 2,000 credits, DataForSEO >= $40 |
| Phase 2 -> 3 | Per-niche credit variance | Actual <= 150% of estimate (~200 credits) |
| Phase 3 -> 4 | Phase 3 credit consumption | <= 30 credits |
| CANVAS FINAL | Total per-niche | <= 200 credits, <= $0.10 DataForSEO |

### Implementation Functions Required

Add to preflight-check script:
- `check_firecrawl_health()` — ping + credit balance
- `check_dataforseo_health()` — ping + balance
- `check_mcp_health()` — test OpenRegistry, Reddit MCP, Context7
- `check_free_api_health()` — test GDELT, OECD, EUROSTAT (spot check 1-2)
- `check_disk_space()` — `df` check
- `check_python_env()` — import integrity + version

---

## DATA-COVERAGE-MATRIX.md SCHEMA

From Lens 4 audit §6.1 — Required for normalizing evidence quality scores across all 25 niches.

### Schema

```yaml
# niche-program/research/_program/DATA-COVERAGE-MATRIX.yaml
# Per-niche data availability profile — used to normalize evidence quality scores
# AVAILABLE = toolchain expected to produce data meeting freshness SLA
# SPARSE = data exists but may be thin, single-source, or hard to find
# UNAVAILABLE = data type does not exist for this niche; do not penalize absence

niche_coverage:
  N-001-b2b-saas-revops:
    market_sizing: AVAILABLE
    competitor_profiles: AVAILABLE
    competitor_pricing: AVAILABLE
    buyer_personas: AVAILABLE
    trigger_signals: AVAILABLE
    technographics: AVAILABLE
    review_sentiment: AVAILABLE
    hiring_signals: AVAILABLE
    notes: "Highest coverage — IT SaaS niche with full digital footprint"
    normalization_factor: 1.0  # Baseline — no adjustment needed

  N-010-fractional-executive:
    market_sizing: SPARSE
    competitor_profiles: SPARSE
    competitor_pricing: UNAVAILABLE
    buyer_personas: SPARSE
    trigger_signals: SPARSE
    technographics: UNAVAILABLE
    review_sentiment: UNAVAILABLE
    hiring_signals: AVAILABLE
    notes: "Private companies, no public pricing, no G2 reviews. Compete via relationships."
    normalization_factor: 0.6  # Adjust expected evidence ratio to 60% of baseline

  N-015-eu-public-sector:
    market_sizing: AVAILABLE
    competitor_profiles: SPARSE
    competitor_pricing: UNAVAILABLE
    buyer_personas: SPARSE
    trigger_signals: AVAILABLE
    technographics: SPARSE
    review_sentiment: UNAVAILABLE
    hiring_signals: AVAILABLE
    notes: "Public tenders available via TED API. Buyers are government, not commercial."
    normalization_factor: 0.55

  N-020-niche-manufacturing:
    market_sizing: AVAILABLE
    competitor_profiles: SPARSE
    competitor_pricing: UNAVAILABLE
    buyer_personas: SPARSE
    trigger_signals: SPARSE
    technographics: UNAVAILABLE
    review_sentiment: UNAVAILABLE
    hiring_signals: SPARSE
    notes: "Limited digital footprint. No standard review platforms. Manufacturing tech not detectable."
    normalization_factor: 0.4
```

### Normalization Rule

```
Normalized_E_Q = Actual_E_Q / (Sum_of(AVAILABLE * 1.0 + SPARSE * 0.66) / 8)
```

Where `Actual_E_Q` is the percentage of claims graded `[E]` or higher, and the denominator normalizes for the number of data types available. A niche with 8/8 AVAILABLE has denominator 1.0 (no adjustment). A niche with 3 AVAILABLE, 3 SPARSE, 2 UNAVAILABLE has denominator `(3.0 + 3*0.66 + 2*0)/8 = 0.6225`, so its evidence quality is divided by 0.6225.

### Coverage Tiers for All 25 Niches

| Tier | Number of Niches | Typical Coverage | Examples |
|---|---|---|---|
| **Tier 1: Full Coverage** (6-8/8 AVAILABLE) | ~5-7 niches | Bounded-Platform SaaS with multiple competitors, public pricing, G2 presence, rich digital footprint | IT Staffing, RevOps, Sales Engagement, Customer Success |
| **Tier 2: Partial Coverage** (4-6/8 AVAILABLE) | ~10-12 niches | Vertical-industry niches with some public data, fewer review sources, partial pricing | Professional Services Automation, EU GovTech, MarTech |
| **Tier 3: Sparse Coverage** (1-3/8 AVAILABLE) | ~6-8 niches | Relationship-driven, private-company niches with thin or no digital footprint | Fractional Executive, Niche Consulting, Manufacturing Services |

---

## GRAND SUMMARY

| Audit | Findings Extracted | Blocking | High | Medium | Low/Embedded |
|---|---|---|---|---|---|
| Lens 3: SRE/Reliability | 51 | 9 (8 enumerated + 1 body) | 16 (14 enumerated + 2 body) | 15 (9 enumerated + 6 body) | 11 (8 enumerated + 3 body) |
| Lens 4: Data Quality | 21 | 4 | 6 (4 enumerated + 2 body) | 9 (4 enumerated + 5 body) | 2 (0 enumerated + 2 body) |
| **TOTAL** | **72** | **13** | **22** | **24** | **13** |

---

*End of synthesis-batch2-sre-data.md — All findings extracted from audit-lens3-sre-reliability.md and audit-lens4-data-quality.md.*
