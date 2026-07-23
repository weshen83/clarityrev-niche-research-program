# Tool Landscape Fix Specification

**Status:** BINDING — remediation roadmap for all 5 audit lenses
**Source Lenses:** Lens 1 (MCP Integration), Lens 2 (Agent Instructions), Lens 3 (SRE/Reliability), Lens 4 (Data Quality), Lens 6 (Red Team)
**Date:** 2026-07-23
**Author:** Program Director Synthesis (post-5-lens adversarial audit)

---

## Executive Summary

The 25-niche pipeline architecture is the most thoroughly designed automated research system encountered across all 5 lenses, but it has never been executed against a single real niche — every critical number (credit estimates, timeout values, rate limits, per-niche wall-clock) is an untested guess. The five audit lenses surfaced 128+ discrete findings which collapse into 7 workstreams spanning MCP configuration, agent instruction encoding, reliability infrastructure, evidence integrity, data coverage, pipeline scheduling, and cross-cutting security gaps. This document specifies every fix required before the first niche evaluation can proceed, ranked by severity and organized into execution-ready workstreams with hours estimates, owners, and verification gates.

---

## Workstream Overview

| Workstream | Total Hours | Priority | Critical Count | High Count |
|---|---|---|---|---|
| A: MCP Server Configuration | 2.0h | P0 | 3 | 7 |
| B: Agent Instruction Layer | 5.5h | P0 | 5 | 6 |
| C: Reliability & Concurrency | 8.5h | P0 | 8 | 14 |
| D: Evidence Integrity | 5.0h | P0 | 4 | 4 |
| E: Data Quality & Coverage | 6.5h | P1 | 4 | 4 |
| F: Pipeline Scheduling & Budget | 4.0h | P1 | 2 | 3 |
| G: Security (SECURITY_LENS_PENDING) | 2.0h | P1 | 0 | 6 |
| **Total** | **33.5h** | | **26** | **44** |

---

## Top 15 Findings (Ranked)

Ranking method: severity (Critical=5, High=4, Medium=3, Low=2) x probability (0-1) x blast radius (0-1) x fix cost (inverse, 1=cheap, 0.2=expensive). Normalized to 100.

| Rank | Finding | Score | Severity | Source Lens | One-Line Fix |
|---|---|---|---|---|---|
| **1** | Concurrency lock file (`_CONCURRENCY_LOCK.yaml`) does not exist on disk; 4 concurrent agents have zero cross-agent rate coordination | 96 | CRITICAL | L3-C04, L6-F02 | Create `_program/_CONCURRENCY_LOCK.yaml` with lock acquisition/release protocol; implement atomic temp-file writes for all shared YAML files |
| **2** | Credit estimates (132 credits/DEEP niche) assume ideal conditions; realistic 80th-percentile cost is 180-220 credits, 95th-percentile is 300-400 | 94 | CRITICAL | L6-F01, L3-H08 | Run first REAL niche end-to-end before finalizing budget; set buffer to 2.0x not 1.3x; implement credit runway kill switch at 4,000/hr |
| **3** | Grade engine cannot evaluate whether a source SUPPORTS a claim — only whether the URL exists and the content hash matches | 93 | CRITICAL | L6-F03, L4-DQ03 | Add semantic verification step (LLM-as-judge) that independently extracts the claim from the source and checks for substantiation; flag all existing [E]/[P] claims that have never been semantically verified |
| **4** | Phase 2 context budget (60K tokens) is dangerously tight — must-load content is ~45K tokens, leaving only ~15K for research data, which is insufficient for any moderate-depth niche | 88 | CRITICAL | L2-B1 | Create TOOL-EXECUTION-SPEC.md (<5K tokens) to replace full reference doc loading; reduce Phase 2 loading spec by ~15K tokens |
| **5** | Preflight-check script does not verify ANY tool is actually reachable — every endpoint must be pinged before pipeline proceeds | 87 | CRITICAL | L3-C08, L3-§6 | Add GATE 1 (tool health checks) to preflight-check: Firecrawl ping, DataForSEO ping, disk space check, Python dependency integrity |
| **6** | DataForSEO standard queue timeout set to 30s in TIMEOUT_CONFIG.yaml but actual queue latency is 1-5 minutes (300s) | 86 | CRITICAL | L3-C01 | Change `dataforseo.serp.standard.total` from 30s to 310s (5 min + 10s buffer) |
| **7** | No tool escalation pattern encoded anywhere — agents default to /scrape instead of /search first, /interact instead of /scrape with --wait-for, /crawl without /map preflight | 85 | BLOCKING | L2-B2, L2-F1/F2/F3 | Create TOOL-EXECUTION-SPEC.md with exact commands per task type; rule #1: "escalate up, not down: search -> scrape -> map -> crawl -> interact" |
| **8** | Cache preflight not automated — agents re-fetch data that already exists and is within freshness SLA, wasting 50-100+ credits across 25 niches | 84 | BLOCKING | L2-B4, L2-F9 | Add mandatory cache preflight step before every fetch command in TOOL-EXECUTION-SPEC.md; check .firecrawl/ and research/N-XXX/ before consuming credits |
| **9** | GDELT has zero retry logic — if GDELT rate-limits or returns empty, agents silently consume empty responses as valid data | 82 | CRITICAL | L3-C02, L4-DQ11 | Add exponential backoff + 3 retry attempts to all GDELT calls; if all fail, mark SOURCE_UNAVAILABLE, do not pass empty data to analysis |
| **10** | 11 of 14 MCP servers are not configured in settings.json; 3 are CONFIGURE_NOW (7 min, zero credentials), 7 are CONFIGURE_SOON (40 min, free signups) | 81 | CRITICAL | L1-§4 | Add PaperPlain, Reddit Research (hosted SSE), Financial Hub MCP to settings.json immediately (7 min); add Serper, DataForSEO MCP, webskim, Brave Search, Google CSE over next 3 sessions |
| **11** | No search-feedback automation — up to 100 credits/day in refunds are being lost because no agent instruction requires running search-feedback after every /search | 79 | HIGH | L2-H1, L2-F10 | Add binding rule in TOOL-EXECUTION-SPEC.md: "Run search-feedback after EVERY /search call"; template: `SEARCH_ID=$(jq -r '.id' .firecrawl/search-*.json) && firecrawl search-feedback "$SEARCH_ID" --rating good --silent &` |
| **12** | Dead-host registry is a write-desert — nothing in the pipeline actually writes to it; 3 consecutive failures to the same host go undetected forever | 78 | HIGH | L3-C06, L2-H2 | Add dead-host write logic to all scraping agent prompts; on 3 consecutive failures to same host, write to DEAD_HOST_REGISTRY.yaml with host, timestamp, error code |
| **13** | No normalization for data availability across niches — non-IT niches (Fractional Executive, Manufacturing, EU Public Sector) will be systematically under-scored by the grade engine | 76 | CRITICAL | L4-DQ02, L4-§3 | Implement DATA-COVERAGE-MATRIX.yaml with per-niche AVAILABLE/SPARSE/UNAVAILABLE flags; add normalization factor to fertility ranking |
| **14** | RIOS score formula is arbitrary and unfalsifiable — equal weighting, 6-inversion formula, >3.0 LAUNCH PENDING threshold all lack empirical basis; different equally-reasonable formulas produce different rankings | 74 | CRITICAL | L6-F13, L6-F14, L6-§Meta | Add explicit "Limitations" section to methodology acknowledging scores are ordinal opinions not cardinal truths; document sensitivity analysis showing ranking stability across formula variants |
| **15** | Shared YAML file communication has 3+ unhandled race conditions (concurrent write interleaving, partial flush reads, registry-desynchronization from two-write sequences) | 73 | HIGH | L6-F09, L6-Assumption 3 | Replace advisory locks with atomic write-transaction pattern: (a) write to temp file, (b) `mv` to atomically replace, (c) implement read-versioning via sequence counter in YAML header |

---

## Workstream A: MCP Server Configuration (2.0 hours)

