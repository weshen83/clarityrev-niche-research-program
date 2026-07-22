# Lens 1: Data Operations Architecture — 25-Niche Research

**Architect:** Data Operations Architect  
**Date:** 2026-07-23  
**Status:** DESIGN COMPLETE  
**Supersedes:** None (new architecture)

---

## 0. EXECUTIVE SUMMARY

A completely free-first, tiered data pipeline for researching 25 B2B niches. Total monthly recurring cost: **EUR 0** (all essential sources are free). Total one-time paid deposits: **EUR 50** (DataForSEO) + **EUR 0** (Firecrawl 100K credits already owned).

**Key design decisions:**
- Free-first: only spend credits when free APIs cannot answer the question
- Cache-everything: no data fetched twice for the same purpose
- Firecrawl's new `/search` with relevance excerpts changes the equation — many data types now resolve in a single search call with no separate scrape step
- DataForSEO reserved for SEO/keyword intelligence only (where it has no free substitute)
- OpenRegistry MCP is the #1 workhorse: 30 European registries, live data, 30 req/min free

**Budget summary:**
| Resource | Available | Per-Niche Budget | Estimated Consumed | Buffer |
|----------|-----------|-----------------|-------------------|--------|
| Firecrawl credits | 100,000 | 4,000 | ~1,200 | 70% |
| DataForSEO ($) | $50.00 | $2.00 | ~$1.20 | 40% |
| OpenRegistry (req/min) | 30/min | n/a (shared) | ~5/min average | 83% |
| Free APIs (calls/mo) | varies | n/a (shared) | well under limits | >80% |

---

## 1. DESIGN REQUIREMENTS

### R1. Free-First, Then Cheap, Then Premium
The architecture MUST resolve every data need from free sources before spending any credit. Credit-burning tools (Firecrawl, DataForSEO) are fallbacks only. Decision tree per data need: Free MCP → Free API → Firecrawl search (2 credits) → DataForSEO ($0.0006+) → scraped page data (1-2 credits).

### R2. Cache-Idempotent
Every fetch produces a cacheable artifact. Every read checks the cache first. No data is fetched twice for the same purpose.

### R3. Schema-First Outputs
Every research data type produces output matching a predefined schema. Raw scrapes are intermediate artifacts only — the pipeline ends with structured data.

### R4. Concurrent Fan-Out, Sequential Within Dependencies
Fan out aggressively (respect tool limits) for independent data needs. Collapse to sequential for dependent chains (e.g., discover companies THEN enrich them).

### R5. Credit Budget Per Niche
Fit within 4,000 Firecrawl credits and $2.00 DataForSEO spend per niche. Most niches should stay well under this.

### R6. Retention and Freshness Policies
Every cached data type has a defined TTL. Stale data is re-fetched. Cold data (older than 3 months without access) expires.

### R7. Graceful Degradation
When a source is unavailable (login wall, ToS block, API down), record the absence with a structured `SOURCE_UNAVAILABLE` marker — do not fabricate, guess, or retry indefinitely.

---

## 2. TOOL-TO-TASK MAPPING

Legend: ✅ = Primary | 🔄 = Fallback | ❌ = Do not use

---

### 2.1 COMPETITOR PROFILES (who is in this niche)

| Step | Tool | Config | Cost | Notes |
|------|------|--------|------|-------|
| 1. Discovery search | **Firecrawl search** `--limit 15 --scrape` | Query: `"[niche] companies" "competitors" OR "top [niche] tools"` | 2 + 15 = 17 credits | Firecrawl's relevance model surfaces only companies, not noise. Scrape embeds content inline — no second call. |
| 2. Validate existence | **OpenRegistry MCP** `search_companies` | Company name, jurisdiction | 0 credits (free) | Validates company is real, provides registry number, legal form, status |
| 3. Enrich profile | **Apify Website Company Enricher** | Batch up to 100 domains per niche | ~$0.25/100 domains (Apify free credits) | Returns ~100 fields: description, industry, employees, revenue estimates, phone, address, social |
| 4. Deep dive (top 5) | **Firecrawl search** `[company] "funding" OR "about" OR "news" --sources news --tbs qdr:m --limit 5 --scrape` | Per standout company | 2 + 5 = 7 credits each | Only for top 5 most interesting companies per niche |
| 🔄 Fallback | **Apollo.io free** (browse) | Unlimited browsing | 0 credits | Manual lookup fallback if automated enrichment fails |
| ❌ No-go | DataForSEO competitor profile | — | — | Overkill — free sources cover company profiles fully |

**Estimated per-niche cost:** 17 Firecrawl + ~$0.25 Apify credits

---

### 2.2 PRICING (what competitors charge)

| Step | Tool | Config | Cost | Notes |
|------|------|--------|------|-------|
| 1. Search first | **Firecrawl search** `"[competitor] pricing" --limit 5 --scrape` | For each known competitor | 2 + 5 = 7 credits per competitor | Relevance model returns pricing excerpts — may eliminate individual scrapes |
| 2. Deep scrape if needed | **Firecrawl scrape** `--only-main-content` | URL: `/pricing` | 1-2 credits per page | Only if search excerpts don't contain full pricing table |
| 3. Structured extraction | **Firecrawl agent** with schema | `--urls [pricing pages] --schema [pricing schema] --max-credits 10 --wait` | ~10 credits | Only when 5+ competitors have complex (JS-rendered, tab-switched) pricing |
| 🔄 Fallback | **Gralio MCP** (review data often includes pricing) | Query by product name | 0 credits | Many SaaS products have pricing in their Gralio profile |
| **Caching:** 90 days | Pricing changes infrequently. Re-fetch only if monitor fires. | | | |

