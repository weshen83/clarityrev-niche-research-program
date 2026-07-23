# Tool Landscape Fix Specification — COMPLETE

**Status:** BINDING — consolidated remediation from all 6 audit lenses
**Source Lenses:** L1 (MCP Integration), L2 (Agent Instructions), L3 (SRE/Reliability), L4 (Data Quality), L5 (Security & Compliance), L6 (Red Team Adversarial)
**Date:** 2026-07-23
**Author:** Program Director Synthesis (6-lens adversarial audit consolidation)

---

## Executive Summary

The 6-lens audit surfaced **119 unique findings** across the entire niche research pipeline architecture. After cross-lens de-duplication (where the same issue was independently identified by multiple lenses), these findings span 7 workstreams.

| Metric | Count |
|---|---|
| **Total unique findings** | **119** |
| **CRITICAL** | **25** |
| **HIGH** | **38** |
| **MEDIUM** | **34** |
| **LOW** | **22** |
| **Workstream A: MCP Configuration** | 20 findings |
| **Workstream B: Agent Instruction Layer** | 16 findings |
| **Workstream C: Reliability & Concurrency** | 33 findings |
| **Workstream D: Evidence Integrity** | 12 findings |
| **Workstream E: Data Quality & Coverage** | 16 findings |
| **Workstream F: Pipeline Scheduling & Budget** | 10 findings |
| **Workstream G: Security & Compliance** | 12 findings |
| **Estimated total fix time** | **~42.5 hours** |
| **Quick wins (<15 min each)** | **34 findings** |

**Key insight:** The most-converged finding across ALL six lenses is that the evidence grade engine cannot distinguish between "the source exists" and "the source substantiates the claim" — this single vulnerability was independently identified by Lens 3 (SRE), Lens 4 (Data Quality), and Lens 6 (Red Team). The second most-converged finding is that all credit, timeout, and timing estimates are unverified design fiction — confirmed by L3 and L6 independently.

---

## Complete Finding Index (119 unique findings, numbered)