**Owner:** Pipeline Operator
**Dependencies:** None — can execute immediately with internet access
**Verified by Phase 0 calibration?** YES — all 3 CONFIGURE_NOW servers must pass calibration tests before any niche

### A.1 Immediate: CONFIGURE_NOW Servers (7 minutes, zero credentials)

| Step | Server | Config Block | Time | Verification |
|---|---|---|---|---|
| A1-1 | PaperPlain MCP | `"paperplain": { "type": "stdio", "command": "npx", "args": ["-y", "paperplain-mcp"] }` | 2 min | Agent calls `search_research("niche validation")` returns structured results |
| A1-2 | Reddit Research MCP (hosted SSE) | `"reddit-research": { "type": "sse", "url": "https://reddit-research-mcp.fastmcp.app/mcp" }` | 2 min | Agent calls `searchReddit({ query: "test", limit: 5 })` returns results |
| A1-3 | Financial Hub MCP | `"financial-hub": { "type": "stdio", "command": "npx", "args": ["-y", "financial-hub-mcp"], "env": { "SEC_USER_AGENT_EMAIL": "weshen83@gmail.com", "FRED_API_KEY": "${FRED_API_KEY}" } }` | 3 min | Agent calls `search_companies({ query: "Microsoft" })` returns SEC/FRED data |

**Total: 7 minutes. Zero new accounts needed. Immediate research value.**

### A.2 Short-Run: CONFIGURE_SOON Servers (40 minutes, free signups)

All require free signup + API key. Execute in priority order. Add API keys to settings.json env block.

| Step | Server | Signup URL | Config Time | Free Tier | Verification |
|---|---|---|---|---|---|
| A2-1 | Serper MCP | serper.dev | 5 min | 2,500 queries/mo (recurring) | `search_web({ q: "test" })` returns SERP data |
| A2-2 | DataForSEO MCP (official) | Already have credentials | 5 min | N/A (paid, $50 deposit) | `serp_google_organic_live({ keyword: "test" })` returns SERP. **Migration risk:** verify all 9 API categories work before switching from raw curl |
| A2-3 | webskim (Jina AI) | jina.ai | 5 min | 1M tokens free | `webskim_search({ query: "test" })` returns results |
| A2-4 | Brave Search MCP | api.search.brave.com | 5 min | 2,000 queries/mo | `brave_web_search({ query: "test" })` returns results |
| A2-5 | Google CSE MCP | programmablesearchengine.google.com | 10 min | 100 searches/day | `google_search({ q: "test" })` returns results |
| A2-6 | CrawlForge MCP | crawlforge.dev | 5 min | 1,000 credits/mo | Only if Firecrawl budget runs low |
| A2-7 | FetchSERP MCP | fetchserp.com | 5 min | 250 credits | Only if WHOIS/DNS not covered by DataForSEO |

**Total: 40 minutes across 7 servers. Skip A2-6 and A2-7 if not needed.**

### A.3 Medium-Run: CONFIGURE_LATER Servers

| Step | Server | Setup | Time | When to Execute |
|---|---|---|---|---|
| A3-1 | TAM-MCP-Server | `git clone` + `npm install` + `npm run build` + env config | 30 min | Before Niche Batch 1 — consolidates 8 gov data sources (EUROSTAT, OECD, World Bank, IMF, FRED, etc.) into one server |
| A3-2 | SearXNG MCP | Docker SearXNG instance + Redis + `@iori7295/searxng-mcp` | 60 min | Before Niche Batch 1 — provides unlimited private web search without API costs |

### A.4 SKIP Decisions (Documented)

| Server | Why Skip | Source |
|---|---|---|
| SEC EDGAR MCP (standalone) | Financial Hub MCP already covers SEC EDGAR with 16 tools vs SEC EDGAR's narrower set | L1-§3.11 |
| Firecrawl MCP | CLI has 10+ commands (interact, monitor, download, parse, agent, search-feedback) that MCP is missing. MCP adds 3 features (batch_scrape, deep_research, generate_llmstxt) but loses 7 critical ones. | L1-§9 |
| `@cdilorenzo/mcp-dataforseo` (community) | Official `dataforseo-mcp-server` (DataForSEO org, v2.9.11, Apache-2.0) is better maintained | L1-§2.2 |

### A.5 Architecture Document Corrections

| Section | Current Text | Correction | Source |
|---|---|---|---|
| DATA-ARCH §2.1 Brave Search | "Unlimited (self-hosted)" | "2,000 queries/month free (requires Brave API key). Self-hosted alternative: SearXNG (requires Docker)." | L1-Appx-B |
| DATA-ARCH §2.1 Serper | "2,500 free queries (one-time)" | "2,500 free queries PER MONTH (recurring — more capacity than documented)" | L1-Appx-B |
| DATA-ARCH §2.1 Reddit Research | "Free, no auth, 20K+ subreddits" | "Hosted SSE at https://reddit-research-mcp.fastmcp.app/mcp. Anonymous access: 10 req/min. OAuth configured: 100 req/min." | L1-Appx-B + L3-§2.4 |
| DATA-ARCH §2.1 OpenRegistry | "30 national registries" | "30 req/min (signed-in). Multi-country fan-out: 3 countries/60s on free tier." | L3-H04 |
| DATA-ARCH OECD | "Unlimited, no auth" | "20 queries/minute, 20 data downloads/hour" | L3-C05 |
| DATA-ARCH IMF | "Unlimited, no key" | "50 req/s app-based (requires unique user-agent). Client libraries enforce 1.5s delays." | L3-H01 |
| DATA-ARCH TED API | "Unlimited, no key" | "Per-IP undocumented rate limits. Best-effort only." | L3-H02 |
| DATA-ARCH Wikidata | "5s timeout/query" | "60s timeout/query, 5 concurrent queries/IP limit" | L3-H03 |

---

## Workstream B: Agent Instruction Layer — TOOL-EXECUTION-SPEC.md (5.5 hours)

**Owner:** Pipeline Architect
**Dependencies:** Workstream A (MCP servers must exist before commands can reference them)
**Output:** `niche-program/_pipelines/TOOL-EXECUTION-SPEC.md` (~4.5K tokens)

### B.1 Create TOOL-EXECUTION-SPEC.md (2 hours)

This single file replaces all tool-reference-doc section loading for agent context, freeing ~15K tokens per phase. Structure:

```markdown
# TOOL-EXECUTION-SPEC.md — Exact Commands for Niche Research
**Status:** BINDING. Load once per phase. Supersedes all tool-reference loading for execution.
**Principle:** Exactly one command per task. No parsing. No cross-referencing.

## HOW TO USE
1. Find your task in the table (organized by data type, NOT by tool).
2. Copy command verbatim, replacing {placeholders}.
3. Report results to specified output path.
4. Run search-feedback after every /search.

## BEFORE ANY COMMAND — Cache Preflight (MANDATORY)
[if -f "{output_path}" && freshness check passes, skip]

## COMMAND TABLE
| # | Task | Phase | Command | Output Path | Credits | Fallback |

## CREDIT BUDGET PER PHASE
| Phase | Credit Budget | Dollar Budget |

## RULES (BINDING — 10 rules)
1. Escalate up, not down: search -> scrape -> map -> crawl -> interact
2. Prefer scrape over agent
3. Never use --query
4. Always use --only-main-content on competitor pages
5. Always use --wait-for 3000-5000 on JS-rendered pages
6. Send search-feedback after EVERY /search
7. Check .firecrawl/ cache before every fetch
8. Map before crawl
9. Parallelize independent operations
10. Write to .firecrawl/ always

## EMERGENCY CREDIT SAVE
## ERROR RECOVERY
```

### B.2 Key Binding Rules to Encode