**Credit optimization:** Use `firecrawl monitor` on pricing pages AFTER initial scrape to detect changes instead of re-scraping. The `--goal` filters out non-price noise.

**Estimated per-niche cost:** ~14 credits (2-3 competitors × 7 credits) + optional agent run

---

### 2.3 REVIEWS / VOC (what customers say)

| Step | Tool | Config | Cost | Notes |
|------|------|--------|------|-------|
| 1. Bulk SaaS reviews | **Gralio MCP** | Query by product name | **0 credits** | 3M+ SaaS reviews from G2 + Trustpilot + Capterra. Pricing, competitors, sentiment, categories |
| 2. Reddit organic VOC | **Reddit Research MCP** | Semantic search across subreddits | **0 credits** | Free, hosted, no credentials. Surface unvarnished customer sentiment |
| 3. G2 deep dive (top 3) | **Decodo G2 Scraper API** (free: 2K/mo) | Product URL | 0 credits (within free tier) | Structured review extraction if Gralio coverage insufficient |
| 🔄 Fallback | **Firecrawl interact** on G2/Capterra | Scrape → interact "Load more reviews" → extract | ~5-10 credits | Only if free APIs miss a critical competitor. Use sparingly. |
| ❌ No-go | DataForSEO Business Data Reviews | — | $0.012/task | Firecrawl search can find review pages cheaper |
| ❌ No-go | Reddit official API (commercial) | — | $12K+/year | Not viable |

**Important:** For niche research, we are NOT doing deep review analysis per company. We need VOC at the niche level — what buyers in this segment complain about and value.

**Estimated per-niche cost:** 0 credits (free MCPs cover this fully)

---

### 2.4 MARKET SIZING (how big is this niche)

| Step | Tool | Config | Cost | Notes |
|------|------|--------|------|-------|
| 1a. Macro EU industry | **EUROSTAT API** | NACE code lookup | **0 credits** | Employment, company counts, turnover by industry. Unrestricted free access. |
| 1b. NL-specific | **CBS OData API** | SBI code lookup | **0 credits** | Dutch industry-level data. Vacancies, company demography, employment. |
| 1c. US industry | **US Census Bureau API** + **BLS API** | NAICS code lookup | **0 credits** | Establishments, employment, payroll. Free with API key. |
| 2. Demand validation | **Firecrawl search** `"[niche] market size 2025" --limit 10 --scrape --categories research,pdf` | Research reports | 2 + 10 = 12 credits | Scrape market reports, industry analyst data |
| 3. Traffic-based TAM | **Apify Website Traffic Analysis** + **Open PageRank API** | Batch top-20 domain list | **0 credits** (free actor) | Traffic estimates for top companies in niche |
| 4. Company counts | **OpenRegistry MCP** (count by jurisdiction) + **DataForSEO Business Listings** (if needed) | By category/SBI code | 0 credits | Registry counts give lower-bound market size |
| 🔄 Fallback | **Firecrawl search** `"[niche] market report Gartner OR Forrester OR IDC"` | — | 17 credits | Only if free government data doesn't have good industry coverage for this niche |
| 🔄 Fallback | **TAM-MCP-Server** (self-hosted, open source) | Wraps Eurostat + Census + BLS + OECD | 0 credits (if self-hosted) | Integrated TAM calculation from government data |

**Estimated per-niche cost:** 12 Firecrawl credits (for market report search)

---

### 2.5 BUYER LANGUAGE (what terms buyers use)

| Step | Tool | Config | Cost | Notes |
|------|------|--------|------|-------|
| 1. Google Autocomplete | **DataForSEO Keywords API** → `search_suggestions` | 5-10 seed terms per niche | ~$0.0006 per request | Reveals what buyers ACTUALLY type. Cheap. |
| 2. Reddit natural language | **Reddit Research MCP** | Query: `"[niche] solution" OR "[niche] tool" OR "looking for [niche]"` | **0 credits** | Real buyer phrasing, pain language, comparison terms |
| 3. Related keywords | **DataForSEO Labs** → `related_keywords` | From seed terms | ~$0.012 + $0.00012/item | Semantic keyword cloud for the niche |
| 4. Search volume | **DataForSEO Keywords API** → `search_volume` | Up to 200 terms per request | ~$0.0006 per request | Quantify which language patterns have highest demand |
| 🔄 Fallback | **Firecrawl search** with query patterns from known language | Broad search for buyer phrasing | 2 credits | Only if DataForSEO is unavailable or exhausted |
| 🔄 Fallback | **SERPJET** (free: 1K/mo) | Recurring SERP searches | 0 credits | Alternative SERP API with free recurring tier |

**Estimated per-niche cost:** ~$0.02 DataForSEO (negligible)

---

### 2.6 COMPANY DISCOVERY (finding companies in a niche)