| # | Severity | ID | Lens Source | Description | One-Line Fix | Minutes |
|---|---|---|---|---|---|---|
| 1 | CRITICAL | MCP-A1 | L1 | PaperPlain MCP not configured (zero setup, no auth) | Add `paperplain` MCP config to settings.json (2 min) | 2 |
| 2 | CRITICAL | MCP-A2 | L1 | Reddit Research MCP not configured (hosted SSE, no creds) | Add `reddit-research` hosted SSE config to settings.json | 2 |
| 3 | CRITICAL | MCP-A3 | L1 | Financial Hub MCP not configured (already have creds) | Add `financial-hub` MCP config, set SEC_USER_AGENT_EMAIL | 3 |
| 4 | CRITICAL | MCP-A4 | L1 | Brave Search documented as "Unlimited (self-hosted)" — incorrect | Fix DATA-OPERATIONS-ARCHITECTURE.md §2.1: 2K queries/mo, API key required | 5 |
| 5 | CRITICAL | MCP-A5 | L1 | Serper free tier documented as "one-time" — actually monthly recurring | Fix SME-tool-reference-expansion.md §1.4: "2,500 queries/month recurring" | 5 |
| 6 | CRITICAL | MCP-A6 | L1 | Firecrawl MCP vs CLI decision not documented — CLI superior for pipeline | Document SKIP decision: CLI has 10+ commands, MCP missing 7 critical ones | 5 |
| 7 | CRITICAL | MCP-A7 | L1 | DataForSEO used via raw curl instead of official MCP server | Migrate to `dataforseo-mcp-server` (official, v2.9.11, 10 API modules) | 15 |
| 8 | HIGH | MCP-B1 | L1 | Serper MCP not configured (2,500 queries/month recurring) | Sign up at serper.dev, add config + SERPER_API_KEY to settings.json | 5 |
| 9 | HIGH | MCP-B2 | L1 | DataForSEO MCP migration unverified against all 9 API categories | Test MCP against all 9 API categories; keep raw curl as fallback | 15 |
| 10 | HIGH | MCP-B3 | L1 | Jina AI MCP (webskim) not configured (1M tokens free) | Sign up at jina.ai, add webskim config + JINA_API_KEY | 5 |
| 11 | HIGH | MCP-B4 | L1 | Brave Search MCP not configured (2,000 queries/month free) | Sign up at api.search.brave.com, add config + BRAVE_API_KEY | 5 |
| 12 | HIGH | MCP-B5 | L1 | Google CSE MCP not configured (already have GOOGLE_API_KEY) | Create CSE engine ID at programmablesearchengine.google.com (10 min) | 10 |
| 13 | HIGH | MCP-B6 | L1 | CrawlForge MCP not configured (1,000 free credits) | Sign up at crawlforge.dev, add config + CRAWFORGE_API_KEY | 5 |
| 14 | HIGH | MCP-B7 | L1 | FetchSERP MCP not configured (250 free credits, unique domain data) | Sign up at fetchserp.com, add config + FETCHSERP_API_TOKEN | 5 |
| 15 | MEDIUM | MCP-C1 | L1 | SearXNG MCP not deployed (unlimited private web search) | Set up Docker SearXNG instance + Redis, configure MCP | 60 |
| 16 | MEDIUM | MCP-C2 | L1 | TAM-MCP-Server not built (consolidates 8 gov data sources) | git clone + npm install + build + configure (30 min) | 30 |
| 17 | LOW | MCP-D1 | L1 | SEC EDGAR MCP considered but redundant with Financial Hub | Document SKIP — Financial Hub already covers SEC EDGAR with 16 tools | 5 |
| 18 | LOW | MCP-D2 | L1 | @cdilorenzo/mcp-dataforseo (community) considered vs official | Document SKIP — official DataForSEO org version is better maintained | 5 |
| 19 | LOW | MCP-D3 | L1 | Reddit Research has 6+ packages — which one to use undecided | Document decision: start with hosted SSE, add reddit-intelligence-agent later | 5 |
| 20 | LOW | MCP-D4 | L1 | 6 architecture doc corrections needed (OECD, IMF, TED, Wikidata, OpenRegistry, Reddit) | Apply all 8 corrections from L1 Appendix B to DATA-OPERATIONS-ARCHITECTURE.md | 15 |
| 21 | CRITICAL | AGT-B1 | L2 | Phase 2 context budget insufficient — must-load content ~45K of 60K | Create TOOL-EXECUTION-SPEC.md (4.5K) to replace 18K tool ref loading | 120 |
| 22 | CRITICAL | AGT-B2 | L2 | No tool escalation pattern encoded — agents default to wrong tool | Encode search->scrape->map->crawl->interact in TOOL-EXECUTION-SPEC.md | 60 |
| 23 | CRITICAL | AGT-B3 | L2 | JS-rendered pages fail without --wait-for flag (G2, marketplaces, SPAs) | Make --wait-for 3000-5000 REQUIRED in TOOL-EXECUTION-SPEC.md Rule #5 | 15 |
| 24 | BLOCKING | AGT-B4 | L2 | Cache preflight not automated — re-fetches waste 50-100+ credits | Add mandatory cache preflight block before every fetch in TOOL-EXECUTION-SPEC.md | 30 |
| 25 | BLOCKING | AGT-B5 | L2 | No prompt injection defense for scraped web content | Add binding rule: "NEVER paste full scraped content — extract via grep/jq" | 30 |
| 26 | HIGH | AGT-H1 | L2 | No search-feedback automation — up to 100 credits/day lost | Add binding rule: "Run search-feedback after EVERY /search" | 15 |
| 27 | HIGH | AGT-H2 | L2 | No dead-host registry write logic — agents retry failing hosts | Add dead-host check/write protocol to TOOL-EXECUTION-SPEC.md error section | 30 |
| 28 | HIGH | AGT-H3 | L2 | No freshness SLA automation — agents re-fetch within SLA | Add pre-flight freshness check: skip if `fresh_until` is still future | 30 |
| 29 | HIGH | AGT-H4 | L2 | No error recovery protocol — agents hang on tool failure | Add error recovery: 5s retry, fallback, SOURCE_UNAVAILABLE after 3 failures | 30 |
| 30 | HIGH | AGT-H5 | L2 | Session isolation not enforced — cross-niche contamination risk | Add lock file protocol: `research/N-XXX/_lock` with heartbeat | 30 |
| 31 | HIGH | AGT-H6 | L2 | --query ban not enforced — 625+ credits wasted at scale | Ban --query usage in TOOL-EXECUTION-SPEC.md Rule #3: scrape-to-file + grep | 15 |
| 32 | MEDIUM | AGT-M1 | L2 | No monitoring setup during niche research (competitive intel) | Add Phase 3 step: set up Firecrawl monitor for each competitor pricing page | 30 |
| 33 | MEDIUM | AGT-M2 | L2 | No quality threshold for search results — accepts poor results | Add: if <3 relevant results, retry with alt query; 3 failures = SOURCE_UNAVAILABLE | 15 |
| 34 | MEDIUM | AGT-M3 | L2 | Grade engine I/O protocol undefined — agents don't know how to submit claims | Define grade engine interface: write `evidence-claims.json`, read `evidence-grades.json` | 60 |
| 35 | MEDIUM | AGT-M4 | L2 | F-4: Using DataForSEO when Firecrawl already has the data | Surface tool decision tree as 10-line checklist in TOOL-EXECUTION-SPEC.md | 15 |
| 36 | MEDIUM | AGT-M5 | L2 | F-5: Using /search for structured registry data that OpenRegistry handles better | Add explicit tool assignment for company registry verification | 10 |
| 37 | MEDIUM | AGT-M6 | L2 | F-8: Missing --only-main-content on competitor page scrapes | Make --only-main-content REQUIRED for competitor pages in TOOL-EXECUTION-SPEC.md | 10 |
| 38 | LOW | AGT-L1 | L2 | F-7: Missing --scrape flag on Phase 2 /search calls | Distinguish: "Phase 1: no --scrape. Phase 2: with --scrape." | 10 |
| 39 | LOW | AGT-L2 | L2 | F-13: Old Firecrawl flags in training data (--formats vs --format, etc.) | Encode canonical flags in TOOL-EXECUTION-SPEC.md — no agent needs old flags | 15 |
| 40 | LOW | AGT-L3 | L2 | F-14: Train data may reference old credit costs (/search = 1 cr not 2) | Reference current costs from TOOL-EXECUTION-SPEC.md credit budget table | 10 |
| 41 | CRITICAL | SRE-C01 | L3 | DataForSEO standard queue timeout is 30s, must be 310s | Change `dataforseo.serp.standard.total` from 30s to 310s in TIMEOUT_CONFIG.yaml | 5 |
| 42 | CRITICAL | SRE-C02 | L3 | GDELT has zero retry logic — silent data loss when rate-limited | Add exponential backoff + 3 retries; mark SOURCE_UNAVAILABLE if all fail | 20 |
| 43 | CRITICAL | SRE-C03 | L3 | Firecrawl status page `status.firecrawl.com` DNS NXDOMAIN — RUNBOOK broken | Replace broken page with test-request procedure in RUNBOOK.md | 5 |
| 44 | CRITICAL | SRE-C04 | L3 | Global concurrency lock file does NOT exist on disk | Create `_program/_CONCURRENCY_LOCK.yaml` with acquire/release protocol | 30 |
| 45 | CRITICAL | SRE-C05 | L3 | OECD API has 20 req/min limit, documented as "unlimited" | Fix documentation; add per-agent OECD throttle to 5 req/min | 10 |
| 46 | CRITICAL | SRE-C06 | L3 | Dead-host registry is a write-desert — nothing writes to it | Add dead-host write logic: 3 consecutive failures -> write to DEAD_HOST_REGISTRY.yaml | 25 |
| 47 | CRITICAL | SRE-C07 | L3 | Hiring signal fallback chain degrades to unrecoverable data type | Accept SOURCE_UNAVAILABLE; remove GDELT as hiring fallback | 15 |
| 48 | CRITICAL | SRE-C08 | L3 | Preflight-check does not verify any tool reachable — offline pipeline reports PROCEED | Add GATE 1 tool health checks: Firecrawl ping, DataForSEO ping, disk space | 45 |
| 49 | CRITICAL | SRE-CB1 | L3 | Firecrawl /crawl rate limit is 50 starts/min, not "50 concurrent" as documented | Fix documentation; document crawl start concurrency as separate from scrape | 10 |
| 50 | HIGH | SRE-H01 | L3 | IMF API 50 req/s limit, documented as "unlimited" — default app-name collision risk | Fix documentation; add unique user_agent; 1.5s delay between calls | 10 |
| 51 | HIGH | SRE-H02 | L3 | TED API undocumented per-IP rate limits, returns HTTP 429 | Fix documentation; add 429 handling; accept best-effort only | 10 |
| 52 | HIGH | SRE-H03 | L3 | Wikidata SPARQL 5 concurrent/IP limit — 4 agents exceed this | Fix timeout (60s, not 5s); add per-agent max 3 concurrent queries | 10 |
| 53 | HIGH | SRE-H04 | L3 | OpenRegistry MCP multi-country fan-out limited to 3 countries/60s free tier | Fix documentation; add per-agent throttle 5 req/min for OpenRegistry | 5 |
| 54 | HIGH | SRE-H05 | L3 | Reddit Research MCP anonymous access 10 req/min — 20 concurrent exceed 2x | Document auth mode; add per-agent throttle 2 concurrent calls | 15 |
| 55 | HIGH | SRE-H06 | L3 | Registry Lookup API fallback (5K/mo) documented but NOT configured | Add API key, endpoint to CREDENTIALS.yaml; or accept OpenRegistry-only | 15 |
| 56 | HIGH | SRE-H07 | L3 | BuiltWith fallback (2K/day) documented but NOT configured | Register for BuiltWith free API; add to CREDENTIALS.yaml | 15 |
| 57 | HIGH | SRE-H08 | L3 | Per-niche wall-clock estimates (13-16 min) completely untested | Run calibration niche; measure actual timings; set hard limit at 45 min | 30 |
| 58 | HIGH | SRE-H09 | L3 | Disk space check missing from ALL pipeline scripts | Add `check_disk_space()`: BLOCKED if <100MB, WARNING if 100-500MB | 15 |
| 59 | HIGH | SRE-H10 | L3 | No requirements.txt — `pip install --upgrade` could break deps | Create requirements.txt with pinned versions; add preflight import check | 15 |
| 60 | HIGH | SRE-H11 | L3 | DataForSEO Google Ads Live endpoint 12 req/min limit | Document 12/min limit; ensure agents specify "use standard queue" for Google Ads | 10 |
| 61 | HIGH | SRE-H12 | L3 | Currents API fallback (1K/day) documented but NOT configured | Add Currents API key or accept Firecrawl-only for news | 10 |
| 62 | HIGH | SRE-H13 | L3 | Pricing data has no tool-diverse fallback — both primary+fallback are Firecrawl | Add DataForSEO OnPage API as tool-diverse pricing fallback | 20 |
| 63 | HIGH | SRE-H14 | L3 | Preflight-check says INTERNAL_ERROR for missing CREDIT_BUDGET instead of actionable msg | Change to: "Phase 0 calibration NOT run. Run Phase 0 before any niche evaluation." | 5 |
| 64 | HIGH | SRE-HB1 | L3 | Market sizing fallback uses qualitatively different data (search vol != market size) | Add DATA_TYPE_MISMATCH flag; document substitution in trace-map.yaml | 15 |
| 65 | HIGH | SRE-HB2 | L3 | DataForSEO balance can hit $0 mid-phase — no per-call balance check | Add per-call DFS balance check before every API call | 15 |
| 66 | MEDIUM | SRE-M01 | L3 | Credit forecast accuracy SLI (20%) too tight for uncalibrated system | Loosen to 50% for first 5 niches; tighten after calibration | 5 |
| 67 | MEDIUM | SRE-M02 | L3 | Fetch success SLI counts non-retryable failures in denominator | Exclude 401/402/403/404 from fetch success SLI calculation | 5 |
| 68 | MEDIUM | SRE-M03 | L3 | Evidence quality SLI fails for single-source niches despite correct grading | Add `single_source_ratio` qualifier; adjust target if >50% single-source | 10 |
| 69 | MEDIUM | SRE-M04 | L3 | Freshness re-certification via HEAD hash comparison impossible | Replace with "ETag or Last-Modified header comparison" | 10 |
| 70 | MEDIUM | SRE-M05 | L3 | MCP_SCHEDULE.yaml not created — agents default to 1 concurrent call/server | Create `_program/MCP_SCHEDULE.yaml` with concurrent capacity per server | 15 |
| 71 | MEDIUM | SRE-M06 | L3 | TOOL_VERSIONS.yaml not created — no pinned API versions | Create during Phase 0 calibration; pin versions; delta check every 10 niches | 15 |
| 72 | MEDIUM | SRE-M07 | L3 | SHARED/ directory bootstrap not started — no _REGISTRY.yaml, benchmarks | Create _REGISTRY.yaml, benchmarks/, competitors/, triggers/ under SHARED/ | 20 |
| 73 | MEDIUM | SRE-M08 | L3 | Cache hit rate tracking not implemented — unmeasurable | Add `cache_hit` field to CREDIT_BUDGET.yaml tracking | 10 |
| 74 | MEDIUM | SRE-M09 | L3 | Pipeline availability SLI has no measurement mechanism | Add `pipeline_start_timestamp` and `last_failure_timestamp` to TOOL_ERROR_LOG.yaml | 10 |
| 75 | MEDIUM | SRE-MB1 | L3 | Eurostat rate limit is "30 req/min" but this is a GUESS | Verify empirically during Phase 0; update docs with measured value | 10 |
| 76 | MEDIUM | SRE-MB2 | L3 | World Bank "unlimited" — UNVERIFIED | Verify empirically during Phase 0 | 10 |
| 77 | MEDIUM | SRE-MB3 | L3 | Firecrawl /crawl consumes ALL 50 browser sessions if one agent starts large crawl | Document: large crawl jobs (>20 pages) during low-usage windows | 10 |
| 78 | MEDIUM | SRE-MB4 | L3 | TIMEOUT_CONFIG.yaml uses ONLY total timeouts, no connect/read split | Restructure to 3-level (connect + read + total) per tool | 20 |
| 79 | MEDIUM | SRE-MB5 | L3 | Firecrawl /scrape JS-rendered timeout 60s, should be 90s | Change to 90s; add `static` vs `js_rendered` sub-keys in TIMEOUT_CONFIG.yaml | 5 |
| 80 | MEDIUM | SRE-MB6 | L3 | No free API timeout entries in TIMEOUT_CONFIG.yaml | Add `free_apis:` section with connect/read/total for GDELT, EUROSTAT, OECD, etc. | 15 |
| 81 | LOW | SRE-L01 | L3 | CONCURRENCY_LOCK.yaml stale lock cleanup not specified | Document: "If a lock is >5 minutes old, any agent may break it." | 5 |
| 82 | LOW | SRE-L02 | L3 | Post-incident review directory `_program/_postmortems/` doesn't exist | Create directory + INDEX.yaml | 5 |
| 83 | LOW | SRE-L03 | L3 | Credit burn rate kill switch can't be measured without real tracking | Ensure every credit op writes to CREDIT_BUDGET.yaml with timestamp | 10 |
| 84 | LOW | SRE-L04 | L3 | Phase 0 delta check (every 10 niches) not scheduled — no counter | Add PHASE_0_DELTA_COUNTER to PIPELINE_CHECKPOINTS.yaml | 5 |
| 85 | LOW | SRE-L05 | L3 | Firecrawl credit-usage not run programmatically — CREDIT_BUDGET.yaml may be stale | Add `firecrawl credit-usage` parsing to preflight-check | 15 |
| 86 | LOW | SRE-L06 | L3 | No mechanism to verify DataForSEO password hasn't rotated | Add `last_verified` field to CREDENTIALS.yaml; expiry date for OAuth | 10 |
| 87 | LOW | SRE-L07 | L3 | No --force flag documented for BLOCKED-class data staleness override | Document `--force` in RUNBOOK.md for emergency waiver | 5 |
| 88 | LOW | SRE-L08 | L3 | Cross-source consistency for categorical claims not implemented | Add check: if 2 independent sources same categorical claim, verify wording | 20 |
| 89 | CRITICAL | DQ-P01 | L4 | Evidence grade engine never calibrated against human judgment | Run calibration: 3 humans grade 30 claims vs engine; adjust if Kappa < 0.61 | 60 |
| 90 | CRITICAL | DQ-P02 | L4 | No normalization for data availability across niches | Implement DATA-COVERAGE-MATRIX.yaml with normalization factor | 45 |
| 91 | CRITICAL | DQ-P03 | L4 | Independent verifier cannot detect interpretation fabrication | Extend verifier: independently extract claim from source, compare to trace-map | 60 |
| 92 | CRITICAL | DQ-P04 | L4 | Schema validation scripts are DRAFT — not operational | Implement validate-schema.sh, freshness-audit.sh, preflight-check.sh | 120 |
| 93 | HIGH | DQ-P2_1 | L4 | >=20 reviews from >=2 sources impossible for 8-10 niches | Add `review_corpus_availability` flag; demote req to "target" for affected niches | 15 |
| 94 | HIGH | DQ-P2_2 | L4 | No dedicated tool for buyer language extraction | Add dedicated Phase 2.9 step: search for verbatim quotes with schema | 20 |
| 95 | HIGH | DQ-P2_3 | L4 | Trigger scoring has no empirical basis — pure agent judgment | Require evidence for 2+ dimensions per trigger; verifiable via API/doc | 20 |
| 96 | HIGH | DQ-P2_4 | L4 | Stackshare/tech blog analysis has no assigned tool | Add Stackshare API or BuiltWith; or flag tech claims as `[H]` | 20 |
| 97 | MEDIUM | DQ-P3_1 | L4 | Budget verification has no tool support — inherently human | Accept as human process; flag in §15 as pre-investment validation step | 5 |
| 98 | MEDIUM | DQ-P3_2 | L4 | Non-transparent pricing for enterprise has no fallback | Use G2 price mentions, job-posting budgets, case studies; mark `[E]` | 15 |
| 99 | MEDIUM | DQ-P3_3 | L4 | GDELT rate limit unbounded — no queuing or batch strategy | Add rate-limit handling; bundle queries; add 1s/2s/4s backoff | 15 |
| 100 | MEDIUM | DQ-P3_4 | L4 | Reddit Research MCP non-English coverage thin | Supplement with Dutch-language LinkedIn groups, forums, CBS StatLine | 15 |
| 101 | MEDIUM | DQ-B01 | L4 | Market sizing AMBIGUITY — no guidance on source combination | Add: "gov API primary, Firecrawl secondary. If unavailable, 2 independent searches." | 10 |
| 102 | MEDIUM | DQ-B02 | L4 | Revenue leak benchmark (26%) is single vendor-commissioned source | Document as vendor-commissioned; cross-validate with industry benchmarks | 5 |
| 103 | MEDIUM | DQ-B03 | L4 | Tech architecture inference no tool assigned (same as DQ-P2_4) | Same fix as DQ-P2_4: Stackshare or `[H]` downgrade | 5 |
| 104 | MEDIUM | DQ-B04 | L4 | Ecosystem section — no tool for aggregator economics or partner activation | Accept as design work; flag economic estimates as `[H]`-`[S]` | 5 |
| 105 | MEDIUM | DQ-B05 | L4 | Signal catalog — 15 signals with no discovery pipeline; at 0 clients all are `[H]` | Accept; first 3 clients are calibration partners; upgrade after live validation | 5 |
| 106 | MEDIUM | DQ-B06 | L4 | Customer journey — no tool supports journey design; all rates are `[H]`-`[S]` | Accept as design; conversion rates inherit pricing grades; document limitation | 5 |
| 107 | HIGH | DQ-B07 | L4 | Dark matter: Trade shows have zero digital exhaust — no API | Add explicit note in each canvas §15 for affected niches | 10 |
| 108 | HIGH | DQ-B08 | L4 | Dark matter: In-person meetings/word-of-mouth undetectable | Acknowledge as inherent limitation; trigger system is entirely digital | 5 |
| 109 | HIGH | DQ-B09 | L4 | Dark matter: Private company dynamics — no Crunchbase, no SEC for consulting | Add coverage flag per niche; normalize evidence scores | 15 |
| 110 | CRITICAL | SEC-01 | L5 | FRED API "Non-Commercial Use Only" — active ToS violation for commercial entity | Remove FRED_API_KEY immediately; replace with World Bank + IMF; mark FRED as COMMERCIAL_LICENSE_REQUIRED | 15 |
| 111 | HIGH | SEC-02 | L5 | Reddit Research MCP ToS ambiguity — scraping vs official API | Verify MCP uses official API; if scraping -> DO NOT USE -> Firecrawl fallback | 30 |
| 112 | HIGH | SEC-03 | L5 | Credentials split across ~/.bashrc and ~/.claude/settings.json — .bashrc visible to ALL | Move FIRECRAWL_API_KEY, DATAFORSEO_LOGIN/PASSWORD to settings.json; remove from .bashrc | 10 |
| 113 | HIGH | SEC-04 | L5 | No credential rotation or expiry tracking for any of 9 API keys | Add `expires` and `last_rotated` fields to CREDENTIALS.yaml; quarterly audit | 20 |
| 114 | HIGH | SEC-05 | L5 | G2/Capterra scraping ToS unverified — Section 4.3 may prohibit scraping | Read ToS; if prohibited use DataForSEO SERP; create COMPLIANCE_BLACKLIST.yaml | 45 |
| 115 | MEDIUM | SEC-06 | L5 | No prompt injection defense (duplicates AGT-B5) | See AGT-B5 fix; add §31 to loading spec + binding rule | 15 |
| 116 | MEDIUM | SEC-07 | L5 | Raw content accumulates in .firecrawl/ — may contain PII | Run clean-raw-fetches; set 30-day retention; spot-check for PII | 20 |
| 117 | MEDIUM | SEC-08 | L5 | Session transcripts in ~/.claude/projects/ may contain API keys | Search/redact transcripts; add binding rule: "Never echo credential values" | 15 |
| 118 | MEDIUM | SEC-09 | L5 | No data disposal plan — competitor pricing, review corpora have no lifecycle | Document lifecycle: Active -> Archive (30d) -> Dispose (90d) | 15 |
| 119 | MEDIUM | SEC-10 | L5 | YouTube Data API v3 10K quota/day — 4 agents could exhaust on one niche | Add quota tracking; budget 500 units/niche; check before calls | 10 |
| 120 | LOW | SEC-11 | L5 | Brandfetch free tier (500K req/mo) requires attribution — not documented | Add attribution requirement to SME-tool-reference-expansion.md | 5 |
| 121 | LOW | SEC-12 | L5 | UK Companies House API commercial terms not explicitly verified | Verify terms; current usage well within acceptable use | 10 |
| 122 | LOW | SEC-13 | L5 | No security contact or incident response plan | Add security contact + incident response procedure to RUNBOOK.md | 10 |
| 123 | CRITICAL | RED-F01 | L6 | Credit estimate is design fiction — realistic 180-400 credits (not 132) | Run first REAL niche end-to-end; set 2.0x buffer; implement kill switch | 120 |
| 124 | CRITICAL | RED-F03 | L6 | Grade engine has NO semantic understanding — URL existence != claim substantiation | Replace with semantic checker: LLM evaluates if source supports claim | 240 |
| 125 | CRITICAL | RED-F04 | L6 | Calibration on 2 niches has zero statistical power for 25 | Add manual mid-pipeline review at #5 and #10; independent agent mini-calibration | 180 |
| 126 | CRITICAL | RED-F13 | L6 | RIOS score formula is subjective judgment engineered to look objective | Add "Limitations" section: scores are ordinal opinions, not cardinal truths | 30 |
| 127 | CRITICAL | RED-F14 | L6 | Pipeline outputs are unfalsifiable for 23+ months | Add falsifiability criteria per niche canvas: "If <50K ARR in 12mo, which claim was wrong?" | 60 |
| 128 | HIGH | RED-F02 | L6 | Concurrency lock cannot distinguish intent from execution — 9.7% collision per batch | Implement write-transactions; reduce concurrency from 4 to 3 agents | 120 |
| 129 | HIGH | RED-F05 | L6 | Self-audit drift detection is contradictory — agent checks itself | Replace with INDEPENDENT agent mini-calibration every 5th niche | 120 |
| 130 | HIGH | RED-F06 | L6 | Ground truth does NOT exist — _GROUND-TRUTH/ directory EMPTY | Wesley produces reference canvas for 5 sections BEFORE any agent calibration | 240 |
| 131 | HIGH | RED-F07 | L6 | 25-niche list too rigid — no surprise niche slot; rewards data-rich niches | Add "surprise niche" slot; add "top 5 in 2 weeks" fast-track | 60 |
| 132 | HIGH | RED-F09 | L6 | Shared YAML race conditions: incomplete flush, partial writes, interleaved append | Implement atomic mv; per-agent log files; JSON-line structured logging | 90 |
| 133 | HIGH | RED-F11 | L6 | "BINDING" has NO enforcement mechanism | Enforce via: deterministic grade engine, independent verification, schema validation | 60 |
| 134 | HIGH | RED-F15 | L6 | Methodology rewards FORM over SUBSTANCE — well-formatted wrong answers score higher | Add semantic accuracy dimension: verifier extracts specific claim from source | 120 |
| 135 | MEDIUM | RED-F08 | L6 | Pipeline produces NO output until all 25 complete — 6 weeks of zero decisions | Implement "top 5 in 2 weeks" fast-track (STANDARD depth -> DEEP on top 5) | 60 |
| 136 | MEDIUM | RED-F10 | L6 | First niche's 7-day SLA data stale before pipeline completes | Collect job/hiring data as final step before canvas finalization, not initial | 30 |
| 137 | MEDIUM | RED-F12 | L6 | Pipeline requires human operator for 8+ failure scenarios — each is SPOF on Wesley | Document all human interventions in OPERATOR-RESPONSIBILITIES.md | 30 |