| Rule | Detail | Source Lens | Saves |
|---|---|---|---|
| B2-1 | Never use `--query` flag — scrape to file, then grep | L2-F12 | 5 credits/call, ~625 credits across 25 niches |
| B2-2 | Always try `--wait-for 5000` before escalating to /interact | L2-F2 | 3x cost savings per JS page |
| B2-3 | Always use `--only-main-content` on competitor pages | L2-F8 | Reduces token consumption 3-5x per page |
| B2-4 | Map before crawl — map=1 credit, crawl=1 credit/page | L2-F11 | Prevents 50x cost explosions |
| B2-5 | Run search-feedback after EVERY /search | L2-F10 | Up to 100 credits/day refunded |
| B2-6 | Check .firecrawl/ + research/N-XXX/ cache before any fetch | L2-F9 | Prevents 50-100+ duplicate credit waste |

### B.3 Fix Phase 2 Context Budget (1 hour)

**Problem:** Phase 2 has 60K budget. Must-load tool ref sections = ~18K tokens (Firecrawl + Data Sources). With 22K for NICHE-METHOD §§2-6 canvas = 40K before research data. Only ~15K headroom — insufficient for any moderate-depth niche.

**Fixes:**
1. Replace all tool reference section loading with TOOL-EXECUTION-SPEC.md (4.5K tokens vs 18K) — saves 13.5K tokens
2. Update AGENT-CONTEXT-SPEC.md §Phase 2 loading spec: remove references to Firecrawl Ref §§3,4,5,6,8,9,29,30 and Data Sources §§1.2-1.9,2,3,4,5
3. Add loading spec: "Phase 2 loading: TOOL-EXECUTION-SPEC.md (complete) + NICHE-METHOD §§2-6 (canvas only, not full research protocol)"

**Result:** Phase 2 headroom increases from ~15K to ~40K tokens.

### B.4 Add Prompt Injection Defense (30 minutes)

**Problem:** Web content is untrusted third-party data. Agents read scraped content from `.firecrawl/` and write it into context with no sanitization. This is a context-poisoning vector.

**Fixes:**
1. Add binding rule to TOOL-EXECUTION-SPEC.md: "NEVER write full scraped page content directly into a prompt or agent context. Extract specific data using grep/jq from the file."
2. Add Firecrawl Ref §31 (Security & Output Handling) to Phase 1 loading spec in AGENT-CONTEXT-SPEC.md
3. Add to methodology: "All scraped content must be read from file, not pasted into context. Use `head -n200` or `grep` for targeted extraction."

### B.5 Add Dead-Host Registry Write Logic (30 minutes)

**Problem:** DEAD_HOST_REGISTRY.yaml exists on disk but is never written to — it is a write-desert.

**Fixes:**
1. Add to TOOL-EXECUTION-SPEC.md error section: "On 3 consecutive failures to the same host, write to `_program/DEAD_HOST_REGISTRY.yaml` with: host, timestamp, error_code, tool_used. Use atomic write: `echo "..." > .tmp && mv .tmp DEAD_HOST_REGISTRY.yaml`"
2. Add dead-host check to preflight pre-step: "Check DEAD_HOST_REGISTRY.yaml before every operation. If host is listed, skip immediately and use fallback tool."
3. Implement concurrent-write guard: use file-level lock (timeout 5s) before writing; if lock can't be acquired within 5s, skip dead-host registration and log warning.

### B.6 Add Session Isolation Lock Files (30 minutes)

**Problem:** No enforcement mechanism prevents a second agent from operating on the same niche ID.

**Fixes:**
1. Add lock file protocol: "Each agent must check `research/N-XXX/_lock` before starting. If lock file exists and is < 30 minutes old, ABORT. If > 30 min, assume crashed agent, break lock, and continue."
2. Lock file format: `{ niche_id, agent_session_id, phase, started_at, heartbeat_at }` with heartbeat update every 5 minutes.
3. Add lock release on phase completion and on error (in catch block).
4. Document in AGENT-CONTEXT-SPEC.md §Session Isolation Rule.

### B.7 Add Freshness SLA Automation (30 minutes)

**Problem:** SLA table exists but no automation checks freshness before re-fetching.

**Fixes:**
1. Add pre-flight freshness check to TOOL-EXECUTION-SPEC.md: "Check if `research/N-XXX/*.yaml` exists with a `fresh_until` timestamp that's still in the future. If within SLA, skip. If expired, re-fetch only this data point."
2. Add `fresh_until` field to all structured data file schemas.
3. Document in TOOL-EXECUTION-SPEC.md the SLA table: JOB/HIRING/INTENT = 7 days, PRICING = 30 days, REVIEWS = 90 days, MARKET_SIZING = 180 days.

---

## Workstream C: Reliability & Concurrency (8.5 hours)

**Owner:** Pipeline Architect
**Dependencies:** Workstream B (TOOL-EXECUTION-SPEC.md is needed for dead-host and error recovery rules)
**Critical Path:** MUST complete before any concurrent niche evaluation

### C.1 Create Global Concurrency Lock File (1.5 hours)

**Problem:** `_CONCURRENCY_LOCK.yaml` does not exist on disk. The architecture describes cross-agent rate limiting (L3-§4.6) but no file implements it. Four agents running Phase 2 simultaneously will hit every tool with zero coordination.

**Specification:**

```yaml
# _program/_CONCURRENCY_LOCK.yaml
# Global concurrency coordinator — agents MUST acquire before burst operations
# ACQUIRE: write intent, execute burst, release
# Intent != execution — this file tracks what agents INTEND, not what they ARE doing.
# The per-tool throttle (not this file) is the actual execution ceiling.

schema_version: 1
active_bursts:
  # Each burst is a single agent's burst plan
  # Agent declares: tool, expected_request_count, max_duration_seconds
  - agent_id: "N-007-agent-session-xk9f"
    niche_id: "N-007"
    tool: "firecrawl_scrape"
    declared_request_count: 10
    started_at: "2026-07-23T14:30:00Z"
    expected_duration_seconds: 45

tool_limits:
  firecrawl_scrape:
    max_concurrent_bursts: 4
    max_total_declared: 40  # agents can declare up to this, actual limit is lower
    tool_actual_limit: 500  # req/min — enforced by Firecrawl, not by lock
  firecrawl_search:
    max_concurrent_bursts: 4
    max_total_declared: 20
    tool_actual_limit: 250
  firecrawl_crawl:
    max_concurrent_bursts: 2
    max_total_declared: 2
    tool_actual_limit: 50  # starts/min
  dataforseo:
    max_concurrent_bursts: 4
    max_total_declared: 12
    tool_actual_limit: 30
  openregistry:
    max_concurrent_bursts: 2
    max_total_declared: 10
    tool_actual_limit: 30
  gdelt:
    max_concurrent_bursts: 2
    max_total_declared: 2
    tool_actual_limit: null  # undocumented — be conservative
```

**Protocol:**
1. Before any burst operation (>1 concurrent call to a tool), agent reads lock file
2. Agent sums declared_request_count for its target tool across all active_bursts
3. If sum + agent's request_count would exceed `max_total_declared`: wait 5s, retry
4. If wait exceeds 30s: lower concurrency by 50% and proceed
5. On completion or error: remove agent's entry from active_bursts
6. Stale burst cleanup: if started_at > 90s ago and entry still present, any agent may remove it

**Implementation:** Python script `_pipelines/acquire_burst_lock.py`:
```python
# read _CONCURRENCY_LOCK.yaml
# check tool limits
# if within limit: add entry, write atomically (tmp+mv)
# if over limit: sleep 5, retry, max 6 retries (30s total)
```

### C.2 Bring Preflight-Check to Operational Readiness (2 hours)

**Current state:** 984-line Python script with 5 steps (input validation, cache check, credit balance, dead-host check, verdict). Missing all tool endpoint verification.

**Required additions (from L3-§6.1):**

**GATE 0: Self-Checks** (30 min)
- `check_python_env()`: import integrity + version >= 3.10
- `check_disk_space()`: > 500MB free — BLOCKED if < 100MB
- `check_dependency_pins()`: verify `requirements.txt` packages resolvable

**GATE 1: Tool Endpoint Reachability** (45 min)
- `check_firecrawl_health()`: test `/search` with 1-query + credit balance
- `check_dataforseo_health()`: test SERP endpoint + parse balance
- `check_mcp_health()`: test OpenRegistry + Reddit MCP + Context7
- `check_free_api_health()`: spot test GDELT + OECD + EUROSTAT