| Step | Tool | Config | Cost | Notes |
|------|------|--------|------|-------|
| 1. European discovery | **OpenRegistry MCP** → `search_companies` | By jurisdiction + keyword | **0 credits** (30 req/min) | Live from 30 European registries. Search by name, registered address, or activity code. |
| 2. NL specific | **KVK Open Dataset** (1 req/min) | SBI code lookup | **0 credits** | Only if you have KVK numbers. Use OpenRegistry instead for better rate limits. |
| 3. CH specific | **ZEFIX API** | Canton + legal form filtering | **0 credits** (no auth) | Swiss companies by canton. Excellent for geographic niche research. |
| 4. UK specific | **UK Companies House API** | SIC code search | **0 credits** (600 req/5 min) | Free, well-documented, generous limits. |
| 5. US discovery | **Registry Lookup API** (5K calls/mo) | Free tier | **0 credits** | 521M entities. Best free US company data source. |
| 6. Tech-based discovery | **DataForSEO Domain Analytics** → `domains_by_technology` | By specific tech (e.g., "Bullhorn CRM") | ~$0.0012/lookup | Find ALL companies using a specific tool. Critical for tech-defined niches. |
| 🔄 Fallback | **Apollo.io free** (browse) | Filter by industry, employees, location | 0 credits | Unlimited browsing, limited exports. Good for manual validation. |
| 🔄 Fallback | **Firecrawl search** `"list of [niche] companies" --limit 20 --scrape` | Directory pages | 2 + 20 = 22 credits | For aggregator/directory content |

**Estimated per-niche cost:** 0 credits (mostly registry lookups) + ~$0.0012 per DataForSEO technographic lookup

---

### 2.7 TECHNOGRAPHICS (what tech companies use)

| Step | Tool | Config | Cost | Notes |
|------|------|--------|------|-------|
| 1. Bulk detection | **unbuilt.app** (open source CLI) | Domain list | **0 credits** (unlimited) | Analyzes bundled/minified code. No limits. |
| 2. Quick lookups | **BuiltWith** (already have access) | Check specific domains | 0 credits | Already in our stack. Good for spot checks. |
| 3. Platform search | **DataForSEO Domain Analytics** → `domain_technologies` | Per domain | ~$0.0012/lookup | Detailed technology stack including CMS, frameworks, analytics. Cheap. |
| 4. Batch from free | **Apify website-tech-stack-detector** | Batch up to 1,000 domains | ~$5 (Apify free credits cover this) | Wide coverage with Apify's free platform credits. |
| 🔄 Fallback | **Populr Stacks** (Chrome extension) | Per-site | 0 credits | Privacy-first, manual. Good for quick checks during browsing. |
| 🔄 Fallback | **Wappalyzer free** (50/mo) | Per-site | 0 credits | Already in our stack. Use for top-10 priority companies per niche only. |
| ❌ No-go | Context7 MCP for tech detection | — | — | Context7 is for tool docs, not tech detection |

**Estimated per-niche cost:** ~$0.01 DataForSEO for technographic lookups + Apify free credits

---

### 2.8 HIRING SIGNALS (growth/contraction indicators)

| Step | Tool | Config | Cost | Notes |
|------|------|--------|------|-------|
| 1. Direct ATS APIs | **Greenhouse/Lever/Workable/SmartRecruiters/Ashby public job board APIs** | Per company URL pattern | **0 credits** (unauthenticated) | Free, no API key needed. Check the 5 major ATS platforms for each company. Pattern: `boards-api.greenhouse.io/v1/boards/{company}/jobs` |
| 2. Aggregated feed | **Techmap API** (free: 1K jobs/mo) | Query by niche keywords, company names | **0 credits** (within free tier) | 8.2M+ new jobs/month from 127+ sources. 1K job postings = ~40 per niche. |
| 3. NL job board | **Nationale Vacaturebank** via Apify (if needed) | ~$1.50/1K results | Apify free credits | Only for NL-specific staffing niches |
| 🔄 Fallback | **Firecrawl search** `"[company] careers" --limit 5 --scrape` | Per company career page | 2 + 5 = 7 credits | For companies not on major ATS platforms. |
| 🔄 Fallback | **Apify Hiring-Signal Actors** (free: 25/mo) | — | 0 credits | Only for signal validation on top-5 companies per niche |

**Caching:** 7 days. Job postings change frequently.

**Estimated per-niche cost:** 0 credits (ATS APIs free, Techmap covers within free tier)

---

### 2.9 NEWS / INTENT SIGNALS (recent events, triggers)

| Step | Tool | Config | Cost | Notes |
|------|------|--------|------|-------|
| 1. Global news | **GDELT Project** (API v2) | Query by company name, niche keywords | **0 credits** (unlimited) | 100K+ news outlets, 65 languages, 15-min updates. The gold standard for free news monitoring. |
| 2. Real-time news | **Currents API** (free: 1K req/day) | Topic-based search | **0 credits** (30K/mo) | Real-time news with entity extraction. 1K requests/day far exceeds 25-niche needs. |
| 3. RSS-based | **Firecrawl monitor** → Blog/Docs/Changelog pages | For each top competitor | 1-2 credits per creation only | After initial scrape, monitoring detects changes for free (no scrape cost per check) |
| 🔄 Fallback | **NewsAPI** (free: 100 req/day) | Development only | 0 credits | Not for production but OK for research |
| ❌ No-go | DataForSEO for news | — | ~$0.0006/request | GDELT is free and better |

**Estimated per-niche cost:** 0 credits (GDELT + Currents cover fully)

---

### 2.10 FINANCIAL / FUNDING DATA (investment activity)