---

## Quick Wins (<15 min each, do immediately)

These 34 findings can be fixed in under 15 minutes each. Do them first for immediate impact.

### Under 5 Minutes

| # | ID | Description | Minutes | Workstream |
|---|---|---|---|---|
| 1 | MCP-A1 | Add PaperPlain MCP config | 2 | A |
| 2 | MCP-A2 | Add Reddit Research hosted SSE config | 2 | A |
| 3 | MCP-A3 | Add Financial Hub MCP config | 3 | A |
| 4 | MCP-A4 | Fix Brave Search documentation | 5 | A |
| 5 | MCP-A5 | Fix Serper free tier documentation | 5 | A |
| 6 | MCP-A6 | Document Firecrawl MCP SKIP decision | 5 | A |
| 7 | SRE-C01 | Fix DataForSEO standard queue timeout (30s -> 310s) | 5 | C |
| 8 | SRE-C03 | Fix Firecrawl status page RUNBOOK entry | 5 | C |
| 9 | SRE-H14 | Fix preflight-check CREDIT_BUDGET error message | 5 | C |
| 10 | SRE-M01 | Loosen credit forecast accuracy SLI | 5 | C |
| 11 | SRE-M02 | Fix fetch success SLI error exclusion | 5 | C |
| 12 | SRE-L01 | Document stale lock cleanup interval | 5 | C |
| 13 | SRE-L02 | Create post-incident review directory | 5 | C |
| 14 | SRE-L04 | Add Phase 0 delta counter to PIPELINE_CHECKPOINTS.yaml | 5 | C |
| 15 | SRE-L07 | Document --force flag for BLOCKED freshness override | 5 | C |
| 16 | SEC-11 | Add Brandfetch attribution requirement | 5 | G |
| 17 | DQ-P3_1 | Accept budget verification as human process; flag in §15 | 5 | E |
| 18 | DQ-B02 | Document vendor-commissioned source flag | 5 | E |
| 19 | DQ-B03 | Document tech inference tool gap (or cross-ref DQ-P2_4) | 5 | E |
| 20 | DQ-B04 | Accept ecosystem as design work; flag economic estimates | 5 | E |
| 21 | DQ-B05 | Accept signal catalog limitation for zero-client stage | 5 | E |
| 22 | DQ-B06 | Accept customer journey as design section | 5 | E |
| 23 | SRE-MB5 | Fix Firecrawl JS-rendered timeout (60s -> 90s) | 5 | C |
| 24 | SRE-H04 | Fix OpenRegistry multi-country doc | 5 | C |

### 10-15 Minutes

| # | ID | Description | Minutes | Workstream |
|---|---|---|---|---|
| 25 | MCP-B5 | Create Google CSE engine ID | 10 | A |
| 26 | SRE-C05 | Fix OECD rate limit documentation | 10 | C |
| 27 | SRE-H01 | Fix IMF rate limit documentation | 10 | C |
| 28 | SRE-H02 | Fix TED API rate limit documentation | 10 | C |
| 29 | SRE-H03 | Fix Wikidata SPARQL timeout doc | 10 | C |
| 30 | SRE-H11 | Document DataForSEO Google Ads Live 12/min limit | 10 | C |
| 31 | SRE-H12 | Add Currents API key or accept Firecrawl-only | 10 | C |
| 32 | SRE-M03 | Add single_source_ratio qualifier to SLI | 10 | C |
| 33 | SRE-M04 | Fix freshness re-certification to use ETag/Last-Modified | 10 | C |
| 34 | SEC-03 | Move credentials from .bashrc to settings.json | 10 | G |