**GATE 2: Rate Limit Headroom** (30 min)
- Firecrawl burst test: 5 concurrent `/scrape` calls to fast pages
- DataForSEO burst test: 3 concurrent SERP checks
- OpenRegistry burst test: query 5 companies in succession

**GATE 3: Auth Verification** (15 min)
- Verify all env vars resolve (FIRECRAWL_API_KEY, DATAFORSEO_LOGIN, etc.)
- Verify CREDENTIALS.yaml parses correctly

**Script interface:**
```bash
python3 _pipelines/preflight-check.py --niche N-001 --phase phase2
# Output: PASS | WARNING: [list] | BLOCKED: [list]
```

### C.3 Fix TIMEOUT_CONFIG.yaml (30 minutes)

**Current state:** Single-level timeouts (total only). DataForSEO standard queue = 30s (SHOULD BE 310s). Free APIs not listed. No connect timeout granularity.

**Required changes:**

```yaml
# CRITICAL FIX: DataForSEO standard queue timeout
dataforseo:
  serp:
    live:
      connect: 5
      read: 15
      total: 30
    standard:
      connect: 5
      read: 300     # 5 minutes — standard queue can take 1-5 min
      total: 310

# CRITICAL FIX: Firecrawl JS-rendered scrape
firecrawl:
  scrape:
    static:
      connect: 10
      read: 30
      total: 45
    js_rendered:
      connect: 10
      read: 45
      total: 90     # was 60s — insufficient for --wait-for 5000

# ADD: Free APIs (none had entries)
free_apis:
  gdelt:
    connect: 15
    read: 30
    total: 60
  oecd:
    connect: 15
    read: 45
    total: 60
  world_bank:
    connect: 15
    read: 45
    total: 60
  imf:
    connect: 15
    read: 45
    total: 60
  ted:
    connect: 15
    read: 30
    total: 45
  wikidata:
    connect: 10
    read: 60       # was 5s in architecture — actual timeout is 60s
    total: 70
```

### C.4 Add GDELT Retry Logic (30 minutes)

**Problem:** GDELT has zero retry/backoff. When rate-limited, agents silently get empty responses and treat them as "no news."

**Fix:**
1. Wrap every GDELT call in exponential backoff: 1s/2s/4s/8s (3 retries)
2. On empty response: retry once before accepting as "no news"
3. If all retries fail: mark `SOURCE_UNAVAILABLE`, do NOT pass empty data
4. Implement in TOOL-EXECUTION-SPEC.md error section
5. Add GDELT-specific note: "GDELT returns empty array on rate limit. Empty+ratelimited != no news. Always retry empty responses at least once."

### C.5 Fix Fallback Chains (2 hours)

**Problem:** 5 of 17 data types have CRITICAL or HIGH fallback chain failures:

| Data Type | Problem | Fix | Time |
|---|---|---|---|
| Competitor pricing | No tool-diverse fallback (both primary and fallback are Firecrawl) | Add DataForSEO OnPage API as tool-diverse pricing fallback | 30 min |
| Market sizing | DataForSEO Keywords API fallback is qualitatively different data (search volume != market size) | Flag substitution with DATA_TYPE_MISMATCH marker; don't silently substitute | 15 min |
| Company registry | Registry Lookup API fallback not configured — no API key, no endpoint | Accept OpenRegistry-only; document as single point of failure; add manual lookup as fallback | 15 min |
| Technographics | BuiltWith fallback not configured | Register for BuiltWith free API; add key to CREDENTIALS.yaml; add agent prompt | 20 min |
| Hiring signals | Fallback chain degrades to unrecoverable (ATS -> Techmap -> GDELT). GDELT cannot produce structured job counts. | Accept SOURCE_UNAVAILABLE for hiring when ATS fails. Remove GDELT as hiring fallback (cannot produce structured job counts). | 10 min |
| News/intent | GDELT no retry + Currents API not configured | Implement GDELT retry (C.4). Add Currents API key OR remove from fallback chain and accept Firecrawl-only. | 20 min |

### C.6 Implement Error Recovery Protocol (30 minutes)

**Problem:** No general error recovery protocol. On tool failure, agents have no guidance on retry/fallback/abort.

**Fix:** Add to TOOL-EXECUTION-SPEC.md error section:

```
## ERROR RECOVERY (BINDING)
1. On any tool failure: wait 5s, retry ONCE
2. If second attempt fails: check if error is RETRYABLE (429, 500, 502, 503) or NON-RETRYABLE (401, 402, 403, 404, 400)
   - RETRYABLE: exponential backoff (1s/2s/4s/8s) up to 3 total retries
   - NON-RETRYABLE: do NOT retry. Use fallback tool immediately.
3. If fallback also fails: mark SOURCE_UNAVAILABLE with error details in TOOL_ERROR_LOG.yaml
4. Do NOT retry a third time — use fallback or SOURCE_UNAVAILABLE
5. If 3 consecutive failures to the same host: write to DEAD_HOST_REGISTRY.yaml
```

### C.7 Pin Python Dependencies (30 minutes)

**Problem:** No `requirements.txt` exists. Dependency breakage from `pip install --upgrade` is undetected.

**Fix:**
```txt
# requirements.txt — PINNED versions for pipeline scripts
pyyaml==6.0.2
requests==2.32.3
urllib3==2.2.2
certifi==2024.7.4
jsonschema==4.23.0
```

Add `check_python_env()` to preflight-check that verifies all imports succeed.

### C.8 Add Disk Space Guard (15 minutes)

**Problem:** No disk space check exists. Full disk causes partial writes, zero-size files, cache corruption.

**Fix:**
1. Add `check_disk_space()` to preflight-check GATE 0: BLOCKED if < 100MB, WARNING if < 500MB
2. Add write-time guard: before every atomic write, verify `df . --output=avail > 100MB`
3. Document cache corruption recovery in RUNBOOK: "If disk was full, delete all `.tmp` files before retrying"

---

## Workstream D: Evidence Integrity (5.0 hours)

**Owner:** Grade Engine Designer
**Dependencies:** Workstream B (cache preflight prevents stale-data grading)
**Risk:** This workstream addresses the most dangerous finding — the grade engine can be systematically gamed

### D.1 Add Semantic Verification to Grade Engine (2 hours)

**Problem:** The grade engine checks URL existence and content hash but NEVER whether the source content actually substantiates the claim. An agent can fabricate a claim, cite a real URL, and pass all 4 binary criteria with a fabricated interpretation of real content.

**Fix — Extended Verifier Protocol:**

The verifier agent (currently tasked with re-fetching URLs and comparing hashes) must additionally:

1. **Extract the claim's core assertion** from the trace-map.yaml claim entry (the exact text the agent wrote)
2. **Fetch the source content** (same URL, same page)
3. **Run a Claude code analysis** against the source content with prompt:
   ```
   Does this web page support the claim below?
   Claim: {claim_text}
   Source URL: {url}
   
   Answer one of: SUPPORTED, PARTIALLY_SUPPORTED, NOT_SUPPORTED, PAGE_UNAVAILABLE
   Provide a 1-sentence justification.
   ```
4. **Record the verdict** in `evidence-grades.yaml` alongside the existing grade:
   ```yaml
   claim_id: "C-042"
   existing_grade: "[P]"  # from deterministic engine
   semantic_verdict: "SUPPORTED | PARTIALLY_SUPPORTED | NOT_SUPPORTED"
   semantic_confidence: "HIGH | MEDIUM | LOW"
   justification: "The page lists enterprise pricing at EUR 2,300/mo..."
   verifier_agent_session: "v-N-007-xk9f"
   ```
5. **Override rule:** If semantic_verdict = NOT_SUPPORTED, override grade to `[S]` (source does not support claim). Log in TOOL_ERROR_LOG.yaml as EVIDENCE_INTEGRITY_FAILURE.