| Step | Tool | Config | Cost | Notes |
|------|------|--------|------|-------|
| 1. US funding | **SEC EDGAR API** | Form D filings search | **0 credits** (10 req/sec) | US private placement data. Authoritative and free. |
| 2. US startups | **ExploreYC** (free API) | Company name lookup | **0 credits** | 6,600+ YC + a16z companies with funding data |
| 3. EU capital changes | **OpenRegistry MCP** → `get_financials` / `list_filings` | By company ID | **0 credits** (30 req/min) | Many EU registries show capital changes and filings |
| 4. EU funding (press) | **GDELT Currents** → filter by funding keywords + niche + `EU` | News-based funding signals | **0 credits** | Press coverage of funding rounds |
| 🔄 Fallback | **Firecrawl search** `"[company] funding round 2025" --sources news --limit 5 --scrape` | Per company | 2 + 5 = 7 credits | For specific funding announcements |
| ❌ No-go | Crunchbase API (free tier eliminated) | — | — | Paid only as of 2025 |
| ❌ No-go | Dealroom.co (EUR 13.7K/year) | — | — | Best EU data but far beyond budget |

**EU funding data is the #1 gap** — no single free source covers it comprehensively. Strategy: combine GDELT news signals + OpenRegistry registry filings + Firecrawl search fallback.

**Estimated per-niche cost:** 0-7 credits (mostly free, occasional Firecrawl search)

---

### 2.11 SEO / KEYWORD DATA (search demand, content gaps)

| Step | Tool | Config | Cost | Notes |
|------|------|--------|------|-------|
| 1. Competitor SEO profile | **DataForSEO Labs** → `competitors_domain` | Per top competitor domain | ~$0.012 + $0.00012/item | Full competitive landscape: intersecting keywords, ETV, position distribution. **Best value DataForSEO call.** |
| 2. Keyword volume | **DataForSEO Keywords API** → `search_volume` | Up to 1,000 keywords/request | ~$0.0006 per request | Quantify search demand for niche terms |
| 3. Keyword difficulty | **DataForSEO Labs** → `bulk_keyword_difficulty` | Up to 1,000 keywords | ~$0.025/1K keywords | Content opportunity scoring |
| 4. SERP ownership | **DataForSEO Labs** → `serp_competitors` | Niche keyword set | ~$0.012/request | Who owns page 1 for niche terms |
| 5. Domain authority | **Open PageRank API** (free: 4.3M domains/day) | Domain list | **0 credits** | Free domain authority at scale |
| 6. Domain ranking | **Tranco** (free API) | Top 1M domain ranks | **0 credits** | Academic-grade domain popularity rankings |
| 🔄 Fallback | **SERPJET** (free: 1K/mo) | SERP data | 0 credits | Limited volume but free recurring |
| 🔄 Fallback | **Firecrawl search** for SERP proxy | Niche keyword search | 2 credits | Use search as SERP proxy when DataForSEO is exhausted |
| 🔄 Fallback | **Serper.dev** (2.5K one-time free) | SERP data | 0 credits | Good for initial deep-dive |

**This is the primary DataForSEO budget consumer.** Use judiciously — 4-5 Labs calls + 1 volume call per niche.

**Estimated per-niche cost:** ~$0.05-0.10 DataForSEO

---

### 2.12 DISTRIBUTION / AGGREGATOR DISCOVERY (where buyers find solutions)

| Step | Tool | Config | Cost | Notes |
|------|------|--------|------|-------|
| 1. Aggregator search | **Firecrawl search** `"[niche] software directory" OR "[niche] tools list" --limit 15 --scrape` | Broad aggregator queries | 2 + 15 = 17 credits | Find directories, marketplaces, G2 categories |
| 2. Marketplace check | **HubSpot App Marketplace** (free listing) | Existing ecosystem | 0 credits | Check if this niche has HubSpot integrations |
| 3. Partnership signals | **Firecrawl search** `"[niche] partner program" OR "[niche] marketplace" --limit 10 --scrape` | Partnership ecosystem | 2 + 10 = 12 credits | Identify platform partners and reseller channels |
| 🔄 Fallback | **Gralio MCP** (SaaS directory) | Category browse | 0 credits | Gralio includes alternatives section — implicit aggregator discovery |

**Estimated per-niche cost:** ~29 Firecrawl credits

---

### 2.13 TRIGGER / SIGNAL RESEARCH (what triggers buying)

| Step | Tool | Config | Cost | Notes |
|------|------|--------|------|-------|
| 1. Reddit/community triggers | **Reddit Research MCP** | Query: `"[pain] solved" OR "finally found" OR "switched to"` | **0 credits** | Organic trigger event language from communities |
| 2. Event triggers | **GDELT Currents** (news event triggers) | Major events in niche | **0 credits** | News-driven buying triggers (funding, leadership change, regulation) |
| 3. Procurement data | **TED EU Procurement API** | CPV code for niche | **0 credits** (unlimited) | Government procurement triggers (tender wins, RFPs) |
| 🔄 Fallback | **Firecrawl search** `"why companies switch [niche] solution" --limit 10 --scrape` | Trigger language search | 2 + 10 = 12 credits | For qualitative trigger research |

**Estimated per-niche cost:** 0-12 credits

---

### 2.14 BENCHMARK DATA (industry norms for comparison)

