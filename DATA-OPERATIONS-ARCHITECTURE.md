# Data Operations Architecture — Binding Specification

**Status:** BINDING — All 25 niche agents MUST follow this architecture.
**Version:** 1.1 (post 6-lens audit — 5 P0 + 6 HIGH fixes applied)
**Last Updated:** 2026-07-23
**Audit:** 6-lens adversarial audit complete (2026-07-23). 40 findings, 5 blocking/critical. See session artifacts.

---

## TABLE OF CONTENTS

1. [Architecture Overview](#1-architecture-overview)
2. [Final Toolchain](#2-final-toolchain)
3. [Directory Structure](#3-directory-structure)
4. [Per-Niche Execution Pipeline](#4-per-niche-execution-pipeline)
5. [Data Schemas](#5-data-schemas)
6. [Freshness & Quality Control](#6-freshness--quality-control)
7. [Cross-Agent Data Sharing](#7-cross-agent-data-sharing)
8. [Credit Budget & Cost Controls](#8-credit-budget--cost-controls)
9. [Cross-Cutting Gap Resolution](#9-cross-cutting-gap-resolution)
10. [Integration with NICHE-METHODOLOGY.md](#10-integration-with-niche-methodologymd)

---

## 1. Architecture Overview

### 1.1 What This Is

This is the binding data operations specification for ClarityRev's 25-niche evaluation program. Every niche agent follows this architecture to gather, store, and share research data. It replaces the generic "web search" instructions in NICHE-METHODOLOGY.md Part 2 (Research Protocol) with exact tools, exact commands, exact schemas, and exact storage paths.

### 1.2 Key Numbers

| Metric | Value |
|---|---|
| Firecrawl credits available | 100,000 |
| Firecrawl per niche (DEEP depth) | ~132 credits (estimated — measure on calibration niche) |
| Firecrawl for all 25 niches | ~3,300 credits (3.3% of budget) + 5,000 for 8-12 DEEP niches = ~4,300-6,300 total |
| Phase 0 calibration budget | 200 credits (one-time) |
| DataForSEO credits available | $50 (~83,000 SERP checks) |
| DataForSEO per niche (DEEP depth) | ~$0.04 |
| DataForSEO for all 25 niches | ~$1.00 (2% of budget) |
| Phase 0 calibration budget | $0.50 (one-time) |
| Wall-clock per niche (network I/O only) | ~13-16 minutes estimated |
| Canvas authoring (LLM gen + trace-map) | ~5-8 minutes additional |
| Total wall-clock per niche | ~20-25 minutes estimated (p95 not measured) |
| Per-niche hard timeout | 45 minutes |
| Concurrent niches | Max 4 (per G-026 concurrency findings) |
| Firecrawl concurrent requests | 50 (standard plan) |
| DataForSEO concurrent requests | 30 |

### 1.3 Design Principles (Binding)

1. **Paid-first: Firecrawl + DataForSEO as primary tools.** We have 100K Firecrawl credits and $50 DataForSEO credits — more than sufficient for 25 niches. Use these as the PRIMARY tools for all data gathering. Free tools are fallbacks only, used when: (a) Firecrawl/DataForSEO cannot access the data source (e.g., Reddit requires authenticated sessions), (b) a free tool is demonstrably superior at a specific task with verified evidence, or (c) the credit cost is disproportionate to the insight value and a free alternative produces equivalent output. Do NOT use free tools just because they're free.
2. **Cache-idempotent.** Before any credit-consuming operation, check if fresh data already exists. No data is fetched twice within its freshness SLA. Every fetch is cacheable and reusable.
3. **Schema-first structured outputs.** Raw fetched content goes to `.firecrawl/`. Structured, validated data goes to `niche-program/research/N-XXX/`. File names encode what the data IS (source, date, type).
4. **Three-depth execution.** STANDARD depth for all 25 niches (fertility scoring). DEEP depth for niches that survive the fertility gate (projected: 8-12). FORENSIC depth only for LAUNCH PENDING niches (projected: 1-3). Depth determines how MUCH data we gather, not which tools we use — Firecrawl + DataForSEO are the primary tools at ALL depths.
5. **Traceability from canvas to source.** Every `[E]` or `[P]` claim in a niche canvas must trace through 4 layers: canvas claim → structured data file → raw fetch file → original URL with fetch date and checksum.
6. **Graceful degradation.** If a tool fails, fall back to the next best option. If both primary and all documented fallbacks for a data type fail in the same niche, mark the entire data type as SOURCE_UNAVAILABLE with audit trail. Do NOT cascade the failure by falling back to a qualitatively different data type and pretending it's equivalent. Log the gap for post-pipeline review. If all options fail, mark the data gap as `SOURCE_UNAVAILABLE` and continue. A partial canvas is better than a blocked pipeline.
7. **Atomic writes.** Write all structured data files to `{target}.tmp`, then `mv {target}.tmp {target}` on success. Agent MUST verify the `.tmp` file is valid (parseable YAML/JSON, all required fields present) before the rename. Read side: skip files that exist but have zero size, are missing the `fresh_until` field, or are `.tmp` (treat as absent). This prevents silent data corruption from partial writes on crash — a partial file passes the preflight cache-hit check on re-run (file exists + date string in its content) and corrupts downstream analysis.
8. **Agent non-determinism.** Claude Code agents are non-deterministic. No quality control mechanism may rely solely on agent self-audit. Every quality gate must include either: (a) an independent observer (separate agent re-fetching and re-computing), or (b) a mathematical invariant the agent cannot plausibly fake (git history of trace-maps, deterministic grade engine, content hash comparisons). The agent does NOT self-grade evidence — the deterministic grade engine (§6.2) assigns all grades.

---

## 2. Final Toolchain

### 2.1 Verified Tool Inventory

Every tool in this inventory has been verified for: exact free tier limits, sufficiency for 25 niches, commercial use allowed, and active maintenance. Tools marked INSUFFICIENT are excluded from the architecture.

#### Tier 1 — Credit-Consuming (Use Strategically)

| Tool | Capacity | Cost per Unit | Best For | Sufficiency for 25 Niches |
|---|---|---|---|---|
| **Firecrawl** /search (new relevance model) | 100K credits, 50 concurrent | 2 credits/search, 1-2/scrape, 1/crawl page | JS-rendered pages, structured extraction, crawling, monitoring, query-relevant excerpts (94.7% SimpleQA accuracy, 10x fewer tokens) | SUFFICIENT — 12% budget used |
| **Firecrawl** /scrape | Same pool | 1-2 credits/page | Single-page extraction, pricing pages, about pages | SUFFICIENT |
| **Firecrawl** /crawl | Same pool | 1 credit/page | Bulk review extraction, docs sites, competitor site mapping | SUFFICIENT |
| **Firecrawl** /map | Same pool | 1 credit | URL discovery before crawling — saves 80% of crawl credits | SUFFICIENT |
| **Firecrawl** /monitor | Same pool | 1 credit/check | Ongoing competitor pricing/review monitoring | SUFFICIENT |
| **DataForSEO** SERP API | $50 credits, 30 concurrent | $0.0006/SERP (standard) | Real-time SERP data for any keyword | SUFFICIENT — 15% budget used |
| **DataForSEO** Labs API | Same pool | ~$0.012/task | Competitor domain analysis, keyword overlap, traffic estimation | SUFFICIENT |
| **DataForSEO** Keywords API | Same pool | $0.0006/request (up to 1,000 keywords) | Search volume, CPC, competition | SUFFICIENT |
| **DataForSEO** Domain Analytics | Same pool | $1.21/1K companies | Technographics at scale — cheaper than BuiltWith/Wappalyzer | SUFFICIENT |
| **DataForSEO** Backlinks API | Same pool | ~$0.012/task | Backlink profiles, competitor link intersection | SUFFICIENT |
| **DataForSEO** Business Data API | Same pool | ~$0.012/task | Business reviews (Google Maps, Trustpilot), business listings | SUFFICIENT |
| **DataForSEO** OnPage API | Same pool | **Free** (content parsing) | Extract contacts, meta, headings from any URL | SUFFICIENT — free |

#### Tier 2 — Free MCP Servers (Use First)

| MCP Server | Capacity | Best For |
|---|---|---|
| **Brave Search MCP** | Unlimited (self-hosted) | General web search without API costs |
| **Reddit Research MCP** | Free, no auth, 20K+ subreddits | B2B VOC, pain point discovery, community sentiment |
| **OpenRegistry MCP** | 30 req/min, 30 national registries | European company registry data — NL KVK, BE KBO, UK CH, DE Handelsregister, CH ZEFIX, +25 more |
| **Financial Hub MCP** | Unlimited, no key | SEC EDGAR — 10-K, 10-Q, 8-K, corporate events |
| **paperplain-mcp** | Unlimited, no key | 200M+ peer-reviewed papers — market research, academic validation |
| **Jina AI MCP** | 10M tokens free | Web + academic search, reader mode |
| **SearXNG / Web Explorer MCP** | Unlimited (self-hosted) | Private web search, no rate limits |
| **CrawlForge MCP** | 1,000 free credits, 27 tools | Multi-purpose web research, SERP rank tracking |
| **FetchSERP MCP** | 250 free credits | Domain analysis, WHOIS, DNS, tech stack |
| **Context7 MCP** | Unlimited | Official docs lookup — verify API capabilities before committing to workflow designs |
| **SEC EDGAR MCP** | Unlimited, public data | US public company financials |
| **Serper MCP** | 2,500 free queries (one-time) | Initial deep research SERP data |
| **TAM-MCP-Server** | Unlimited, open source | Market sizing from 8 government sources |
| **Google CSE MCP** | 100 searches/day | Google-specific search results |

#### Tier 3 — Free APIs (Use First, Verify Limits)

| API | Free Tier | Best For | Sufficiency for 25 Niches |
|---|---|---|---|
| **HubSpot API** | 250,000 req/day | CRM-native signal delivery platform | SUFFICIENT |
| **Registry Lookup** | 5,000 calls/mo, 521M entities | Global company registry data | SUFFICIENT |
| **GDELT Project** | Free (BigQuery limits at scale), 100K+ outlets, 65 languages | News monitoring, intent signals | SUFFICIENT |
| **EUROSTAT API** | 30 req/min, no auth | EU industry statistics by NACE code | SUFFICIENT |
| **OECD API** | Unlimited, no auth | 38-country macro/industry data | SUFFICIENT |
| **TED API** | Unlimited, no key | EU government contract awards — growth signal | SUFFICIENT |
| **Open PageRank API** | 4.3M domains/day | Domain authority scoring | SUFFICIENT |
| **Brandfetch** | 500K req/mo | Company logos + brand data | SUFFICIENT |
| **FRED API** | 120 req/min (non-commercial use only — verify applicability) | US macro-economic data | SUFFICIENT |
| **World Bank API** | Unlimited, no key | Global economic indicators | SUFFICIENT |
| **IMF Data API** | Unlimited, no key | Global financial/economic data | SUFFICIENT |
| **OpenAlex** | 100K req/day | 250M+ scholarly works | SUFFICIENT |
| **YouTube Data API v3** | 10K quota/day | Video content, competitor channels | SUFFICIENT |
| **Public ATS Job Board APIs** | Unlimited, no auth (Greenhouse, Lever, etc.) | Hiring signals — which companies are hiring, which roles | SUFFICIENT |
| **Currents API** | 1,000 req/day, 30-day history | News monitoring | SUFFICIENT |
| **Wikidata SPARQL** | 5s timeout/query, public endpoint | Structured company data (industry codes, revenue, funding) | SUFFICIENT |
| **ZEFIX API** | Unlimited, no auth (Switzerland) | Swiss company registry — full data, free REST API | SUFFICIENT |
| **UK Companies House API** | 600 req/5 min | UK company registry | SUFFICIENT |
| **CBS StatLine OData API** | Unlimited, no key | Netherlands market sizing by SBI code | SUFFICIENT |
| **ExploreYC** | Free | 6,600+ YC/a16z company data | SUFFICIENT |
| **OpenSERP** | Unlimited (self-hosted) | SERP data — free fallback for DataForSEO | SUFFICIENT |
| **Serpjet** | 1,000 searches/mo | Free recurring SERP (fallback) | SUFFICIENT |
| **Techmap Job Postings API** | 1,000 postings/mo | Hiring signals with ATS detection | SUFFICIENT |

### 2.2 Tool Selection Decision Tree

```
START: Need data type X?

1. Can Firecrawl provide the data?
   → Use Firecrawl /search (relevance excerpts) for discovery queries. Cost: 2 credits.
   → Use Firecrawl /scrape for single-page extraction (JS-rendered pages, pricing pages). Cost: 1-2 credits.
   → Use Firecrawl /crawl for bulk extraction (reviews, docs). Cost: 1 credit/page.
   → Use Firecrawl /map before /crawl to discover URLs (1 credit, saves 80% of crawl credits).
   → Use Firecrawl /interact for authenticated sessions, pagination, form-filling, login-walled content. Cost: 1 credit/action.
   → If Firecrawl CAN do it: DONE. Do NOT check free alternatives unless cost is disproportionate.
   → NO: Go to 2.

2. Can DataForSEO provide the data?
   → Use DataForSEO SERP API for real-time search results ($0.0006/SERP).
   → Use DataForSEO Labs API for competitor keyword profiling, domain intersection ($0.012/task).
   → Use DataForSEO Keywords API for search volume, CPC ($0.0006/request, up to 1,000 keywords).
   → Use DataForSEO Domain Analytics for technographics at scale ($1.21/1K companies).
   → Use DataForSEO Backlinks API for backlink profiles ($0.012/task).
   → Use DataForSEO OnPage API for content parsing (FREE).
   → If DataForSEO CAN do it: DONE. Do NOT check free alternatives.
   → NO: Go to 3.

3. Is there a free tool that is demonstrably BETTER at this specific task?
   → BETTER means: more current data, higher accuracy, deeper coverage, OR Firecrawl/DataForSEO cannot access this source at all (e.g., Reddit requires authenticated sessions).
   → NOT "it's free so we should use it." Cost savings on a tool we already have unlimited budget for is not a valid reason.
   → Examples where free IS better: Reddit Research MCP (native Reddit access vs. Firecrawl scraping Reddit without auth), Context7 MCP (official docs query vs. scraping docs pages), SEC EDGAR MCP (structured XBRL data vs. scraping HTML filings).
   → YES: Use the free tool. Document WHY it was chosen over Firecrawl/DataForSEO.
   → NO: Go back to 1 or 2 — Firecrawl/DataForSEO IS the answer, even if it costs credits.

4. Mark as SOURCE_UNAVAILABLE. Write a sentinel value to the structured data file: `source: SOURCE_UNAVAILABLE, fetch_date: [now], method: ATTEMPTED, error: [specific error]`. Downstream steps check for `SOURCE_UNAVAILABLE` before consuming the field. The pipeline continues — a partial canvas is better than a blocked pipeline. Log the SOURCE_UNAVAILABLE event with tool name, timestamp, and impact scope (single-step or whole-phase). If the same tool produces SOURCE_UNAVAILABLE across >20% of all steps in a niche, flag the niche for human review — the data gap may invalidate the canvas. No fetch retry for this data type in this session (retry on next fresh cycle per freshness SLA).
```

### 2.3 Tool-to-Task Master Matrix

| # | Data Type | Primary Tool | Fallback Tool | Cost per Niche | Freshness SLA |
|---|---|---|---|---|---|
| 1 | Competitor discovery | Firecrawl /search (relevance excerpts) | DataForSEO Labs SERP Competitors | 2-17 credits | 90 days |
| 2 | Competitor pricing | Firecrawl /scrape (JS-rendered pages) | Firecrawl /search with excerpts | 6-20 credits | 90 days |
| 3 | Reviews / VOC | Firecrawl /search + targeted /scrape on G2/Capterra | Reddit Research MCP | 0-20 credits | 180 days |
| 4 | Market sizing | Firecrawl /search for "[niche] market size 2026" + EUROSTAT/OECD/CBS StatLine APIs (free, verified superior for gov statistics) | DataForSEO Keywords API for demand quantification | 2-5 credits | 180 days |
| 5 | Company registry data | Firecrawl /scrape official registry pages OR OpenRegistry MCP (30 registries, free — better for structured multi-country queries) | Registry Lookup API (5K/mo) | 0-2 credits | 90 days |
| 6 | Buyer language | Firecrawl /search for "[niche] reviews G2" + /scrape review pages. Reddit: Firecrawl /interact with authenticated profile | Reddit Research MCP (free fallback if profile unavailable) | 5-15 credits | 180 days |
| 7 | Technographics | DataForSEO Domain Analytics ($1.21/1K companies — primary) | BuiltWith free API (2K/day — fallback) | $0-$0.01 | 180 days |
| 8 | Hiring signals | Firecrawl /scrape public ATS job boards (Greenhouse, Lever — free, no auth) + Techmap Job Postings API | GDELT job market news | 3-5 credits | 7 days |
| 9 | News / intent signals | Firecrawl /search with `--tbs qdr:w` (last week) + GDELT Project (free fallback, comprehensive but less targeted) | Currents API (1K/day) | 2-5 credits | 14 days |
| 10 | SEO / keyword data | DataForSEO Keywords API (batch 1K keywords/req — PRIMARY) | Firecrawl /search for SERP analysis | $0.0006-$0.30 | 90 days |
| 11 | Competitor keyword profiling | DataForSEO Labs API (PRIMARY) | Firecrawl /search for competitor content analysis | $0.012-$0.50 | 90 days |
| 12 | Backlink analysis | DataForSEO Backlinks API (PRIMARY) | Open PageRank (free — less comprehensive, use only if DataForSEO unavailable) | $0-$0.012 | 90 days |
| 13 | Financial / funding data | Firecrawl /search for "[company] funding 2025 2026" + Financial Hub MCP (SEC EDGAR — free, better for structured public company data) | ExploreYC (YC/a16z startups) | 2-5 credits | 90 days |
| 14 | Domain authority | DataForSEO SERP API (rankings, visibility) | Open PageRank API (4.3M/day — free, less granular) | $0-$0.002 | 90 days |
| 15 | Brand / logo data | Firecrawl /scrape competitor homepage (extract logo, brand colors) | Brandfetch (500K/mo — free, good for structured logo data) | 1-2 credits | 180 days |
| 16 | Trigger / signal feasibility | Context7 MCP (official API docs — free, BETTER for verifying API capabilities) + Firecrawl /scrape for signal source verification | GDELT for event-based signal detection | 2-5 credits | 30 days |
| 17 | Distribution / aggregator discovery | Firecrawl /search for "[niche] agencies partners consultants" + /scrape top directory pages | OpenRegistry MCP for company category queries | 3-8 credits | 90 days |

---

### 2.4 Global Timeout Policy (BINDING)

**Zero timeout specification = pipeline hangs indefinitely on the first unresponsive host.** Every tool call MUST have explicit timeouts.

| Timeout Type | Default Value | Applies To |
|---|---|---|
| Connect timeout | 10 seconds | All HTTP/HTTPS connections |
| Read timeout | 30 seconds | All HTTP responses |
| Total request timeout | 60 seconds | All API calls — hard kill after this duration |

**Per-tool overrides (override defaults where specified):**

| Tool / Operation | Connect | Read | Total | Notes |
|---|---|---|---|---|
| Firecrawl /search | 10s | 30s | 60s | Standard defaults |
| Firecrawl /scrape (static) | 10s | 30s | 45s | Static pages resolve quickly |
| Firecrawl /scrape (JS-rendered, --wait-for) | 10s | 45s | 90s | JS rendering adds latency |
| Firecrawl /crawl (per page) | 10s | 30s | 60s | Per-page within a crawl job |
| Firecrawl /map | 10s | 30s | 60s | URL discovery is lightweight |
| Firecrawl /interact (per action) | 10s | 45s | 90s | Browser automation is slow |
| DataForSEO SERP API (live) | 5s | 15s | 30s | Live queue is fast |
| DataForSEO SERP API (standard) | 5s | 15s | 300s | Standard queue: up to 5 min |
| DataForSEO Labs API | 5s | 15s | 30s | Analytics queries |
| DataForSEO Keywords API | 5s | 15s | 30s | Batch lookups |
| MCP server tool calls | Inherit AI platform | Inherit AI platform | 60s | Platform-dependent |
| Free API calls (all Tier 3) | 10s | 30s | 60s | Standard HTTP defaults |
| Context7 MCP | Inherit | Inherit | 30s | Docs lookups should be fast |

**On timeout:** Mark the step as ATTEMPTED with `error: TIMEOUT` and the tool name + timeout value. Follow the tool's fallback chain from §2.2. If all fallbacks also timeout, mark the data field as `SOURCE_UNAVAILABLE` with `error: TIMEOUT_ALL_FALLBACKS`.

**Timeout configuration:** All timeouts are overrideable via `_program/TIMEOUT_CONFIG.yaml`. Agents read this file at pipeline start. If the file is missing, use the defaults above.

---

### 2.5 Credential Management (BINDING)

All credentials follow env-var convention. NO credentials are hardcoded in pipeline scripts or stored in the repository.

**Schema for `_program/CREDENTIALS.yaml` (gitignored, NEVER committed):**

```yaml
# CREDENTIALS.yaml — Credential inventory
# THIS FILE IS GITIGNORED. NEVER COMMIT.
# All values reference environment variables — no secrets in this file.

firecrawl:
  api_key_env_var: "FIRECRAWL_API_KEY"
  default_interact_profile: "reddit-research"

dataforseo:
  login_env_var: "DATAFORSEO_LOGIN"
  password_env_var: "DATAFORSEO_PASSWORD"
  queue_type: "standard"

auth_sessions:
  reddit:
    profile_name: "reddit-research"
    username_env_var: "REDDIT_USERNAME"
    password_env_var: "REDDIT_PASSWORD"
    session_refresh_interval_hours: 24
    primary_method: "reddit_research_mcp"

free_tools_with_keys:
  SERPER_API_KEY: "serper"
  JINA_API_KEY: "jina"
  BRANDFETCH_API_KEY: "brandfetch"
  HUBSPOT_API_KEY: "hubspot"
  YOUTUBE_API_KEY: "youtube"
```

**Pre-flight credential check (added to §4.0.5 gate):**
- FIRECRAWL_API_KEY environment variable resolves
- DATAFORSEO_LOGIN and DATAFORSEO_PASSWORD environment variables resolve
- CREDENTIALS.yaml exists and is valid YAML
- All *_env_var values in CREDENTIALS.yaml resolve to non-empty environment variables
- Reddit Research MCP returns valid results (no auth required)

**Credential rotation:** All API keys rotated every 90 days. Auth sessions verified at Phase 0 and every 10 niches thereafter. Session expiry logged to CREDENTIALS.yaml `auth_sessions.{name}.last_verified` field.

**Encryption-at-rest:** If CREDENTIALS.yaml is stored on cloud storage or shared filesystem, encrypt before upload. The plaintext file exists only on Wesley's local machine.

### 3.1 Root Structure

```
niche-program/research/
├── _program/                          # Cross-cutting program management
│   ├── LEDGER.yaml                    # 25-niche tracking ledger (status, scores, verdicts)
│   ├── CREDIT_BUDGET.yaml             # Running credit consumption tracker
│   ├── DEAD_HOST_REGISTRY.yaml        # Shared dead-host list (G-012)
│   └── PIPELINE_CHECKPOINTS.yaml      # Per-niche checkpoint state
│
├── SHARED/                            # Cross-niche reusable data
│   ├── _REGISTRY.yaml                 # Index of all shared data files
│   ├── benchmarks/                    # B2B benchmarks (leakage rates, churn, conversion)
│   ├── competitors/                   # Cross-niche competitor profiles
│   ├── regulatory/                    # GDPR, AI Act, industry regulations
│   ├── tools/                         # Tool/capability inventory
│   ├── taxonomy/                      # Niche categories, signal types, buyer roles
│   └── triggers/                      # Cross-niche trigger registry
│
├── CALIBRATION/                       # Calibration niche (evaluated first by 2 agents)
│   ├── N-CAL-AGENT-A/                 # Agent A's evaluation
│   │   ├── 01-company-discovery/
│   │   ├── 02-competitor-intel/
│   │   ├── 03-market-sizing/
│   │   ├── 04-voice-of-customer/
│   │   ├── 05-signal-feasibility/
│   │   ├── 06-technographic/
│   │   ├── 07-buyer-insight/
│   │   ├── 08-pricing/
│   │   ├── _canvas/                   # Completed 15-section canvas
│   │   └── _work/                     # Temporary working files (auto-cleaned)
│   ├── N-CAL-AGENT-B/                 # Agent B's independent evaluation
│   │   └── ... (mirror structure)
│   └── _RECONCILIATION/               # Inter-rater comparison results
│
├── N-001/                             # Niche 001 (highest priority)
│   ├── 01-company-discovery/
│   ├── 02-competitor-intel/
│   ├── 03-market-sizing/
│   ├── 04-voice-of-customer/
│   ├── 05-signal-feasibility/
│   ├── 06-technographic/
│   ├── 07-buyer-insight/
│   ├── 08-pricing/
│   ├── _canvas/                       # Completed 15-section canvas
│   │   ├── NICHE-CANVAS-N-001.md      # Full markdown canvas
│   │   ├── frontmatter-N-001.yaml     # Machine-readable YAML frontmatter
│   │   └── evidence/                  # Traceability maps
│   │       └── trace-map.yaml         # claim_id → source_file → original_URL → checksum
│   └── _work/                         # Temporary files (retention: 7 days)
│
├── N-002/ ... N-025/                  # Niches 002-025 (same structure)
│
├── _pipelines/                        # Pipeline automation
│   ├── cache-warm.sh                  # Cache warming script
│   ├── preflight-check.sh             # Pre-flight credit/rate-limit checker
│   ├── freshness-audit.sh             # Staleness audit script
│   └── dedup-manifest.yaml            # Cross-niche deduplication tracking
│
└── _archive/                          # Completed/archived niche data (post-evaluation)
```

### 3.2 File Naming Convention

```
{niche_id}-{data_type}-{descriptor}-v{version}.{extension}

Examples:
  N-001-competitor-profile-syncgtm-v1.yaml
  N-001-review-corpus-usergems-v2.json
  N-001-market-sizing-TAM-v1.yaml
  N-001-buyer-language-cro-v1.json
  SHARED-competitor-profile-gong-v3.yaml
  SHARED-benchmark-churn-b2b-saas-v1.yaml
  CAL-A-competitor-profile-clari-v1.yaml
```

**Controlled vocabulary for `{data_type}`:** `company-discovery`, `competitor-profile`, `competitor-pricing`, `market-sizing`, `review-corpus`, `buyer-language`, `signal-feasibility`, `technographic-profile`, `buyer-insight`, `keyword-volume`, `backlink-profile`, `serp-analysis`, `news-monitoring`, `hiring-signals`, `funding-data`, `regulatory-data`, `benchmark`, `trigger-catalog`, `canvas`, `evidence-trace`, `reconciliation`.

### 3.3 Raw Fetch Storage

All raw fetched content goes to `.firecrawl/` (Firecrawl output) or `.dataforseo/` (DataForSEO output). These directories are gitignored. Structured data is extracted from raw content into the `niche-program/research/` directories. Raw content is retained for audit trail but never directly consumed by canvas authoring.

---

## 4. Per-Niche Execution Pipeline

### 4.0 Phase 0: Tool Calibration & Test Data Gathering (Run Once Before Any Niche)

**Purpose:** Before evaluating a single niche, verify every tool in the architecture works as documented. This phase catches: broken API keys, rate-limit surprises, tool deprecations, authentication issues, and data quality problems BEFORE they impact niche research. It also establishes authenticated sessions for platforms that require login (Reddit, G2, LinkedIn).

**Gate:** Phase 0 MUST complete successfully before any niche evaluation begins. If a tool fails calibration and has no fallback, the architecture is amended before the pipeline starts. `[DESIGN]`.

#### 4.0.1 Firecrawl Calibration Tests

| Test | Command | Expected Result | If Fails |
|---|---|---|---|
| Basic search | `firecrawl search "revenue intelligence software 2026" --limit 5` | Returns 5 results with relevance excerpts | Check API key, account status |
| JS-rendered scrape | `firecrawl scrape "https://www.g2.com/products/gong-io/reviews" --wait-for 3000` | Returns page content with review data | Increase `--wait-for`, check if G2 blocks |
| Pricing page scrape | `firecrawl scrape "https://www.gong.io/pricing/" --wait-for 3000` | Returns pricing tier information | Page may be login-walled — try /interact |
| Crawl with path filter | `firecrawl crawl "https://docs.dataforseo.com" --include-paths "/v3/" --max-depth 2 --limit 10` | Returns 10 docs pages | Adjust depth/limit |
| Map discovery | `firecrawl map "https://www.gong.io" --search "pricing"` | Returns pricing-related URLs | Check if site blocks /map |
| Credit balance | `firecrawl credit-usage` | Returns remaining credits | Check account |
| Concurrent test | 3 parallel scrapes of different URLs | All 3 complete successfully | Concurrency limit may be lower than documented |

#### 4.0.2 DataForSEO Calibration Tests

| Test | API Endpoint | Expected Result | If Fails |
|---|---|---|---|
| SERP check | `serp/google/organic/live/advanced` with keyword "revenue intelligence software" | Returns SERP results with URLs, titles, positions | Check API credentials, balance |
| Keyword volume | `keywords/google/search_volume/live` with 10 test keywords | Returns search volumes, CPC, competition | Check endpoint availability |
| Labs competitor | `dataforseo_labs/google/competitors_domain/live` with domain "gong.io" | Returns competitor domains + keyword overlap | Verify domain is indexed |
| Domain technographics | `domain_analytics/technologies/live` with domain "gong.io" | Returns detected technologies | Check domain coverage |
| Credit balance | DataForSEO dashboard | Returns remaining balance | Check account |

#### 4.0.3 Authenticated Session Setup

For platforms that require login to access data, use Firecrawl `/interact` with persistent browser profiles. Create accounts where needed.

**Reddit:**
- Reddit data collection uses the **Reddit Research MCP server** as the PRIMARY method (free, no auth required, complies with Reddit API terms via official API). This MCP provides native Reddit access — use it for all Reddit queries: subreddit search, post content, comment threads, community sentiment analysis.
- **Fallback:** Firecrawl /search for public Reddit pages (no authentication required — limited to what Reddit serves without login). URL pattern: `site:reddit.com "[query]"`. This accesses only publicly visible content.
- **Do NOT:** Create throw-away Reddit accounts. Do NOT use Firecrawl /interact with persistent authenticated profiles for Reddit scraping. Creating fake accounts violates Reddit's User Agreement. Authenticated scraping violates Reddit's API Terms (all automated access requires official API key, no circumvention of access restrictions).
- **ToS compliance:** Reddit Research MCP uses the official Reddit API. Firecrawl /search for public pages accesses only what Reddit serves without authentication. Both methods are ToS-compliant.

**G2/Capterra (public access first):**
- G2 reviews are accessed via public (unauthenticated) pages first. Test without login: `firecrawl scrape "https://www.g2.com/products/[product]/reviews" --wait-for 3000`.
- If a review page is behind a login wall, use alternative sources (Capterra, Trustpilot, Reddit Research MCP) for that competitor's reviews rather than creating accounts for scraping. Creating free G2 accounts specifically for automated scraping violates G2 Terms of Service.
- Many reviews are publicly accessible without login — test first before assuming a login wall.

**LinkedIn (public data only):**
- LinkedIn scraping is against ToS. Do NOT scrape LinkedIn. Do NOT create fake accounts.
- Use public ATS job board APIs (Greenhouse, Lever, etc.) for hiring signals instead.
- Use company websites and press releases for leadership change detection.
- Use GDELT news monitoring for executive movement detection.

**Other platforms as needed:**
- For any platform that requires authentication to access data needed for niche research: create an account, set up persistent Firecrawl profile, verify access, document credentials in `niche-program/research/_program/CREDENTIALS.yaml` (gitignored).

#### 4.0.4 Free Tool Verification (Fallback-Only)

Verify the free tools that serve as fallbacks. These are tested AFTER Firecrawl/DataForSEO — they are fallbacks, not primaries.

| Tool | Test | Expected | If Fails |
|---|---|---|---|
| OpenRegistry MCP | Query KVK for a known Dutch company | Returns company registration data | Remove from fallback list |
| Reddit Research MCP | Search for "RevOps challenge" | Returns relevant posts | Use Firecrawl with profile instead |
| GDELT Project | Query last 7 days for "acquisition" | Returns news articles | Remove from fallback list |
| EUROSTAT API | Query NACE J.62 employment data | Returns structured data | Use Firecrawl /search for market reports instead |
| HubSpot API | Test OAuth connection with developer account | Returns contact/deal data | Verify API key, scopes |

#### 4.0.5 Calibration Completion Gate

All of the following must be true before Phase 1 begins on any niche:

- [ ] Firecrawl: basic search, JS scrape, and credit balance verified — all PASS
- [ ] DataForSEO: SERP check, keyword volume, and credit balance verified — all PASS
- [ ] Authenticated sessions: Reddit Research MCP returns valid results (official API, no auth required). G2 tested via public access (no account creation).
- [ ] Fallback tools: ≥3 of 5 free tools verified as working
- [ ] Concurrent test: 5 parallel Firecrawl requests complete successfully
- [ ] Credit budget: Firecrawl >90,000 credits remaining, DataForSEO >$45 remaining
- [ ] Dead-host registry: initialized (empty, populated during pipeline per G-012)
- [ ] _program/ directory: LEDGER.yaml, CREDIT_BUDGET.yaml, PIPELINE_CHECKPOINTS.yaml, CREDENTIALS.yaml created
- [ ] SHARED/ directory: _REGISTRY.yaml initialized with empty index, benchmarks/ competitors/ triggers/ directories created
- [ ] _pipelines/ directory: dedup-manifest.yaml initialized, cache-warm.sh and preflight-check.sh present
- [ ] Credential pre-flight: FIRECRAWL_API_KEY, DATAFORSEO_LOGIN, DATAFORSEO_PASSWORD env vars resolve
- [ ] All CREDENTIALS.yaml *_env_var values resolve to non-empty environment variables
- [ ] TOOL_VERSIONS.yaml created with current API versions from calibration tests

**Phase 0 credit budget:** Reserve up to 200 Firecrawl credits + $0.50 DataForSEO for calibration. This is outside the per-niche budget.

**Phase 0 recurring delta check:** Phase 0 runs fully before the first niche. After the first niche, a delta check runs every 10 niches AND whenever any tool returns its first failure. The delta check re-verifies: (a) all primary tool endpoints respond correctly, (b) authenticated sessions are still valid, (c) API version headers match expected values (compare against `_program/TOOL_VERSIONS.yaml`), (d) credit balance is consistent with projections. If any primary tool fails the delta check, halt new niche starts until resolved.

**Phase 0 emergency override:** If a non-primary (fallback) tool fails calibration and has an equivalent working fallback, Wesley may waive the failing gate item after logging the waiver in `_program/PIPELINE_CHECKPOINTS.yaml`. Primary tool failures (Firecrawl, DataForSEO) cannot be waived — the pipeline is blocked until resolved. This ensures the pipeline isn't blocked by a single fallback tool failure while maintaining the hard gate on primary tools.

---

### 4.1 Phase 1: Niche Bounding (~17 credits, ~$0.002, ~3 minutes)

**Gate:** Kills clearly non-viable niches before significant credit spend.

| Step | Operation | Tool | Cost | Parallel? |
|---|---|---|---|---|
| 1.1 | Market existence check — 5 broad web searches | Firecrawl /search (relevance excerpts) | 10 credits | Yes — all 5 parallel |
| 1.2 | First-5 Prospect Test — company discovery | Firecrawl /search + OpenRegistry MCP | 7 credits | Yes |
| 1.3 | Broad market sizing | EUROSTAT + OECD + CBS StatLine APIs | $0 | Yes — all 3 parallel |
| 1.4 | Competitor count estimate | DataForSEO Labs — SERP Competitors for "[niche] software" | $0.002 | No |
| 1.5 | Data accessibility gate check | Context7 MCP — query CRM/ATS API docs | $0 | Yes — parallel per system |
| **Phase 1 Total** | | | **~17 credits + $0.002** | |

**Gate:** If Phase 1 fails to confirm niche existence (fewer than 50 searchable companies, zero analyst coverage, or data accessibility RED), flag as HIGH-UNCERTAINTY. Do not proceed to Phase 2 without explicit approval.

### 4.2 Phase 2: Deep Research (~100 credits, ~$0.31, 5-8 minutes)

**Gate:** This is where most credit spend occurs. Runs only if Phase 1 passes.

| Step | Operation | Primary Tool | Cost | Parallel? |
|---|---|---|---|---|
| 2.1 | Competitor discovery + profiling (5-10 competitors) | Firecrawl /search (competitor names, positioning) + /scrape (homepages) | 40 credits | Yes — 5 parallel scrapes |
| 2.2 | Competitor pricing extraction | Firecrawl /map (discover pricing URLs, 1 credit) → /scrape (3-5 pricing pages) | 15 credits | Yes — per-competitor parallel |
| 2.3 | Review/VOC extraction (≥20 reviews per competitor) | Firecrawl /search "X reviews G2" → /scrape review pages | 30 credits | Yes — per-competitor parallel |
| 2.4 | Technographic profiling | DataForSEO Domain Analytics — Domains by Technology | $0.01 (for 5 competitors) | Yes — batch all 5 |
| 2.5 | SERP/keyword analysis | DataForSEO Keywords API — batch 50 keywords/competitor | $0.03 (50 queries × $0.0006) | No — single batched request |
| 2.6 | Company registry verification | OpenRegistry MCP (5 companies) | $0 | Yes — per-company parallel |
| 2.7 | News/intent signal scan | GDELT Project API (last 90 days) | $0 | No |
| 2.8 | Hiring signal scan | Public ATS APIs (5 target companies) | $0 | Yes — per-company parallel |
| 2.9 | Buyer language extraction | Reddit Research MCP + Firecrawl /search review quotes | 0-10 credits | Yes — both parallel |
| 2.10 | Market sizing deep dive | EUROSTAT/OECD/World Bank APIs + Firecrawl /search for niche reports | 10 credits | Yes — all parallel |
| **Phase 2 Total** | | | **~95-105 credits + $0.04** | |

**Data quality gate (BINDING):** After Phase 2, verify: (a) ≥3 competitors with pricing anchors (KT-3 gate), (b) ≥20 reviews across ≥3 competitors, (c) ≥2 independent market sizing sources. If any gate fails, flag as INSUFFICIENT_DATA. Do not proceed to Phase 3 until resolved or waived.

### 4.3 Phase 3: Commercial Design (~15 credits, ~3 minutes)

**Gate:** Runs only if Phase 2 data quality gates pass.

| Step | Operation | Tool | Cost |
|---|---|---|---|
| 3.1 | Pricing benchmark validation — verify pricing data completeness and schema validity | Firecrawl /scrape (re-verify competitor pricing) | 9 credits |
| 3.2 | Distribution/aggregator discovery | Firecrawl /search for "[niche] agencies/partners/consultants" | 6 credits |
| 3.3 | Signal feasibility verification | Context7 MCP — verify API capabilities for each planned signal | $0 |
| 3.4 | Canvas section authoring | Agent fills NICHE-METHODOLOGY.md §§1-15 using structured data | 0 credits |
| 3.5 | Evidence traceability mapping | Generate `evidence/trace-map.yaml` — link every [E]/[P] claim to source | 0 credits |
| **Phase 3 Total** | | | **~15 credits** |

### 4.4 Phase 4: Scoring & QA (~0 credits, ~2 minutes)

| Step | Operation | Tool | Cost |
|---|---|---|---|
| 4.1 | RIOS scoring (§14) | Agent scores all 8 dimensions using calibration anchors | 0 credits |
| 4.2 | Freshness audit | Run `freshness-audit.sh` — verify all source data within SLA | 0 credits |
| 4.3 | Evidence grade audit | Grade Assignment Engine recomputes grades from source metadata | 0 credits |
| 4.4 | Cross-reference verification | Canvas-level gates (§4.2): completeness, coherence, conversion reconciliation, pricing consistency, minimum viable sequencing | 0 credits |
| 4.5 | Adversarial QA | Fresh agent runs adversarial checklist from Part 3 | 0 credits |
| **Phase 4 Total** | | | **~0 credits** |

### 4.5 Pre-Spend Credit Gates (BINDING)

Credit gates fire BEFORE each phase, not after. This ensures credits are verified BEFORE spending, not audited after the damage is done.

| Gate | When | Budget Check | Action If Fail |
|---|---|---|---|
| **GATE-1→2** | Before Phase 2 starts | Firecrawl remaining ≥ 5,000 credits. DataForSEO ≥ $40 remaining. | Halt ALL niches. Raise credit alert. Do not proceed until credits are replenished or Wesley waives. |
| **GATE-2→3** | Before Phase 3 starts | Firecrawl remaining ≥ 2,000 credits. Per-niche Phase 1+2 actual ≤ 150% of estimate (~200 credits). | Halt THIS niche. Log overage cause. If 3+ niches exceed Phase 1+2 estimate, pause pipeline for methodology review. |
| **GATE-3→4** | Before Phase 4 starts | Phase 3 credit consumption ≤ 30 credits. DataForSEO within $0.05 of estimate. | Log. Phase 3 is low-credit by design. Overage indicates re-fetching with stale cache — investigate cache layer. |
| **GATE-FINAL** | Before canvas finalization | Per-niche total ≤ 200 credits Firecrawl, ≤ $0.10 DataForSEO (1.5x safety buffer over estimated ~132 credits). | Log final. If persistent overage across >3 niches, escalate to methodology review. Add niche to overage ledger. |

**Credit check timing:** Before each phase transition, read `_program/CREDIT_BUDGET.yaml` for current remaining credits. Compare to the gate threshold. If threshold is exceeded, the HALT action is: do NOT start the next phase; investigate cause; log the gate event with timestamp, niche ID, and credit state.

**Running credit tracking:** Every credit-consuming operation logs to `_program/CREDIT_BUDGET.yaml` with: timestamp, niche_id, tool, operation, credits_consumed, credits_remaining. The gate transition check reads the most recent `credits_remaining` value. Firecrawl credits are checked via `firecrawl credit-usage` at each gate; DataForSEO balance via dashboard check.

---

### 4.6 Concurrency Management (BINDING)

**Problem:** 4 concurrent niches in Phase 2 generate bursts of 60-80 Firecrawl requests, exceeding the 50-concurrent standard plan limit. Without traffic shaping, this causes 429 rate-limit cascades within the first 2-3 minutes of peak Phase 2 overlap.

**Staggered Phase 2 entry:** Niches entering Phase 2 MUST stagger their start times by 30-90 seconds of random jitter. Implementation: `sleep(random.randint(30, 90))` before Phase 2 Step 2.1. This prevents all 4 concurrent niches from hitting Firecrawl's burst-scrape steps simultaneously.

**Per-agent rate limiters:**
- Max 10 concurrent Firecrawl requests per niche agent
- Max 5 concurrent DataForSEO requests per niche agent
- Agents check their own in-flight request count before issuing new requests

**Global concurrency coordination:** `_program/_CONCURRENCY_LOCK.yaml` provides cross-agent Firecrawl coordination:
- Before a burst: agent writes its niche ID, start time, and expected concurrent request count
- After burst completion: agent releases the lock by removing its entry
- Other agents read the lock and adjust their own throttling: if total active requests across agents >40, wait until ≤40 before issuing new requests

**429 response handling:** If any agent detects HTTP 429 (rate limited) from Firecrawl, it MUST back off for `min(60, 2^retry_count * rand(0.5, 1.5))` seconds before retrying. The agent also writes a rate-limit event to TOOL_ERROR_LOG.yaml so other agents can adjust.

**Exponential backoff for all retries:** Per §8.3: retry with exponential backoff (1s, 2s, 4s, 8s) plus jitter of 50-100ms per retry. Do NOT use immediate retries — they amplify burst load against already-throttled endpoints.

---

### 4.7 Independent Verification (Post-Finalization)

**Purpose:** The same agent that fetches, structures, hashes, grades, and maps data to claims cannot be the sole quality auditor of its own work. A hallucinating agent can fabricate competitors, pricing tiers, review quotes, and signal sources — the evidence grade engine will rate them `[P]` as long as plausible-looking URLs are provided.

**Procedure (every 5th niche + any niche with evidence_quality <50%):**
1. After canvas finalization, a SEPARATE (non-context-sharing) agent receives ONLY the `evidence/trace-map.yaml` from the completed canvas.
2. The verifier randomly selects 10% of source URLs from the trace-map (minimum 5, maximum 20).
3. The verifier independently re-fetches each URL, computes content hashes, and compares against trace-map entries.
4. **Gate:** If >20% of re-checked hashes mismatch the trace-map, the ENTIRE canvas is flagged for human review. The canvas verdict is downgraded to `CONDITIONAL` pending verification.
5. Verifier credit budget: 10% of the original niche's consumed credits. Separate from the niche budget. The verifier shares NO agent context with the original niche agent — only the URL list.
6. Verification result is logged to trace-map.yaml: `independent_verification: {verifier_agent: "", date: "", urls_checked: N, hashes_match: N, hashes_mismatch: N, verdict: PASS | FLAGGED}`

**This is the highest-ROI single fix for evidence integrity.** It catches hallucination-driven corruption that no self-audit can detect. Recommended by 3 of 6 audit lenses (Data Quality, Red-Team Chaos Engineer, Security).

---

## 5. Data Schemas

### 5.1 Competitor Profile Schema

```yaml
# niche-program/research/N-XXX/02-competitor-intel/{niche_id}-competitor-profile-{name}-v1.yaml
competitor_profile:
  competitor_id: "comp_syncgtm_v1"          # Unique ID: comp_{name}_{version}
  name: "SyncGTM"                            # Company name
  url: "https://syncgtm.com"                 # Homepage URL
  fetch_date: "2026-07-23"                   # ISO 8601 date
  fetch_method: "firecrawl_scrape"           # firecrawl_search | firecrawl_scrape | dataforseo | openregistry | manual
  freshness_sla: "90d"                       # From freshness SLA table
  fresh_until: "2026-10-21"                  # fetch_date + 90 days
  freshness_status: "FRESH"                  # FRESH | STALE | EXPIRED
  niches_where_relevant: ["niche-003", "niche-007"]  # Cross-niche tags for sharing
  source_urls:                               # URLs fetched for this profile
    - url: "https://syncgtm.com"
      fetch_date: "2026-07-23"
      http_status: 200
      content_hash: "sha256:a1b2c3d4..."
      raw_file: ".firecrawl/syncgtm-homepage.md"
  profile:
    funding: "Bootstrapped"                   # or "VC-backed ($XM Series X)"
    delivery_model: "HYBRID"                  # SOFTWARE | MANAGED | HYBRID
    gtm_motion: "Sales-led + partner"         # Self-serve | Sales-led | Partner-led | Marketplace
    estimated_customers: "500+ (G2 reviews: 150, LinkedIn employees: 45)"
    positioning_headline: "Revenue intelligence for GTM teams"  # Verbatim from homepage
    pricing:                                  # From competitor pricing extraction
      - tier: "Self-Serve"
        price_monthly_eur: 77
        billing: "monthly"
        source_url: "https://syncgtm.com/pricing"
        source_verified_date: "2026-07-23"
      - tier: "Managed (Fractional GTMe)"
        price_monthly_eur: 2300
        billing: "monthly"
        source_url: "https://syncgtm.com/pricing"
        source_verified_date: "2026-07-23"
    strengths:                                # From review analysis (≥20 reviews)
      - "Multi-source signal detection"
      - "Claude Code integration"
      - "Fractional GTMe managed service"
    weaknesses:                               # From review analysis
      - "No proprietary data moat"
      - "Self-serve tier limited enrichment"
    review_summary:
      total_reviews_analyzed: 25
      sources: ["G2 (15)", "Capterra (7)", "Reddit (3)"]
      avg_rating: 4.3
      top_praise: "Ease of setup, multi-source signals"
      top_complaint: "Self-serve pricing jumps significantly at scale"
    tech_stack:                               # From technographic analysis
      - category: "AI/LLM"
        tools: ["Claude AI"]
        detection_method: "dataforseo_domain_analytics"
    vulnerabilities:
      - "Pricing not publicly available for enterprise tier"
      - "No SOC2 certification found"
```

### 5.2 Review Corpus Schema

```json
{
  "review_corpus": {
    "competitor_name": "SyncGTM",
    "fetch_date": "2026-07-23",
    "total_reviews": 25,
    "sources": {
      "g2": { "count": 15, "url": "https://www.g2.com/products/syncgtm/reviews" },
      "capterra": { "count": 7, "url": "https://www.capterra.com/p/123456/syncgtm/reviews" },
      "reddit": { "count": 3, "subreddits": ["r/RevOps", "r/sales"] }
    },
    "reviews": [
      {
        "review_id": "rev_001",
        "source": "g2",
        "source_url": "https://www.g2.com/...",
        "rating": 4,
        "reviewer_role": "VP Sales",
        "reviewer_company_size": "50-200 employees",
        "date": "2026-06-15",
        "title": "Great signal detection, wish enrichment was deeper",
        "pros": "Multi-source signals, easy CRM integration",
        "cons": "Enrichment limited on self-serve tier, pricing jump at scale",
        "verbatim_quotes": [
          "Setup took 2 days and we were getting actionable signals by day 3",
          "The jump from $77/mo to $2,300/mo managed is steep for smaller teams"
        ]
      }
    ],
    "theme_analysis": {
      "top_praise_themes": [
        {"theme": "Ease of setup", "frequency": 12, "pct": 48},
        {"theme": "Multi-source signals", "frequency": 10, "pct": 40},
        {"theme": "CRM integration quality", "frequency": 8, "pct": 32}
      ],
      "top_complaint_themes": [
        {"theme": "Pricing at scale", "frequency": 7, "pct": 28},
        {"theme": "Limited enrichment self-serve", "frequency": 5, "pct": 20}
      ]
    }
  }
}
```

### 5.3 Market Sizing Schema

```yaml
market_sizing:
  niche_id: "N-003"
  fetch_date: "2026-07-23"
  methodology: "bottom-up"                    # top-down | bottom-up | hybrid
  tam:
    companies: 8000
    companies_range: "6,000-12,000"           # 80% confidence interval
    revenue_eur: 24000000                     # TAM in EUR (companies × avg ACV)
    sources:
      - name: "EUROSTAT NACE J.62"
        url: "https://ec.europa.eu/eurostat/..."
        methodology: "Business demography by NACE code"
        year: 2024
      - name: "OECD Structural Business Statistics"
        url: "https://stats.oecd.org/..."
        year: 2023
    confidence: "MEDIUM"                      # HIGH | MEDIUM | LOW
  geographic_scope:
    primary: "NL"
    secondary: ["BE", "DE"]
    justification: "Founder network strongest in NL; DACH expansion via partners"
  concentration: "fragmented"                 # platform-dominant | oligopoly | fragmented
  growth_trajectory: "growing"               # growing | stable | shrinking
  niche_existence_proof:
    - "Gartner Market Guide for Revenue Intelligence 2025"
    - "LinkedIn group 'RevOps Netherlands' — 2,300 members"
    - "Industry conference: Revenue Intelligence Summit Europe"
```

### 5.4 Additional Schemas

The following schemas follow the same pattern (required fields, optional fields, controlled enums, source traceability). Full specifications in `niche-program/lenses/02-schema-storage-designer.md`:

- **Company Discovery List:** company name, URL, decision-maker title, qualification criteria met, discovery source
- **Buyer Language Extracts:** verbatim quotes with source URL, reviewer role, date, niche-specific vs. generic tag
- **Signal Feasibility Report:** signal name, data source, API endpoint, detection method, feasibility rating, false positive estimate
- **Pricing Data:** tier name, monthly/annual pricing, source URL, verification date, managed vs. self-serve flag
- **Technographic Profile:** domain, detected technologies by category, detection method, confidence
- **Niche Canvas Frontmatter:** YAML per NICHE-METHODOLOGY.md §6.2 specification
- **Cross-Niche Patterns:** shared benchmarks, overlapping competitors, common buyer language themes

---

### 5.5 Schema Validation Gate

**Schema violations are caught at ingestion time, not when an agent discovers them mid-canvas.**

All structured data files written to `niche-program/research/N-XXX/` are validated against their schema BEFORE being consumed by canvas authoring. Schema definitions live in `niche-program/schemas/`:
- `competitor-profile-schema.yaml` — Validates competitor profiles against §5.1
- `review-corpus-schema.yaml` — Validates review corpora against §5.2
- `market-sizing-schema.yaml` — Validates market sizing against §5.3
- `canvas-frontmatter-schema.yaml` — Validates canvas YAML frontmatter against NICHE-METHODOLOGY.md §6.2

**Validation procedure:**
1. Agent writes structured data to `{target}.tmp` (per atomic write principle, §1.3 item 7).
2. Agent runs validation script: `_pipelines/validate-schema.sh {data_type} {target}.tmp`.
3. If validation PASSES: rename `.tmp` → final file.
4. If validation FAILS: log the validation error to `TOOL_ERROR_LOG.yaml`, mark the data type as `SCHEMA_VIOLATION` in the niche's PIPELINE_CHECKPOINTS.yaml, and re-generate the data. If re-generation fails 3 times, mark as `SOURCE_UNAVAILABLE` with `error: SCHEMA_VALIDATION_FAILED`.

**Schema fields are marked REQUIRED or OPTIONAL.** A file missing a REQUIRED field fails validation. A file missing an OPTIONAL field passes with a warning logged. The `validate-schema.sh` script (to be created) uses the schema definitions in `niche-program/schemas/`. Until the script is operational, manual schema review is required at each Phase completion gate.

---

## 6. Freshness & Quality Control

### 6.1 Freshness SLA Table

| # | Data Type | Freshness Class | Max Age | Staleness Action | Re-Fetch Priority |
|---|---|---|---|---|---|
| D-01 | Competitor pricing | PRICING | 90 days | RE_FETCH → if unavailable DEMOTE to `[H]` | HIGH |
| D-02 | Competitor positioning/features | CAPABILITY | 90 days | RE_FETCH → DEMOTE | MEDIUM |
| D-03 | Reviews / VOC | REVIEW | 180 days | PASS_FLAG (label "Data as of [date]") | LOW |
**BLOCK enforcement (BINDING):** Data types with freshness class HIGHEST (JOB, HIRING, INTENT — D-04, D-05, D-12) have HARD BLOCK on staleness. If a BLOCK-class data type is stale AND re-fetch fails (SOURCE_UNAVAILABLE or TIMEOUT after exhausting all fallbacks), the pipeline step marks the data field as `BLOCKED: STALE_UNRECOVERABLE`. The canvas section relying on this data is flagged as `INCOMPLETE` and cannot be finalized. The canvas verdict is capped at `CONDITIONAL` until the data is refreshed or the block is waived by Wesley. A `--force` override exists for emergency cases but MUST be logged as a waiver event in PIPELINE_CHECKPOINTS.yaml. All other freshness classes use SOFT enforcement (DEMOTE + PASS_FLAG) — the pipeline continues with downgraded evidence grades.
| D-05 | Job postings / open roles | JOB | 7 days | RE_FETCH → if unavailable BLOCK | HIGHEST |
| D-06 | Market sizing data | MARKET | 180 days | PASS_FLAG | LOW |
| D-07 | Technographics | TECHNO | 180 days | RE_FETCH → DEMOTE | LOW |
| D-08 | Company registry data | REGISTRY | 90 days | RE_FETCH → DEMOTE | MEDIUM |
| D-09 | SEO / keyword data | SEO | 90 days | RE_FETCH → DEMOTE | MEDIUM |
| D-10 | Job posting / role data (public ATS APIs, press releases) | PROFILE | 30 days | RE_FETCH → DEMOTE | HIGH |
| D-11 | Funding / financial data | FUNDING | 90 days | RE_FETCH → DEMOTE | MEDIUM |
| D-12 | Engineering / hiring roles | HIRING | 7 days | RE_FETCH → if unavailable BLOCK | HIGHEST |
| D-13 | Competitor positioning | POSITION | 90 days | PASS_FLAG | LOW |
| D-14 | Regulatory data | REGULATORY | 365 days | PASS_FLAG | LOW |
| D-15 | Certifications (SOC2, ISO) | CERT | 365 days | PASS_FLAG | LOW |

### 6.2 Evidence Grade Mapping (Deterministic — First-Match-Wins)

Evidence grades are assigned by a deterministic engine, not agent judgment. Four binary criteria are evaluated in priority order. **First matching row wins.** The same inputs always produce the same grade.

| Priority | C1: ≥2 independent sources? | C2: ≥1 verified source with URL? | C3: Within freshness SLA? | C4: Source URLs documented? | Grade |
|---|---|---|---|---|---|
| 1 | YES | YES | YES | YES | `[P]` |
| 2 | NO | YES | YES | YES | `[E]` |
| 3 | — | NO | — | — | `[H]` |
| 4 | — | — | NO | — | `[H]` (demoted from original grade) |
| 5 | — | — | — | NO | `[S]` |
| DEFAULT | — | — | — | — | `[S]` |

**Evaluation rules:**
- Criteria are checked in priority order (1 through 5). The FIRST matching row determines the grade.
- Priority 3 (C2=NO) captures ALL cases where C4=NO before Priority 5 could fire. This means `[H]` wins over `[S]` when a verified source is missing — the data exists but attribution is incomplete, which is better than no source at all.
- Priority 4 (C3=NO) fires only when C2=YES but freshness SLA is violated. The grade is `[H]` (demoted) to signal that the data was once verifiable but is now stale.
- Priority 5 (C4=NO) fires only when all other criteria pass but source URLs are undocumented — an incomplete audit trail. This is `[S]` because the claim cannot be verified by a third party.
- DEFAULT catches any combination not covered above (should not occur with complete criteria evaluation).

**Truth-table verification:** All 16 binary combinations (C1×C2×C3×C4) map to exactly ONE grade. See Appendix C for the complete truth table.

**Source independence check:** Two URLs from the same domain (e.g., both from g2.com) are NOT independent sources. Two URLs from the same parent company (e.g., g2.com and capterra.com, both G2.com, Inc.) are NOT independent. The independence check requires DIFFERENT root domains owned by DIFFERENT entities.

**Cross-source consistency for `[P]` claims:** When two independent sources produce numerical values (pricing, market size, churn rate, etc.), compare them. If the values diverge by >20%, the claim is downgraded from `[P]` to `[E]` with annotation: "Sources diverge: Source A says X, Source B says Y (Δ = Z%)." The 20% threshold applies to numerical claims only. Categorical claims (e.g., "competitor uses AWS") require exact match between sources. The cross-source agreement percentage is recorded in `evidence/trace-map.yaml` as `cross_source_agreement_pct`. If only one independent source exists (C1=NO), skip consistency check — grade is capped at `[E]`.

### 6.3 Audit Trail Format

Every `[E]` or `[P]` claim in a niche canvas carries a traceability block:

```yaml
# In evidence/trace-map.yaml
claims:
  - claim_id: "N-003-S4-claim-003"           # Niche ID, Section, claim number
    claim_text: "SyncGTM charges EUR 2,300/mo for managed Fractional GTMe service"
    evidence_grade: "[E]"
    grade_criteria:                            # How the grade was computed
      c1_independent_sources: false
      c2_verified_source: true
      c3_within_sla: true
      c4_source_urls: true
    sources:
      - source_file: "N-003-competitor-pricing-syncgtm-v1.yaml"
        source_field: "profile.pricing[1].price_monthly_eur"
        source_url: "https://syncgtm.com/pricing"
        fetch_date: "2026-07-23"
        fetch_tool: "firecrawl_scrape"
        content_hash: "sha256:e5f6g7h8..."
        freshness_status: "FRESH"
        fresh_until: "2026-10-21"
    audit_verdict: "PASS"                      # PASS | STALE | UNVERIFIED | ORPHAN
```

### 6.4 Staleness Audit Procedure (Pre-Finalization)

Before any canvas is marked complete, run the staleness audit:

1. **COLLECT:** Resolve all source references from `evidence/trace-map.yaml`.
2. **EVALUATE:** For each source file, check `now - fetch_date < max_age` per the freshness SLA table.
3. **COMPUTE:** Calculate `stale_ratio = stale_source_files / total_source_files`.
4. **DECIDE:**
   - 0% stale → **PASS.** Canvas is fresh.
   - ≤10% stale → **PASS WITH WARNING.** Stale sources are flagged in the canvas. No `[P]` claims may depend on stale sources.
   - >10% stale → **BLOCKED.** Canvas cannot be marked complete. Re-fetch stale sources or mark affected claims as `[H]`/`[S]`.

**Claim-weighted staleness ratio:** If a single stale source supplies >20% of the canvas's `[E]` or `[P]` claims, the canvas is BLOCKED regardless of the source-count-based ratio. (Resolves Lens 6 Gap 2.)

### 6.4a Stale-but-Unchanged Re-Certification

Data past its freshness SLA that has NOT actually changed may be re-certified without a full re-fetch. Procedure:
1. Re-fetch a HEAD request (or a single representative URL from the data source) and compare the content hash against the original fetch's hash.
2. If hashes match: the data is re-certified for ONE additional SLA period. Log `re_certified_date` and `re_certified_by` in the trace-map. Evidence grade is NOT downgraded during re-certification.
3. If hashes differ: the data IS stale. Follow the normal staleness action (DEMOTE or BLOCK per §6.1).
4. Re-certification is limited to ONE extension per data source. After the extension period expires, a FULL re-fetch is required.
5. This applies to data types with freshness SLA ≥90 days (MARKET, REVIEW, CERT, REGULATORY). HIGHEST-class data (JOB, HIRING, INTENT) cannot be re-certified — they MUST be re-fetched.

### 6.5 Retroactive Freshness Check (Resolves Lens 6 Gap 3)

For HIGHEST-priority data types (JOB, HIRING, INTENT), a retroactive freshness check is required before canvas finalization:

1. After the canvas is authored, re-fetch the source URL for all JOB, HIRING, and INTENT data types.
2. Compare the re-fetched content hash to the original fetch's content hash.
3. If the hashes differ: the source changed between fetch and canvas finalization. Flag as `VERIFIED_STALE`. The claim based on this source is downgraded to `[H]` and annotated: "Source changed between fetch (2026-07-23) and finalization (2026-07-24)."
4. This check is only required for data types with freshness SLA ≤14 days.

**This directly resolves the Eye Security bug from the Gapstars demo (G-015/L-027 family):** vacancy count was 10 at fetch time, 28 on the live page. The freshness check passed because the file was 1 hour old. The retroactive check would have caught the hash mismatch.

### 6.6 Immutable Audit Log (Resolves Lens 6 Gap 1)

Source data files and their checksums are stored separately from the canvas. The `evidence/trace-map.yaml` is committed to git alongside the canvas. The source data files in `N-XXX/` directories are also committed. The raw fetched content in `.firecrawl/` is NOT committed (gitignored). This provides an immutable audit trail: git history proves the source data and trace-map existed at the time the canvas was finalized. Modifying a checksum after canvas finalization would require a git commit — which is detectable.

**Audit trail integrity caveat:** Git history provides detection of post-hoc modification but NOT cryptographic non-repudiation without commit signing. For full non-repudiation: (a) enable GPG or SSH commit signing for all pipeline commits, (b) configure branch protection on `main` (no force-push, require signed commits), (c) the signed commit chain proves WHO made each change and WHEN. Without signing, git provides tamper-EVIDENCE (detectable modification) but not tamper-PROOF (undeniable authorship). For the 25-niche program's threat model (agents operating autonomously, not external attackers), git detection is sufficient.

### 6.7 Aggregated Quality Monitoring

**Source of truth for pipeline health.** Three tracking files accumulate quality data across all niches:

| File | Purpose | Update Cadence |
|---|---|---|
| `_program/QUALITY_METRICS.yaml` | Per-data-type staleness rates, per-tool error rates, per-niche evidence distributions, cross-niche aggregate scores | After each niche completion |
| `_program/FRESHNESS_VIOLATION_LOG.yaml` | Append-only: niche_id, data_type, violation_type, resolution | At each freshness violation detection |
| `_program/TOOL_ERROR_LOG.yaml` | Append-only: tool, error_code, niche_id, operation, resolution | At each tool error occurrence |

**SLIs (Service Level Indicators) — defined in `_program/SLI_DEFINITIONS.yaml`:**
- **Fetch success rate:** Target >95%. Measured from TOOL_ERROR_LOG.yaml.
- **Freshness compliance:** Target >90% of sources within SLA at canvas finalization.
- **Credit forecast accuracy:** Target within 20% of per-niche estimate. Measured from CREDIT_BUDGET.yaml.
- **Per-niche wall-clock:** Target <45 min (hard timeout). Measured from PIPELINE_CHECKPOINTS.yaml.
- **Evidence quality:** Target >50% of claims at `[E]` or higher. Measured from canvas frontmatter.
- **Pipeline availability:** Target >95% during active evaluation. Measured from TOOL_ERROR_LOG.yaml system-level errors.

**Quality dashboard:** A `generate-quality-dashboard.sh` script (to be created) reads the three tracking files and produces a summary YAML report. Run after every 5th niche or on demand. The dashboard surfaces: staleness hot spots (which data types most frequently stale), error-prone tools (which tools most frequently fail), evidence quality trends (is evidence quality improving or degrading across niches?), and wall-clock drift (are niches getting slower?).

---

## 7. Cross-Agent Data Sharing

### 7.1 Data Classification

Every data type is classified on three axes: niche-specificity (1-5), reusability (1-5), staleness risk (1-5).

**NICHE-SPECIFIC (8 types):** Re-fetched per niche. Includes: company lists, niche pain quotes, raw scraped content, SERP results, diagnostic snapshots, offer canvases, market sizing estimates.

**CROSS-NICHE (12 types):** Fetched once, shared across all niches. Includes: company registry lookups, generic B2B pain patterns, competitor profiles/pricing/tech stacks, buyer language patterns, signal detection patterns, API/MCP feasibility findings, B2B benchmarks.

**NICHE-SHARED (3 types):** Partial overlap. Includes: competitor gaps, keyword volumes, buyer trigger hypotheses.

### 7.2 Discovery Protocol

When Agent N-007 starts niche evaluation, they query the shared registry BEFORE fetching any data:

1. Query `SHARED/_REGISTRY.yaml` for data tagged with this niche's category or overlapping competitors.
2. For each matching shared file: check `freshness_status`. If FRESH, consume directly ($0, 0 credits). If STALE, re-fetch.
3. For NICHE data: always fetch fresh.
**Step 4 — After completing the niche: publish any new cross-niche data to SHARED/ and update the registry.**

**Bootstrap protocol (first 5 niches):** For the first 5 niches evaluated, the SHARED registry is expected to be sparse or empty. Bootstrap fetches (fetching cross-niche data that will later be shared) count against the initiating niche's budget. The `CREDIT_BUDGET.yaml` tracks a `cross_niche_bootstrap_credits` field to distinguish bootstrap costs from niche-specific costs. After niche 5, the SHARED registry should cover ~60% of common cross-niche data (competitor profiles, benchmarks, B2B patterns), and per-niche credit consumption drops accordingly. A bootstrap health check runs after niche 5: if the registry is still >50% empty, escalate — niches may not be sharing data correctly.

### 7.3 Deduplication

A `_pipelines/dedup-manifest.yaml` tracks which niche first profiled each cross-niche entity (e.g., "SyncGTM first profiled by N-003"). If Agent N-007 encounters SyncGTM again, they consume the existing profile rather than re-fetching. The manifest prevents duplicate credit spend on the same competitor across niches.

**Race condition guard (BINDING):** Before writing to `dedup-manifest.yaml`, `SHARED/_REGISTRY.yaml`, or `DEAD_HOST_REGISTRY.yaml`, acquire a file-level advisory lock. Implementation: write a lock file `_pipelines/.{filename}.lock` with the agent's niche ID and timestamp. Other agents see the lock, poll for up to 60s, then check again whether the file now exists. If lock acquisition exceeds 30 seconds: skip dedup registration for this entry, log a warning, and continue — the worst case is a duplicate fetch (minor credit waste), not a corrupted manifest (data integrity failure). Lock files are cleaned up by the owning agent after write completion. Stale locks (>5 minutes old) are broken by any agent that encounters them.

### 7.4 Shared Benchmark Database

`SHARED/benchmarks/_BENCHMARK_DATABASE.yaml` accumulates proprietary benchmarks as niches are evaluated:

```yaml
benchmarks:
  - benchmark_id: "bench_churn_b2b_saas_001"
    metric: "Monthly churn rate"
    value_range: "1.5-3.0%"
    unit: "percentage"
    confidence: "MEDIUM"
    sample_size: 150
    source_niches: ["N-003", "N-007"]
    methodology: "Aggregated from KeyBanc 2025 survey + published benchmarks"
    trace_ids: ["N-003-S10-claim-005", "N-007-S10-claim-003"]
    status: "ACTIVE"                            # ACTIVE | SUPERSEDED | INCONCLUSIVE
    staleness_policy: "Re-evaluate every 180 days or when 5+ new niches contribute data"
```

### 7.5 MCP Server Integration

MCP servers are queried directly by agents during research. Server outputs are cached to avoid redundant queries. MCP protocol version pinned to ≥ draft-2025-03.

**MCP server version pinning:** Each MCP server's protocol version is recorded in `_program/TOOL_VERSIONS.yaml` during Phase 0 calibration. The delta check (every 10 niches) re-verifies MCP server protocol versions. If a version changes, the agent logs the delta and proceeds — MCP protocol is forward-compatible. If a server is unreachable, follow the fallback chain in §2.2.

**Rate limit scheduling:** Rate limits among concurrent niches are managed by the concurrency coordination in §4.6. Per-agent rate limiters prevent any single niche from exhausting MCP server allowances. The `_pipelines/mcp-schedule.yaml` file (created during Phase 0 bootstrap) tracks per-server concurrency limits and last-access timestamps. If this file is missing, agents default to 1 concurrent MCP call per server per niche.

---

## 8. Credit Budget & Cost Controls

### 8.1 Three-Depth Execution Model

All depths use Firecrawl + DataForSEO as primary tools. Depth determines how MUCH data we gather per niche — not which tools we use.

| Depth | Applies To | Firecrawl per Niche | DataForSEO per Niche | Data Gathered |
|---|---|---|---|---|
| **STANDARD** | All 25 niches | ~17 credits | ~$0.002 | Phase 1 only — fertility scoring. 3-5 competitors, 10 reviews/competitor, basic SERP, market sizing from government APIs |
| **DEEP** | Niches that survive fertility gate (projected: 8-12) | ~132 credits | ~$0.04 | Phases 1-4 — complete niche evaluation. 5-10 competitors, 20-50 reviews/competitor, full SERP/keyword profiling, backlink analysis |
| **FORENSIC** | LAUNCH PENDING niches (projected: 1-3) | +200-400 credits | +$1.00-$2.00 | Full validation — full keyword gap analysis, complete backlink profile, monitor setup on competitor pricing, full review history, technographic deep-dive |

> **⚠️ CREDIT RECONCILIATION NOTE (Audit Finding, 2026-07-23):** The §4 pipeline detail tables sum to ~132 credits for a full DEEP run. The original §8.1 estimate was ~500 credits — a 380% discrepancy. The pipeline detail tables (§4.1-4.4) are the source of truth until real-world measurements from the calibration niche and first 5 niches replace estimates with data. The discrepancy is explained by: (a) Phase header parentheticals were 2-4x their own detail table sums (now corrected), (b) several pipeline steps list "$0" cost but consume credits via Firecrawl /crawl page-level costs and /interact actions not individually costed in the pipeline steps, (c) retry overhead (§8.3), cross-niche bootstrap overhead, and cache-miss penalties on first runs are not included in per-step estimates. After the calibration niche is completed, replace ALL estimates with measured credit consumption and update §8.1 accordingly.

**BINDING RULE:** FORENSIC depth requires explicit approval + LAUNCH PENDING verdict. STANDARD depth is the default for all 25 niches. DEEP depth activates automatically when a niche passes the fertility gate.

### 8.2 Diminishing Returns Thresholds

| Data Type | STANDARD Depth | DEEP Depth | FORENSIC Depth | Reasoning |
|---|---|---|---|---|
| Reviews per competitor | 10 | 20-30 | 50 | After 20 reviews, 95% of sentiment themes captured. FORENSIC only for launch niches. |
| Competitors profiled | 5 | 10 | 15-25 | Top 5 capture 70% of market. FORENSIC maps full landscape. |
| Keywords per competitor | 25 | 50 | 100 | Top 50 capture ~80% of organic traffic. |
| Pricing anchors per category | 3 | 5 | 5+ | Price band stabilizes within ±5% after 5 verified anchors. |
| News articles per niche | 15 | 30 | 50 | Returns diminish sharply after 30 articles. |

### 8.3 Runaway Burn Detection

| Kill Switch | Warning Threshold | Halt Threshold | Action on Halt |
|---|---|---|---|
| Per-niche Firecrawl | 6,000 credits (150% of OPTIMAL) | 9,000 credits | Pause pipeline. Review. Was PREMIUM applied to FREE-tier niche? |
| Per-niche DataForSEO | $4.00 | $5.00 | Pause. Review. Was batch keyword optimization missed? |
| Consecutive fetch failures | 3 failures (with exponential backoff: 1s/2s/4s/8s + 50-100ms jitter) | 5 failures | Stop. Investigate tool failure. Do not retry until resolved. |
| Aggregate failure rate | >30% of fetch requests fail in any rolling 5-minute window | >50% in 5-minute window | Halt ALL pipelines immediately. Notify Wesley. This is the coordinated circuit breaker — prevents cascade failure when a primary tool (Firecrawl, DataForSEO) is degraded. |
| Aggregate Firecrawl burn rate | 4,000 credits/hour | 8,000 credits/hour | Stop all pipelines. Investigate runaway loop. |
| Single API call retries | 3 retries with exponential backoff | Stop | Mark SOURCE_UNAVAILABLE. Continue pipeline. |
| Dead host detected (3 consecutive failures) | — | Add to DEAD_HOST_REGISTRY.yaml | All agents skip this host. Re-check every 7 days via a single lightweight HEAD request. If host responds successfully twice consecutively, remove from registry. If re-activation fails 4 consecutive times (28 days total), escalate to Wesley for manual review — the host may be permanently unreachable. |
| Firecrawl/DataForSEO dead-host auto-block | — | NEVER auto-block primary tools | Dead-host registry entries for Firecrawl or DataForSEO base URLs require MANUAL confirmation. Do NOT auto-block the tools themselves — only block specific target URLs (e.g., a competitor's dead pricing page, not `api.firecrawl.dev`). |

### 8.4 Credit Optimization Rules

1. **Firecrawl /search before /scrape.** The new relevance model returns query-relevant excerpts (94.7% SimpleQA accuracy, 10x fewer tokens). For discovery queries, /search alone is sufficient — no need to follow up with /scrape. Use /scrape when you need full page content (pricing pages, detailed competitor profiles).
2. **Firecrawl /map before /crawl.** 1 credit to discover URLs vs. blind crawling. Saves ~80% of crawl credits.
3. **DataForSEO batch keywords.** 1 API request covers up to 1,000 keywords — same cost as 1 keyword. Always batch.
4. **DataForSEO standard queue.** Use standard (5 min) instead of high-priority (1 min) or live (<60s). All niche research is batch, not real-time.
5. **Firecrawl /monitor for recurring checks.** 1 credit per check vs. repeated /scrape calls. Set up once for competitor pricing, changelogs.
6. **Firecrawl search-feedback for refunds.** First feedback per search ID refunds 1 credit (up to 100/day).
7. **Firecrawl /interact with persistent profiles for authenticated content.** Create profiles once in Phase 0, reuse for all subsequent authenticated scraping. Saves re-authentication time and avoids repeated login patterns that trigger bot detection.
8. **Firecrawl over free tools — always, unless free is better.** We have 100K credits. Spending 2 credits on a Firecrawl /search is NOT a reason to use a free alternative. Only use free tools when they produce BETTER data, not when they produce CHEAPER data.

---

## 9. Cross-Cutting Gap Resolution

### 9.1 Resolved Gaps

| Gap | Lens | Resolution |
|---|---|---|
| **No retroactive freshness check** | Lens 6 Gap 3 (HIGH) | §6.5 — Retroactive re-fetch + hash comparison for JOB/HIRING/INTENT data types before canvas finalization. Directly resolves the Eye Security bug family (G-015/L-027). |
| **No immutable audit log** | Lens 6 Gap 1 (MAJOR) | §6.6 — Checksums stored in git-committed trace-map.yaml. Raw content in gitignored .firecrawl/. Modification detectable via git history. |
| **Claim-to-source mapping has no binding hash** | Lens 6 Gap 6 (MEDIUM) | §6.3 — Every claim in trace-map.yaml carries source_file, source_field, content_hash. Rewiring detectable via git diff. |
| **Fertility gate bypass risk** | Lens 5 (NON-NEGOTIABLE) | §8.1 — PREMIUM tier requires explicit approval + LAUNCH PENDING verdict. BINDING rule. |
| **10% staleness threshold is source-count-based** | Lens 6 Gap 2 (MEDIUM) | §6.4 — Added claim-weighted staleness ratio. Single stale source supplying >20% of claims blocks canvas regardless. |
| **Source independence self-attested** | Lens 6 Gap 4 (MEDIUM) | §6.2 — Independence check requires DIFFERENT root domains owned by DIFFERENT entities. G2 + Capterra (same parent) = NOT independent. |
| **EU funding data gap** | Lens 1 Fix 2 (HIGH) | Toolchain: TED API (EU tenders, free) + OpenRegistry (capital changes) + GDELT (funding news). Schema: funding-data-v1.yaml in SHARED/benchmarks/. |
| **Free-API fallback chain underspecified** | Lens 3 Fix 2 | §2.2 — Decision tree: Firecrawl → Free API (OpenSERP/Serpjet) → DataForSEO. Adds $0 layer between Firecrawl and DataForSEO. |
| **Monitor-to-action pipeline undefined** | Lens 1 Fix 1 (HIGH) | Firecrawl /monitor webhooks → cache invalidation → targeted re-evaluation of affected niche sections. Alert routing per §9.3 (Incident Response) below. |

### 9.2 Accepted Gaps (Non-Blocking)

| Gap | Rationale |
|---|---|
| **URL death between SLA check and delivery** (Lens 6 Gap 5) | Accepted for one-shot canvases. For recurring canvases, re-fetch on each cycle. |
| **No staleness rollback procedure** (Lens 6 Gap 7) | If >10% stale, canvas is BLOCKED (§6.4). Rollback = re-fetch. No partial recovery needed. |
| **Firecrawl relevance-excerpt accuracy uncalibrated for B2B niches** (Lens 1 Fix 3) | Monitor first 5 niches for relevance quality. If excerpts miss critical data, escalate to /scrape. |

---

## 10. Integration with NICHE-METHODOLOGY.md

### 10.1 What This Architecture Replaces

This architecture replaces the generic "web search" instructions in NICHE-METHODOLOGY.md Part 2 (Research Protocol, §3.1-3.5). Specifically:

| NICHE-METHODOLOGY.md Section | Replaced By |
|---|---|
| §3.1 Research Sequence (web search queries) | §4 (Per-Niche Execution Pipeline) — exact tools, exact commands, exact costs |
| §3.2 Web Search Strategy (search operators) | §2.2 (Tool Selection Decision Tree) + Firecrawl /search with relevance excerpts |
| §3.4 When to Flag Unknowns | §6.1 (Freshness SLA Table) — deterministic staleness actions |
| §3.5 Using ClarityRev's Existing Research | §7 (Cross-Agent Data Sharing) — shared registry, dedup manifest |
| §5.1 Workflow Catalog (W1-W9) | §4 (Per-Niche Execution Pipeline) — each workflow maps to a pipeline step |

### 10.2 How NICHE-METHODOLOGY.md References This Architecture

In NICHE-METHODOLOGY.md Part 2 (Research Protocol), add at the top:

> **Data operations architecture:** All research data gathering, storage, and sharing follows the binding Data Operations Architecture at `niche-program/DATA-OPERATIONS-ARCHITECTURE.md`. This specification replaces the generic web search instructions below with exact tools, commands, schemas, and storage paths. Niche agents must consult the Data Operations Architecture for tool selection and execution sequences; the Research Protocol below provides the research QUESTION — the Architecture provides the research METHOD.

### 10.3 Machine-Readable Output

Every completed niche canvas produces a YAML frontmatter (per NICHE-METHODOLOGY.md §6.2) plus:
- `evidence/trace-map.yaml` — claim-to-source traceability
- `_canvas/frontmatter-N-XXX.yaml` — machine-readable scores and metrics

The tracking ledger at `niche-program/research/_program/LEDGER.yaml` aggregates all 25 niches for portfolio comparison.

---

## 9.3 Incident Response

**When the pipeline breaks, this section tells Wesley exactly what happened and what to do.**

### Severity Tiers

| Severity | Definition | Examples | Notification | Response Time |
|---|---|---|---|---|
| **P1** | Pipeline halted — no niches can progress | Firecrawl API down for all agents, DataForSEO balance exhausted, credit runaway detected | Wesley phone + Slack within 15 min | Immediate |
| **P2** | Degraded — some niches impacted, pipeline continues at reduced capacity | Single niche stuck, single tool returning errors, concurrency limit hit | Wesley Slack within 30 min | Within 2 hours |
| **P3** | Non-blocking anomaly — pipeline continues normally | Schema validation failure on one data type, freshness violation on low-priority data | Next business day | Within 24 hours |

### Escalation Contacts

- **Wesley** — Primary on-call. All priorities. Phone + Slack.
- **Bob** — Secondary. P2 only, business hours. For business-impact decisions (e.g., "do we continue the pipeline with fallback tools or wait for Firecrawl to recover?")

### Notification Matrix

| Event | Detection Method | P-Level | Action |
|---|---|---|---|
| Firecrawl >30% error rate in 5 min | §8.3 aggregate failure kill switch | P1 | Halt pipelines, check Firecrawl status page, switch to fallbacks per §2.2 |
| DataForSEO balance exhausted | GATE-1→2 credit check | P1 | Convert remaining niches to STANDARD only, log gap |
| Credit burn rate >4,000/hr | §8.3 runaway burn detection | P1 | Kill all agents, diagnose loop |
| Single niche stuck >45 min | PIPELINE_CHECKPOINTS.yaml heartbeat check | P2 | Kill stuck agent, mark FAILED_TOOL, resume other niches |
| Schema validation failure on ≥3 data types | validate-schema.sh output | P2 | Investigate schema bug or agent drift |
| Freshness violation on >10% of sources | Freshness audit (§6.4) | P2 | Re-fetch stale sources or accept with downgraded grades |
| Dead-host registry corruption | YAML parse error on DEAD_HOST_REGISTRY.yaml | P2 | Restore from backup per RUNBOOK.md Scenario 5 |

### Alert Routing

All alerts are logged to `TOOL_ERROR_LOG.yaml` with timestamp and severity. P1 events additionally trigger an immediate notification to Wesley (phone + Slack). P2 events trigger a Slack notification. P3 events are visible in the quality dashboard (generate-quality-dashboard.sh) and reviewed at each 5-niche checkpoint.

**Post-incident review:** For any P1 or P2 pipeline halt event, document root cause, detection gap, fix, and prevention within 48 hours (P1) or next session (P2). Use the template in `_pipelines/RUNBOOK.md` Post-Incident Review section. Archive completed reviews in `_program/_postmortems/`.

---

## 9.4 GDPR & Data Retention Compliance

### Lawful Basis Assessment

The pipeline collects data from multiple third-party sources. Each data type must have a documented lawful basis under GDPR:

| Data Type | Source | Personal Data Collected | Lawful Basis (Art. 6) | Notes |
|---|---|---|---|---|
| Competitor pricing | Public websites | None (business pricing data) | N/A — no personal data | Public business information |
| Reviews / VOC | G2, Capterra, Reddit (public) | Reviewer name, role, company size | Legitimate interest (Art. 6(1)(f)) | Publicly posted reviews; reviewer chose to publish |
| Job postings | Public ATS APIs (Greenhouse, Lever) | None (job descriptions only) | N/A — no personal data | Public job listings |
| Company registry | OpenRegistry MCP, Registry Lookup | Company directors, registered address | Public interest (Art. 6(1)(e)) | Public registries by law |
| News / intent signals | GDELT Project, Firecrawl /search | Names in news articles | Legitimate interest (Art. 6(1)(f)) | Publicly published news |
| Reddit content | Reddit Research MCP (official API) | Usernames, post content | Legitimate interest (Art. 6(1)(f)) | Publicly posted content; official API access |
| Buyer language | Firecrawl /search, review pages | Reviewer names in public reviews | Legitimate interest (Art. 6(1)(f)) | Aggregated/anonymized in analysis |

### Data Retention Policy

| Data Type | Max Retention | Erasure Trigger | Erasure Procedure |
|---|---|---|---|
| Niche canvas (all sections) | 2 years post-program completion | Program archived | Move to `_archive/` — retained for reference, not deleted |
| Structured data files (N-XXX/) | 2 years post-niche evaluation | Niche verdict NO_GO + 90 days | Delete N-XXX/ directory; retain summary in LEDGER.yaml |
| Raw fetched content (.firecrawl/ .dataforseo/) | 30 days post-fetch | Auto-clean after 30 days | Script `_pipelines/clean-raw-fetches.sh` removes files older than 30 days |
| SHARED/ competitor profiles | Retain while competitor exists | Competitor ceases operations (confirmed) | Move to `_archive/defunct-competitors/` |
| SHARED/ benchmarks | Retain indefinitely | Superseded by newer benchmark | Tag as SUPERSEDED in _BENCHMARK_DATABASE.yaml; retain for traceability |
| Prospect CRM data (if collected) | 90 days post-prospect non-conversion | Prospect formally declines or 90 days no-contact | Securely delete all prospect-specific data; retain anonymized aggregate metrics |
| Review data | 2 years post-fetch | Program archived | Delete raw review files; retain theme analysis (anonymized) |
| CREDENTIALS.yaml | Delete immediately on credential rotation | Key rotated | `shred -u` the old file; never leave plaintext credentials on disk |

**Data minimization:** The pipeline collects only data needed for the 15-section canvas. Do NOT collect: personal email addresses, phone numbers, home addresses, or any data not directly relevant to niche evaluation. If a data source inadvertently contains personal data beyond what's needed, strip it during the fetch→structure step.

### SHARED/ Data Sunset

SHARED/ data accumulates across niches. Every 10 niches, run a SHARED/ sunset review:
- Competitor profiles with `freshness_status: EXPIRED` for >180 days → archive
- Benchmarks tagged `SUPERSEDED` for >365 days → archive
- Trigger registries with no niche references in >180 days → archive

---

## 9.5 Data Processor & Vendor Risk Assessment

Third-party tools processing data on ClarityRev's behalf must be assessed for compliance:

| Tool | Data Processed | DPA Available? | ToS Review | Risk Level |
|---|---|---|---|---|
| Firecrawl | Web page content, search results | Review required | Commercial use allowed (paid plan) | LOW — processes only public web data |
| DataForSEO | SERP data, keywords, domain analytics | Review required | Commercial use allowed (paid plan) | LOW — processes only public SEO data |
| Reddit Research MCP | Public Reddit posts, usernames | N/A — official API | Compliant (official API) | LOW — official API access |
| OpenRegistry MCP | Company registry data | N/A — public data | Compliant (public registries) | LOW — government public data |
| GDELT Project | News articles, event data | N/A — public data | Compliant (open project) | LOW — public news data |
| Context7 MCP | API documentation | N/A — public docs | Compliant (public documentation) | LOW — public docs |

All vendor DPAs and ToS should be reviewed by Wesley before the pipeline enters production. Tools marked "Review required" need a documented commercial-use check. No tool should be used for commercial purposes if its terms restrict non-commercial use only (see FRED API note in §2.1 Tier 3).

---

## APPENDIX A: Pre-Flight Check Script

> **⚠️ DRAFT — NOT OPERATIONAL.** This script is a template showing the intended logic. The placeholder sections (`# ... (implementation iterates...)`) are NOT functional. This script will be implemented as an operational Python/bash script within 2 weeks of program start, tested against the calibration niche. Until then, pre-flight checks are manual. The operational implementation will handle: YAML parsing, content-hash comparison, dead-host registry lookups, atomic write handling, and cache-hit decisions based on URL-normalized content-addressed lookups (per Design Principle 7). Located in `_pipelines/TEMPLATES/` until operational.

```bash
#!/bin/bash
# preflight-check.sh — Run before any credit-consuming operation
# Usage: ./preflight-check.sh NICHE_ID DATA_TYPE

NICHE_ID=$1
DATA_TYPE=$2
FRESHNESS_SLA=${3:-"90d"}  # default 90 days

# 1. Check if fresh data already exists
CACHE_FILE="niche-program/research/${NICHE_ID}/*/${NICHE_ID}-${DATA_TYPE}-*.yaml"
if [ -f $CACHE_FILE ]; then
  FETCH_DATE=$(grep fetch_date "$CACHE_FILE" | head -1 | cut -d'"' -f2)
  FRESH_UNTIL=$(grep fresh_until "$CACHE_FILE" | head -1 | cut -d'"' -f2)
  NOW=$(date -u +"%Y-%m-%d")
  
  if [[ "$NOW" < "$FRESH_UNTIL" ]]; then
    echo "CACHE_HIT: $CACHE_FILE is fresh until $FRESH_UNTIL. Skipping fetch."
    exit 0
  else
    echo "CACHE_STALE: $CACHE_FILE expired $FRESH_UNTIL. Re-fetching."
  fi
fi

# 2. Check credit balance
FIRECRAWL_BALANCE=$(grep firecrawl_remaining niche-program/research/_program/CREDIT_BUDGET.yaml | cut -d' ' -f2)
if [ "$FIRECRAWL_BALANCE" -lt 2000 ]; then
  echo "WARNING: Firecrawl balance below 2,000. Check before proceeding."
fi

# 3. Check if host is on dead-host registry
# (implemented per G-012 — hosts that 403/timeout are unusable)
DEAD_HOSTS="niche-program/research/_program/DEAD_HOST_REGISTRY.yaml"
# ... check target URLs against dead hosts ...

# 4. Proceed with fetch
echo "PREFLIGHT_PASS: No cache hit, credits sufficient. Proceeding with fetch."
exit 0
```

---

## APPENDIX B: Freshness Audit Script

> **⚠️ DRAFT — NOT OPERATIONAL.** Same status as Appendix A. The placeholder sections are NOT functional. Until implemented, freshness audits are manual. The operational implementation will handle: YAML trace-map parsing, SLA table lookups, claim-weighted staleness ratio calculation, and BLOCK-class data type hard enforcement. Located in `_pipelines/TEMPLATES/` until operational.

```bash
#!/bin/bash
# freshness-audit.sh — Run before canvas finalization
# Usage: ./freshness-audit.sh NICHE_ID

NICHE_ID=$1
TRACE_MAP="niche-program/research/${NICHE_ID}/_canvas/evidence/trace-map.yaml"
STALE_COUNT=0
TOTAL_COUNT=0

# Parse trace-map, check each source file's freshness
# ... (implementation iterates trace-map entries, compares fetch_date + SLA to now) ...

STALE_RATIO=$(echo "scale=2; $STALE_COUNT / $TOTAL_COUNT" | bc)

if [ "$STALE_COUNT" -eq 0 ]; then
  echo "FRESHNESS_AUDIT: PASS (0% stale)"
  exit 0
elif [ $(echo "$STALE_RATIO <= 0.10" | bc) -eq 1 ]; then
  echo "FRESHNESS_AUDIT: PASS_WITH_WARNING ($STALE_RATIO% stale)"
  exit 0
else
  echo "FRESHNESS_AUDIT: BLOCKED ($STALE_RATIO% stale — exceeds 10% threshold)"
  echo "Re-fetch stale sources before canvas finalization."
  exit 1
fi
```

---

---

## APPENDIX C: Evidence Grade Truth Table (All 16 Binary Combinations)

Verification that the priority-ordered grade engine (§6.2) produces exactly one grade for every possible input:

| # | C1 (≥2 indep.) | C2 (≥1 verified) | C3 (within SLA) | C4 (URLs documented) | Matches Priority | Grade |
|---|---|---|---|---|---|---|
| 1 | YES | YES | YES | YES | 1 | `[P]` |
| 2 | NO | YES | YES | YES | 2 | `[E]` |
| 3 | YES | NO | YES | YES | 3 | `[H]` |
| 4 | NO | NO | YES | YES | 3 | `[H]` |
| 5 | YES | YES | NO | YES | 4 | `[H]` (demoted) |
| 6 | NO | YES | NO | YES | 4 | `[H]` (demoted) |
| 7 | YES | NO | NO | YES | 3 | `[H]` |
| 8 | NO | NO | NO | YES | 3 | `[H]` |
| 9 | YES | YES | YES | NO | 5 | `[S]` |
| 10 | NO | YES | YES | NO | 5 | `[S]` |
| 11 | YES | NO | YES | NO | 3 | `[H]` |
| 12 | NO | NO | YES | NO | 3 | `[H]` |
| 13 | YES | YES | NO | NO | 4 | `[H]` (demoted) |
| 14 | NO | YES | NO | NO | 4 | `[H]` (demoted) |
| 15 | YES | NO | NO | NO | 3 | `[H]` |
| 16 | NO | NO | NO | NO | 3 | `[H]` |

**Interpretation:** Priority 3 (C2=NO → `[H]`) fires in 8 of 16 cases. Priority 4 (C3=NO, C2=YES → `[H]` demoted) fires in 4 cases. Priority 1 (`[P]`) fires in exactly 1 case — the most demanding evidence standard. Priority 5 (`[S]`) fires in 2 cases where source URLs are missing. No combination produces an ambiguous result. This table is mechanically verifiable and serves as the acceptance test for any grade engine implementation.

---

*End of DATA-OPERATIONS-ARCHITECTURE.md v1.1 — This document is the binding specification for all data operations in the 25-niche evaluation program. Post 6-lens audit (2026-07-23): 5 P0 + 20+ HIGH/MEDIUM fixes applied. Remaining: operational script implementation, calibration niche measurement run. It is referenced by NICHE-METHODOLOGY.md Part 2 (Research Protocol).*