**Cost estimate:** ~$0.03 per claim check (1 Claude API call + 1 Firecrawl scrape). At ~50 claims/niche x 25 niches = 1,250 checks = ~$37.50 total. Verify at least 20% of claims per niche, ALL claims where `[E]` or `[P]` is claimed.

**Deployment:** Phase in over first 5 niches. Run on 100% of claims for niches 1-2, then reduce to 20% spot-check if false-positive rate is low.

### D.2 Calibrate Grade Engine Against Human Judgment (1.5 hours)

**Problem:** The deterministic engine has never been compared to human judgment. The 16-combination truth table is mathematically complete but may not align with how humans evaluate evidence.

**Calibration Protocol:**
1. Use the calibration niche canvas (once produced) to generate 30 claims with complete trace-map entries
2. Have 3 human raters (Wesley + 2 others) independently grade each claim as `[P]`/`[E]`/`[H]`/`[S]`
3. Run the deterministic engine on the same 30 claims
4. Calculate Cohen's Kappa between engine and each human rater
5. Threshold: if Kappa < 0.61 for any rater, adjust grade criteria before proceeding

**Expected adjustment targets:** Source independence criteria (C1) and the 20% numerical divergence threshold are the most likely to need adjustment based on human disagreement patterns.

### D.3 Implement Independent Mini-Calibration Every 5 Niches (1 hour)

**Problem:** The current drift detection is a self-audit by the same agent. The methodology says (L6-F05) "no quality control mechanism may rely solely on agent self-audit" but the mini-calibration does exactly this.