| Step | Tool | Config | Cost | Notes |
|------|------|--------|------|-------|
| 1. EU industry stats | **EUROSTAT API** | NACE code → employment, turnover, company counts | **0 credits** | Free, authoritative, comparative across member states |
| 2. NL industry stats | **CBS OData API** | SBI code → company demographics, employment | **0 credits** | Free Dutch statistical data |
| 3. Macro context | **OECD API** + **World Bank API** + **IMF Data API** | GDP, sector growth, inflation | **0 credits** (unlimited) | All free, no auth required |
| 4. NL vacancies | **CBS Vacancy API** | Quarterly vacancy data by SBI | **0 credits** (free API) | Aggregate vacancy statistics as hiring benchmark |
| 🔄 Fallback | **FRED API** (US only, check commercial license) | Economic data | 0 credits | Use with attribution; non-commercial terms may apply |
| ❌ No-go | Statista free tier (too restrictive) | — | — | EUR 49/mo for meaningful access |

**Estimated per-niche cost:** 0 credits (fully covered by free government APIs)

---

## 3. TOOL SELECTION DECISION FRAMEWORK

### Decision tree (evaluate in order):

```
Is there a FREE MCP server for this?               → Use it (0 credits)
  ↓ no
Is there a FREE API for this?                       → Use it (0 credits, free quota)
  ↓ no
Can Firecrawl search with relevance excerpts        → Use it (2-17 credits)
  resolve this? (new! eliminates separate scrape)    
  ↓ no
Can Firecrawl scrape resolve this?                  → Use it (1-2 credits per page)
  ↓ no
Can DataForSEO resolve this cheaply?                → Use it ($0.0006-$0.012/task)
  ↓ no
Is it worth Firecrawl agent credits?                → Use agent (variable)
  ↓ no
Use browser/manual fallback (Apollo, BuiltWith UI)  → 0 credits, human time
```

### When to use which tool for each data type:

| Data Type | #1 Choice (Free) | #2 Choice (Cheap) | #3 Choice (Premium) |
|-----------|-----------------|-------------------|---------------------|
| Competitor profiles | Firecrawl search | OpenRegistry + Apify Enricher | — |
| Pricing | Firecrawl search (relevance excerpts eliminate scrape) | Firecrawl agent (complex sites) | Firecrawl monitor (ongoing) |
| Reviews/VOC | Gralio MCP + Reddit Research MCP | Decodo G2 Scraper (free: 2K/mo) | Firecrawl interact (deep scrape) |
| Market sizing | EUROSTAT + CBS + Census (gov APIs) | Apify Traffic Analysis | Firecrawl search (reports) |
| Buyer language | DataForSEO Keywords API ($) | Reddit Research MCP (free) | SERPJET (free: 1K/mo) |
| Company discovery | OpenRegistry MCP (30 registries) | UK Companies House + ZEFIX | DataForSEO Business Listings |
| Technographics | unbuilt.app (free OSS CLI) | BuiltWith (already owned) | DataForSEO Domain Analytics |
| Hiring signals | Public ATS APIs (Greenhouse etc.) | Techmap API (free: 1K jobs/mo) | Firecrawl search (career pages) |
| News/intent signals | GDELT + Currents (both free) | Firecrawl monitor (ongoing) | Firecrawl search (one-time) |
| Financial/funding | SEC EDGAR + OpenRegistry | ExploreYC (free API) | Firecrawl search (news-based) |
| SEO/keyword | DataForSEO Labs + Keywords API ($) | Open PageRank + Tranco (free) | SERPJET (free: 1K/mo) |
| Aggregator discovery | Firecrawl search | Gralio MCP (alternatives data) | HubSpot Marketplace browse |
| Trigger research | Reddit Research MCP + GDELT | TED EU Procurement API | Firecrawl search (qualitative) |
| Benchmark data | EUROSTAT + OECD + World Bank | CBS (NL-specific) | — |

---

## 4. PARALLELIZATION STRATEGY

### Per-Niche Fan-Out Pattern

For each niche, independent data types can be gathered concurrently. Dependent streams run in sequence.

```
PHASE 1 — DISCOVERY (parallel, 5 branches)
├── A. Firecrawl search: "[niche] competitors + market"
├── B. DataForSEO Keywords: search volume + suggestions for 5 seed terms
├── C. OpenRegistry: search companies by jurisdiction + activity code
├── D. EUROSTAT/CBS: industry benchmarks by NACE/SBI code
└── E. Reddit Research MCP: niche pain language

    (All 5 branches launch simultaneously — no dependencies)

PHASE 2 — COLLECTION (parallel after Phase 1)
├── A. Firecrawl scrape: top competitor pricing pages (from Phase 1A URLs)
├── B. Firecrawl search: "[niche] market size" reports (parallel to A)
├── C. DataForSEO Labs: competitor SEO profiles for top 3 domains
├── D. Gralio MCP: review data for discovered companies
├── E. GDELT/Currents: recent news for niche keywords
├── F. OpenRegistry: enrich discovered companies with filings data
└── G. Techmap API: hiring signals for niche companies

PHASE 3 — ENRICHMENT (parallel, depends on Phase 1+2 results)
├── A. Apify Enricher: bulk company enrichment (from discovered list)
├── B. unbuilt.app: technographics for discovered companies
├── C. Public ATS APIs: hiring signals (from company domains)
└── D. Open PageRank: domain authority scoring (from company domains)

PHASE 4 — FUSION (sequential — requires all phase 3 data)
└── A. Synthesize all outputs → structured niche profile
```

### Concurrency Limits