---

## Workstream A: MCP Configuration (20 findings)

### Critical

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| A-C1 | MCP-A1 | PaperPlain MCP not configured (zero setup, no auth, academic paper search) | Add config: `"paperplain": { "type": "stdio", "command": "npx", "args": ["-y", "paperplain-mcp"] }` | 2 | Pipeline Operator |
| A-C2 | MCP-A2 | Reddit Research MCP (hosted SSE) not configured | Add config: `"reddit-research": { "type": "sse", "url": "https://reddit-research-mcp.fastmcp.app/mcp" }` | 2 | Pipeline Operator |
| A-C3 | MCP-A3 | Financial Hub MCP not configured (already have SEC_USER_AGENT_EMAIL, FRED_API_KEY) | Add config with SEC_USER_AGENT_EMAIL and FRED_API_KEY env vars | 3 | Pipeline Operator |
| A-C4 | MCP-A4 | Brave Search documented as "Unlimited (self-hosted)" — incorrect. Requires API key, 2K queries/mo free | Fix DATA-OPERATIONS-ARCHITECTURE.md §2.1; add self-hosted SearXNG as separate option | 5 | Documentation |
| A-C5 | MCP-A5 | Serper free tier documented as "one-time" — actually 2,500/month recurring (better than documented) | Fix SME-tool-reference-expansion.md §1.4 | 5 | Documentation |
| A-C6 | MCP-A6 | Firecrawl MCP vs CLI decision not documented — CLI has 10+ commands, MCP missing 7 critical ones (interact, monitor, download, parse, agent, search-feedback) | Document SKIP decision permanently; CLI stays primary | 5 | Documentation |
| A-C7 | MCP-A7 | DataForSEO used via raw curl — should migrate to official `dataforseo-mcp-server` (v2.9.11, 10 API modules) | Migrate; keep raw curl scripts as fallback during transition | 15 | Pipeline Architect |

### High

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| A-H1 | MCP-B1 | Serper MCP not configured (2,500 queries/month recurring — best free-tier web search) | Sign up at serper.dev; add SERPER_API_KEY + config to settings.json | 5 | Pipeline Operator |
| A-H2 | MCP-B2 | DataForSEO MCP migration unverified against all 9 API categories | Test all 9 API categories (SERP, Keywords, Labs, Domain Analytics, Backlinks, OnPage, Business Data, Content Analysis, Merchant) against raw curl parity | 15 | Pipeline Architect |
| A-H3 | MCP-B3 | Jina AI MCP (webskim) not configured (1M tokens free, context-efficient design) | Sign up at jina.ai; add JINA_API_KEY + webskim config | 5 | Pipeline Operator |
| A-H4 | MCP-B4 | Brave Search MCP not configured (2,000 queries/month free) | Sign up at api.search.brave.com; add BRAVE_API_KEY + config | 5 | Pipeline Operator |
| A-H5 | MCP-B5 | Google CSE MCP not configured (already have GOOGLE_API_KEY, need CSE engine ID) | Create Programmable Search Engine at programmablesearchengine.google.com; add GOOGLE_CSE_ID | 10 | Pipeline Operator |
| A-H6 | MCP-B6 | CrawlForge MCP not configured (1,000 free credits, 27 MCP-native tools) | Sign up at crawlforge.dev; add CRAWLFORGE_API_KEY + config | 5 | Pipeline Operator |
| A-H7 | MCP-B7 | FetchSERP MCP not configured (250 free credits, unique DNS/WHOIS/tech stack tools) | Sign up at fetchserp.com; add FETCHSERP_API_TOKEN + config | 5 | Pipeline Operator |

### Medium

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| A-M1 | MCP-C1 | SearXNG MCP not deployed (unlimited private web search without API costs) | Docker Compose SearXNG + Redis; configure `@iori7295/searxng-mcp` | 60 | Pipeline Architect |
| A-M2 | MCP-C2 | TAM-MCP-Server not built (consolidates 8 government data sources: BLS, Census, FRED, IMF, OECD, World Bank, Alpha Vantage, Nasdaq) | git clone + npm install + npm run build + env config | 30 | Pipeline Architect |

### Low

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| A-L1 | MCP-D1 | SEC EDGAR MCP considered but redundant (Financial Hub covers it with 16 tools) | Document SKIP decision | 5 | Documentation |
| A-L2 | MCP-D2 | `@cdilorenzo/mcp-dataforseo` (community) considered vs official | Document SKIP decision — official DataForSEO version is better maintained | 5 | Documentation |
| A-L3 | MCP-D3 | Reddit Research has 6+ different MCP packages — which to use undecided | Document: start with hosted SSE; optionally add `reddit-intelligence-agent-mcp` for scoring | 5 | Documentation |
| A-L4 | MCP-D4 | 8 architecture document corrections needed across DATA-OPERATIONS-ARCHITECTURE.md | Apply all corrections: Brave Search, Serper, Reddit, OpenRegistry, OECD, IMF, TED, Wikidata, Firecrawl note | 15 | Documentation |

### Verification Gate A: MCP Infrastructure

| Check | Pass Criteria |
|---|---|
| A-G1 | PaperPlain MCP: `search_research("test")` returns structured results within 15s |
| A-G2 | Reddit Research MCP: `searchReddit({ query: "test", limit: 5 })` returns results |
| A-G3 | Financial Hub MCP: `search_companies({ query: "Microsoft" })` returns SEC/FRED data |
| A-G4 | Serper MCP (if configured): `search_web({ q: "test" })` returns SERP data |
| A-G5 | DataForSEO MCP (if migrated): `serp_google_organic_live({ keyword: "test" })` returns SERP |
| A-G6 | All 8 architecture corrections applied: diff shows changes in DATA-OPERATIONS-ARCHITECTURE.md |

---

## Workstream B: Agent Instruction Layer (16 findings)

### Critical / Blocking

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| B-C1 | AGT-B1 | Phase 2 context budget (60K) dangerously tight — must-load content ~45K, leaving only ~15K for research data. Sufficient coverage requires independent mini-calibration agent | — | — | — |
| B-C2 | AGT-B2 | Phase 2 context budget insufficient — must-load tool ref sections = ~18K. With NICHE-METHOD canvas = 40K, only ~15K headroom for research data | — | — | — |

**Consolidated fix for B-C1/B-C2:** Create TOOL-EXECUTION-SPEC.md (4.5K tokens) to replace all tool reference section loading. Update AGENT-CONTEXT-SPEC.md: replace Firecrawl Ref §§3,4,5,6,8,9,29,30 and Data Sources §§1.2-1.9,2,3,4,5 with single link to TOOL-EXECUTION-SPEC.md. Phase 2 headroom increases from ~15K to ~40K tokens. | 120 | Pipeline Architect |

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| B-C3 | AGT-B3 | No tool escalation pattern — agents default to /scrape when should /search, or /interact when should /scrape --wait-for | Encode escalation pattern in TOOL-EXECUTION-SPEC.md: search -> scrape -> map -> crawl -> interact. Rule #1. | 60 | Pipeline Architect |
| B-C4 | AGT-B4 | JS-rendered pages fail without --wait-for — G2, marketplaces, SPAs return empty content | Make --wait-for 3000-5000 REQUIRED for review pages, marketplaces, JS sites. Encode in TOOL-EXECUTION-SPEC.md Rule #5. | 15 | Pipeline Architect |
| B-C5 | AGT-B5 | Cache preflight not automated — agents re-fetch data that exists and is within SLA | Add mandatory cache preflight block: check .firecrawl/ + research/N-XXX/ before every fetch. Freshness check using `fresh_until` timestamps. | 30 | Pipeline Architect |
| B-C6 | AGT-B6 | No prompt injection defense — web content is untrusted third-party data that can poison context | Add binding rule: "NEVER write full scraped page content into context. Extract via grep/jq from file." Add Firecrawl Ref §31 to Phase 1 loading spec. | 30 | Pipeline Architect |

### High

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| B-H1 | AGT-H1 | No search-feedback automation — up to 100 credits/day refundable lost | Add binding rule #6: "Run search-feedback after EVERY /search call." Template: `SEARCH_ID=$(jq -r '.id' .firecrawl/search-*.json) && firecrawl search-feedback "$SEARCH_ID" --rating good --silent &` | 15 | Pipeline Architect |
| B-H2 | AGT-H2 | No dead-host registry write logic — 3 consecutive failures to same host go undetected | Add to TOOL-EXECUTION-SPEC.md error section: on 3 failures to same host, write to DEAD_HOST_REGISTRY.yaml with atomic tmp+mv | 30 | Pipeline Architect |
| B-H3 | AGT-H3 | No freshness SLA automation — agents re-fetch data still within SLA window | Add pre-flight freshness check: check `fresh_until` in structured data files. If still valid, skip. If expired, re-fetch only that data point. | 30 | Pipeline Architect |
| B-H4 | AGT-H4 | No error recovery protocol — agents hang on tool failure with no retry/fallback/abort guidance | Add error recovery section to TOOL-EXECUTION-SPEC.md: 5s retry -> check RETRYABLE vs NON-RETRYABLE -> use fallback -> SOURCE_UNAVAILABLE after 3 failures | 30 | Pipeline Architect |
| B-H5 | AGT-H5 | Session isolation not enforced — second agent could operate on same niche ID | Add lock file protocol: `research/N-XXX/_lock` with niche_id, agent_session_id, started_at, heartbeat. Check before starting; abort if lock <30min old; break if >30min. | 30 | Pipeline Architect |
| B-H6 | AGT-H6 | `--query` ban not enforced — each misuse costs 5 extra credits; 625+ credits wasted at scale | Ban `--query` in TOOL-EXECUTION-SPEC.md Rule #3: "Never use `--query`. Scrape to file, then grep." | 15 | Pipeline Architect |

### Medium

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| B-M1 | AGT-M1 | No competitive monitoring setup during niche research | Add Phase 3 step: Firecrawl monitor for each competitor pricing page: `firecrawl monitor create --name "{competitor} pricing" --schedule "daily" --goal "Alert when pricing changes" --page {url}` | 30 | Pipeline Architect |
| B-M2 | AGT-M2 | No quality threshold for search results — if /search returns <3 relevant, agents accept poor results | Add: "If <3 relevant results, log QUALITY_WARNING, retry with alt query. If 3+ attempts fail, mark SOURCE_UNAVAILABLE." | 15 | Pipeline Architect |
| B-M3 | AGT-M3 | Grade engine I/O protocol undefined — agents don't know how to submit claims for grading | Define: "After completing all 15 sections, write `research/N-XXX/evidence-claims.json` with all claim-source pairs. Grade engine reads this file and writes `evidence-grades.json`. Do NOT finalize canvas until grades received." | 60 | Pipeline Architect |
| B-M4 | AGT-M4 | F-4: Using DataForSEO for data Firecrawl already has — wastes $2-3 across 25 niches | Surface tool decision tree as 10-line checklist in TOOL-EXECUTION-SPEC.md | 15 | Pipeline Architect |
| B-M5 | AGT-M5 | F-5: Using /search for registry data that OpenRegistry MCP handles better | Add explicit tool assignment: "For company registry: use OpenRegistry MCP first, not /search" | 10 | Pipeline Architect |
| B-M6 | AGT-M6 | F-8: Missing --only-main-content on competitor scrapes — wastes tokens on nav/footer/sidebar | Make --only-main-content REQUIRED in TOOL-EXECUTION-SPEC.md Rule #4 | 10 | Pipeline Architect |

