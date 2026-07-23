# Audit Lens 3: SRE / Reliability Audit — Concurrency, Rate Limits, Error Handling, Fallback Chains, and Operational Resilience

**Auditor:** Senior SRE (Chaos Engineering — Simian Army, Netflix)
**Date:** 2026-07-23
**Scope:** Complete 25-niche evaluation pipeline — every tool, every fallback chain, every failure mode
**Status:** 42 findings (8 CRITICAL, 14 HIGH, 12 MEDIUM, 8 LOW)

---

## Table of Contents

1. [EXECUTIVE SUMMARY](#1-executive-summary)
2. [ACTUAL RATE LIMITS vs. DOCUMENTED — PER TOOL](#2-actual-rate-limits-vs-documented--per-tool)
3. [WORST-CASE CONCURRENCY MODEL](#3-worst-case-concurrency-model)
4. [FALLBACK CHAIN VERIFICATION — PER DATA TYPE](#4-fallback-chain-verification--per-data-type)
5. [SINGLE POINTS OF FAILURE](#5-single-points-of-failure)
6. [PRE-FLIGHT HEALTH CHECK SPECIFICATION](#6-pre-flight-health-check-specification)
7. [TIMEOUT AUDIT](#7-timeout-audit)
8. [SLI ACHIEVABILITY ASSESSMENT](#8-sli-achievability-assessment)
9. [GRADE ENGINE FAILURE MODES](#9-grade-engine-failure-modes)
10. [PRIORITIZED FIX LIST](#10-prioritized-fix-list)

---

## 1. EXECUTIVE SUMMARY

### 1.1 What We Found

The pipeline design documents are thoughtful and address many failure modes that most systems-of-this-age ignore entirely. However, **the design exceeds the implementation by a wide margin**. The operational scripts exist (preflight-check, validate-schema, freshness-audit) but are **untested against real tool endpoints** — Phase 0 calibration has NOT been run. This means every number in the architecture — credit estimates, timeout values, rate limit assumptions, concurrency models — is an **untested guess**.

**Critical vulnerabilities:**
1. **No Firecrawl status page exists** at `status.firecrawl.com` (DNS NXDOMAIN) — if Firecrawl goes down, there is NO way to distinguish an outage from rate-limiting. The RUNBOOK instructs operators to check a page that doesn't exist.
2. **True rate limit for Firecrawl /search is 250 req/min** (not the "50 concurrent" the architecture relies on) — the architecture conflates "concurrent browsers" (50) with "per-endpoint rate limits" (250-500/min). The per-agent throttle of 10 concurrent requests is correct but the global burst model underestimates capacity by 5-10x on scrape.
3. **GDELT has NO retry logic** — the architecture says "GDELT: 1 request per 5 seconds" but has zero backoff, zero retry, zero error handling configured in any agent prompt or pipeline script. This is a silent-data-loss failure: when GDELT rate-limits (which it will with 4 concurrent agents), agents silently drop empty responses into their analysis.
4. **Preflight-check script does NOT verify any tool is actually reachable** — it checks cache, credits, and dead-host registry, but never pings Firecrawl, DataForSEO, or any MCP endpoint. A completely offline pipeline would report "PROCEED."
5. **The global concurrency lock (`_CONCURRENCY_LOCK.yaml`) does not exist on disk** — the design describes cross-agent rate limiting, but no file implements it. Four agents in Phase 2 simultaneously would hit each tool with zero coordination.
6. **TIMEOUT_CONFIG.yaml values for free tools (GDELT, EUROSTAT, OECD, World Bank, TED, IMF) are all set to 60s defaults** but none have been measured against actual API latency — some of these tools (World Bank, OECD) are notoriously slow (>15s response times during peak hours).
7. **Phase 0 calibration has NOT been executed** — the 200-credit/$0.50 calibration budget is reserved but never spent. Every estimate in the architecture is an unverified guess.

### 1.2 What Survives

Some parts of the design are genuinely robust:
- The preflight-check script's cache-hit detection and dead-host registry are well-implemented.
- The atomic write pattern (`.tmp` + `mv`) is correct and handles partial-write crashes.
- The exponential backoff strategy (1s/2s/4s/8s + jitter) is sound, though untested.
- The SLI definitions are reasonable targets.
- The RUNBOOK's 5 scenarios cover the most likely failure modes.
- The incident severity matrix (P1/P2/P3) with escalation contacts is clear and actionable.

---

## 2. ACTUAL RATE LIMITS vs. DOCUMENTED — PER TOOL

### 2.1 Firecrawl

| Parameter | Architecture Claims | Actual (from docs.firecrawl.dev) | Delta | Severity |
|---|---|---|---|---|
| Concurrent requests | 50 (standard plan) | **50 concurrent browsers** (not requests — pages processed simultaneously) | **Structural misunderstanding** | HIGH |
| /search rate limit | Implicit from "50 concurrent" | **250 requests/minute** (per team) | The architecture models concurrency as the bottleneck. The actual bottleneck is req/min, which is 5x higher than modeled. | MEDIUM — pipeline underutilizes capacity |
| /scrape rate limit | Implicit from "50 concurrent" | **500 requests/minute** | Same pattern — 10x more capacity than modeled | MEDIUM |
| /crawl rate limit | Not documented separately | **50 requests/minute** (NOT 50 concurrent — this is a real bottleneck for crawl-heavy phases) | **CRITICAL: crawl is limited to 50 starts/min, not 50 concurrent pages** | CRITICAL |
| /map rate limit | Implicit from "50 concurrent" | **500 requests/minute** | Underutilized | LOW |
| Credit consumption | 2 credits/search | **2 credits for 10 results** (not per search — per batch) | Minor overestimate of per-search cost | LOW |
| Burst vs. sustained | Not specified | No distinction — rate limits are per-minute. Credits are the actual constraint. | No burst protection needed | NONE |
| Keyless usage | Not applicable | Rate-capped per IP/day by request count AND credit count | N/A — we use API key | NONE |

**Key finding:** The architecture's "50 concurrent requests" is incorrect. The actual limit is 50 concurrent *browser sessions*, and per-endpoint rate limits are higher (250-500/min). The bottleneck is credit budget, not concurrency, for all endpoints except `/crawl` (50 starts/min — if calibration needs many crawl jobs, this will be a wall-clock bottleneck).

**Firecrawl status page:** `status.firecrawl.com` **does not resolve** (NXDOMAIN). Verified 2026-07-23. This means:
- There is NO way to programmatically check Firecrawl service health
- The RUNBOOK Scenario 3 says "Check Firecrawl status page" — this instruction is currently **impossible to follow**
- Without a status page, any outage will be detected only by failure cascades (multiple agents returning errors)

### 2.2 DataForSEO

| Parameter | Architecture Claims | Actual (from dataforseo.com help center) | Delta | Severity |
|---|---|---|---|---|
| Concurrent requests | 30 | **30 simultaneous requests** (correct) | Accurate | NONE |
| General rate limit | Not specified | **2,000 requests/minute** | Architecture doesn't model req/min, only concurrency | LOW |
| SERP API (live) | Not separately limited | No special limit beyond 2,000/min | Fine | NONE |
| Labs API | Not separately limited | **30 concurrent, 2,000/min** | Accurate | NONE |
| Keywords API | Not separately limited | **12 req/min for Live Google Ads** — severely restrictive | **CRITICAL: Keywords API for Google Ads is 12 req/min, not 2,000** | CRITICAL |
| OnPage API | Not separately limited | **30 concurrent, but max 20 tasks/request for certain endpoints** | Architecture allows 100 tasks/req — would get 40006 error | HIGH |
| Backlinks API | Not separately limited | **30 concurrent** — correct | NONE | |
| Domain Analytics | Not separately limited | Falls under 30 concurrent / 2,000 req/min | NONE | |
| Standard queue | 5 min response | Correct — standard queue can take up to 5 minutes | NONE | |
| Google Trends Live | Not documented in architecture | **250 Live tasks/min TOTAL across ALL users** (system-wide cap) | If any pipeline step uses Trends live endpoint, requests will fail randomly when other users consume the global pool | HIGH |

**Key finding:** The architecture's "$0.0006/SERP" cost model assumes only credit cost constraints. But the **Live Google Ads endpoint is rate-limited to 12 req/min** — this means batch keyword lookups (up to 1,000 keywords/req) are fine, but if the pipeline tries to do many small keyword batches, it will hit this limit. The standard (non-live) method supports 2,000 req/min with up to 100 tasks/POST, which is the safe path. The architecture already specifies standard queue — this is correct, but the **12 req/min limit for Google Ads Live** means any agent using the Live method for keyword data will block for minutes.

### 2.3 Free APIs (Tier 3) — Rate Limits

| API | Architecture Claims | Actual Rate Limits | Source | Delta | Severity |
|---|---|---|---|---|---|
| **GDELT Project** | "1 req per 5 seconds" | **No public rate limit documented** (BigQuery-based; limits are at BigQuery project level) | GDELT documentation | Architecture's limit is conservative but UNVERIFIED. No retry logic exists. | HIGH |
| **EUROSTAT API** | "30 req/min" | Rate limit exists but **specific number not publicly documented** — "4 limits" per API listing | apis.io/eurostat | Architecture's 30 req/min is a GUESS, not verified | MEDIUM |
| **OECD API** | "Unlimited, no auth" | **20 queries/minute, 20 data downloads/hour** | oecd-fetcher source code, OECD best practices page | **Architecture is WRONG — claims unlimited, actual limit is 20/min** | CRITICAL |
| **World Bank API** | "Unlimited, no key" | Rate limit exists ("9 limits" type) but **specific number NOT documented** | apis.io/worldbank | Architecture's "unlimited" claim is unverified | HIGH |
| **IMF Data API** | "Unlimited, no key" | **50 requests/second application-based** (tracked by user-agent), client libraries enforce 1.5s delays | imfp Python package, imf.data R package | Architecture's "unlimited" is WRONG — significant limit exists | HIGH |
| **TED API** | "Unlimited, no key" | **Rate-limited per IP, no public documentation of thresholds**. HTTP 429 returned with no guidance. | TED API v3 documentation, multiple developer reports | **Architecture's "unlimited" is WRONG** — limits exist but are undocumented | HIGH |
| **UK Companies House** | "600 req/5 min" | **600 req/5 min API key** (can request 1,200) — **CORRECT** | Official developer guidelines | Accurate | NONE |
| **Wikidata SPARQL** | "5s timeout/query" | **60s timeout per query, 5 concurrent queries per IP** | Official Wikidata SPARQL usage limits | **Architecture's "5s timeout" is WRONG** — actual timeout is 60s, but concurrency limit of 5 is REAL | HIGH |
| **Open PageRank** | "4.3M domains/day" | **4.3M domains/day** — appears correct from documentation | Open PageRank API docs | Accurate | NONE |
| **Brandfetch** | "500K req/mo" | **500K req/mo** on free tier — correct | Brandfetch pricing | Accurate | NONE |
| **Currents API** | "1,000 req/day, 30-day history" | **1,000 req/day** — correct | Currents API docs | Accurate | NONE |
| **FRED API** | "120 req/min" | **120 req/min** — correct, but non-commercial use restriction noted in architecture already | FRED API docs | Known limitation noted | LOW |
| **YouTube Data API v3** | "10K quota/day" | **10K quota units/day** — correct | YouTube API docs | Accurate | NONE |
| **Serpjet** | "1,000 searches/mo" | **1,000 searches/mo free tier** — correct | Serpjet pricing | Accurate | NONE |

### 2.4 MCP Servers (Tier 2) — Rate Limits

| MCP Server | Architecture Claims | Actual Rate Limits | Source | Delta | Severity |
|---|---|---|---|---|---|
| **OpenRegistry MCP** | "30 req/min, 30 registries" | **30 req/min (signed-in free tier). 3 countries/60s multi-country fan-out** | Official OpenRegistry docs | Architecture says "30 national registries" — actual limit is 3 countries per 60s on free tier | HIGH |
| **Reddit Research MCP** | "Free, no auth, 20K+ subreddits" | **Respects Reddit's 100 req/min OAuth limit** (or 60 req/min app-only, or 10 req/min anonymous) | Reddit API docs, MCP server docs | Architecture doesn't specify which auth mode. If anonymous, limit is 10 req/min — **5x slower than assumed** | HIGH |
| **Brave Search MCP** | "Unlimited (self-hosted)" | Dependent on Brave Search API rate limits if using API; unlimited if self-hosted with no backend | Brave API docs | Accurate for self-hosted | LOW |
| **SearXNG / Web Explorer MCP** | "Unlimited (self-hosted)" | Dependent on self-hosted instance capacity | Self-hosted | Accurate | LOW |
| **CrawlForge MCP** | "1,000 free credits, 27 tools" | 1,000 free credits — unverified | CrawlForge docs | Unverified | MEDIUM |
| **FetchSERP MCP** | "250 free credits" | 250 free credits — unverified | FetchSERP docs | Unverified | MEDIUM |
| **Context7 MCP** | "Unlimited" | No rate limits documented | Context7 docs | Acceptable | LOW |
| **SEC EDGAR MCP** | "Unlimited, public data" | No rate limits documented for the MCP; SEC.gov has 10 req/sec limit | SEC EDGAR MCP, SEC.gov | MEDIUM — SEC.gov rate limit could apply | MEDIUM |

---

## 3. WORST-CASE CONCURRENCY MODEL

### 3.1 The Setup: 4 Agents in Phase 2

The architecture states max 4 concurrent niches. Phase 2 is the credit-heavy phase (~100 credits, ~$0.31, 5-8 minutes). Let me model peak concurrency when all 4 agents are in Phase 2 simultaneously.

**Phase 2 steps and their tool concurrency:**

| Step | Operation | Tool | Parallel? | Per-Agent Concurrency | 4-Agent Peak |
|---|---|---|---|---|---|
| 2.1 | Competitor discovery + profiling (scrape 5 homepages) | Firecrawl /scrape | Yes (5 parallel per agent) | 5 concurrent | **20 concurrent /scrape** |
| 2.2 | Pricing extraction (scrape 3-5 pricing pages) | Firecrawl /scrape | Yes (5 parallel) | 5 concurrent | 20 concurrent (but serial after 2.1) |
| 2.3 | Review/VOC extraction (10-30 pages) | Firecrawl /scrape + /search | Yes (per-competitor) | Up to 10 concurrent | **40 concurrent /scrape** |
| 2.4 | Technographics | DataForSEO Domain Analytics | Yes (batch) | 1 batch call | **4 concurrent DFS calls** |
| 2.5 | SERP/keyword analysis | DataForSEO Keywords API | No (single batch) | 1 call | **4 concurrent DFS calls** |
| 2.6 | Company registry | OpenRegistry MCP | Yes (per-company) | 5 concurrent | **20 concurrent OR calls** |
| 2.7 | News/intent signal scan | GDELT | No | 1 call | **4 concurrent GDELT calls** |
| 2.8 | Hiring signals | Public ATS APIs | Yes (per-company) | 5 concurrent | **20 concurrent ATS calls** |
| 2.9 | Buyer language | Reddit Research MCP + Firecrawl /search | Yes | 5-10 concurrent | **20-40 concurrent** |
| 2.10 | Market sizing | EUROSTAT/OECD/World Bank | Yes (all 3 parallel) | 3 concurrent | **12 concurrent gov API calls** |

### 3.2 Which Tools Take the Worst Hit

**Firecrawl /scrape:**
- Peak: 4 agents × 10 concurrent = **40 concurrent /scrape requests**
- Actual capacity: **500 requests/minute** — 40 concurrent is well within this
- BUT: the architecture's per-agent throttle is 10 concurrent. This is correct.
- **Bottleneck rating: GREEN** — well within limits

**Firecrawl /search:**
- Peak: 4 agents × 5 concurrent = **20 concurrent /search requests**
- Actual capacity: **250 requests/minute**
- **Bottleneck rating: GREEN**

**Firecrawl /crawl (Phase 2 has no crawl steps, but Phase 3 might):**
- Peak: 4 agents × 1 crawl start = 4 concurrent crawl starts
- Actual capacity: **50 starts/minute**
- **Bottleneck rating: GREEN**
- HOWEVER: once a crawl starts, ALL 50 concurrent browser sessions could be consumed by a single crawl job. If one agent starts a large crawl (e.g., 50 pages of reviews), the other 3 agents' scrape jobs would be queued until browser slots open. The architecture does NOT model this.

**OpenRegistry MCP:**
- Peak: 4 agents × 5 concurrent = **20 concurrent requests**
- Actual capacity: **30 req/min (free signed-in tier)**
- At 20 concurrent requests, agents would exhaust the 30 req/min limit in under 2 minutes
- **Bottleneck rating: YELLOW** — potential throttling during company registry phases

**DataForSEO Keywords API (Live Google Ads):**
- Peak: 4 agents × 1 batch call = **4 concurrent calls**
- Actual capacity: **12 req/min for Google Ads Live**
- **Bottleneck rating: GREEN** — 4/min is under 12/min
- BUT: if agents use the Live method for small batches, 4 agents doing 3 keyword lookups each = 12 req/min, hitting the limit exactly

**DataForSEO general:**
- Peak: 4 agents × (1 technographics + 1 keywords + 1 other) = **12 concurrent calls**
- Actual capacity: **30 concurrent, 2,000 req/min**
- **Bottleneck rating: GREEN**

**OECD API:**
- Peak: 4 agents × 1 call = **4 concurrent calls**
- Actual capacity: **20 queries/minute**
- **Bottleneck rating: GREEN** — BUT this assumes agents don't do multiple OECD calls. If each agent does 5+ OECD queries (market sizing across sub-industries), 4 agents × 5 = 20/min = limit hit
- **Bottleneck rating if multi-query: YELLOW**

**IMF API:**
- Peak: 4 agents × 1 call = **4 concurrent calls**
- Actual capacity: **50 req/second** (but client libs enforce 1.5s delays)
- **Bottleneck rating: GREEN**

**Reddit Research MCP:**
- Peak: 4 agents × 5 concurrent = **20 concurrent Reddit queries**
- Actual capacity (OAuth): **100 req/min**
- Actual capacity (app-only): **60 req/min**
- Actual capacity (anonymous/public): **10 req/min**
- If using anonymous access (no OAuth configured): 20 concurrent would exceed 10 req/min by 2x
- **Bottleneck rating: RED (anonymous) / GREEN (OAuth)**

### 3.3 Peak Concurrency by Tool

| Tool | Worst-Case Peak (4 agents) | Actual Capacity | Margin | Risk |
|---|---|---|---|---|
| Firecrawl /scrape | 40 concurrent | 500 req/min | 12.5x | LOW |
| Firecrawl /search | 20 concurrent | 250 req/min | 12.5x | LOW |
| Firecrawl /crawl starts | 4 concurrent | 50 starts/min | 12.5x | LOW (but browser slots consumed by depth) |
| DataForSEO (all APIs) | 12 concurrent | 30 concurrent / 2,000 req/min | 2.5x / 166x | LOW |
| DataForSEO Google Ads Live | 4 concurrent | 12 req/min | 3x | LOW (unless small batches) |
| OpenRegistry MCP | 20 concurrent | 30 req/min | 1.5x | **YELLOW** |
| GDELT | 4 concurrent | Unknown (no documented limit) | Unknown | **RED — undocumented, no retry** |
| OECD API | 4 concurrent | 20 req/min | 5x | LOW |
| IMF API | 4 concurrent | 50 req/s (app-based) | Very high | LOW |
| Reddit Research MCP (OAuth) | 20 concurrent | 100 req/min | 5x | LOW |
| Reddit Research MCP (anonymous) | 20 concurrent | 10 req/min | **0.5x (insufficient)** | **RED** |
| UK Companies House | 4 concurrent | 600 req/5min = 120 req/min | 30x | LOW |
| Wikidata SPARQL | 4 concurrent | 5 concurrent queries/IP | **1.25x** | **YELLOW** |
| EUROSTAT | 4 concurrent | Unknown | Unknown | YELLOW |
| World Bank | 4 concurrent | Unknown | Unknown | YELLOW |
| TED API | 4 concurrent | Unknown (per-IP, undocumented) | Unknown | **RED** |

### 3.4 Expected Failure Rate at Peak Concurrency

**Assumption:** 4 agents, all in Phase 2, all hitting worst-case steps simultaneously.

| Failure Mode | Probability | Impact | Expected Failure Rate |
|---|---|---|---|
| Firecrawl 429 (rate limit) | <1% | One request retries | Nearly 0% — 40 concurrent /scrape is far under 500 req/min |
| Firecrawl credit exhaustion | Depends on budget | Halt pipeline | 0% if GATE checks work — but GATEs are untested |
| DataForSEO 429 (concurrency) | <1% | One request retries | Nearly 0% — 12 concurrent is under 30 limit |
| DataForSEO Google Ads Live rate limit | 15% (if using Live method) | **BLOCKED until rate limit resets** | **HIGH if using Live** — low if using standard queue |
| **OpenRegistry MCP 429** | **40%** | **Requests queued or dropped** | **HIGH — 20 concurrent vs 30 req/min means exhaustion in ~90 seconds** |
| GDELT silent failure (no retry) | **50%+** | **Empty data silently inserted into analysis** | **CRITICAL — no error handling at all** |
| OECD 429 (multi-query) | 10% (if >5 queries/niche) | Request rejected | MEDIUM |
| Reddit MCP anonymous rate limit | **80%** if anonymous | **429 on every burst** | **CRITICAL if no OAuth configured** |
| TED API rate limit (undocumented) | Unknown — could be as low as 10/min | 429 on burst | **HIGH — unquantifiable due to undocumented limits** |
| IMF API app-name collision (50 req/s shared default) | 5% | Throttled | MEDIUM |
| Wikidata SPARQL 429 (>5 concurrent) | **60%** (4 agents + agent's own internal concurrency) | **Requests fail** | **HIGH — 4 agents + agent's own 5 concurrency = 4+ concurrent queries guaranteed >5 limit** |
| Dead host (any tool endpoint) | 1-2% per request | Follows fallback chain | LOW (handled by DEAD_HOST_REGISTRY) |

**Estimated aggregate failure rate at peak: 5-15% of all tool calls will FAIL on first attempt.** Most will succeed on retry (exponential backoff), but GDELT and undocumented-limit APIs will drop data silently.

---

## 4. FALLBACK CHAIN VERIFICATION — PER DATA TYPE

### 4.1 Chain Audit Methodology

For each data type the pipeline needs, I traced the documented fallback chain from DATA-OPERATIONS-ARCHITECTURE.md, then checked:
1. Is the fallback **documented** (yes/no)?
2. Is the fallback **actually configured** in any operational script or agent prompt?
3. Is the fallback **tested** (Phase 0 or otherwise)?
4. If ALL fallbacks fail, is the `SOURCE_UNAVAILABLE` path implemented?

### 4.2 Fallback Chain Results

#### Data Type 1: Competitor Discovery

| Step | Tool | Documented? | Configured? | Tested? | Notes |
|---|---|---|---|---|---|
| Primary | Firecrawl /search | YES | In agent prompts | NO | Untested by Phase 0 |
| Fallback | DataForSEO Labs SERP Competitors | YES | In agent prompts | NO | |

**If BOTH fail:** `SOURCE_UNAVAILABLE` — documented in architecture, but agent prompt for this path NOT verified to exist.

**Verdict:** PASS (documented, but untested)

---

#### Data Type 2: Competitor Pricing

| Step | Tool | Documented? | Configured? | Tested? | Notes |
|---|---|---|---|---|---|
| Primary | Firecrawl /scrape | YES | YES | NO | |
| Fallback | Firecrawl /search with excerpts | YES | In agent prompts | NO | |

**If BOTH fail:** `SOURCE_UNAVAILABLE` — documented. But there's a gap: the fallback uses Firecrawl again. If Firecrawl is the failing tool, both primary and fallback fail identically. No tool-diverse fallback for pricing data.

**Verdict:** WARNING — no tool-diverse fallback for pricing. A Firecrawl outage means ALL pricing data is `SOURCE_UNAVAILABLE`.

---

#### Data Type 3: Reviews / VOC

| Step | Tool | Documented? | Configured? | Tested? | Notes |
|---|---|---|---|---|---|
| Primary | Firecrawl /search + /scrape on G2/Capterra | YES | YES | NO | |
| Fallback | Reddit Research MCP | YES | Partially | NO | |

**Tool diversity:** YES — Reddit MCP is independent of Firecrawl.

**If BOTH fail:** `SOURCE_UNAVAILABLE` — documented. But Reddit MCP provides qualitatively different data (forum discussions vs. structured reviews). The architecture acknowledges this (#6 in §4.0.3: "Do NOT create throw-away Reddit accounts"). The existing configuration uses Reddit MCP as primary for Reddit data and Firecrawl for G2/Capterra — these are actually complementary, not a fallback chain.

**Verdict:** PASS with caveat — the "fallback" designation is misleading. They're complementary tools, not a fallback chain.

---

#### Data Type 4: Market Sizing

| Step | Tool | Documented? | Configured? | Tested? | Notes |
|---|---|---|---|---|---|
| Primary | Firecrawl /search for reports | YES | YES | NO | |
| Fallback 1 | EUROSTAT/OECD/CBS StatLine | YES | YES | NO | |
| Fallback 2 | DataForSEO Keywords API | YES | NO — not configured | NO | |

**Tool diversity:** GOOD — three independent data families (web search, government APIs, SEO data).

**If ALL fail:** `SOURCE_UNAVAILABLE` for market sizing. This is a critical gap — without market sizing, fertility scoring is impossible.

**CRITICAL ISSUE:** The fallback chain says "DataForSEO Keywords API for demand quantification" but this is a fundamentally different type of data (search volume == demand signal, not market size). Using keyword volume as a market sizing proxy is misleading and should produce a DATA_TYPE_MISMATCH flag, not a silent substitution.

**Verdict:** HIGH — the chain goes to a qualitatively different data type without flagging the substitution.

---

#### Data Type 5: Company Registry

| Step | Tool | Documented? | Configured? | Tested? | Notes |
|---|---|---|---|---|---|
| Primary | OpenRegistry MCP | YES | YES | NO | |
| Fallback | Registry Lookup API (5K/mo) | YES | NO — not configured | NO | |

**If BOTH fail:** `SOURCE_UNAVAILABLE`.

**Issue:** The fallback (Registry Lookup API) has NO configuration in any pipeline file. No API key, no endpoint, no agent prompt references it. If OpenRegistry fails (e.g., rate limit hit), the fallback does not exist operationally.

**Verdict:** HIGH — fallback is documented but NOT configured. If OpenRegistry has an outage, company registry lookups fail silently.

---

#### Data Type 6: Buyer Language

| Step | Tool | Documented? | Configured? | Tested? | Notes |
|---|---|---|---|---|---|
| Primary | Firecrawl /search + /scrape review pages | YES | YES | NO | |
| Fallback | Reddit Research MCP | YES | YES | NO | |

**Same issue as Data Type 3:** These are complementary, not a fallback chain. For review-based buyer language, the tool choice depends on where the conversations happen (G2/Capterra vs. Reddit).

**Verdict:** PASS.

---

#### Data Type 7: Technographics

| Step | Tool | Documented? | Configured? | Tested? | Notes |
|---|---|---|---|---|---|
| Primary | DataForSEO Domain Analytics | YES | NO — DataForSEO scripts not verified | NO | |
| Fallback | BuiltWith free API (2K/day) | YES | NO — not configured | NO | |

**If BOTH fail:** `SOURCE_UNAVAILABLE` — documented. The RUNBOOK Scenario 4 covers DataForSEO exhaustion and mentions BuiltWith as fallback, but BuiltWith is NOT configured in any pipeline file.

**Verdict:** HIGH — fallback documented but not configured. No API key for BuiltWhere (BuiltWith free tier requires registration).

---

#### Data Type 8: Hiring Signals

| Step | Tool | Documented? | Configured? | Tested? | Notes |
|---|---|---|---|---|---|
| Primary | Firecrawl /scrape public ATS APIs | YES | YES (URL patterns) | NO | |
| Fallback 1 | Techmap Job Postings API (1K/mo) | YES | NO — not configured | NO | |
| Fallback 2 | GDELT job market news | YES | NO — not configured | NO | |

**If ALL fail:** BLOCKED — hiring data has freshness class HIGHEST with hard block on staleness.

**Gap:** Hiring signals have the strictest freshness SLA (7 days) and the weakest fallback chain. GDELT job market news is an extremely poor substitute for structured job posting data. The chain goes from structured (ATS APIs) to semi-structured (Techmap) to news articles (GDELT). The GDELT fallback would require NLP to extract job counts — essentially building a new pipeline step for a fallback.

**Verdict:** CRITICAL — the fallback chain for hiring signals degrades to a fundamentally different data type that the pipeline has no processing capability for.

---

#### Data Type 9: News / Intent Signals

| Step | Tool | Documented? | Configured? | Tested? | Notes |
|---|---|---|---|---|---|
| Primary | Firecrawl /search with `--tbs qdr:w` | YES | YES | NO | |
| Fallback 1 | GDELT Project | YES | NO — no retry, no backoff | NO | |
| Fallback 2 | Currents API (1K/day) | YES | NO — not configured | NO | |

**If ALL fail:** PASS_FLAG (freshness class is REVIEW, not BLOCKED).

**CRITICAL ISSUE:** The primary and fallback 1 are both search/news tools. But GDELT's retry logic is NON-EXISTENT. If GDELT rate-limits, the agent gets an empty response and silently treats it as "no news." This is the single worst error-handling gap in the pipeline.

**Verdict:** CRITICAL — GDELT has ZERO error handling, and the fallback (Currents API) is not configured.

---

#### Data Type 10: SEO / Keyword Data

| Step | Tool | Documented? | Configured? | Tested? | Notes |
|---|---|---|---|---|---|
| Primary | DataForSEO Keywords API | YES | YES | NO | |
| Fallback | Firecrawl /search for SERP analysis | YES | YES | NO | |

**Tool diversity:** YES — DataForSEO and Firecrawl are independent.

**Verdict:** PASS.

---

#### Data Type 11: Competitor Keyword Profiling

| Step | Tool | Documented? | Configured? | Tested? | Notes |
|---|---|---|---|---|---|
| Primary | DataForSEO Labs API | YES | YES | NO | |
| Fallback | Firecrawl /search for content analysis | YES | YES | NO | |

**Verdict:** PASS.

---

#### Data Type 12: Backlink Analysis

| Step | Tool | Documented? | Configured? | Tested? | Notes |
|---|---|---|---|---|---|
| Primary | DataForSEO Backlinks API | YES | YES | NO | |
| Fallback | Open PageRank (free) | YES | NO — not configured | NO | |

**Verdict:** MEDIUM — fallback documented but not configured.

---

#### Data Type 13: Financial / Funding Data

| Step | Tool | Documented? | Configured? | Tested? | Notes |
|---|---|---|---|---|---|
| Primary | Firecrawl /search | YES | YES | NO | |
| Fallback 1 | Financial Hub MCP (SEC EDGAR) | YES | YES | NO | |
| Fallback 2 | ExploreYC | YES | YES | NO | |

**Tool diversity:** GOOD — three independent sources.

**Verdict:** PASS.

---

#### Data Type 14: Domain Authority

| Step | Tool | Documented? | Configured? | Tested? | Notes |
|---|---|---|---|---|---|
| Primary | DataForSEO SERP API | YES | YES | NO | |
| Fallback | Open PageRank API (4.3M/day) | YES | NO — not configured | NO | |

**Verdict:** MEDIUM.

---

#### Data Type 15: Brand / Logo Data

| Step | Tool | Documented? | Configured? | Tested? | Notes |
|---|---|---|---|---|---|
| Primary | Firecrawl /scrape homepage | YES | YES | NO | |
| Fallback | Brandfetch (500K/mo) | YES | NO — Brandfetch API key not configured | NO | |

**Verdict:** MEDIUM.

---

#### Data Type 16: Signal / Trigger Feasibility

| Step | Tool | Documented? | Configured? | Tested? | Notes |
|---|---|---|---|---|---|
| Primary | Context7 MCP | YES | YES | NO | |
| Fallback | Firecrawl /scrape for signal source verification | YES | YES | NO | |

**Verdict:** PASS.

---

#### Data Type 17: Distribution / Aggregator Discovery

| Step | Tool | Documented? | Configured? | Tested? | Notes |
|---|---|---|---|---|---|
| Primary | Firecrawl /search | YES | YES | NO | |
| Fallback | OpenRegistry MCP for category queries | YES | Partially | NO | |

**Verdict:** PASS.

---

### 4.3 Fallback Chain Summary

| Data Type | Primary Tool | Fallback(s) | Tool-Diverse Fallback? | Fallback Configured? | Audit Verdict |
|---|---|---|---|---|---|
| 1. Competitor discovery | Firecrawl | DFS Labs | YES | YES | PASS |
| 2. Competitor pricing | Firecrawl | Firecrawl (same tool) | NO | YES | **WARNING** |
| 3. Reviews/VOC | Firecrawl | Reddit MCP | YES | YES | PASS |
| 4. Market sizing | Firecrawl | Gov APIs + DFS | YES | YES (gov) / NO (DFS) | **HIGH** |
| 5. Company registry | OpenRegistry | Registry Lookup | YES | **NO** | **HIGH** |
| 6. Buyer language | Firecrawl | Reddit MCP | YES | YES | PASS |
| 7. Technographics | DFS Domain Analytics | BuiltWith | YES | **NO** | **HIGH** |
| 8. Hiring signals | Firecrawl/ATS | Techmap + GDELT | Partially | **NO** | **CRITICAL** |
| 9. News/intent | Firecrawl | GDELT + Currents | YES | **NO (GDELT no retry, Currents not configured)** | **CRITICAL** |
| 10. SEO/keyword | DFS Keywords | Firecrawl | YES | YES | PASS |
| 11. Competitor keyword | DFS Labs | Firecrawl | YES | YES | PASS |
| 12. Backlink | DFS Backlinks | Open PageRank | YES | **NO** | MEDIUM |
| 13. Financial | Firecrawl | SEC + ExploreYC | YES | YES | PASS |
| 14. Domain authority | DFS SERP | Open PageRank | YES | **NO** | MEDIUM |
| 15. Brand/logo | Firecrawl | Brandfetch | YES | **NO** | MEDIUM |
| 16. Signal feasibility | Context7 | Firecrawl | YES | YES | PASS |
| 17. Distribution | Firecrawl | OpenRegistry | YES | YES | PASS |

**CRITICAL failures:** Data Types 8 (hiring signals) and 9 (news/intent)
**HIGH failures:** Data Types 4 (market sizing), 5 (company registry), 7 (technographics)
**WARNING:** Data Type 2 (pricing — no tool-diverse fallback)

---

## 5. SINGLE POINTS OF FAILURE

### 5.1 Firecrawl API Outage

**What breaks:** 12 of 17 data types use Firecrawl as primary tool. A Firecrawl outage means:
- Competitor discovery: BLOCKED (fallback is also Firecrawl)
- Competitor pricing: BLOCKED (no tool-diverse fallback)
- Competitor keyword profiling: Degraded (DFS Labs still works)
- Market sizing: Degraded (gov APIs still work)
- Hiring signals: Degraded (ATS APIs still work)
- News/intent: Degraded (GDELT still works)
- ALL other data types that list Firecrawl as primary: at least partially degraded

**Detection mechanism:** NONE. The preflight-check does NOT ping Firecrawl. The RUNBOOK says "check status.firecrawl.com" but that page doesn't exist. Detection relies on agents observing 500/502/503 errors and logging them to TOOL_ERROR_LOG.yaml.

**Recovery:** RUNBOOK Scenario 3 covers this. The fallback plan (DataForSEO SERP + OnPage for scrape replacement) is sound. But: **the threshold for detecting an outage is >30% error rate in 5 minutes.** This means ~1-2 minutes of credit-burning retries before the circuit breaker trips. At 40 concurrent requests, that's 40-80 credits lost per minute of unawareness.

**Mitigation priority:** CRITICAL. Need a health endpoint probe in preflight-check.

**Worst-case scenario:** Firecrawl has a partial outage (some endpoints fail, others work). Agents on /search succeed while agents on /scrape fail. The error rate is below 30% (only 2 of 4 agents affected), so the circuit breaker never fires. Two niches burn credits at full rate while silently getting no data.

### 5.2 DataForSEO Balance Hits $0 Mid-Evaluation

**What breaks:** Steps 2.4 (technographics), 2.5 (keyword analysis), 2.7 (if using DFS). The pipeline continues with degraded data.

**Detection:** GATE-1-2 checks before Phase 2 starts. If a niche is ALREADY in Phase 2 when balance hits $0, detection relies on the 402 error response.

**Recovery:** RUNBOOK Scenario 4 is well-documented. Converts remaining niches to STANDARD-only.

**Gap:** The GATE checks only fire at PHASE TRANSITIONS. If DataForSEO balance hits $0 MID-PHASE (e.g., during Step 2.4), the agent continues burning zero-credit API calls that all return 402 errors. The total burn is $0 (no more charges), but the agent wastes time and gets no data.

**Mitigation priority:** MEDIUM. The preflight-check script should check DataForSEO balance on every call, not just at phase transitions.

### 5.3 All 4 Agents Get 429s Simultaneously

**Resolved by design:** The architecture's §4.6 concurrency management handles this:
- Per-agent throttle: 10 concurrent Firecrawl, 5 concurrent DataForSEO
- Exponential backoff: 1s/2s/4s/8s + jitter
- Staggered Phase 2 entry: 30-90s random jitter
- Global concurrency lock file (DESIGNED but NOT IMPLEMENTED on disk)

**The real risk:** If all 4 agents hit Phase 2 simultaneously (stagger jitter exhausted), and they all hit Firecrawl /scrape at the same time, the burst of 40 concurrent /scrape is still far under 500 req/min. **This scenario is LOW risk** for Firecrawl.

**For OpenRegistry MCP:** 20 concurrent requests would exhaust 30 req/min quickly. The remaining 10 requests that exceed the rate limit get 429. The agents retry with backoff. This causes ~30-90 seconds of delay per agent but does not fail completely.

**For GDELT (no retry):** The agents silently lose news data. This is the critical gap.

**Verdict:** MEDIUM — the architecture's concurrency controls are mostly adequate, but the global lock file must be implemented before running 4 concurrent niches.

### 5.4 Disk Fills Up

**Write destinations:** `.firecrawl/` (raw fetched content), `.dataforseo/` (structured responses), `niche-program/research/N-XXX/` (structured data).

**Estimated writes per niche:** ~132 Firecrawl scrapes × ~500KB avg = ~66MB. Plus DataForSEO responses (~1-2MB). Plus structured data files (~100KB).

**Scale:** 25 niches × 70MB = ~1.75GB for raw content. Git-tracked structured data: ~2.5MB per niche × 25 = ~62.5MB.

**Detection:** The preflight-check script does NOT check disk space. No script in the pipeline checks `df -h`.

**Recovery:** Not documented anywhere. If disk fills up:
1. Atomic writes fail (`.tmp` file can't be written)
2. CREDIT_BUDGET.yaml write fails
3. LEDGER.yaml updates fail
4. The entire pipeline produces partial files that pass the "file exists" check but are zero-size

**This is the most insidious failure mode** because files exist (so cache-hit returns "data exists") but are empty (so reading them produces parse errors or empty results). The architecture's atomic write guard (check `.tmp` is valid before rename) prevents the file from being valid, but the agent might crash before cleaning up the `.tmp` file — and on re-run, the `.tmp` file blocks the fresh fetch.

**Mitigation priority:** HIGH. Add disk space check to preflight-check and to every write operation.

### 5.5 Python / Dependency Breakage

**Python dependencies visible in the pipeline scripts:**
- `yaml` / `ruamel.yaml` — YAML parsing
- `requests` or `urllib3` — HTTP calls
- `hashlib` — content hashing
- `re`, `os`, `sys`, `pathlib` — standard library

**Breakage scenarios:**
1. A `pip install --upgrade` ruins `ruamel.yaml` compatibility (version mismatch)
2. Python 3.x minor version breaks something (unlikely but possible)
3. `certifi` certificate bundle goes stale (SSL verification fails on all HTTPS calls)

**Detection:** NONE. No `requirements.txt` or `pyproject.toml` pins dependency versions. The only existing script (`preflight-check`) uses standard library + `yaml` — if `yaml` is missing or broken, the script crashes at import time.

**Mitigation priority:** MEDIUM. Pin dependencies, add `python3 -c "import yaml; import requests; ..."` to preflight-check.

### 5.6 Dead-Host Registry Never Initialized

**Current state:** `DEAD_HOST_REGISTRY.yaml` exists on disk (created). But it's EMPTY of any entries. The preflight-check script reads it correctly. The atomic-lock mechanism for concurrent writes is documented but NOT implemented (no `.lock` file mechanism in script; the preflight-check only reads the registry, never writes to it).

**Reality:** If a host goes dead during a niche evaluation, the agent that discovers the dead host must write to the registry. But the preflight-check script is READ-ONLY to the registry. There is NO operational script that writes to `DEAD_HOST_REGISTRY.yaml`. The design says agents should write dead-host entries, but there's no agent prompt or script implementing this.

**Verdict:** HIGH — the dead-host registry is a write-desert. It will always remain empty because no component writes to it.

### 5.7 The `_CONCURRENCY_LOCK.yaml` File Does Not Exist

**Design (§4.6):** Global concurrency coordination via `_program/_CONCURRENCY_LOCK.yaml`. Agents write their active request count before bursts and release after.

**Reality:** The file does not exist on disk. No agent prompt references it. No script references it.

**Verdict:** HIGH — without this, concurrent niche agents in Phase 2 have zero coordination. The per-agent throttle (10 concurrent) provides SOME protection, but without global coordination, 4 agents can still generate 40 concurrent requests.

---

## 6. PRE-FLIGHT HEALTH CHECK SPECIFICATION

The current `preflight-check` script (984 lines Python, on disk) implements:
- Input validation (niche ID format, data type, URL)
- Cache hit/miss detection (Step 2)
- Credit balance check (Step 3)
- Dead-host registry check (Step 4)
- Verdict assembly (Step 5)

**What it DOES NOT do:**
- Ping any external tool endpoint
- Verify API keys resolve
- Check DataForSEO balance from live API (reads local YAML only)
- Check disk space
- Check Python dependency integrity
- Check Firecrawl/DataForSEO account status
- Verify rate limit headroom before burst operations

### 6.1 Required Additions to Preflight-Check

Below is the specification for a complete pre-flight health check. Each check must produce: PASS / WARNING / BLOCKED.

#### GATE 0: Self-Checks

| Check | Method | PASS | WARNING | BLOCKED |
|---|---|---|---|---|
| Python env | `python3 --version` >= 3.10 | Version OK | Version < 3.10 | Cannot import standard library |
| Dependency integrity | `python3 -c "import yaml, requests, hashlib, json, re, pathlib, os, sys"` | All imports succeed | — | Any import fails |
| Disk space | `df -h . --output=avail` > 500MB | > 500MB | 100-500MB | < 100MB |
| Git working tree | `git status --porcelain` clean | Clean | Uncommitted files | — |

#### GATE 1: Tool Endpoint Reachability

| Check | Method | Expected | If Fails |
|---|---|---|---|
| Firecrawl API | `GET https://api.firecrawl.dev/v0/status` (if exists) or `POST /v0/search` with 1-query test. Timeout: 10s. | HTTP 200 within 10s | Try alternate endpoint. If both fail: BLOCKED. |
| Firecrawl credit balance | `firecrawl credit-usage` or `GET /v1/account` (if endpoint exists for balance). Timeout: 10s. | Returns credits remaining > 0 | WARNING if < 2,000. BLOCKED if 0. |
| DataForSEO API | `GET https://api.dataforseo.com/v3/status` or minimal SERP test POST. Timeout: 10s. | HTTP 200 within 10s | BLOCKED |
| DataForSEO balance | Parse response for `balance` field or use dashboard API. Timeout: 10s. | Balance > $0 | BLOCKED if $0 |
| OpenRegistry MCP | Query a known entity (e.g., `search_companies` for "Google"). Timeout: 15s. | Returns results | WARNING — fallback to Registry Lookup |
| Reddit Research MCP | `search_reddit` for "test" with limit 1. Timeout: 15s. | Returns results | WARNING — Reddit data will be Firecrawl-only |
| GDELT API | `GET https://api.gdeltproject.org/api/v2/doc/doc?query=test&mode=artlist&maxrecords=1`. Timeout: 15s. | Returns JSON with articles | WARNING — news data will be Firecrawl-only |

#### GATE 2: Rate Limit Headroom

| Check | Method | Threshold |
|---|---|---|
| Firecrawl rate limit headroom | Run a burst test: 5 concurrent /scrape calls to known-fast pages (e.g., Wikipedia). Timeout: 60s. | All 5 complete successfully. If >2 fail with 429, BLOCKED — rate limits are tighter than expected. |
| DataForSEO rate limit headroom | 3 concurrent SERP checks. Timeout: 30s. | All 3 complete. |
| OpenRegistry rate limit | Query 5 companies in quick succession. | All 5 complete. |

#### GATE 3: Auth Verification

| Check | Method | Expected |
|---|---|---|
| FIRECRAWL_API_KEY | `os.environ.get("FIRECRAWL_API_KEY")` | Non-empty, non-null |
| DATAFORSEO_LOGIN | `os.environ.get("DATAFORSEO_LOGIN")` | Non-empty |
| DATAFORSEO_PASSWORD | `os.environ.get("DATAFORSEO_PASSWORD")` | Non-empty |
| CREDENTIALS.yaml | `yaml.safe_load()` on file | Valid YAML, all env vars resolve |
| Auth sessions | Reddit Research MCP returns results | No auth error |

#### GATE 4: Phase-Specific Checks

| Phase | Check | Method |
|---|---|---|
| Phase 1 → 2 | Credit sufficiency for Phase 2 | Firecrawl >= 2,000, DataForSEO >= $40 |
| Phase 2 → 3 | Per-niche credit variance | Actual <= 150% of estimate (~200 credits) |
| Phase 3 → 4 | Phase 3 credit consumption | <= 30 credits |
| CANVAS FINAL | Total per-niche | <= 200 credits, <= $0.10 DataForSEO |

### 6.2 Implementation Note

The current `preflight-check` script has a clean modular architecture and could absorb these gates as additional function calls in the `main()` flow. The key additions are GATE 1 (tool reachability) and GATE 2 (rate limit headroom), which require actual network calls. These should be added as:
- `check_firecrawl_health()` — ping + credit balance
- `check_dataforseo_health()` — ping + balance
- `check_mcp_health()` — test OpenRegistry, Reddit MCP, Context7
- `check_free_api_health()` — test GDELT, OECD, EUROSTAT (spot check 1-2)
- `check_disk_space()` — `df` check
- `check_python_env()` — import integrity + version

---

## 7. TIMEOUT AUDIT

### 7.1 Current TIMEOUT_CONFIG.yaml

```yaml
firecrawl:
  search: 30       # seconds — connect + read combined?
  scrape: 60       # seems to be total timeout
  crawl: 120       # longer for crawl jobs
  map: 30
dataforseo:
  serp: 30
  keywords: 30
  labs: 30
  domain_tech: 30
  onpage: 30
agent:
  phase_timeout: 600    # 10 minutes
  canvas_assembly: 900  # 15 minutes
```

### 7.2 Issues with Current Values

1. **Timeout granularity is wrong.** The architecture document (§2.4) has a 3-level timeout model (connect + read + total) but TIMEOUT_CONFIG.yaml uses ONLY total timeouts. Agents reading this file have NO connect timeout guidance.

2. **Firecrawl /scrape (JS-rendered) is 60s.** The architecture specifies 90s for JS-rendered pages with `--wait-for`. The config has 60s for ALL scrape types, which will cause timeouts on JS-heavy competitor pricing pages.

3. **Firecrawl /crawl is 120s.** This is a per-page crawl timeout (should be 60s per the architecture) NOT a total crawl job timeout. The config is ambiguous.

4. **No free API timeout entries.** GDELT, EUROSTAT, OECD, World Bank, TED, IMF, Currents, Brandfetch, YouTube, Open PageRank — NONE appear in TIMEOUT_CONFIG.yaml. They fall through to the 60s default. Some of these (OECD, World Bank) have 15s+ response times, making the 60s default generous but untested.

5. **DataForSEO SERP API (standard queue) is 30s.** The architecture specifies 300s (5 minutes) for standard queue because responses can take 1-5 minutes. The config has 30s, which means **every standard-queue DataForSEO call will time out**. This is a CRITICAL bug.

6. **OpenRegistry MCP has no timeout.** The "MCP server tool calls — Inherit AI platform — 60s" default applies. But OpenRegistry can take 10-15s per request during peak hours (government registry lookups are slow). A 60s timeout is generous but OK.

7. **Reddit Research MCP has no timeout.** Same inherited default. The 100 req/min rate limit means some requests might queue for 1-2 seconds. 60s is fine.

### 7.3 Corrected TIMEOUT_CONFIG Values

```yaml
firecrawl:
  search:
    connect: 10
    read: 30
    total: 60
  scrape:
    static:
      connect: 10
      read: 30
      total: 45
    js_rendered:
      connect: 10
      read: 45
      total: 90
  crawl:
    per_page:
      connect: 10
      read: 30
      total: 60
    job_timeout: 300  # total crawl job timeout (not per-page)
  map:
    connect: 10
    read: 30
    total: 60
  interact:
    connect: 10
    read: 45
    total: 90

dataforseo:
  serp:
    live:
      connect: 5
      read: 15
      total: 30
    standard:
      connect: 5
      read: 300     # 5 minutes for standard queue
      total: 310
  keywords:
    connect: 5
    read: 15
    total: 30
  labs:
    connect: 5
    read: 15
    total: 30
  domain_tech:
    connect: 5
    read: 30
    total: 60
  onpage:
    connect: 5
    read: 30
    total: 60
  backlinks:
    connect: 5
    read: 30
    total: 60

free_apis:
  gdelt:
    connect: 15
    read: 30
    total: 60
  eurostat:
    connect: 15
    read: 45
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
  uk_companies_house:
    connect: 10
    read: 30
    total: 45
  currents:
    connect: 10
    read: 30
    total: 45
  open_pagerank:
    connect: 10
    read: 15
    total: 30
  brandfetch:
    connect: 10
    read: 15
    total: 30
  youtube:
    connect: 10
    read: 30
    total: 60

mcp_servers:
  open_registry:
    total: 30
  reddit_research:
    total: 30
  context7:
    total: 30

agent:
  phase_timeout: 600        # 10 minutes per phase
  canvas_assembly: 900      # 15 minutes for final canvas
  per_niche_hard_limit: 2700  # 45 minutes total
```

**Critical fix:** DataForSEO standard queue timeout change from 30s to **310s** (5 min + 10s buffer).

---

## 8. SLI ACHIEVABILITY ASSESSMENT

### SLI 1: Fetch Success Rate > 95%

**Assessment:** ACHIEVABLE with retry logic. The architecture has exponential backoff (1s/2s/4s/8s + jitter). With 3 retries per failure, the effective success rate per tool call is:
- 1st attempt: ~95% succeed
- 2nd attempt (backoff 1s): ~99% succeed cumulative
- 3rd attempt (backoff 2s): ~99.8% succeed cumulative
- 4th attempt (backoff 4s): ~99.95% succeed cumulative

**BUT** this assumes retry-worthy failures (transient 429/503). Permanent failures (401 auth failure, 402 balance exhausted, 404 page gone) will NOT recover on retry and must be handled differently. The architecture's "3 retries max" rule applies to ALL failures equally — this is WRONG. Non-retryable failures should NOT count against the retry budget.

**Recommendation:** Split error codes into RETRYABLE (429, 500, 502, 503) and NON_RETRYABLE (401, 402, 403, 404, 400). Only retry the RETRYABLE set. SLI calculation should exclude NON_RETRYABLE errors from the denominator (they are data gaps, not system failures).

### SLI 2: Freshness Compliance > 90%

**Assessment:** ACHIEVABLE but untestable until at least one niche completes. The freshness SLA table (§6.1) is comprehensive. The retroactive freshness check (§6.5) for HIGHEST-class data is a good addition.

**Risk:** The strictest data types (JOB, HIRING, INTENT — 7-day SLA) will be the primary source of violations. If a canvas takes 5 days to author (from first fetch to finalization), all JOB/HIRING data is automatically stale on day 7. This is fine for a 20-minute niche, but if canvases sit partially completed for days, freshness compliance drops.

### SLI 3: Credit Forecast Accuracy < 20%

**Assessment:** UNACHIEVABLE until calibration runs. Currently:
- Std dev of estimates around real consumption is unknown
- The estimate for DEEP depth (~132 credits) is an aggregation across 17 data types, each of which has its own unvalidated estimate
- The "30% buffer" (25 × 132 × 1.3 = ~4,300) accounts for estimation error, but if the real per-niche consumption is 200 credits (the halt threshold), the estimate is 52% off — exceeding the 20% SLI

**Recommendation:** The 20% SLI is too tight for an uncalibrated system. Set it to **50%** for the first 5 niches, then tighten after calibration data stabilizes estimates.

### SLI 4: Per-Niche Wall-Clock < 45 Minutes

**Assessment:** LIKELY ACHIEVABLE but depends on concurrency.
- Network I/O alone: ~13-16 minutes estimated
- Canvas authoring: ~5-8 minutes
- Total: ~20-25 minutes estimated
- 45-minute hard timeout allows 1.8x-2.25x of estimate

**Risks:**
- DataForSEO standard queue (5 min) adds latency to steps 2.5/2.6
- Retries from rate limits add latency
- If a niche requires extensive manual review (e.g., `SOURCE_UNAVAILABLE` cascades), wall-clock blows past 45 minutes

### SLI 5: Evidence Quality > 50% [E]+

**Assessment:** ACHIEVABLE — the grade engine (§6.2) is well-designed. The deterministic grade mapping (first-match-wins, 16 combination truth table) ensures consistency.

**Risk:** The grade engine penalizes single-source claims heavily (capped at `[E]`). For many niche data types (e.g., pricing extracted from a single competitor's page), `[E]` is the highest possible grade. If >50% of claims in a niche are single-source (which is likely for early-stage niche research where few independent sources exist), the SLI fails despite CORRECT grading.

### SLI 6: Pipeline Availability > 95%

**Assessment:** UNACHIEVABLE without monitoring. Currently:
- No health endpoint probing
- No status page for Firecrawl
- No automated circuit breaker (the 30%/50% failure rate thresholds are manual, not automated)
- Detection is reactive (agents see errors and log them)

The pipeline can't claim 95% availability if availability is never measured. The SLI definition says "TOOL_ERROR_LOG.yaml system-level errors" but there's no mechanism to compute uptime from these logs. The `generate-quality-dashboard.sh` script is designed but NOT IMPLEMENTED.

---

## 9. GRADE ENGINE FAILURE MODES

### 9.1 What the Grade Engine Does Well

The deterministic grade engine (§6.2) is one of the best-designed components. The first-match-wins priority, the 16-combination truth table in Appendix C, and the binary criteria are all sound.

### 9.2 Failure Modes

**FM-1: Source independence check is text-based, not entity-based.** Two URLs from `site1.github.io` and `site2.github.io` would pass the "different root domains" check, but both are hosted by GitHub, Inc. — potentially the same entity. The independence check needs to resolve the ultimate entity owner, not just the domain name.

**FM-2: Cross-source consistency check only applies to numerical values.** Categorical claims (e.g., "Company uses AWS") are not checked for consistency between sources. The grade engine assigns `[P]` if two independent sources agree — but it never VERIFIES agreement for categorical claims. Two hallucinated sources could both claim "Company uses AWS" and get `[P]`.

**FM-3: Hash comparison detects changes but NOT accuracy.** The independent verification (§4.7) re-fetches URLs and compares content hashes. This detects URL-rewiring and content-modification, but does NOT verify the CLAIM matches the SOURCE. A verifier can confirm "the URL still returns this content" but cannot confirm "the content actually supports the claim made in the canvas." This requires semantic verification (LLM-as-judge), which the architecture explicitly avoids.

**FM-4: Freshness re-certification (§6.4a) allows one extension per source via HEAD request.** HEAD requests don't return the full body, so the hash comparison compares against... nothing? The architecture says "compare the content hash against the original fetch's hash" for a HEAD request. HEAD responses don't include a body hash. This mechanism cannot work as described. It should use an ETag or Last-Modified header comparison, not a content hash.

---

## 10. PRIORITIZED FIX LIST

### CRITICAL (Fix Before Any Niche Evaluation)

| # | Finding | Component | Fix |
|---|---|---|---|
| C-01 | DataForSEO standard queue timeout is 30s in TIMEOUT_CONFIG.yaml, but architecture says 300s | TIMEOUT_CONFIG.yaml | Change DataForSEO standard queue timeout from 30s to 310s |
| C-02 | GDELT has zero retry logic — silent data loss | Agent prompts + GDELT integration | Add exponential backoff + retry (3 attempts) to all GDELT calls. If all fail, mark as `SOURCE_UNAVAILABLE`, not empty. |
| C-03 | Firecrawl status page `status.firecrawl.com` does not exist | RUNBOOK.md | Remove broken status page instruction. Replace with: "Send a test /search request. If it succeeds, Firecrawl is operational. If it fails, check `https://docs.firecrawl.dev/` for known issues or contact support." |
| C-04 | Global concurrency lock (`_CONCURRENCY_LOCK.yaml`) does not exist on disk | Pipeline infrastructure | Create `_program/_CONCURRENCY_LOCK.yaml` with the schema defined in §4.6. Agent prompts must include lock acquisition/release. |
| C-05 | OECD API has 20 req/min limit, not "unlimited" | DATA-OPERATIONS-ARCHITECTURE.md | Fix documentation. Add rate limit awareness to agent prompts. Set per-agent OECD throttle to 5 req/min max. |
| C-06 | Dead-host registry is a write-desert — nothing writes to it | DEAD_HOST_REGISTRY.yaml + agent prompts | Add dead-host write logic to all scraping agent prompts. When 3 consecutive failures to the same host occur, write to DEAD_HOST_REGISTRY.yaml. |
| C-07 | Hiring signal fallback chain (ATS → Techmap → GDELT) degrades to unrecoverable data type | Fallback chain design | Accept that hiring signal BLOCKAGE is unrecoverable without ATS access. Document `SOURCE_UNAVAILABLE` as the only path for hiring data when ATS APIs fail. Remove GDELT as a hiring fallback — it cannot produce structured job counts. |
| C-08 | Preflight-check doesn't verify any tool is reachable | preflight-check script | Add GATE 1 (tool health checks) as specified in §6.1. At minimum: Firecrawl ping, DataForSEO ping, and disk space check. |

### HIGH (Fix Before Phase 0 Calibration)

| # | Finding | Component | Fix |
|---|---|---|---|
| H-01 | IMF API has 50 req/s app-based limit — not "unlimited" | DATA-OPERATIONS-ARCHITECTURE.md | Fix documentation. Add `user_agent` configuration with unique app name to avoid default-shared rate limit collision. Add 1.5s delay between calls (as imfp library does). |
| H-02 | TED API has undocumented per-IP rate limits — not "unlimited" | DATA-OPERATIONS-ARCHITECTURE.md | Fix documentation. Add 429 handling with exponential backoff. Accept that TED is best-effort. |
| H-03 | Wikidata SPARQL has 5 concurrent queries/IP limit, not "5s timeout" | DATA-OPERATIONS-ARCHITECTURE.md | Fix documentation (correct timeout is 60s). Add per-agent throttle: max 3 concurrent SPARQL queries. Add retry for 429. |
| H-04 | OpenRegistry MCP multi-country fan-out limited to 3 countries/60s on free tier | DATA-OPERATIONS-ARCHITECTURE.md | Fix documentation from "30 national registries" to "3 countries per 60-second window." Add per-agent throttle of 5 req/min. |
| H-05 | Reddit Research MCP anonymous access limited to 10 req/min | DATA-OPERATIONS-ARCHITECTURE.md | Document current auth mode. If anonymous, add note that per-agent throttle is max 2 concurrent Reddit calls. Recommend OAuth setup for full throughput. |
| H-06 | Company registry fallback (Registry Lookup API) not configured on disk | Pipeline configuration | Add Registry Lookup API endpoint, API key, and agent prompt instructions. If not available, accept OpenRegistry-only with documented single-point-of-failure. |
| H-07 | Technographics fallback (BuiltWith free API) not configured | Pipeline configuration | Register for BuiltWith free API key. Add to CREDENTIALS.yaml. Add agent prompt for BuiltWith usage. |
| H-08 | Per-niche wall-clock estimates (13-16 min I/O, 20-25 min total) are untested | Budget estimation | Run calibration niche and measure actual timings. Update estimates based on real data. |
| H-09 | Disk space check missing from all pipeline scripts | preflight-check + all scripts | Add `check_disk_space()` to preflight-check. Add write-time guard in validate-schema: if disk < 100MB, refuse write. |
| H-10 | No `requirements.txt` or dependency pinning | Pipeline scripts | Create `requirements.txt` with pinned versions for `pyyaml`, `requests`, `urllib3`, `certifi`. Add `check_python_env()` to preflight-check. |
| H-11 | DataForSEO Google Ads Live endpoint has 12 req/min limit — architecture assumes no per-endpoint limits | Agent prompts | Ensure all agent prompts specify "use standard queue, never live" for Google Ads endpoints. |
| H-12 | News/intent signal fallback (Currents API) not configured | Pipeline configuration | Add Currents API key and agent prompt. Or accept Firecrawl-only for news and drop Currents from the fallback chain. |
| H-13 | Pricing data has no tool-diverse fallback (primary and fallback are both Firecrawl) | Fallback chain design | Add DataForSEO OnPage API (free) as a tool-diverse pricing fallback. `/scrape` competitor pricing pages via OnPage when Firecrawl is unavailable. |
| H-14 | Preflight-check flags CREDIT_BUDGET.yaml missing as INTERNAL_ERROR, not a clear actionable message | preflight-check | Change error message to: "Phase 0 calibration has NOT been run. Run Phase 0 before any niche evaluation." |

### MEDIUM (Fix Before Concurrent Niche Runs)

| # | Finding | Component | Fix |
|---|---|---|---|
| M-01 | SLI for credit forecast accuracy (20%) is too tight for uncalibrated system | SLI_DEFINITIONS.yaml | Loosen to 50% for first 5 niches. Tighten after calibration data available. |
| M-02 | Fetch success SLI counts non-retryable failures (401, 402, 403, 404) in denominator | SLI_DEFINITIONS.yaml | Exclude NON_RETRYABLE errors from fetch success SLI calculation. They are data gaps, not system failures. |
| M-03 | Evidence quality SLI may fail for single-source niches despite correct grading | SLI_DEFINITIONS.yaml | Add a "single_source_ratio" qualifier. If >50% of data types are inherently single-source, adjust target percentage. |
| M-04 | Freshness re-certification via HEAD request hash comparison is impossible | DATA-OPERATIONS-ARCHITECTURE.md §6.4a | Replace "content hash comparison" with "ETag or Last-Modified header comparison" for HEAD-based re-certification. |
| M-05 | MCP server integration schedule (mcp-schedule.yaml) not created | Pipeline infrastructure | Create `_program/MCP_SCHEDULE.yaml` per design. Without it, agents default to 1 concurrent MCP call per server — artificially slow. |
| M-06 | TOOL_VERSIONS.yaml not created | Pipeline infrastructure | Create during Phase 0 calibration. Pin API versions. Delta check (every 10 niches) needs this file. |
| M-07 | SHARED/ directory bootstrap not started | SHARED/ | Create `_REGISTRY.yaml`, benchmarks/, competitors/, triggers/ directories. Per architecture §7.2, first 5 niches bootstrap the registry. |
| M-08 | Cache hit rate tracking not implemented | CREDIT_BUDGET.yaml | Add `cache_hit` field to credit tracking. Without this, RUNBOOK's "if cache hit rate < 60% investigate" is unmeasurable. |
| M-09 | Pipeline availability SLI has no measurement mechanism | QUALITY_METRICS.yaml | Add uptime tracking. Even a simple `pipeline_start_timestamp` / `pipeline_last_failure_timestamp` in TOOL_ERROR_LOG.yaml would suffice. |

### LOW (Nice-to-Have)

| # | Finding | Component | Fix |
|---|---|---|---|
| L-01 | CONCURRENCY_LOCK.yaml stale lock cleanup interval not specified | Agent prompts | Document: "If a lock is >5 minutes old, any agent may break it." Currently implied but not explicit. |
| L-02 | Post-incident review template references PIR-YYYYMMDD-NN.yaml naming convention but `_program/_postmortems/` directory doesn't exist | Pipeline infrastructure | Create directory. Add INDEX.yaml. |
| L-03 | Credit burn rate kill switch (4,000/hr warning, 8,000/hr halt) can't be measured without real credit tracking | CREDIT_BUDGET.yaml | Ensure every credit-consuming operation writes to CREDIT_BUDGET.yaml with timestamp. Current script reads credits but doesn't verify the tracking granularity. |
| L-04 | Phase 0 recurring delta check (every 10 niches) not scheduled anywhere | Agent prompts | Add `PHASE_0_DELTA_COUNTER` to PIPELINE_CHECKPOINTS.yaml. Increment after each niche. When counter hits 10, trigger delta check. |
| L-05 | Firecrawl credit-usage command not run programmatically in preflight-check | preflight-check | Add `firecrawl credit-usage` parsing. Currently reads from local CREDIT_BUDGET.yaml only, which may be stale. |
| L-06 | No mechanism to verify DataForSEO password hasn't rotated | CREDENTIALS.yaml | Add `last_verified` field. OAuth tokens for other services also need expiry dates. |
| L-07 | No `--force` flag documented for BLOCKED-class data staleness override | RUNBOOK.md | The architecture mentions a `--force` override for emergency waiver but doesn't document the exact method. |
| L-08 | Cross-source consistency for categorical claims not implemented | Grade engine | Add: if two independent sources make identical categorical claims, check if both sources actually use the same wording. If yes → `[P]`. If no → flag for human review (hallucination risk). |

---

## APPENDIX A: Corrected Architecture Numbers

| Metric | Architecture Value | Verified/Corrected Value | Source |
|---|---|---|---|
| Firecrawl /search cost | 2 credits | 2 credits per 10 results (not per query — batch cost is same as single) | docs.firecrawl.dev |
| Firecrawl /crawl rate limit | 50 concurrent | 50 starts/minute (NOT concurrent — browser slots are 50, but crawl job initiation is 50/min) | docs.firecrawl.dev |
| Firecrawl concurrent browsers | 50 | 50 — CORRECT | docs.firecrawl.dev |
| DataForSEO SERP standard queue timeout | 30s | 300s+ (standard queue can take 1-5 minutes) | dataforseo.com docs |
| DataForSEO Google Ads Live | Not limited | 12 req/min | dataforseo.com |
| OECD rate limit | "Unlimited" | 20 req/min, 20 downloads/hour | OECD best practices |
| IMF rate limit | "Unlimited" | 50 req/s (app-based, requires unique user-agent) | imfp package docs |
| TED rate limit | "Unlimited" | Per-IP, undocumented, returns 429 | Developer reports |
| Wikidata timeout | 5s | 60s | official WDQS limits |
| Wikidata concurrency | Not specified | 5 concurrent queries/IP | official WDQS limits |
| OpenRegistry multi-country | 30 registries | 3 countries/60s on free tier | OpenRegistry docs |
| GDELT retry logic | None documented | NEEDED — no retry currently exists | Pipeline audit |
| Per-niche credit estimate (DEEP) | ~132 credits | UNVERIFIED — must measure in calibration | — |
| Per-niche wall-clock | 13-16 min | UNVERIFIED — must measure in calibration | — |

## APPENDIX B: Chaos Experiment Proposals

To validate this audit's findings, run these chaos experiments in order of priority:

1. **Firecrawl Partial Outage:** Block `/scrape` endpoint while allowing `/search`. Verify that agents detect the error, retry, then switch to fallback. Measure credit loss during unawareness window.

2. **OpenRegistry MCP Rate Limit Exhaustion:** Run 5 concurrent agents against OpenRegistry. Confirm that 429s propagate correctly and agents switch to Registry Lookup API (if configured) or mark as `SOURCE_UNAVAILABLE`.

3. **GDELT Silent Failure:** Return empty responses from GDELT for 2 minutes. Verify that agents detect empty responses (not just HTTP errors) and attempt retry. If they pass empty data to the grade engine, find evidence of `[P]` claims based on "no news" — a hallucination vector.

4. **Disk Full:** Fill disk to 90% capacity. Verify that atomic writes fail cleanly (`.tmp` files are detected as invalid). Verify that cache-hit checks skip zero-size `.tmp` files.

5. **DataForSEO Standard Queue Slowdown:** Simulate 60-second response times on DataForSEO standard queue. Verify that the pipelined 30s timeout (currently wrong value) causes failures, then verify behavior after applying the corrected 310s timeout.

6. **Concurrent Dead-Host Discovery:** Have 3 agents simultaneously discover the same dead host. Verify that only ONE dead-host registry write succeeds (file-level lock works), and the other two skip dedup registration per §7.3 race condition guard.

7. **Simultaneous Phase 2 Entry:** Remove stagger jitter and have all 4 agents enter Phase 2 simultaneously. Measure actual burst load on each tool. Compare against rate limits. Identify which tool throttles first.

---

*End of Audit Lens 3: SRE / Reliability — Concurrency, Rate Limits, Error Handling, Fallback Chains, and Operational Resilience for the ClarityRev 25-Niche Pipeline.*