| Tool | Max Concurrent | Notes |
|------|---------------|-------|
| Firecrawl CLI | 50 (plan limit) | Use `firecrawl scrape URL1 URL2 URL3 ... &` pattern. Stay at ~20 for stability. |
| DataForSEO | 30 simultaneous | 2,000 calls/min. Batch volume/keyword calls to minimize API calls. |
| OpenRegistry MCP | 30 req/min (free) | 3 distinct jurisdictions per 60s. Stagger cross-border lookups. |
| Free APIs (GDELT, Currents, etc.) | Various | Keep at 10 concurrent max to avoid IP-based rate limits. |
| ATS job board APIs | Unlimited (per company) | Each company's API is a separate origin — no shared rate limit. |

### Batched Execution Plan (25 niches)

Rather than researching 25 niches sequentially, parallelize at the NICHE level:

```
Batch 1 (5 niches):   Niche A  Niche B  Niche C  Niche D  Niche E
Batch 2 (5 niches):   Niche F  Niche G  Niche H  Niche I  Niche J
Batch 3 (5 niches):   ...
Batch 4 (5 niches):
Batch 5 (5 niches):
```

Within each batch, run Phase 1 (discovery) for all 5 niches concurrently. Then Phase 2 (collection) for all 5. This maximizes throughput while respecting tool concurrency limits.

**Timeline estimate:**
- Per-niche research (all 4 phases): ~40-60 minutes elapsed (wall clock)
- 5-niche batch: ~60-90 minutes (parallel phases overlap)
- All 25 niches: ~5-8 hours total (batched, fully parallelized within batch)

---

## 5. CACHING POLICY

### Retention Periods by Data Type

| Data Type | Cache TTL | Storage Location | Refresh Trigger |
|-----------|-----------|-----------------|-----------------|
| Competitor profiles | 90 days | `research/{niche}/companies/` | New company discovered in niche |
| Pricing data | 90 days | `research/{niche}/pricing/` | Firecrawl monitor alert |
| Reviews / VOC | 180 days | `research/{niche}/reviews/` | Stale read (180+ days old) |
| Market sizing | 180 days | `research/{niche}/market/` | Annual report cycle |
| Buyer language | 180 days | `research/{niche}/language/` | New competitor enters |
| Company discovery | 90 days | `research/{niche}/companies/` | Quarterly re-scan |
| Technographics | 90 days | `research/{niche}/technographics/` | Major tech shift |
| Hiring signals | 7 days | `research/{niche}/hiring/` | Always re-fetch (fast, free) |
| News / Intent signals | 14 days | `research/{niche}/news/` | GDELT is real-time, re-fetch on access |
| Financial / Funding | 90 days | `research/{niche}/funding/` | Funding round announcement |
| SEO / Keyword data | 90 days | `research/{niche}/seo/` | SERP volatility detected |
| Aggregator / Distribution | 180 days | `research/{niche}/distribution/` | Marketplace change |
| Trigger / Signal research | 180 days | `research/{niche}/triggers/` | Qualitative, slow to change |
| Benchmark data | 180 days | `research/{niche}/benchmarks/` | Government data release cycle |

### Cache Storage Structure

```
research/{niche-name}/
  _CACHE.yaml            # Cache manifest: file, type, fetched_at, ttl_days, source_tool
  companies/
    competitors.yaml     # List of discovered companies + metadata
    profiles/            # Per-company enriched profiles
  pricing/
    {competitor}.md      # Pricing page content (raw scrape)
    structured.yaml      # Parsed pricing tiers
  reviews/
    gralio-response.json # Gralio MCP output (raw)
    niche-voc.yaml       # Synthesized VOC patterns
  market/
    reports/             # Scraped market report content
    sizing.yaml          # Market size estimates (TAM/SAM/SOM)
  language/
    keywords.yaml        # DataForSEO keyword data
    reddit-language.yaml # Reddit-derived buyer language
  hiring/
    ats-raw/             # ATS API responses (raw)
    hiring-signals.yaml  # Aggregated hiring signal analysis
  news/
    gdelt-events.yaml    # Recent GDELT events in niche
    current-api-raw/     # Currents API raw responses
  seo/
    competitor-seo/      # DataForSEO Labs output per competitor domain
    keyword-data.yaml    # Search volume, difficulty, SERP ownership
  distribution/
    aggregators.yaml     # Directory/marketplace listings
    partnerships.yaml    # Partner ecosystem
```

### Cache-First Read Pattern

```python
def get_cached_data(niche, data_type, key):
    cache_meta = load_yaml(f"research/{niche}/_CACHE.yaml")
    entry = cache_meta.get(data_type, {}).get(key)
    if entry and not is_expired(entry):
        return load_data(entry["filepath"])
    return None  # Cache miss → fetch fresh
```

### Expiry Check Rule

Before any fetch: check if the cached artifact exists AND is within its TTL. If fresh, read from cache and skip the fetch. Log the cache hit for audit. Only fetch if: (a) no cache entry exists, (b) TTL expired, or (c) forced refresh for verification.

---

## 6. CREDIT BUDGET PER NICHE

### Firecrawl Budget: 4,000 credits/niche (100,000 / 25)

| Data Type | Estimated Firecrawl Credits | Notes |
|-----------|---------------------------|-------|
| Competitor profiles | 17 | Search + scrape top results |
| Pricing | 14 | Search + scrape for 2-3 competitors |
| Market sizing | 12 | Market report search |
| Company discovery | 22 | Directory list search |
| News / intent | 0 | GDELT + Currents (free, no Firecrawl) |
| Financial / funding | 7 | Occasional search fallback |
| Distribution / aggregators | 29 | Aggregator search + partnership search |
| Trigger research | 12 | Qualitative search |
| **Subtotal** | **~113 credits** | **Well under 4,000 budget (2.8%)** |