### Low

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| B-L1 | AGT-L1 | F-7: Missing --scrape flag on Phase 2 /search calls — returns snippets only | Distinguish in TOOL-EXECUTION-SPEC.md: "Phase 1: search without --scrape. Phase 2+: search with --scrape." | 10 | Pipeline Architect |
| B-L2 | AGT-L2 | F-13: Old Firecrawl flags in training data (--formats vs --format, --state vs --status) | All canonical flags encoded in TOOL-EXECUTION-SPEC.md. Agent uses spec, not training data. | 15 | Pipeline Architect |
| B-L3 | AGT-L3 | F-14: Training data may reference old credit costs (/search=1 not 2) | Current costs in TOOL-EXECUTION-SPEC.md credit budget table. Agent uses current spec. | 10 | Pipeline Architect |

### Verification Gate B: Agent Instruction Layer

| Check | Pass Criteria |
|---|---|
| B-G1 | TOOL-EXECUTION-SPEC.md exists on disk at `niche-program/_pipelines/TOOL-EXECUTION-SPEC.md` |
| B-G2 | All 10 binding rules present: grep count of "BINDING" >= 10 in file |
| B-G3 | Every command table entry has non-empty fallback column |
| B-G4 | All 3 CONFIGURE_NOW MCP servers listed in command table |
| B-G5 | Prompt injection defense rule present: "NEVER write full scraped page content" in methodology |
| B-G6 | Cache preflight block present with freshness check |
| B-G7 | Dead-host write logic in error section |
| B-G8 | Session isolation lock file protocol present |
| B-G9 | Error recovery protocol present (5s retry -> fallback -> SOURCE_UNAVAILABLE) |
| B-G10 | search-feedback rule present |

---

## Workstream C: Reliability & Concurrency (33 findings)

### Critical

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| C-C1 | SRE-C01 | DataForSEO standard queue timeout = 30s in config, architecture says 300s — every standard-queue call will time out | Change `dataforseo.serp.standard.total` from 30s to 310s; add connect/read split | 5 | Pipeline Architect |
| C-C2 | SRE-C02 | GDELT has zero retry logic — rate-limited requests return empty data that agents treat as "no news" | Add exponential backoff with 3 retries (1s/2s/4s + jitter). If all fail: SOURCE_UNAVAILABLE. Never pass empty data. | 20 | Pipeline Architect |
| C-C3 | SRE-C03 | RUNBOOK says check `status.firecrawl.com` but DNS NXDOMAIN — page doesn't exist | Replace with: "Send test /search request. If it succeeds, operational. If not, check docs.firecrawl.dev." | 5 | Documentation |
| C-C4 | SRE-C04 | `_CONCURRENCY_LOCK.yaml` does NOT exist on disk — 4 agents would hit tools with zero coordination | Create `_program/_CONCURRENCY_LOCK.yaml` with schema from architecture §4.6. Agent prompts must include lock acquire/release. | 30 | Pipeline Architect |
| C-C5 | SRE-C05 | OECD API has 20 req/min limit (not "unlimited" as documented) | Fix docs. Add per-agent OECD throttle: 5 req/min. Err on conservative side. | 10 | Documentation |
| C-C6 | SRE-C06 | Dead-host registry is a write-desert — nothing writes to it | Add write trigger: 3 consecutive failures to same host -> write to DEAD_HOST_REGISTRY.yaml with host, timestamp, error code. Use `.lock` file for concurrent writes. | 25 | Pipeline Architect |
| C-C7 | SRE-C07 | Hiring signal fallback chain (ATS -> Techmap -> GDELT) degrades to fundamentally different data type | Accept SOURCE_UNAVAILABLE as only path when ATS APIs fail. Remove GDELT as hiring fallback — it cannot produce structured job counts. | 15 | Methodology |
| C-C8 | SRE-C08 | Preflight-check does not verify ANY tool is reachable | Add GATE 1: Firecrawl ping, DataForSEO ping, disk space check, Python dependency integrity. Implement `check_firecrawl_health()`, `check_dataforseo_health()`, `check_disk_space()`. | 45 | Pipeline Architect |
| C-C9 | SRE-CB1 | Firecrawl /crawl rate limit documented as "50 concurrent" — actually 50 starts/min | Fix documentation. Document crawl start concurrency as separate from scrape concurrency. | 10 | Documentation |

### High

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| C-H1 | SRE-H01 | IMF API 50 req/s app-based limit (not "unlimited"). Default app-name collision risk. | Fix docs. Add unique user_agent. Add 1.5s delay between calls. | 10 | Documentation |
| C-H2 | SRE-H02 | TED API undocumented per-IP rate limits. Returns HTTP 429 with no guidance. | Fix docs. Add 429 handling with exponential backoff. Accept best-effort. | 10 | Documentation |
| C-H3 | SRE-H03 | Wikidata SPARQL has 5 concurrent/IP limit. Timeout is 60s, not 5s. | Fix docs. Add per-agent throttle: max 3 concurrent queries. Add 429 retry. | 10 | Documentation |
| C-H4 | SRE-H04 | OpenRegistry MCP multi-country fan-out: 3 countries/60s on free tier (not "30 national registries") | Fix docs. Add per-agent throttle: 5 req/min for OpenRegistry. Document free tier constraint. | 5 | Documentation |
| C-H5 | SRE-H05 | Reddit Research MCP anonymous access: 10 req/min. 20 concurrent requests exceed 2x. | Add per-agent throttle: 2 concurrent Reddit calls max. Recommend OAuth for 100 req/min. | 15 | Operations |
| C-H6 | SRE-H06 | Registry Lookup API (5K/mo) fallback documented but NOT configured — no API key, endpoint, or agent prompt | Add API key, endpoint to CREDENTIALS.yaml. If not available, accept OpenRegistry-only SPOF. | 15 | Operations |
| C-H7 | SRE-H07 | BuiltWith fallback (2K/day) documented but NOT configured — no API key | Register for BuiltWith free API. Add to CREDENTIALS.yaml. Add agent prompt for usage. | 15 | Operations |
| C-H8 | SRE-H08 | Per-niche wall-clock estimates (13-16 min) are completely untested guesses | Run calibration niche. Measure actual timings. Update estimates. Set hard limit at 45 min. | 30 | Pipeline Architect |
| C-H9 | SRE-H09 | Disk space check missing from ALL scripts — silent failure when disk fills | Add `check_disk_space()`: BLOCKED if <100MB, WARNING 100-500MB. Add write-time guard. | 15 | Pipeline Architect |
| C-H10 | SRE-H10 | No requirements.txt — `pip install --upgrade` could break ruamel.yaml, certifi SSL | Create requirements.txt with pinned versions (pyyaml, requests, urllib3, certifi, jsonschema). Add preflight import check. | 15 | Operations |
| C-H11 | SRE-H11 | DataForSEO Google Ads Live endpoint: 12 req/min limit | Ensure agents use standard queue (not live) for Google Ads. Document 12/min limit. | 10 | Documentation |
| C-H12 | SRE-H12 | Currents API (1K/day) news fallback documented but NOT configured | Add Currents API key to CREDENTIALS.yaml + agent prompt. Or remove from fallback chain, accept Firecrawl-only news. | 10 | Operations |
| C-H13 | SRE-H13 | Pricing data has NO tool-diverse fallback — primary and fallback are both Firecrawl | Add DataForSEO OnPage API as tool-diverse pricing fallback for when Firecrawl is unavailable. | 20 | Pipeline Architect |
| C-H14 | SRE-H14 | Preflight-check says INTERNAL_ERROR for missing CREDIT_BUDGET — not actionable | Change to: "Phase 0 calibration has NOT been run. Run Phase 0 before any niche evaluation." | 5 | Operations |
| C-H15 | SRE-HB1 | Market sizing fallback uses search volume as proxy for market size — qualitatively different | Add DATA_TYPE_MISMATCH flag when substituting. Document in trace-map.yaml. Do NOT substitute silently. | 15 | Methodology |
| C-H16 | SRE-HB2 | DataForSEO balance can hit $0 mid-phase — GATE only fires at phase transitions | Add per-call DFS balance check before every API call. Wrap DFS calls with try/except for 402 errors. | 15 | Pipeline Architect |

### Medium

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| C-M1 | SRE-M01 | Credit forecast accuracy SLI (20%) too tight for uncalibrated system | Loosen to 50% for first 5 niches. Tighten after calibration data stabilizes. | 5 | Methodology |
| C-M2 | SRE-M02 | Fetch success SLI counts non-retryable failures (401, 402, 403, 404) in denominator | Exclude NON_RETRYABLE from denominator. Split into RETRYABLE (429, 500, 502, 503) and NON_RETRYABLE. | 5 | Methodology |
| C-M3 | SRE-M03 | Evidence quality SLI may fail for single-source niches despite correct grading | Add `single_source_ratio` qualifier. If >50% of data types are single-source, adjust target. | 10 | Methodology |
| C-M4 | SRE-M04 | Freshness re-certification via HEAD + content hash comparison is impossible (HEAD has no body) | Replace with "ETag or Last-Modified header comparison" in DATA-OPERATIONS-ARCHITECTURE.md §6.4a | 10 | Documentation |
| C-M5 | SRE-M05 | MCP_SCHEDULE.yaml not created — agents default to 1 concurrent call per server | Create `_program/MCP_SCHEDULE.yaml` with concurrent capacity per server type. | 15 | Pipeline Architect |
| C-M6 | SRE-M06 | TOOL_VERSIONS.yaml not created — no pinned API versions, no delta check mechanism | Create during Phase 0 calibration. Pin API versions. Delta check every 10 niches. | 15 | Pipeline Architect |
| C-M7 | SRE-M07 | SHARED/ directory bootstrap not started — no _REGISTRY.yaml, benchmarks/, competitors/ | Create `_REGISTRY.yaml`, benchmarks/, competitors/, triggers/ under SHARED/. Bootstrap during first 5 niches. | 20 | Pipeline Architect |
| C-M8 | SRE-M08 | Cache hit rate tracking not implemented — RUNBOOK's "if <60% investigate" unmeasurable | Add `cache_hit` field to CREDIT_BUDGET.yaml tracking. Track hit/miss per fetch. | 10 | Pipeline Architect |
| C-M9 | SRE-M09 | Pipeline availability SLI has no measurement mechanism — no uptime tracking | Add `pipeline_start_timestamp` and `pipeline_last_failure_timestamp` to TOOL_ERROR_LOG.yaml | 10 | Pipeline Architect |
| C-M10 | SRE-MB1 | Eurostat rate limit "30 req/min" is a GUESS — not publicly documented | Verify empirically during Phase 0 calibration. Update docs with measured value. | 10 | Calibration |
| C-M11 | SRE-MB2 | World Bank rate limit "unlimited" is UNVERIFIED | Verify empirically during Phase 0 calibration. | 10 | Calibration |
| C-M12 | SRE-MB3 | Firecrawl /crawl: one large crawl consumes ALL 50 browser sessions, queuing other agents | Document: large crawl jobs (>20 pages) during low-usage windows. Warning if crawl >50% of browser slots. | 10 | Documentation |
| C-M13 | SRE-MB4 | TIMEOUT_CONFIG.yaml uses ONLY total timeouts — no connect/read split | Restructure to 3-level (connect + read + total) per tool. See §7.3 of audit. | 20 | Pipeline Architect |
| C-M14 | SRE-MB5 | Firecrawl /scrape JS-rendered timeout = 60s, should be 90s for --wait-for pages | Change to 90s. Add `static` and `js_rendered` sub-keys in TIMEOUT_CONFIG.yaml. | 5 | Pipeline Architect |
| C-M15 | SRE-MB6 | No free API timeout entries in TIMEOUT_CONFIG.yaml — GDELT, EUROSTAT, OECD, etc. fall through to 60s default | Add `free_apis:` section with connect/read/total per API. See §7.3 of audit. | 15 | Pipeline Architect |