**Fix — Independent Agent Protocol:**
1. After every 5th niche evaluation, spawn a FRESH agent (not the niche's agent)
2. The fresh agent re-scores 3 dimensions from CAL-A calibration niche: Section 4 (Competitive Landscape), Section 6B (Signal Catalog), Section 14 (RIOS Scoring)
3. Compare new scores against the reference canvas (ground truth)
4. If >20% of scores diverge by more than 1 point on a 5-point scale: flag AGENT_DRIFT_DETECTED
5. If flagged, pause pipeline, recalibrate by re-running the calibration protocol (D.2) with adjusted instructions
6. Cost: ~100 credits per 5 niches. Benefit: actual drift detection vs. performative self-audit.

### D.4 Implement DATA-COVERAGE-MATRIX.yaml (30 minutes)

**Problem:** Non-IT niches will be systematically under-scored by the grade engine because their data types are inherently UNAVAILABLE (no review platforms, no public pricing, no technographics). The engine's C1 criterion (">=2 independent sources") is impossible for these niches.

**Schema:**
```yaml
# niche-program/research/_program/DATA-COVERAGE-MATRIX.yaml
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
    normalization_factor: 1.0

  N-010-fractional-executive:
    market_sizing: SPARSE
    competitor_profiles: SPARSE
    competitor_pricing: UNAVAILABLE
    buyer_personas: SPARSE
    trigger_signals: SPARSE
    technographics: UNAVAILABLE
    review_sentiment: UNAVAILABLE
    hiring_signals: AVAILABLE
    normalization_factor: 0.6
```

**Normalization formula:**
```
Normalized_E_Q = Actual_E_Q / (Sum_of(AVAILABLE * 1.0 + SPARSE * 0.66 + UNAVAILABLE * 0.0) / 8)
```

**Implementation:** Add normalization calculation to the fertility ranking script. Document in DATA-OPERATIONS-ARCHITECTURE.md. Populate for all 25 niches before any fertility scoring.

---

## Workstream E: Data Quality & Coverage (6.5 hours)

**Owner:** Research Methodologist
**Dependencies:** Workstream D (grade engine calibration must precede quality assessment)

### E.1 Implement Schema Validation Scripts (2 hours)

**Problem:** `validate-schema.sh`, `freshness-audit.sh`, and preflight-check (partially) are template scripts with placeholder implementations. They are NOT operational.

**Schema validation gates:**
1. **Competitor profile schema** (`research/N-XXX/competitor-profile-N-XXX.yaml`): required fields: `company_name`, `website`, `pricing_tiers` (min 1), `target_buyer`, `key_features`, `source_url` with checksum
2. **Review corpus schema** (`research/N-XXX/review-corpus-N-XXX.yaml`): required fields: `review_count >= 20`, `sources >= 2`, each entry with `source_url`, `rating`, `pros`, `cons`, `extracted_at`
3. **Market sizing schema** (`research/N-XXX/market-sizing-N-XXX.yaml`): required fields: `tam_range` (min-max), `sources >= 2`, each with `url`, `fetch_date`, `fresh_until`

**Validation script behavior:**
- PASS: all required fields present, schemas valid, freshness SLAs satisfied
- WARNING: required fields present but freshness expired; recommend re-fetch
- FAIL: missing required fields, schema violations, or empty corpora

**Fixes:**
1. Implement `validate-schema.sh` as Python script with jsonschema validation against defined schemas
2. Implement `freshness-audit.sh` that checks all structured data files against SLA table
3. Integrate both into Phase gates (Phase 1->2, Phase 2->3, CANVAS FINAL)

### E.2 Add Dedicated Buyer Language Extraction Pipeline (1 hour)

**Problem:** Buyer language quotes (§2.6) are gathered as a byproduct of review scraping with no dedicated pipeline. The architecture specifies "<=5 verbatim quotes with source URLs" but has no systematic workflow for producing them.

**Fix:**
1. Add dedicated Phase 2.9 step: `firecrawl search "[niche] OR [competitor] challenges OR pain points OR 'struggling with'" --limit 10 --scrape --json -o .firecrawl/search-buyer-language.json`
2. Add schema for buyer language extraction:
   ```yaml
   buyer_language:
     - quote: "The reporting is terrible and we waste hours every month"
       source_url: "https://g2.com/products/syncgtm/reviews"
       speaker_title: "Revenue Operations Manager"
       pain_category: "reporting_inefficiency"
       extracted_at: "2026-07-23T14:30:00Z"
   ```
3. Add buyer language corpus minimum: >=5 verbatim quotes from >=2 independent sources
4. Integrate into canvas §2 output format specification

### E.3 Add ACH Trigger Score Validation Gate (1 hour)

**Problem:** Trigger scoring (6A.0 ACH: Frequency, Urgency, Budget-Likelihood, Detectability, each 1-5) has no empirical basis. Agents assign scores by judgment with no tool evidence requirement.

**Fix:**
1. After scoring, require tool evidence for at least 2 of 4 dimensions per trigger:
   - **Frequency:** supported by GDELT or Firecrawl /search returning >5 instances of the trigger event in past 12 months
   - **Detectability:** verified by Context7 MCP API documentation OR live API call demonstrating signal availability
   - **Urgency:** supported by at least 1 review or forum post mentioning "needed immediately" or "urgent"
2. If evidence cannot be produced for >=2 dimensions, cap maximum trigger score at 3.0 (out of 5)
3. Add validation gate after Phase 2 trigger scoring step

### E.4 Fix Review Corpus Minimum for Non-SaaS Niches (1 hour)

**Problem:** The canvas §4 requirement of ">=20 reviews from >=2 independent sources" is impossible for 8-10 niches (Fractional Executive, Consulting, Manufacturing, Public Sector) that have no G2/Capterra presence.

**Fix:**
1. Add `review_unavailable` metadata field to DATA-COVERAGE-MATRIX.yaml for each niche
2. When review data is UNAVAILABLE for a niche:
   - Demote the requirement from "minimum" to "target" in that section
   - Use alternative signals: Reddit mentions, LinkedIn thought-leadership, case studies, analyst reports
   - Flag the substitution in trace-map.yaml: "REVIEW_DATA_UNAVAILABLE — using alternative signals"
3. Do NOT apply grade engine C1 penalty for missing review data in UNAVAILABLE niches
4. Document in canvas §15 (Open Questions): which review sources were checked and why they're unavailable

### E.5 Add Stackshare/Tech Inference Tool Assignment (30 minutes)

**Problem:** Technical architecture inference (§4.1) requires Stackshare, Wappalyzer, or BuiltWith — none are assigned in the tool inventory.

**Fix:**
1. Add Stackshare API as recommended tool for tech inference (if accessible via RapidAPI or similar)
2. Fallback: BuiltWith free API (2K/day) — requires registration. Add to CREDENTIALS.yaml.
3. If both are unavailable: flag tech inference as `[H]` with note "STACKSHARE_UNAVAILABLE — confidence degraded"
4. Document in DATA-OPERATIONS-ARCHITECTURE.md §2.3

### E.6 Add Dark Matter Acknowledgment (30 minutes)

**Problem:** No toolchain can detect offline buying signals (trade shows, word-of-mouth, private company dynamics, internal boardroom conversations). The architecture acknowledges this in passing but provides no framework for estimating the impact of these blind spots.

**Fix:**
1. Add "Dark Matter" section to NICHE-METHODOLOGY.md listing 6 undetectable signal types with per-niche impact
2. For each niche with >=3 UNAVAILABLE or SPARSE data types in DATA-COVERAGE-MATRIX.yaml, flag in canvas §15: "DATA_DARK_MATTER_HIGH — >=3 data types unavailable. Consider light qualitative research (1 subject-matter expert interview) for this niche."
3. Budget 30 minutes per Tier 3 niche for expert interview. Total: ~3 hours for 6-8 Tier 3 niches.

---

## Workstream F: Pipeline Scheduling & Budget (4.0 hours)

**Owner:** Program Director
**Dependencies:** All previous workstreams (infrastructure must be stable before scheduling)

### F.1 Realistic Budget Model (1.5 hours)

**Problem:** Current budget (132 credits/DEEP niche, 25 x 132 x 1.3 = ~4,300) is based on ideal conditions. Realistic cost is 180-400 credits/niche.

**Revised budget model:**

| Scenario | Credits/Niche | DataForSEO $/Niche | 25-Niche Total | Confidence |
|---|---|---|---|---|
| Ideal (zero retries, 5 competitors) | 132 | $0.04 | 3,300 | ~5% of niches |
| Typical (some retries, 10 competitors) | 200 | $0.06 | 5,000 | ~70% of niches |
| Heavy (many competitors, JS pages, real niche) | 300 | $0.10 | 7,500 | ~20% of niches |
| Worst-case (credit death spiral, 30 competitors) | 400 | $0.15 | 10,000 | ~5% of niches |

**Revised buffer:** 2.0x (not 1.3x) on ideal estimate = ~6,600 Firecrawl credits for 25 DEEP niches.

**Implement credit runway kill switch:**
- WARNING: >4,000 credits/hour burn rate
- HALT: >8,000 credits/hour — auto-pause all niche evaluations
- Measure burn rate from CREDIT_BUDGET.yaml entries
- Add to preflight-check GATE 4

**Implementation steps:**
1. Run calibration niche (CAL-A) AND first real niche end-to-end before finalizing budget
2. Measure actual credit consumption per phase per niche
3. Update budget estimates based on real data (not design estimates)
4. Set DataForSEO budget to $75 (was $50) to account for standard queue calls and on-page pricing fallback

### F.2 Implement Intermediate Value Release — "Top 5 in 2 Weeks" (1.5 hours)

**Problem:** Pipeline produces zero actionable output until all 25 niches complete. First niche can be 3 months stale before the portfolio ranking surfaces it.

**Fix — Two-Pass Pipeline:**

**Pass 1: STANDARD depth on ALL 25 niches** (Phase 1 only, ~17 credits/niche, ~425 total credits)
- Goal: Fertility score only, no canvas
- Timeline: 2 weeks
- Output: Prioritized list of 25 niches by fertility score
- Decision: Top 5 proceed to DEEP evaluation

**Pass 2: DEEP depth on TOP 5 niches** (Phase 1-4, ~200 credits/niche, ~1,000 total credits)
- Goal: Full 15-section canvas with evidence grades
- Timeline: 1 week (5 concurrent agents)
- Output: LAUNCH PENDING / VALIDATE FIRST / FERTILITY GATE verdicts for top 5

**Add "surprise niche" slot:** Reserve 300 credits for ONE unexpected niche discovered during Pass 1. If no surprise emerges after 10 evaluations, re-run the lowest-ranked STANDARD-scored niche at DEEP depth as verification.

### F.3 Reduce Concurrent Niche Agents from 4 to 3 (30 minutes)

**Rationale:** Lock file contention, write conflicts, and burst overlap risks increase super-linearly with concurrency. 4 agents = ~10% per-batch collision probability. 3 agents = ~3% per-batch.

**Changes:**
1. Update AGENT-CONTEXT-SPEC.md: "Max 3 concurrent niche agents" (was 4)
2. Reduce per-tool max_concurrent_bursts in CONCURRENCY_LOCK.yaml accordingly
3. Update batch scheduling: 25 niches / 3 concurrent = 9 batches (instead of 7)
4. Update wall-clock estimate: 9 batches x 25 min = ~3.75 hours active pipeline time (was ~3h at 4 concurrent)
5. Reality check: still within the 2-4 week realistic completion window

### F.4 Add Pipeline Limitations Section (30 minutes)

**Problem:** The pipeline presents RIOS scores as objective rankings but they are actually rigorously-generated opinions.

**Fix:** Add to NICHE-METHODOLOGY.md frontmatter:

```
## PIPELINE LIMITATIONS (BINDING)
1. RIOS scores are ordinal opinions, not cardinal truths. Different equally-reasonable formula choices would produce different rankings.
2. Portfolio decisions are conditional on assumptions that cannot be verified until 24+ months post-launch.
3. The pipeline evaluates DIGITAL FOOTPRINT, not commercial viability. Offline buying signals, word-of-mouth, private company dynamics, and internal decision-making are invisible to every tool in the inventory.
4. The evidence grade engine evaluates SOURCE EXISTENCE, not CLAIM ACCURACY. Semantic verification (independent claim extraction from source) catches some but not all interpretation errors. ALL verdicts carry residual uncertainty.
5. Niches with sparse data availability (Tier 3: 1-3/8 data types available) have higher uncertainty regardless of normalization. Consider light qualitative research for these niches.
6. The pipeline produces a snapshot of a moving market. Competitor pricing, hiring signals, and trigger events change between evaluation and launch.
```

---

## Workstream G: Security (SECURITY_LENS_PENDING) (2.0 hours)

**Note:** Lens 5 (Security & Compliance) is still pending. These findings are cross-lens security gaps that MUST be cross-referenced with Lens 5 when it completes. All items in this workstream carry the `SECURITY_LENS_PENDING` flag.

### G.1 Prompt Injection Defense (30 minutes) — SECURITY_LENS_PENDING

**Already specified in B.4.** Critical path: scraped web content may contain prompt injection attacks that poison agent context.

**Cross-reference with Lens 5 needed:** Verify that the defense (never paste full page content, extract via grep/jq from file) is sufficient against known prompt injection techniques targeting LLM-based scraping agents.

### G.2 Credential Rotation Detection (20 minutes) — SECURITY_LENS_PENDING

**Problem:** No mechanism to detect expired credentials. DataForSEO password, Brave API key, Jina AI token may rotate or expire mid-pipeline.

**Fixes:**
1. Add `last_verified` timestamp field to CREDENTIALS.yaml for every credential
2. Add credential verification to preflight-check GATE 3: test each env var against its tool endpoint
3. Set verification frequency: every 30 days or before each batch of 5 niches

### G.3 Shared File Write Integrity (30 minutes) — SECURITY_LENS_PENDING

**Problem:** 3 unhandled race conditions on shared YAML files:
- Concurrent append to TOOL_ERROR_LOG.yaml causes interleaved lines -> invalid YAML
- Partial flush of CREDIT_BUDGET.yaml leads to stale balance reads
- Two-write sequences on dedup-manifest.yaml cause registry entry pointing to nonexistent file

**Mitigations:**
1. Replace all append-to-YAML patterns with write-then-mv atomically
2. Add sequence counter to all shared YAML headers:
   ```yaml
   _meta:
     schema_version: 1
     sequence: 42
     last_updated: "2026-07-23T14:30:00Z"
     updated_by: "N-007-agent-session-xk9f"
   ```
3. Readers must detect sequence gaps: if sequence jumps by >1, the reading agent knows a write was lost and should refetch from a known-good snapshot

### G.4 Fabricated Data Detection Audit Trail (20 minutes) — SECURITY_LENS_PENDING

**Problem:** If a fabricating agent produces plausible-looking claims with real URLs, the git audit trail records the fabrication but provides no alerting mechanism.

**Fix:**
1. Add `EVIDENCE_INTEGRITY_ALERT` to TOOL_ERROR_LOG.yaml for any claim where:
   - Semantic verifier returns NOT_SUPPORTED (D.1)
   - Claim is downgraded from [P] to [S] by anomaly detection
2. Alert threshold: >5% of claims in a single niche flagged = manual review required
3. Add git hook (optional): `pre-commit` hook that checks if any `evidence-grades.yaml` file has `semantic_verdict: NOT_SUPPORTED` entries

### G.5 Source URL Death Detection (10 minutes) — SECURITY_LENS_PENDING

**Problem:** The URL death loophole (L6-F03 finding 4): a claim's source URL may redirect to a new page with different content, but the grade engine sees HTTP 200 and passes.

**Fix:**
1. In the independent verifier (D.1), record the ACTUAL resolved URL (after redirects) in trace-map.yaml
2. If resolved URL != documented URL: flag `URL_REDIRECT_DETECTED`
3. The flag triggers: compare content hash against original. If different, mark grade as `[E]` (source may have moved/changed)

### G.6 BINDING Rule Enforcement (10 minutes) — SECURITY_LENS_PENDING

**Problem:** The word "BINDING" in ALL CAPS has no enforcement mechanism. Agents do not distinguish between "binding" and "advisory" instructions.

**Refer to Lens 5 for:** Whether the system needs an automated compliance checker that parses agent output and verifies binding rules were followed. Options:
- Post-hoc audit script that checks binding rules against agent output
- If-then clauses in the methodology that trigger SOURCE_UNAVAILABLE when binding rules are violated

---

## Execution Sequence & Dependencies

### Phase 0: Foundation (Week 1) — 14.5 hours

```
Week 1, Days 1-2: Workstream A (MCP Configuration) — 2h
  ├── A1: CONFIGURE_NOW servers (7 min)
  ├── A2: CONFIGURE_SOON servers (40 min)
  ├── A3: CONFIGURE_LATER decisions (-- deferred to Phase 0+)
  └── A5: Architecture document corrections (15 min)

Week 1, Days 2-4: Workstream B (Agent Instruction Layer) — 5.5h
  ├── B1: Create TOOL-EXECUTION-SPEC.md (2h)
  ├── B3: Fix Phase 2 context budget (1h)
  ├── B4: Prompt injection defense (30 min)
  ├── B5: Dead-host registry write logic (30 min)
  ├── B6: Session isolation lock files (30 min)
  └── B7: Freshness SLA automation (30 min)

Week 1, Days 3-5: Workstream C (Reliability) — 8.5h
  ├── C1: Global concurrency lock file (1.5h)
  ├── C2: Preflight-check operational readiness (2h)
  ├── C3: TIMEOUT_CONFIG.yaml fixes (30 min)
  ├── C4: GDELT retry logic (30 min)
  ├── C5: Fallback chain fixes (2h)
  ├── C6: Error recovery protocol (30 min)
  ├── C7: Python dependency pinning (30 min)
  └── C8: Disk space guard (15 min)
```

### Phase 0+: Pre-First-Niche (Week 2) — 5.5 hours

```
Week 2, Days 1-3: Workstream D (Evidence Integrity) — 5h
  ├── D1: Semantic verification protocol (2h)
  ├── D2: Grade engine calibration against human judgment (1.5h)
  ├── D3: Independent mini-calibration every 5 niches (1h)
  └── D4: DATA-COVERAGE-MATRIX.yaml (30 min)

Week 2, Days 2-4: Workstream E (Data Quality) — 6.5h
  ├── E1: Schema validation scripts (2h)
  ├── E2: Buyer language extraction pipeline (1h)
  ├── E3: ACH trigger score validation gate (1h)
  ├── E4: Review corpus fix for non-SaaS niches (1h)
  ├── E5: Stackshare tech inference tool (30 min)
  └── E6: Dark matter acknowledgment (30 min)
```

### Phase 0++: Calibration & Budget (Week 2-3) — 4.0 hours

```
Week 2-3 Overlap: Workstream F (Pipeline Scheduling) — 4h
  ├── F1: Realistic budget model from real niche costs (1.5h)
  ├── F2: Top-5-in-2-weeks two-pass pipeline (1.5h)
  ├── F3: Reduce concurrency 4->3 (30 min)
  └── F4: Pipeline limitations section (30 min)

Week 2-3: Workstream G (Security, LENS PENDING) — 2h
  ├── G1-G6: All 6 security items (2h)
  └── ⚠️ Cross-reference with Lens 5 when available
```

### Calibration Execution

```
After ALL infrastructure fixes deployed:

STEP 1: Run preflight-check — must PASS before any niche
STEP 2: Run CAL-A (Mid-Market IT Staffing) at STANDARD depth
         - Measure: credit consumption, wall-clock, tool failure rate
         - Output: reference canvas for 5 sections (Wesley must produce ground truth FIRST)
STEP 3: Calibrate grade engine (D2) — 3 human raters vs engine on 30 claims
STEP 4: Run CAL-A at DEEP depth — verify Phase 2 context fit
STEP 5: Run CAL-B (B2B Fractional Executive) at STANDARD depth
         - Test data-sparse niche coverage
         - Validate DATA-COVERAGE normalization factor
STEP 6: Update all budget estimates based on real consumption
STEP 7: Pass/fail gate: if any CRITICAL bug found during calibration, do NOT proceed to main pipeline
```

---

## Verification Gates

Each gate is a binary pass/fail check inserted between workstream phases. All gates must PASS before the next workstream begins.

### Gate 1: MCP Infrastructure (end of Workstream A)

| Check | Method | Pass Criteria |
|---|---|---|
| G1-1 | PaperPlain MCP reachable | Agent calls `search_research("test")` returns structured results within 15s |
| G1-2 | Reddit Research MCP reachable | Agent calls `searchReddit({ query: "test", limit: 5 })` returns results |
| G1-3 | Financial Hub MCP reachable | Agent calls `search_companies({ query: "Microsoft" })` returns SEC/FRED data |
| G1-4 | Serper MCP reachable (if configured) | `search_web({ q: "test" })` returns SERP data |
| G1-5 | DataForSEO MCP reachable (if configured) | `serp_google_organic_live({ keyword: "test" })` returns SERP |
| G1-6 | Architecture correction document updated | Diff shows all corrections from §A.5 applied |

### Gate 2: Agent Instruction Layer (end of Workstream B)

| Check | Method | Pass Criteria |
|---|---|---|
| G2-1 | TOOL-EXECUTION-SPEC.md exists on disk | File present at `niche-program/_pipelines/TOOL-EXECUTION-SPEC.md` |
| G2-2 | All 10 binding rules present | grep count of "BINDING" >= 10 in file |
| G2-3 | All command table entries have fallback | Every C-XX entry has non-empty fallback column |
| G2-4 | All 3 CONFIGURE_NOW MCP servers listed | PaperPlain, Reddit Research, Financial Hub appear in command table |
| G2-5 | Prompt injection defense rule present | "NEVER write full scraped page content" appears in methodology |
| G2-6 | Cache preflight block present | "CACHE HIT" or equivalent appears in file |
| G2-7 | Dead-host write logic present | "DEAD_HOST_REGISTRY.yaml" appears in error section |
| G2-8 | Session isolation lock file protocol present | "_lock" appears in session isolation section |

### Gate 3: Reliability Infrastructure (end of Workstream C)

| Check | Method | Pass Criteria |
|---|---|---|
| G3-1 | `_CONCURRENCY_LOCK.yaml` exists on disk | File present with tool_limits and schema_version |
| G3-2 | Concurrency lock acquire script exists | `_pipelines/acquire_burst_lock.py` present and executable |
| G3-3 | Preflight-check passes all self-checks | `python3 _pipelines/preflight-check.py --self-check` exits 0 |
| G3-4 | Preflight-check health checks implemented | `check_firecrawl_health()`, `check_dataforseo_health()`, `check_disk_space()` all present |
| G3-5 | TIMEOUT_CONFIG.yaml has all 3-level entries | grep for `connect:` in file confirms connect+read+total per tool |
| G3-6 | DataForSEO standard queue timeout = 310s | `yq '.dataforseo.serp.standard.total' TIMEOUT_CONFIG.yaml` returns 310 |
| G3-7 | GDELT retry implemented | Retry code with exponential backoff present in agent prompts or pipeline script |
| G3-8 | Fallback chains all verified | All 17 data types have tool-diverse fallback and documented SOURCE_UNAVAILABLE path |
| G3-9 | `requirements.txt` exists with pinned versions | File present, `pip install -r requirements.txt --dry-run` succeeds |
| G3-10 | Disk space guard implemented | `check_disk_space()` present in preflight-check |

### Gate 4: Evidence Integrity (end of Workstream D)

| Check | Method | Pass Criteria |
|---|---|---|
| G4-1 | Semantic verifier protocol documented | Extended verifier protocol with claim-extraction step exists in grade engine spec |
| G4-2 | Calibration study results documented | 30 claims graded by 3 humans + engine; Cohen's Kappa >= 0.61 for all pairs |
| G4-3 | Independent mini-calibration protocol documented | Fresh agent re-scores 3 dimensions every 5 niches; drift threshold defined |
| G4-4 | DATA-COVERAGE-MATRIX.yaml populated | All 25 niches have entries with normalization factors |
| G4-5 | Normalization formula implemented in ranking script | Fertility ranking script includes normalization_factor in calculation |

### Gate 5: Data Quality (end of Workstream E)

| Check | Method | Pass Criteria |
|---|---|---|
| G5-1 | `validate-schema.sh` operational | Running against a test schema file returns PASS correctly, FAIL for missing fields |
| G5-2 | `freshness-audit.sh` operational | Running against test data correctly identifies stale vs fresh entries |
| G5-3 | Buyer language extraction step in TOOL-EXECUTION-SPEC.md | Command C-13 (or equivalent) exists with schema-defined output |
| G5-4 | ACH trigger score validation gate in methodology | Text requiring tool evidence for >=2 dimensions present in §6A |
| G5-5 | Review corpus fix documented for non-SaaS niches | Alternative signal substitution protocol documented |
| G5-6 | Dark matter section in methodology | 6 undetectable signal types listed with per-niche impact framework |

### Gate 6: Pipeline Readiness (end of Workstream F)

| Check | Method | Pass Criteria |
|---|---|---|
| G6-1 | Budget model updated from real niche measurement | CREDIT_BUDGET.yaml has actual consumption from calibration niche |
| G6-2 | Two-pass pipeline scheduled | Standarad Pass 1 + Deep Pass 2 documented with timeline |
| G6-3 | Concurrency limit changed to 3 | AGENT-CONTEXT-SPEC.md says "Max 3 concurrent niche agents" |
| G6-4 | Limitations section in methodology | All 6 limitations documented in frontmatter |
| G6-5 | Surprise niche slot reserved | Budget allocated in CREDIT_BUDGET.yaml for 1 surprise niche |

### Gate 7: Security (end of Workstream G, pending Lens 5)

| Check | Method | Pass Criteria |
|---|---|---|
| G7-1 | Prompt injection defense verified with Lens 5 | Cross-reference with Lens 5 findings produces no gaps |
| G7-2 | Credential rotation detection operational | `last_verified` field populated in CREDENTIALS.yaml |
| G7-3 | Shared file write integrity verified | All append-to-YAML patterns replaced with atomic write+mv |
| G7-4 | Source URL death detection operational | Actual resolved URL recorded in trace-map.yaml; redirect comparison logic implemented |

---

## Risk Register for Fix Implementation

| Risk | Probability | Impact | Mitigation |
|---|---|---|---|
| Lens 5 reveals security findings that conflict with Workstream G mitigations | MEDIUM | Requires rework of security items | Flag all G items as `SECURITY_LENS_PENDING`; do not finalize until Lens 5 reviewed |
| TOOL-EXECUTION-SPEC.md becomes too large (>5K tokens) defeating its purpose | MEDIUM | Loses context budget benefit | Enforce 5K token hard limit; if exceeded, split by phase (Phase 1/Phase 2 versions) |
| Semantic verifier (D.1) costs more than estimated ($37.50 for 20% spot-check) | MEDIUM | Budget overrun | Start with 20% spot-check only; measure actual cost per check; adjust sampling rate based on false-positive rate |
| Preflight-check health checks fail on first network call (expected: some MCPs may be temporarily down) | HIGH | False BLOCKED status | Implement grace period: retry each health check 3 times with 30s backoff before declaring BLOCKED |
| Calibration study (D.2) shows Cohen's Kappa < 0.61, requiring grade criteria adjustment mid-implementation | MEDIUM | Delays pipeline start | Accept this as expected outcome of calibration; the study's purpose IS to find and fix these disagreements |
| Independent mini-calibration (D.3) triggers false drift detection (agent behavior varies naturally) | MEDIUM | Wastes credits on re-check | Set drift threshold to >20% divergence AFTER accounting for normal session-to-session variance; calibrate threshold on first 10 niches |

---

## Appendix: Cross-Lens Finding Map

| Finding | L1 (MCP) | L2 (Agent) | L3 (SRE) | L4 (Data) | L6 (Red) | Workstream |
|---|---|---|---|---|---|---|
| MCP servers not configured | CRITICAL | — | — | — | — | A |
| No TOOL-EXECUTION-SPEC.md | — | 14 findings | — | — | — | B |
| Phase 2 context oversubscribed | — | B-1 / §3.2 | — | — | — | B |
| No escalation pattern | — | B-2 / §2.1 | — | — | — | B |
| Cache preflight missing | — | B-4, F-9, H-3 | — | — | — | B |
| Prompt injection unaddressed | — | B-5 / §5.2 | — | — | — | B, G |
| Dead-host registry write-desert | — | H-2 | C-06 | — | — | B, C |
| Session isolation unenforced | — | H-5 / §5.1 | — | — | — | B |
| Concurrency lock missing | — | — | C-04, §5.7 | — | F-02 | C |
| Preflight-check blind | — | — | C-08 / §6 | — | — | C |
| Timeout config wrong | — | — | C-01 / §7 | — | — | C |
| GDELT no retry | — | — | C-02 | DQ-11 | — | C |
| Fallback chains broken | — | — | §4 | — | — | C |
| Credit estimates fiction | — | — | H-08 | — | F-01 | F |
| Grade engine blind | — | — | — | DQ-03 | F-03 | D |
| No data normalization | — | — | — | DQ-02 / §3 | — | E |
| Schema scripts non-operational | — | — | — | DQ-04 | — | E |
| Grade engine uncalibrated | — | — | — | DQ-01 | — | D |
| 25-niche rigidity / no intermediate output | — | — | — | — | F-07, F-08 | F |
| RIOS formula arbitrary | — | — | — | — | F-13, Meta | F |
| Shared YAML race conditions | — | — | — | — | F-09 | G |
| Pipeline assumptions unchecked | — | — | — | — | § Assumptions | F, G |
| Ground truth not written | — | — | H-14 | — | F-06 | Pre-0 |
| BINDING no enforcement | — | — | — | — | F-11 | G |

---

*End of Tool Landscape Fix Specification — 33.5 total hours across 7 workstreams, 26 critical findings, 44 high findings, 21 verification gates.*