**Reality check:** Most data types are resolved by free MCPs and APIs. The estimated average Firecrawl consumption is ~113 credits per niche — **2.8% of the per-niche budget**. The remaining credits are available for:
- Unexpected niche complexity (JS-heavy pricing pages = agent runs of 10-50 credits)
- Deep-dive into high-potential niches (extra competitor research)
- Monitor creation for ongoing alerting (1-2 credits initially, then free checks)
- Buffer for 25 niches: 87,175 credits remain (87% retention)

### DataForSEO Budget: $2.00/niche ($50 / 25)

| Data Type | Estimated DataForSEO Cost | Notes |
|-----------|--------------------------|-------|
| Buyer language (keywords) | ~$0.02 | Search suggestions + volume for 5-10 seed terms |
| SEO competitor profiles (Labs) | ~$0.15 | 1-2 Labs calls per niche |
| Keyword difficulty | ~$0.05 | Bulk difficulty for ~200 terms |
| Technographics (optional) | ~$0.01 | Occasional domain_technologies lookup |
| **Subtotal** | **~$0.23** | **Well under $2.00 budget (11.5%)** |

**Reality check:** DataForSEO consumption averages ~$0.23 per niche — **11.5% of the per-niche budget**. $19.25 of the $50 deposit remains (38.5% retention), available for:
- Deeper competitor SEO analysis for high-priority niches
- Additional keyword research for emerging language patterns
- Business Listings calls for company discovery in niches where registry data is insufficient
- Backlinks analysis for content opportunity discovery

### Free API Quota Consumption (25 niches)

| Free API / MCP | Monthly Limit | Estimated Consumption | Utilization |
|---------------|---------------|---------------------|-------------|
| OpenRegistry MCP | 30 req/min | ~5 req/min (sustained) | 16.7% |
| GDELT Project | Unlimited | ~100 req/day | <<1% |
| Currents API | 30,000 req/mo | ~1,000 req/mo | 3.3% |
| Techmap API | 1,000 jobs/mo | ~250 jobs/mo | 25% |
| Registry Lookup | 5,000 calls/mo | ~500 calls (US discovery) | 10% |
| UK Companies House | 600 req/5 min | ~100 req/day | Low |
| Apify free credits | $5/mo | ~$2/mo | 40% |
| HubSpot API | 250K req/day | ~500 req/day | 0.2% |
| Decodo G2 Scraper | 2,000 req/mo | ~200 req/mo | 10% |
| Open PageRank | 4.3M domains/day | ~1K domains/day | <<1% |

**Conclusion:** All free quotas are well within capacity for 25 niche evaluations. No paid upgrade needed.

---

## 7. ADVERSARIAL VERDICT

### Would this lens sign off?

**SIGN-OFF: CONDITIONAL — 3 minimum fixes required before production use.**

**What works:**
- Free-first design is correct and comprehensive — 80%+ of data needs resolve at zero cost
- Cache-first with defined TTLs prevents redundant fetches
- Per-niche budgets (4K credits, $2.00) provide 70-88% buffer for unexpected complexity
- Decision framework (free MCP → free API → Firecrawl → DataForSEO) is sound and testable
- Parallelization strategy respects every tool's documented concurrency limit
- Retention policies align with data volatility (pricing=90d, news=14d, hiring=7d)

**What needs fixing before sign-off:**

### FIX 1 (HIGH): No monitor-to-action pipeline defined
The architecture specifies where to use `firecrawl monitor` (pricing pages, competitor pages) but does NOT define what happens when a monitor fires. Missing:
- Alert routing: where does the webhook/email go?
- Alert triage: who decides if a pricing change is significant?
- Alert storage: where are change diffs recorded?
- Feedback loop: does a monitor alert trigger a re-crawl of that competitor?

**Fix:** Add a `MONITOR_ACTION_MATRIX.md` section defining for each monitored type: (a) alert destination, (b) triage criteria, (c) action on significance, (d) storage format for diffs.

### FIX 2 (HIGH): EU funding data gap has no structured fallback
EU private company funding is correctly identified as the #1 data gap, but the workaround ("combine GDELT + OpenRegistry + Firecrawl search") is prose, not procedure. This means every niche will solve this differently — producing non-comparable funding intelligence across the 25-niche set.

**Fix:** Define a structured funding intelligence pipeline that produces the SAME schema regardless of which free sources contributed:
```yaml
funding_signals:  # same schema for every niche
  - source: "gdelt_news" | "openregistry_filing" | "firecrawl_search" | "exploreyc"
    signal_type: "funding_round" | "capital_increase" | "acquisition"
    company_name: str
    amount: str | null   # null if amount not found
    date: date | null
    confidence: "HIGH" | "MEDIUM" | "LOW"
    source_url: str
```

### FIX 3 (MEDIUM): No performance benchmark for Firecrawl relevance-excerpt accuracy
The architecture depends heavily on Firecrawl's new relevance model to eliminate separate scrape steps (94.7% SimpleQA accuracy). If this accuracy is lower for B2B niche queries (which may be more specific and less well-represented in training data), the architecture silently falls back on more expensive scrape-per-result patterns.

**Fix:** Before the first production batch, run a calibration pass: take 5 niche queries, run Firecrawl search with `--scrape`, and compare relevance-excerpt completeness against full-page scrape for the top 20 results. If excerpts miss load-bearing data (e.g., pricing numbers, feature lists) more than 10% of the time, adjust the decision tree to default to `--scrape` for those data types.