### Low

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| C-L1 | SRE-L01 | Stale lock cleanup interval not specified in concurrency lock protocol | Document: "If a lock is >5 minutes old, any agent may break it." Add to agent prompts. | 5 | Documentation |
| C-L2 | SRE-L02 | Post-incident review template references PIR-YYYYMMDD-NN naming but `_program/_postmortems/` doesn't exist | Create `_program/_postmortems/` directory + INDEX.yaml | 5 | Operations |
| C-L3 | SRE-L03 | Credit burn rate kill switch (4K/hr warning, 8K/hr halt) can't be measured without real tracking | Ensure every credit-consuming operation writes timestamped entry to CREDIT_BUDGET.yaml | 10 | Pipeline Architect |
| C-L4 | SRE-L04 | Phase 0 delta check (every 10 niches) not scheduled — no counter or trigger | Add `PHASE_0_DELTA_COUNTER` to PIPELINE_CHECKPOINTS.yaml. Increment after each niche. Trigger at 10. | 5 | Pipeline Architect |
| C-L5 | SRE-L05 | Firecrawl credit-usage not run programmatically in preflight — reads local YAML only, may be stale | Add `firecrawl credit-usage` parsing to preflight. Verify on-disk vs API-reported budget. | 15 | Pipeline Architect |
| C-L6 | SRE-L06 | No mechanism to verify DataForSEO password/credentials haven't rotated | Add `last_verified` field to CREDENTIALS.yaml. Add expiry tracking for OAuth tokens. | 10 | Operations |
| C-L7 | SRE-L07 | No --force flag documented for BLOCKED-class data staleness override | Document `--force` flag in RUNBOOK.md with exact usage. | 5 | Documentation |
| C-L8 | SRE-L08 | Cross-source consistency check not implemented — two hallucinated sources claiming same thing get `[P]` | Add: if 2 independent sources make identical categorical claims, verify both use same wording. If yes -> `[P]`. If no -> flag for human review. | 20 | Pipeline Architect |

### Verification Gate C: Reliability & Concurrency

| Check | Pass Criteria |
|---|---|
| C-G1 | `_CONCURRENCY_LOCK.yaml` exists with tool_limits and schema_version |
| C-G2 | `_pipelines/acquire_burst_lock.py` present and executable |
| C-G3 | Preflight-check passes all self-checks: `python3 preflight-check.py --self-check` exits 0 |
| C-G4 | Health check functions present: `check_firecrawl_health()`, `check_dataforseo_health()`, `check_disk_space()` |
| C-G5 | TIMEOUT_CONFIG.yaml has connect+read+total 3-level entries per tool |
| C-G6 | DataForSEO standard queue timeout = 310s: `yq '.dataforseo.serp.standard.total'` returns 310 |
| C-G7 | GDELT retry code present (exponential backoff + 3 retries) |
| C-G8 | All 17 data types have tool-diverse fallback + documented SOURCE_UNAVAILABLE path |
| C-G9 | `requirements.txt` exists with pinned versions; `pip install -r requirements.txt --dry-run` succeeds |
| C-G10 | `check_disk_space()` in preflight-check; BLOCKED at <100MB |
| C-G11 | DEAD_HOST_REGISTRY.yaml exists with write trigger protocol |
| C-G12 | MCP_SCHEDULE.yaml created with concurrent capacity per server |

---

## Workstream D: Evidence Integrity (12 findings)

### Critical

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| D-C1 | DQ-P01 | Grade engine never calibrated against human judgment — 16/16 truth-table combos work mathematically but alignment unknown | Run calibration: 3 human raters grade 30 claims from calibration niche. Compare vs deterministic engine. Adjust criteria where disagreement >20%. Target Cohen's Kappa >= 0.61. | 60 | Grade Engine Designer |
| D-C2 | DQ-P02 | No normalization for data availability across niches — non-IT niches systematically under-scored | Implement DATA-COVERAGE-MATRIX.yaml (schema below). Calculate normalization factor for fertility ranking. | 45 | Grade Engine Designer |
| D-C3 | DQ-P03 | Independent verifier cannot detect interpretation fabrication — re-fetching URL + hash comparison checks URL existence, not claim accuracy | Extend verifier: independently extract the specific claim from fetched content. Compare against trace-map's structured data field. Requires claim text + field mapping awareness. | 60 | Grade Engine Designer |
| D-C4 | DQ-P04 | Schema validation scripts (validate-schema.sh, freshness-audit.sh, preflight-check.sh) are DRAFT — not operational placeholders | Implement all three Python scripts before any niche evaluation. Manual fallbacks will fail under 25-niche concurrency. | 120 | Pipeline Architect |
| D-C5 | RED-F03 | Grade engine has NO semantic understanding — fabricated claim with real URL passes all 4 binary checks. Perverse incentive: fabricating plausible URLs yields HIGHER grades than honest "source unavailable." | Replace grade engine with semantic checker: (a) extract claim's core assertion, (b) fetch source content, (c) run Claude model to assess support level. Cost: ~1 credit/claim. Start with 20% spot-check. | 240 | Grade Engine Designer |

### High

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| D-H1 | DQ-P2_1 | >=20 reviews from >=2 sources impossible for 8-10 niches (consulting, fractional exec, manufacturing) | Add `review_corpus_availability` flag to trace-map.yaml. Demote from "minimum" to "target" for affected niches. Adjust evidence grade ceiling. | 15 | Methodology |
| D-H2 | DQ-P2_2 | No dedicated tool for buyer language extraction — gathered as byproduct, not dedicated pipeline | Add Phase 2.9: Firecrawl /search for verbatim quotes from G2, Reddit, LinkedIn. Require schema-defined output with source URL. | 20 | Methodology |
| D-H3 | DQ-P2_3 | Trigger scoring (ACH matrix) has no empirical basis — Frequency, Urgency, Budget-Likelihood, Detectability are pure agent judgment | Require evidence for at least 2 of 4 dimensions per trigger. Detectability must be verified by live API or documentation reference. | 20 | Methodology |
| D-H4 | DQ-P2_4 | Stackshare/tech blog analysis for technical architecture has no assigned tool | Add Stackshare API or BuiltWith/Wappalyzer for tech inference. Or flag as `[H]` with confidence downgrade. | 20 | Operations |
| D-H5 | RED-F15 | Methodology rewards FORM over SUBSTANCE — well-formatted wrong answers with real URLs score higher than honest sparse canvases | Add semantic accuracy dimension: verifier independently extracts specific claim from fetched content. If >20% of verified claims unsupported, flag for human review. | 120 | Grade Engine Designer |

### Medium

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| D-M1 | DQ-P3_1 | Budget verification ($2.3) has no tool support — inherently human process | Accept. Flag in §15 (Validation Plan) as pre-investment validation step. Cannot be automated. | 5 | Methodology |
| D-M2 | DQ-P3_2 | Non-transparent pricing for enterprise/consulting has no public pricing fallback | When public pricing unavailable: use G2 price mentions, job-posting budgets, competitor case studies. Mark as `[E]`. | 15 | Methodology |
| D-M3 | DQ-P3_3 | GDELT rate limit unbounded — no queuing or batch strategy for 10-20 queries per niche | Add rate-limit handling: bundle queries to minimize requests. Add 1s/2s/4s backoff. BigQuery project-level limits apply. | 15 | Pipeline Architect |
| D-M4 | DQ-P3_4 | Reddit Research MCP for non-English subreddits has thin coverage | Supplement with Dutch-language LinkedIn groups, industry forums, CBS StatLine reports. Document English-dominant VOC limitation. | 15 | Methodology |

### Verification Gate D: Evidence Integrity

| Check | Pass Criteria |
|---|---|
| D-G1 | Semantic verifier protocol documented with claim-extraction step in grade engine spec |
| D-G2 | Calibration study results: 30 claims graded by 3 humans + engine; Cohen's Kappa >= 0.61 for all pairs |
| D-G3 | Independent mini-calibration protocol: fresh agent re-scores 3 dimensions every 5 niches; drift threshold defined |
| D-G4 | DATA-COVERAGE-MATRIX.yaml populated for all 25 niches with normalization factors |
| D-G5 | Normalization formula implemented in fertility ranking script |
| D-G6 | Schema validation scripts operational: `validate-schema.sh`, `freshness-audit.sh`, `preflight-check.sh` all pass tests |
| D-G7 | Fabrication-detection audit trail: EVIDENCE_INTEGRITY_ALERT in TOOL_ERROR_LOG.yaml for NOT_SUPPORTED claims |

---

## Workstream E: Data Quality & Coverage (16 findings)

### Critical

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| E-C1 | DQ-B01 | Market sizing AMBIGUITY — no guidance on which source combination to use as first vs second independent source | Add explicit agent guidance: "Use gov API (EUROSTAT/OECD) as primary, Firecrawl /search as secondary. If gov API unavailable, use two independent Firecrawl searches with different queries." | 10 | Methodology |

### High

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| E-H1 | DQ-B07 | Dark matter: Trade shows have zero digital exhaust — no public API for attendance | Add explicit note in each canvas §15 for affected niches. Most affected: EU Public Sector, Niche Manufacturing, Professional Services. | 10 | Methodology |
| E-H2 | DQ-B08 | Dark matter: In-person meetings/word-of-mouth — #1 B2B buying trigger has no digital signal | Acknowledge as inherent limitation. Trigger system is entirely digital. Cannot detect "peer recommendation." | 5 | Methodology |
| E-H3 | DQ-B09 | Dark matter: Private company dynamics — no Crunchbase API, no SEC, no public pricing for consulting/staffing | Add coverage flag per niche. Most affected: Fractional Executive, Consulting, Agencies, Staffing. Normalize via DQ-P02. | 15 | Methodology |