### Additional observations (non-blocking):

- **Apify free credits are a single point of dependency** — the enricher ($0.25/100 domains × 25 niches × ~50 domains = ~$3.13 total) fits within Apify's $5/mo free credits, but just barely. If domain counts per niche are higher than estimated, Apify costs overflow.
- **DataForSEO Budget is deceptively small** — while $0.23/niche is correct for essential calls, a single `historical_bulk_traffic_estimation` at $0.10 + $0.001/domain for 1,000 domains would consume $1.10 — over half the per-niche budget in one call. The architecture must explicitly forbid expensive DataForSEO calls unless pre-approved for a specific high-value niche.
- **OpenRegistry MCP jurisdiction fan-out limit** (3 distinct jurisdictions per 60s on free tier) is a bottleneck for multi-country European niches. If a niche spans 5+ countries, the free tier slows to 3 jurisdictions per minute. Mitigation: batch cross-border lookups in 60s cycles, or budget $9/mo for OpenRegistry Pro once niche research becomes a regular operation.

---

## APPENDIX A: COMPLETE DATA TYPE REFERENCE

| # | Data Type | Primary Tool | Fallback Tool | Firecrawl Credits | DataForSEO Cost | Free MCP/API |
|---|-----------|-------------|---------------|------------------|----------------|--------------|
| 1 | Competitor profiles | Firecrawl search | Apollo.io browse | 17 | $0 | OpenRegistry |
| 2 | Pricing | Firecrawl search | Firecrawl agent | 14 | $0 | Gralio MCP |
| 3 | Reviews/VOC | Gralio MCP | Reddit Research MCP | 0 | $0 | Gralio, Reddit |
| 4 | Market sizing | EUROSTAT/CBS | Firecrawl search | 12 | $0 | EUROSTAT, OECD |
| 5 | Buyer language | DataForSEO Keywords | Reddit Research MCP | 0 | ~$0.02 | Reddit MCP |
| 6 | Company discovery | OpenRegistry MCP | DataForSEO Business Listings | 22 | ~$0.0012 | OpenRegistry |
| 7 | Technographics | unbuilt.app | BuiltWith | 0 | ~$0.01 | BuiltWith, Wappalyzer |
| 8 | Hiring signals | Public ATS APIs | Techmap API | 0 | $0 | ATS APIs, Techmap |
| 9 | News/intent | GDELT + Currents | Firecrawl monitor | 0 | $0 | GDELT, Currents |
| 10 | Financial/funding | SEC EDGAR + OpenRegistry | Firecrawl search | 7 | $0 | SEC EDGAR, ExploreYC |
| 11 | SEO/keyword | DataForSEO Labs | Open PageRank + Tranco | 0 | ~$0.15 | Open PageRank |
| 12 | Aggregator discovery | Firecrawl search | Gralio MCP | 29 | $0 | — |
| 13 | Trigger research | Reddit Research MCP + GDELT | Firecrawl search | 12 | $0 | Reddit, GDELT |
| 14 | Benchmark data | EUROSTAT + OECD + CBS | — | 0 | $0 | EUROSTAT, OECD, CBS |

**Totals per niche:** ~113 Firecrawl credits (2.8% of budget) | ~$0.18 DataForSEO (9% of budget) | 0 free-API quota issues

## APPENDIX B: CACHE MANIFEST SCHEMA

```yaml
# research/{niche}/_CACHE.yaml
_cache_version: 1
generated_at: 2026-07-23T10:00:00Z
data_types:
  competitor_profiles:
    last_fetched: 2026-07-23T10:00:00Z
    ttl_days: 90
    files:
      - path: companies/competitors.yaml
        source_tool: firecrawl_search
        query: "[niche] companies competitors"
        result_count: 15
  pricing:
    last_fetched: 2026-07-23T10:30:00Z
    ttl_days: 90
    files:
      - path: pricing/competitor-a.md
        source_tool: firecrawl_scrape
        url: https://competitor-a.example.com/pricing
  # ... one entry per fetched data type
  cached_at: 2026-07-23T11:30:00Z
  expires_at: 2026-10-21T11:30:00Z  # +90 days from latest fetch
```

## APPENDIX C: FIREWALLED EXPENSIVE OPERATIONS

The following operations EXCEED the per-niche budget and MUST NOT run without explicit approval:

1. **DataForSEO Historical Bulk Traffic Estimation** — $0.10 + $0.001/domain. At 50 domains/niche, ~$0.15, which is within budget, but at 1,000+ domains, exceeds it. **Gate:** requires approval if domains >100.

2. **Firecrawl agent runs >50 max-credits** — For complex multi-page extraction. **Gate:** any agent run must specify `--max-credits` explicitly and not exceed 50 without approval.

3. **DataForSEO Backlinks full suite** — Backlinks API calls add up fast if looping through pagination. **Gate:** only for top-3 competitors in the highest-potential niches. Not a default step.

4. **Firecrawl full-site crawl** (>200 pages) — At 1 credit/page, a 500-page crawl = 500 credits. **Gate:** only for specific competitors where full site knowledge is necessary for the offer design. Not a default step.

5. **Firecrawl interact sessions** — 1 credit per interaction action. A full paginated review extraction can cost 20-50 credits. **Gate:** only if Gralio + Decodo free tiers fail to provide needed review data.