### Medium

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| E-M1 | DQ-B02 | Revenue leak benchmark (26%) is single vendor-commissioned source (Clari 2024) — borderline `[E]` | Document as vendor-commissioned in trace-map.yaml. Cross-validate with industry benchmarks. | 5 | Methodology |
| E-M2 | DQ-B03 | Technical architecture inference no tool assigned (same as DQ-P2_4) | Same fix: Stackshare API or `[H]` downgrade for tech inference claims. | 5 | Operations |
| E-M3 | DQ-B04 | Ecosystem section — no tool can produce aggregator candidates, channel economics, partner activation playbooks | Accept as design work. Flag economic estimates as `[H]`-`[S]`. Document that Firecrawl /search returns names only. | 5 | Methodology |
| E-M4 | DQ-B05 | Signal catalog (6B) — 15-signal requirement has no discovery pipeline. At zero clients, NO signal has HIGH predictiveness confidence | Accept. First 3 clients are calibration partners. Signal confidence upgrades to `[P]` only after live validation. | 5 | Methodology |
| E-M5 | DQ-B06 | Customer journey — no tool supports journey design. All conversion rates, TTV, breakeven are `[H]`-`[S]` | Accept as design section. Conversion rates inherit pricing grades (Section 4/9). Document zero-client limitation. | 5 | Methodology |
| E-M6 | Specific fix: E.1 Schema validation scripts (moved to D-C4 as critical) | — | — | 0 | — |
| E-M7 | Specific fix: E.2 Buyer language pipeline (moved to D-H2) | — | — | 0 | — |
| E-M8 | Specific fix: E.3 ACH trigger validation gate (moved to D-H3) | — | — | 0 | — |
| E-M9 | Specific fix: E.4 Review corpus fix for non-SaaS niches (moved to D-H1) | — | — | 0 | — |
| E-M10 | Specific fix: E.5 Stackshare tool (moved to D-H4) | — | — | 0 | — |
| E-M11 | Specific fix: E.6 Dark matter acknowledgment (covered by E-H1/E-H2/E-H3 above) | — | — | 0 | — |

Note: E-M6 through E-M11 are cross-references to Workstream D findings to prevent double-counting.

### Verification Gate E: Data Quality & Coverage

| Check | Pass Criteria |
|---|---|
| E-G1 | Market sizing ambiguity resolved: explicit agent guidance documented for source combination |
| E-G2 | Dark matter section in methodology: 6 undetectable signal types listed with per-niche impact framework |
| E-G3 | Dark matter flags per niche: canvas §15 contains DATA_DARK_MATTER_HIGH for >=3 UNAVAILABLE/SPARSE niches |
| E-G4 | All vendor-commissioned sources flagged in trace-map.yaml |
| E-G5 | Signal catalog limitation documented: all signals `[H]` until live client validation |

---

## Workstream F: Pipeline Scheduling & Budget (10 findings)

### Critical

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| F-C1 | RED-F01 | 132-credit estimate assumes ideal conditions (zero retries, zero surprises). Realistic: 180-220 cr (80th), 300-400 cr (95th). 4,300 budget supports 14-19 niches, not 25. | Run first REAL niche end-to-end before finalizing ANY budget. Measure on niche with real competitor density, JS pages, retry patterns. Set buffer to 2.0x (not 1.3x). Implement credit runway kill switch: 4K/hr warning, 8K/hr halt. | 120 | Program Director |
| F-C2 | RED-F13 | RIOS score formula is subjective judgment engineered to look objective — equal weighting, 6-inversion, >3.0 threshold — all arbitrary | Add "Limitations" section to methodology: "Scores are ordinal opinions, not cardinal truths. Rankings conditional on 24-month-unverifiable assumptions. ALL verdicts carry residual uncertainty." | 30 | Methodology |
| F-C3 | RED-F14 | Pipeline outputs are unfalsifiable for 23+ months — no feedback loop within program timeframe | Add falsifiability criteria per canvas: "If niche generates < EUR 50K ARR within 12 months, which specific pipeline claim was wrong?" Forces traceability. | 60 | Methodology |
| F-C4 | SRE-H08 | Per-niche wall-clock (13-16 min I/O, 20-25 min total) completely untested — L3 and L6 agree | Run calibration niche. Measure actual timings. Update estimates. Set per-niche hard limit at 45 min. | 30 | Pipeline Architect |

### High

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| F-H1 | RED-F07 | 25-niche list too rigid — no surprise mechanism. Methodology rewards data-rich niches. | Add "surprise niche" slot (300 credits reserve). Add "top 5 in 2 weeks" fast-track: run all 25 at STANDARD depth first, surface top 5, then DEEP on those 5. | 60 | Program Director |
| F-H2 | RED-F06 | Ground truth does NOT exist — `_GROUND-TRUTH/` directory is EMPTY. Pipeline designed around unimplemented prerequisite. | Wesley produces ground truth reference canvas for 5 sections BEFORE any agent calibration. This is Phase 0 Gate 1. | 240 | Wesley |

### Medium

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| F-M1 | RED-F08 | Pipeline produces NO actionable output until all 25 complete — worst case 6 weeks of zero decisions | Implement "top 5 in 2 weeks" two-pass pipeline: Pass 1 = STANDARD depth on all 25 (425 cr, 2 weeks), Pass 2 = DEEP on top 5 (1,000 cr, 1 week). | 60 | Program Director |
| F-M2 | RED-F10 | First niche's 7-day SLA data (job postings, hiring) stale before pipeline completes (2-4 weeks) | Collect job/hiring data as final step before canvas finalization, not during initial gathering. Minimizes staleness for time-sensitive data. | 30 | Methodology |
| F-M3 | RED-F12 | Pipeline requires human operator for 8+ failure scenarios — each is SPOF on Wesley | Document all human intervention points in OPERATOR-RESPONSIBILITIES.md with estimated frequency and resolution time. Consider automation for DataForSEO top-up alerts. | 30 | Operations |
| F-M4 | RED-F02 | Concurrency lock can't distinguish intent from execution — 9.7% collision per batch at 4 agents | Reduce from 4 to 3 concurrent agents (collision drops to ~3%). Implement write-transactions for shared files. | 120 | Pipeline Architect |

### Verification Gate F: Pipeline Scheduling & Budget

| Check | Pass Criteria |
|---|---|
| F-G1 | Budget model updated from real niche measurement: CREDIT_BUDGET.yaml has actual consumption from calibration |
| F-G2 | Two-pass pipeline documented: STANDARD Pass 1 + DEEP Pass 2 with timeline |
| F-G3 | Concurrency limit changed to 3: AGENT-CONTEXT-SPEC.md says "Max 3 concurrent niche agents" |
| F-G4 | Limitations section in methodology: all 6 limitations in frontmatter |
| F-G5 | Surprise niche slot reserved: 300 credits in CREDIT_BUDGET.yaml |
| F-G6 | Ground truth exists: `_GROUND-TRUTH/` has reference canvas for 5 sections |
| F-G7 | Falsifiability criteria documented in canvas template |
| F-G8 | Job/hiring data collection moved to pre-finalization step in pipeline |

---

## Workstream G: Security & Compliance (12 findings)

### Critical

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| G-C1 | SEC-01 | FRED API "Non-Commercial Use Only" — active ToS violation for commercial entity | Remove FRED_API_KEY from settings.json immediately. Replace with World Bank API + IMF Data API. If FRED data required, contact St. Louis Fed for commercial licensing. Update DATA-OPERATIONS-ARCHITECTURE.md: mark FRED as COMMERCIAL_LICENSE_REQUIRED. | 15 | Wesley |

### High

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| G-H1 | SEC-02 | Reddit Research MCP ToS ambiguity — unclear if uses official Reddit API or scraping (scraping violates ToS) | Verify MCP uses official API. If scraping: DO NOT CONFIGURE — use Firecrawl search with Reddit as fallback. If official API: ensure attribution. Budget $1-2/mo for commercial API. Document in CREDENTIALS.yaml. | 30 | Operations |
| G-H2 | SEC-03 | Credentials split across ~/.bashrc (Firecrawl, DataForSEO) and ~/.claude/settings.json (others) — .bashrc visible to ALL processes | Move FIRECRAWL_API_KEY, DATAFORSEO_LOGIN, DATAFORSEO_PASSWORD to settings.json env block. Remove from .bashrc. Verify with `firecrawl --status`. Update CREDENTIALS.yaml. | 10 | Wesley |
| G-H3 | SEC-04 | No credential rotation or expiry tracking for any of 9 API keys — if any expires mid-pipeline, 4 agents fail simultaneously | Add `expires` and `last_rotated` fields to CREDENTIALS.yaml. For keys without documented expiry: set `expires: unknown`, note "verify annually." Create quarterly audit reminder. Document emergency rotation in RUNBOOK.md. | 20 | Operations |
| G-H4 | SEC-05 | G2/Capterra scraping ToS unverified — G2 Section 4.3 prohibits scraping, but pipeline currently scrapes both | Read G2 and Capterra ToS fully. If scraping prohibited: use DataForSEO SERP API instead. If allowed with restrictions: document limits. Create COMPLIANCE_BLACKLIST.yaml for prohibited domains. | 45 | Wesley |

### Medium

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| G-M1 | SEC-06 | No prompt injection defense for scraped web content (duplicate of AGT-B5) | See AGT-B5 fix: binding rule + §31 loading. Added here for Lens 5 cross-reference completeness. | 15 | Pipeline Architect |
| G-M2 | SEC-07 | Raw content accumulates in .firecrawl/ — clean-raw-fetches script exists but never run. May contain PII. | Run clean-raw-fetches immediately. Set 30-day retention policy. Add pre-niche cleanup step. Spot-check 10 random files for PII. | 20 | Operations |
| G-M3 | SEC-08 | Session transcripts in ~/.claude/projects/ may contain API keys if echoed in bash during calibration | Search transcripts: `grep -r "fc-\|5a6904eff\|DATAFORSEO" ~/.claude/projects/`. Redact or delete affected files. Add binding rule: "Never echo credential values." | 15 | Wesley |
| G-M4 | SEC-09 | No data disposal plan for post-program — competitor pricing, review corpora, persona data have no lifecycle | Document lifecycle: Active (program) -> Archive (30d post) -> Dispose (90d post). Competitor pricing: archive. Raw scraped: dispose at 30d. Canvas outputs: retain indefinitely. | 15 | Operations |
| G-M5 | SEC-10 | YouTube Data API v3 has 10,000 quota units/day — single video search costs 100 units; 4 agents could exhaust on one niche | Add quota tracking to CREDIT_BUDGET.yaml. Budget max 500 units/niche (5 searches). At 3 agents: 1,500 units/day — within 10K limit. Add quota check before API calls. | 10 | Operations |

### Low

| # | ID | Description | Fix | Minutes | Owner |
|---|---|---|---|---|---|
| G-L1 | SEC-11 | Brandfetch free tier (500K req/mo) requires attribution — not documented | Add attribution requirement to SME-tool-reference-expansion.md §2.8. Add "Powered by Brandfetch" to any logo display output. | 5 | Documentation |
| G-L2 | SEC-12 | UK Companies House API commercial use terms not explicitly verified | Verify commercial terms. Document in CREDENTIALS.yaml. Current usage (10-20 queries/niche) well within acceptable use. | 10 | Operations |
| G-L3 | SEC-13 | No security contact or incident response plan documented — if credential leak detected, no procedure | Add security contact (Wesley) and incident response to RUNBOOK.md: (1) revoke, (2) rotate all, (3) check git+transcripts, (4) notify providers. | 10 | Wesley |

### Additional Cross-Lens Security Items (from existing Workstream G)

The existing TOOL-LANDSCAPE-FIX-SPEC.md had 6 security items (G.1-G.6) marked SECURITY_LENS_PENDING. With Lens 5 findings now available, these are resolved as follows:

| Original | Status | Resolution |
|---|---|---|
| G.1 Prompt injection defense | **DUPLICATE** of AGT-B5 / SEC-06 | Covered by binding rule + §31 loading spec (G-M1) |
| G.2 Credential rotation detection | **DUPLICATE** of SEC-04 / SRE-L06 | Covered by CREDENTIALS.yaml fields + preflight check (G-H3) |
| G.3 Shared file write integrity | **REMAINS SEPARATE** — race conditions on shared YAML | Covered by F-M4 (write-transactions, atomic mv, per-agent log files) |
| G.4 Fabricated data detection audit trail | **REMAINS SEPARATE** — EVIDENCE_INTEGRITY_ALERT | Covered by D-H5 / D-G7 (semantic verifier alerts threshold) |
| G.5 Source URL death detection | **REMAINS SEPARATE** — redirect-based content degradation | Add to verifier protocol: record resolved URL, if different from documented -> flag URL_REDIRECT_DETECTED |
| G.6 BINDING rule enforcement | **REMAINS SEPARATE** — no automated compliance checker | Post-hoc audit script checking binding rules against agent output |

### Verification Gate G: Security & Compliance

| Check | Pass Criteria |
|---|---|
| G-G1 | FRED_API_KEY removed from settings.json; World Bank/IMF configured as replacement |
| G-G2 | Reddit Research MCP ToS verified — documented in CREDENTIALS.yaml |
| G-G3 | All credentials in settings.json only; `.bashrc` verified free of API keys |
| G-G4 | CREDENTIALS.yaml has `expires` and `last_rotated` fields for all 9+ keys |
| G-G5 | G2/Capterra ToS compliance documented; COMPLIANCE_BLACKLIST.yaml created if needed |
| G-G6 | `clean-raw-fetches` run; 30-day retention policy documented |
| G-G7 | Session transcripts searched for credential leaks |
| G-G8 | Data disposal lifecycle documented in DATA-OPERATIONS-ARCHITECTURE.md |
| G-G9 | YouTube API quota tracking added to CREDIT_BUDGET.yaml |
| G-G10 | Incident response plan in RUNBOOK.md with security contact (Wesley) |
| G-G11 | Source URL death detection in verifier protocol |
| G-G12 | Post-hoc binding rule compliance audit script created |

---

## Execution Sequence

### Phase 0: Foundation (Week 1) — ~14 hours

```
Week 1, Day 1: Workstream G (Security) — IMMEDIATE ACTION
  ├── G-C1: Remove FRED_API_KEY (15 min) ⚠️ ACTIVE TOS VIOLATION — DO FIRST
  ├── G-H2: Move creds from .bashrc to settings.json (10 min)
  ├── G-H1: Verify Reddit MCP ToS (30 min)
  ├── G-H4: Check G2/Capterra ToS (45 min)
  └── G-H3: Add credential rotation tracking (20 min)

Week 1, Day 1-2: Workstream A (MCP Configuration) — ~2h
  ├── A-C1: PaperPlain MCP (2 min)
  ├── A-C2: Reddit Research MCP (2 min)
  ├── A-C3: Financial Hub MCP (3 min)
  ├── A-H1 through A-H7: CONFIGURE_SOON servers (40 min)
  ├── A-C4 through A-C7: Documentation corrections (30 min)
  ├── A-L1 through A-L4: Low-priority doc decisions (30 min)
  └── VERIFICATION GATE A: MCP Infrastructure

Week 1, Day 2-4: Workstream B (Agent Instruction Layer) — ~7h
  ├── B-C1/B-C2: Create TOOL-EXECUTION-SPEC.md (2h)
  ├── B-C3: Encode escalation pattern (1h)
  ├── B-C4: --wait-for rule (15 min)
  ├── B-C5: Cache preflight automation (30 min)
  ├── B-C6: Prompt injection defense (30 min)
  ├── B-H1: search-feedback rule (15 min)
  ├── B-H2: Dead-host write logic (30 min)
  ├── B-H3: Freshness SLA automation (30 min)
  ├── B-H4: Error recovery protocol (30 min)
  ├── B-H5: Session isolation lock files (30 min)
  ├── B-H6: --query ban (15 min)
  ├── B-M1 through B-M6: Medium items (2h)
  └── VERIFICATION GATE B: Agent Instruction Layer

Week 1, Day 3-5: Workstream C (Reliability & Concurrency) — ~8h
  ├── C-C1: Fix DataForSEO timeout (5 min)
  ├── C-C2: GDELT retry logic (20 min)
  ├── C-C4: Create concurrency lock file (30 min)
  ├── C-C6: Dead-host registry write logic (25 min)
  ├── C-C8: Preflight-check operational readiness (45 min)
  ├── C-C9: Fix Firecrawl /crawl doc (10 min)
  ├── C-H1 through C-H16: All high items (2.5h)
  ├── C-M1 through C-M15: All medium items (2h)
  ├── C-L1 through C-L8: All low items (1h)
  └── VERIFICATION GATE C: Reliability & Concurrency
```

### Phase 0+: Pre-First-Niche (Week 2) — ~12 hours

```
Week 2, Day 1-3: Workstream D (Evidence Integrity) — ~9h
  ├── D-C1: Grade engine calibration study (1h) — requires ground truth first
  ├── D-C2: DATA-COVERAGE-MATRIX.yaml (45 min)
  ├── D-C3: Fabrication detection verifier (1h)
  ├── D-C4: Schema validation scripts (2h)
  ├── D-C5: Semantic checker (4h) — most impactful single fix
  ├── D-H1 through D-H5: High items (3h)
  ├── D-M1 through D-M4: Medium items (50 min)
  └── VERIFICATION GATE D: Evidence Integrity

Week 2, Day 3-5: Workstream E (Data Quality) — ~2h
  ├── E-C1: Market sizing guidance (10 min)
  ├── E-H1 through E-H3: Dark matter acknowledgment (30 min)
  ├── E-M1 through E-M5: Medium items (25 min)
  └── VERIFICATION GATE E: Data Quality & Coverage

Week 2, Day 4-5: Workstream F (Pipeline Scheduling) — ~9h
  ├── F-C1: Realistic budget from real niche (2h) ⚠️ requires ground truth
  ├── F-C2: RIOS limitations section (30 min)
  ├── F-C3: Falsifiability criteria (1h)
  ├── F-H1: Surprise niche + fast-track (1h)
  ├── F-H2: Ground truth production (4h) ⚠️ prerequisite for ALL calibration
  ├── F-M1: Two-pass pipeline design (1h)
  ├── F-M2: Data staleness fix (30 min)
  ├── F-M3: Operator responsibilities doc (30 min)
  ├── F-M4: Concurrency 4->3 reduction (2h)
  └── VERIFICATION GATE F: Pipeline Scheduling & Budget
```

### Calibration Execution (After ALL Infrastructure Fixes Deployed)

```
STEP 1: Run preflight-check — must PASS before any niche
STEP 2: Wesley produces ground truth reference canvas (F-H2) — 5 sections minimum
STEP 3: Run CAL-A (Mid-Market IT Staffing) at STANDARD depth
         - Measure: credit consumption, wall-clock, tool failure rate
         - Output: reference canvas for 5 sections
STEP 4: Calibrate grade engine (D-C1) — 3 human raters vs engine on 30 claims
         - Target: Cohen's Kappa >= 0.61 for all pairs
STEP 5: Run CAL-A at DEEP depth — verify Phase 2 context budget
STEP 6: Run CAL-B (B2B Fractional Executive) at STANDARD depth
         - Test data-sparse niche coverage
         - Validate DATA-COVERAGE normalization factor
STEP 7: Update ALL budget estimates based on real consumption
STEP 8: Pass/fail gate: if ANY CRITICAL bug found during calibration, do NOT proceed to main pipeline
```

### Risk Register for Fix Implementation

| Risk | Probability | Impact | Mitigation |
|---|---|---|---|
| Semantic verifier (D-C5) costs more than estimated ($37.50 for 20% spot-check) | MEDIUM | Budget overrun | Start with 20% spot-check; measure actual cost per check; adjust sampling rate |
| Preflight-check health checks fail on first call (expected: some MCPs temporarily down) | HIGH | False BLOCKED | Retry each check 3 times with 30s backoff before declaring BLOCKED |
| Calibration (D-C1) shows Cohen's Kappa < 0.61, requiring grade criteria adjustment | MEDIUM | Delays pipeline start | Accept as expected outcome of calibration — the study's purpose IS to find disagreements |
| Independent mini-calibration (F-M4 variant) triggers false drift detection (agent variance) | MEDIUM | Wastes credits | Set drift threshold to >20% divergence AFTER accounting for session-to-session variance |
| TOOL-EXECUTION-SPEC.md exceeds 5K tokens, defeating context budget benefit | MEDIUM | Loses savings | Enforce 5K token hard limit; if exceeded, split by phase (Phase 1/Phase 2 versions) |
| Ground truth production (F-H2) takes longer than 4 hours | HIGH | Delays entire program | Prioritize 5 sections minimum; remaining sections can be filled during calibration |
| DataForSEO MCP migration reveals missing endpoint parameters | MEDIUM | Requires fallback | Keep raw curl scripts as fallback throughout Phase 0+ |

---

## De-duplication Notes

The following findings were identified by multiple lenses and appear ONCE in this consolidated spec:

| Consolidated ID | Lenses That Found It | Rationale |
|---|---|---|
| D-C3/D-C5 (grade engine blind) | L4 DQ-03, L6 F-03, L3 FM-2/FM-3 | **3 lenses** — most converged finding across entire audit |
| E-C1/E-H1-E-H3 (data availability bias) | L4 DQ-02, L6 F-07 | 2 lenses |
| F-C1/SRE-H08 (credit estimates unverified) | L3 H-08, L6 F-01 | 2 lenses |
| C-C4/RED-F02 (concurrency infrastructure missing) | L3 C-04, L6 F-02 | 2 lenses |
| B-C6/G-M1 (prompt injection defense) | L2 B-5, L5 SEC-06 | 2 lenses |
| G-H3/C-L6 (no credential rotation tracking) | L3 L-06, L5 SEC-04 | 2 lenses |
| B-H2/C-C6 (dead-host registry write-desert) | L3 C-06, L2 H-2 | 2 lenses |
| F-C4/SRE-H08/F-C1 (wall-clock untested) | L3 H-08, L6 F-01, L3 Appendix A | 2 lenses |

---

*End of Tool Landscape Fix Specification — COMPLETE. 119 unique findings, 25 CRITICAL, 38 HIGH, 34 MEDIUM, 22 LOW. Consolidated from all 6 audit lenses (L1 MCP, L2 Agent, L3 SRE, L4 Data, L5 Security, L6 Red Team). Estimated total fix time: ~42.5 hours.*
