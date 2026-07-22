# Research Sub-Track C1b: Free Alternatives to Crunchbase + SimilarWeb

**Date:** 2026-07-23
**Context:** ClarityRev evaluating free/cheap tools for researching 25 B2B niches (European/Benelux focus). We already have Firecrawl (100K credits), DataForSEO ($50), Context7 MCP, 15+ MCP servers, BuiltWith, Wappalyzer, Hunter.io, Reddit API, OpenAlex, Apollo.io free tier.

---

## PART 1: CRUNCHBASE ALTERNATIVES

### 1.1 Crunchbase Free Tier (What Remains)

**URL:** https://www.crunchbase.com
**Type:** Free tier (heavily restricted)

#### What Still Exists
- **Free web search:** ~5-11 profile views/month. Multiple 2026 sources agree the free tier is "technically yes, practically no."
- **No API access:** Crunchbase eliminated free API access entirely in 2025.
- **No data exports:** Completely locked behind paywall.
- **No advanced search filters.**

#### Paid Entry Points
- **Starter:** $29/month (annual) — advanced search, alerts, limited contact data
- **Pro:** $49/month (annual) or $99/month (monthly) — 2,000 export rows/month
- **API Basic:** $49/month — 200 calls/min, basic company data only

**Commercial use:** Allowed on paid plans
**Sufficiency for 25 niches:** Insufficient (free tier is too limited to be useful)
**Deprecation risk:** Low (paid product is actively maintained; free tier is aggressively feature-gated)
**Notes:** NOT usable for our purposes on the free tier. The free tier exists purely as a taste-gate.

---

### 1.2 StartupWiki

**URL:** https://startupwiki.tech
**Type:** Free, open-style startup database

- **Free tier limits:** Truly free, no accounts/subscriptions needed. Uses AI agent pipelines to cross-reference public sources and write profiles.
- **Public API:** "In progress" — developer has mentioned API key limits from internal usage and is conserving quota.
- **Coverage:** Growing. YC companies being batch-processed at ~800/day. No stated cap on users.
- **Model:** Like Wikipedia — community/automated contributions.

**Commercial use:** Likely allowed (no restrictions stated; open-style platform)
**Sufficiency for 25 niches:** Borderline. Coverage is early-stage and may not have European/Benelux depth yet. Worth monitoring.
**Data freshness:** Unknown (AI-driven profile generation, update cadence unclear)
**Deprecation risk:** Medium (single-developer project, very early stage)
**Notes:** Promising approach but too early to rely on. No confirmed API limits published.

---

### 1.3 Apify Saas Enrichment

**URL:** https://apify.com/fiery_dream/saas-enrichment
**Type:** Pay-per-result actor on Apify (free alternative to Crunchbase/PitchBook/ZoomInfo)

- **Pricing:** $0.01 per 1,000 results (i.e., $0.00001 per result). Actor start fee: $0.00005.
- **Platform usage:** Included in the base price at no additional cost.
- **Data sources:** 15+ free public data sources. AI-powered company enrichment.
- **Requires:** Apify account (free tier gives $5/month platform credits).

**Free tier limits:** Depends on Apify free plan ($5/month credits). At $0.01/1K results, $5 buys ~500,000 results — extremely cheap.
**Commercial use:** Allowed (Apify's platform terms)
**Sufficiency for 25 niches:** Sufficient — at this price point, we can enrich thousands of companies for pennies.
**Data freshness:** Varies by source (pulls from multiple public sources)
**Deprecation risk:** Low (active actor, maintained by developer)
**Notes:** Strong candidate. Combined with our existing Apollo.io free tier, this covers company enrichment needs.

---

### 1.4 ExploreYC (Open-Source API)

**URL:** https://exploreyc.com
**Type:** Open-source API + web app

- **Coverage:** 6,600+ companies from Y Combinator and a16z portfolios.
- **Data:** Funding data, stage, IPO/M&A exits, founder information.
- **Filtering:** By VC (YC/a16z/all), batch, industry, country.
- **Access:** Free API key. Web app with maps, analytics, hiring board, AI tools.
- **License:** Open source (code on GitHub).

**Free tier limits:** Free API key — specific rate limits not published but designed for open access.
**Commercial use:** Allowed (open source)
**Sufficiency for 25 niches:** Borderline. Covers YC + a16z only, so limited for European/Benelux private companies. Good for US tech startup research.
**Data freshness:** Live (direct from YC/a16z data)
**Deprecation risk:** Low-medium (new, open source — community can fork)
**Notes:** Excellent for US tech startup intelligence but not a general company database. Combine with EU-specific sources.

---

### 1.5 OpenRegistry MCP Server (30 Country Registries)

**URL:** https://github.com/sophymarine/openregistry
**Type:** Free MCP server / API (real-time, direct-from-official-registry company data)

#### Free Tier
- **Anonymous:** 20 requests/min per IP. Multi-country search: 3 countries/60s.
- **Signed in:** 30 requests/min per user. Same multi-country limit.
- **Jurisdictions:** 30 national registries including:
  - **UK:** Companies House (full search, profiles, officers, PSCs, charges, filings)
  - **EU:** France RNE, Germany Handelsregister, Italy InfoCamere, Spain BORME, Netherlands KVK, Belgium KBO, Ireland CRO, Poland KRS, Czech ARES, Finland PRH, Cyprus DRCOR
  - **Nordics:** Norway Brreg, Finland PRH, Iceland
  - **Switzerland:** Zefix + SHAB/SOGC delta stream
  - **North America:** Canada (fed + provinces), US states (NY, CA, FL, CT, PA, CO, OR, IA, OH)
  - **APAC:** Australia ABR, New Zealand, Hong Kong CR, Taiwan, Korea OpenDART, Malaysia, Indonesia, India
  - **Latin America:** Mexico, Brazil

#### Paid Tiers
- **Pro:** $9/month (180 req/min, 10 countries/60s)
- **Max:** $29/month (900 req/min, 30 countries/60s)

#### Comparison to OpenCorporates
- OpenRegistry free tier: ~28,800 calls/day (20 req/min)
- OpenCorporates free tier: 50 calls/day
- OpenRegistry is ~576x more generous AND permits commercial use

**Commercial use:** Explicitly allowed on all tiers
**Sufficiency for 25 niches:** Sufficient — covers all key European markets we care about (NL, BE, UK, DE, FR, etc.)
**Data freshness:** Real-time, direct from official registries
**Deprecation risk:** Low (active development, GitHub stars, MCP ecosystem adoption)
**Notes:** This is a STRONG candidate. Direct registry data on Benelux companies, including KVK (Netherlands), KBO (Belgium), Companies House (UK). No data enrichment/aggregation — raw official records. MCP-native, works with our existing MCP infrastructure.

---

### 1.6 UK Companies House Official API

**URL:** https://developer.company-information.service.gov.uk
**Type:** Free government REST API

- **Rate limit:** 600 requests per 5-minute window per API key.
- **Data:** Company profiles, officer appointments, PSCs (beneficial owners), filing history, charges, insolvency records.
- **Streaming API:** Real-time data changes across 9 categories.
- **Bulk PSC data:** Weekly JSON snapshot available for download.
- **Format:** RESTful JSON.
- **Cost:** Free. API key required (free registration).

**Commercial use:** Allowed (open government data)
**Sufficiency for 25 niches:** Sufficient for UK company research (but UK-only)
**Data freshness:** Real-time
**Deprecation risk:** Low (government service, well-established)
**Notes:** We already know about this. Covered by OpenRegistry MCP too. Keep as backup.

---

### 1.7 Funding Signals API (SEC Form D + News)

**URL:** https://dev.to/michalis_solomou_ef4e3025/find-b2b-leads-the-moment-a-company-raises-funding-free-api-python-cb5 (article)
**Type:** Free tier (no credit card)

- **Free tier:** Public sample endpoint (no key needed). Free API key unlocks `/v1/signals` with filters (score range, raise size, industry, source, date window, `has_contact` flag).
- **Data sources:** SEC EDGAR Form D filings + funding news RSS feeds.
- **Features:** Noise filtering (removes amendments, pooled funds). Scores companies by raise size and recency.
- **Refresh:** Daily (free tier). Real-time on paid.

**Commercial use:** Allowed (free tier terms)
**Sufficiency for 25 niches:** Borderline — good for US funding alerts, limited EU coverage. SEC Form D is US-only.
**Data freshness:** Daily refresh (free tier)
**Deprecation risk:** Medium (single-developer API)
**Notes:** Only useful if we want US funding signals. SEC Form D is US-only — limited value for European niche research.

---

### 1.8 Teahose MCP (Open Source)

**URL:** https://github.com/altmbr/teahose-mcp
**Type:** Open-source MCP server, free tier + free key

- **Free tier (keyless):** 50 requests/day, limited features.
- **Free tier (with key):** 1,000 requests/day, 30 req/min, 50 funding rows returned.
- **Data:** AI-company intelligence — funding rounds, similar company search, podcast/newsletter mentions, emerging themes.
- **Focus:** AI landscape primarily.
- **Keyless start:** No API key required to begin.

**Commercial use:** Allowed (MIT license, open source)
**Sufficiency for 25 niches:** Insufficient — AI-company focused, not broad B2B niche research. Good specifically for AI startup monitoring.
**Data freshness:** Live
**Deprecation risk:** Low (open source, can fork)
**Notes:** Specialized for AI company monitoring. Not a general company database. Could be useful as supplementary signal source.

---

### 1.9 People Data Labs (Free Forever Tier)

**URL:** https://www.peopledatalabs.com
**Type:** API with free tier

- **Free tier:** 100 records/month ($0/month). Core data fields only.
- **Contact data:** Emails, phones, addresses are **obfuscated** on free tier — you can't evaluate contact quality without upgrading.
- **Rate limit:** 100 requests/minute for free users.
- **API keys:** Limited to 1 active key on free plan.
- **APIs available:** Person Enrichment, Person Search, Company Enrichment, Company Search.

**Paid entry:** Pro at $98-$100/month.
**Commercial use:** Allowed
**Sufficiency for 25 niches:** Insufficient for regular use (100 records/month is a single batch). But 100 records/month is useful for occasional lookups.
**Data freshness:** Good (actively maintained database)
**Deprecation risk:** Low (established company, well-funded)
**Notes:** 100 free records/month is a nice-to-have but not our primary data source. We already have similar via Apollo.io free tier.

---

### 1.10 OpenCorporates (Free Tier)

**URL:** https://opencorporates.com
**Type:** Free tier + paid API

- **Free tier:** 50 calls/day. Restricted to "open-data / public-benefit only" — commercial use is NOT permitted on free tier.
- **Paid entry:** From approx. 2,250 GBP/year.
- **Coverage:** Global company registry data (similar to OpenRegistry).

**Commercial use:** Restricted on free tier (open-data/public-benefit only)
**Sufficiency for 25 niches:** Insufficient (limited free calls + no commercial use)
**Deprecation risk:** Medium (OpenRegistry is effectively superseding them for free MCP access)
**Notes:** OpenRegistry (1.5 above) is strictly better: 576x more calls, permits commercial use, same jurisdictions, MCP-native. Skip OpenCorporates.

---

### 1.11 GitHub Open Datasets

**Type:** Various open datasets (research/academic)

| Dataset | Coverage | License | Usefulness |
|---|---|---|---|
| PHBench (Product Hunt → Series A) | 67,292 launches, 528 Series A outcomes | CC BY 4.0 | Low for B2B niche research |
| Startup Engineering Acceleration | 55 venture-backed startups | CC BY 4.0 | Very small sample |
| General Crunchbase-derived datasets | Various (22K orgs, 23K funding rounds) | Usually CC / academic | Limited — often outdated |

**Commercial use:** Varies (CC BY 4.0 allows reuse with attribution)
**Sufficiency for 25 niches:** Insufficient — academic datasets are too small, too US-centric, or outdated.
**Deprecation risk:** High (academic datasets are rarely maintained)
**Notes:** Not a practical source for ongoing business research. Good for one-time analysis or ML training data only.

---

### 1.12 Dealroom.co (Free Tier)

**URL:** https://dealroom.co
**Type:** Free tier + paid enterprise

- **Free access:** Very limited. 3-day free trial for full access.
- **Founder program:** Free 6-month Premium for founders who raised <$10M (100 accounts/month cap).
- **General free tier:** "Limited searches" only — no published number.
- **EU focus:** Yes — Dealroom is strong on European startup data.
- **Paid:** From ~$13,700/year.

**Commercial use:** Depends on tier
**Sufficiency for 25 niches:** Insufficient on free tier (too restricted, 3-day trial only)
**Data freshness:** Good (actively maintained, European focus)
**Deprecation risk:** Low (well-funded European company)
**Notes:** Great data if we could afford it, but free tier is nearly useless. Worth noting as a potential paid option if needed.

---

### 1.13 Tracxn (Free Tier)

**URL:** https://tracxn.com
**Type:** Free tier + paid

- **Free tier:** Available (limited). Source from the Crunchbase API article lists it as "free tier available, good coverage."
- **Details:** Specific free limits not widely published. Tracxn is known for strong sector-wise company categorization.
- **Focus:** Global startup intelligence, strong on sectors/verticals.

**Commercial use:** Likely restricted on free tier
**Sufficiency for 25 niches:** Unknown — free tier limits not clearly documented. Worth a quick test.
**Data freshness:** Good
**Deprecation risk:** Low
**Notes:** Could be worth signing up to evaluate the free tier. Not well-documented in our search results.

---

### 1.14 OpenVC

**URL:** https://openvc.app
**Type:** Free

- **Free tier:** Completely free.
- **Focus:** VC-focused startup data. Smaller dataset than Crunchbase.
- **Coverage:** Venture capital ecosystem, startups seeking funding.

**Commercial use:** Likely allowed
**Sufficiency for 25 niches:** Insufficient — too VC-centric, small dataset, likely US-heavy.
**Deprecation risk:** Medium
**Notes:** Niche tool for VC deal sourcing, not general B2B niche research.

---

### 1.15 Apollo.io Free Tier (Already Have)

**URL:** https://www.apollo.io
**Type:** Free tier (we already have this)

- **Credits:** 50-100 data/search credits/month (reports vary; limits shift without notice)
- **Export credits:** 10/month
- **Email credits:** Unlimited (fair use ~10K/month)
- **Sequence limits:** 2 active sequences
- **API access:** NONE on free plan
- **Company data:** Yes — firmographics, funding, technologies used

**Commercial use:** Allowed on free tier
**Sufficiency for 25 niches:** Borderline — 50-100 credits/month is very limited for batch research. Good for individual company lookups.
**Data freshness:** Good
**Deprecation risk:** Low
**Notes:** We already use this. Credits limit means it's useful for targeted lookups but not batch research across 25 niches.

---

## PART 2: SIMILARWEB ALTERNATIVES

### 2.1 SimilarWeb Free Tier

**URL:** https://www.similarweb.com
**Type:** Free tier

#### Free Plan Limits
- **Actions:** Up to 15 actions/day
- **Websites per session:** Benchmark up to 5 websites
- **Historical data:** 3 months (some sources say current month only)
- **Data credits:** 100 monthly
- **Users:** 1 user
- **Geography:** Worldwide view only (no country/region filter)
- **Top websites:** Top 300 only
- **Results per metric:** 5 results max
- **Exports/Reports:** None
- **Keyword analysis:** Basic only
- **API access:** NONE on free tier
- **Coverage:** High-traffic sites only. Lower-traffic domains show "Not enough data"

#### What You CAN Do Free
- View estimated monthly visits, duration, pages/visit, bounce rate
- Traffic sources breakdown (direct, referral, search, social, email, display)
- Basic competitor benchmarking across engagement metrics
- Basic keyword visibility
- Geographic distribution (top countries)
- Chrome extension insights

**Commercial use:** Allowed on free tier (limited)
**Sufficiency for 25 niches:** Insufficient for systematic research across 25 niches (15 actions/day, no exports, no API). OK for quick spot-checks of 1-2 competitor domains.
**Deprecation risk:** Low (major product, actively maintained)
**Notes:** Free tier is useful for ad-hoc lookups but cannot support batch research. 15 actions/day disappears fast across 25 niches x multiple competitors each.

---

### 2.2 Apify Website Traffic Analysis (FREE — No API Key)

**URL:** https://apify.com/datascoutapi/website-traffic-analysis
**Type:** Free Apify actor (no API key required)

#### Features
- **Traffic estimates:** Daily visitors, daily pageviews, pageviews/user
- **Global ranking:** Worldwide website popularity rank
- **SEO audit:** On-page SEO analysis (meta tags, headings)
- **Audience insights:** Geographic distribution, demographics
- **Domain WHOIS:** WHOIS data, domain age, registrar
- **Server info:** Hosting provider, IP, server tech
- **Safety report:** Reputation, malware status, trust score
- **Site status:** Online/offline check

#### Pricing
- **Completely free** — no API key needed, no credit card
- Results cached for 10 minutes per domain
- Runs on Apify's free tier ($5/month platform credits)
- Output: JSON, CSV, Excel

**Commercial use:** Allowed (Apify platform terms)
**Sufficiency for 25 niches:** Sufficient — free, no API key, covers traffic + SEO + WHOIS. Can be scripted via Apify API for batch processing across 25 niches.
**Data freshness:** 10-minute cache; real-time analysis per run
**Deprecation risk:** Medium (community actor, not official Apify product)
**Notes:** BEST FREE OPTION for traffic estimation. Combines traffic data with SEO audit and domain WHOIS — more than SimilarWeb free offers. No API key friction. Use Apify's scheduler for recurring batch runs.

---

### 2.3 Apify SimilarWeb Scraper (by Logiover)

**URL:** https://apify.com/logiover/similarweb-scraper
**Type:** Pay-per-result Apify actor (scrapes SimilarWeb public data)

- **Pricing:** From $3.50/1,000 results.
- **Data:** Total visits, global/country/category rank, bounce rate, pages/visit, visit duration, traffic sources, top countries.
- **No SimilarWeb account or API key needed** — uses SimilarWeb's undocumented data API.
- **Requires:** Apify account (free tier credits work).

**Free tier limits:** Depends on Apify $5/month free credits. At $3.50/1K, $5 buys ~1,400 results.
**Commercial use:** Allowed
**Sufficiency for 25 niches:** Borderline — $5/month covers ~1,400 domains. For 25 niches with ~10 competitors each + ongoing monitoring, this is tight.
**Data freshness:** Real-time (direct from SimilarWeb)
**Deprecation risk:** Medium (relies on SimilarWeb's undocumented API — could break if SimilarWeb changes their backend)
**Notes:** Good for short-term batch research. Risk of the scraper breaking if SimilarWeb changes their internal API. The free Website Traffic Analysis actor (2.2) is lower risk.

---

### 2.4 Apify SimilarWeb Traffic Intelligence (by NexGenData)

**URL:** https://apify.com/nexgendata/similarweb-traffic-intelligence
**Type:** Pay-per-result Apify actor

- **Pricing:** $10.00/1,000 domains ($0.01 per domain).
- **Data:** Estimated monthly visits, global/country/category rank, engagement metrics, traffic-source breakdown, top countries.
- **SimilarWeb account not required.**

**Free tier limits:** Built on Apify platform credits. $5/month covers ~500 domains.
**Sufficiency for 25 niches:** Borderline (similar to 2.3 but more expensive). Better data quality claims.
**Notes:** At $0.01/domain, this is very cheap. 25 niches x 20 competitors each = 500 domains = $5 = one month's free credits.

---

### 2.5 Open PageRank API (Free, Generous Limits)

**URL:** https://www.domcop.com/openpagerank
**Type:** Free API

- **Free tier limits:** Up to 4.3 million domains/day with a single API key.
- **Data:** PageRank score (0-10) based on Common Crawl data.
- **Coverage:** ~200 million crawled domains.
- **Data source:** Common Crawl (open, 250B+ web pages since 2007).
- **Method:** Simulation of Google's original PageRank algorithm.

**Commercial use:** Allowed (free forever stated)
**Sufficiency for 25 niches:** Sufficient — 4.3M/day is effectively unlimited for our needs.
**Data freshness:** Quarterly (Common Crawl snapshots)
**Deprecation risk:** Low (stable, based on Common Crawl — if Open PageRank dies, we can compute our own from Common Crawl)
**Notes:** Not a traffic estimation tool per se, but provides domain authority scores. Combine with traffic data from 2.2 for a complete picture. Excellent for ranking/prioritizing companies within a niche.

---

### 2.6 Ahrefs Free Domain Rating API

**URL:** https://docs.ahrefs.com/en/api/reference/public/get-domain-rating-free
**Type:** Free API

- **Free tier:** Completely free endpoint — does NOT consume API units.
- **Data:** Domain Rating score (0-100 logarithmic scale).
- **Authentication:** Currently optional; becomes mandatory September 1, 2026 (free API key).
- **Attribution:** Must display "Domain Rating by Ahrefs" with link when publishing.
- **Rate limits:** Not publicly documented (Ahrefs reserves right to impose limits).

**Commercial use:** Allowed with attribution
**Sufficiency for 25 niches:** Sufficient — free, no unit consumption. Good for scoring domain authority across niche companies.
**Data freshness:** Ahrefs' index (updated regularly)
**Deprecation risk:** Low (strategic free offering from Ahrefs; locked behind authentication to prevent abuse)
**Notes:** Excellent complement. Use alongside traffic data for holistic company assessment. Attribution requirement matters if we display results publicly.

---

### 2.7 Matomo (Self-Hosted, Open Source)

**URL:** https://matomo.org
**Type:** Open source, self-hosted

#### What it is
Matomo is a full-featured web analytics platform (like Google Analytics but self-hosted).

#### What data it exposes (via API)
- **200+ API methods:** VisitsSummary, Actions, Referrers, UserCountry, DevicesDetection, Goals, E-commerce
- **Raw database access:** log_visit, log_action, log_link_visit_action, log_conversion (self-hosted only)
- **Real-time API:** Live visitor data, current visitors
- **Format:** JSON/XML via reporting API
- **Auth:** token_auth or OAuth 2.0

#### Limits
- **Self-hosted:** No artificial limits. Only constrained by your server/database.
- **Matomo Cloud:** Paid plans start at ~$23/month.

**Relevance to our use case:** LOW. Matomo provides analytics for websites YOU own. It does NOT provide traffic estimates for third-party websites. Not a SimilarWeb alternative.
**Sufficiency for 25 niches:** Not applicable (wrong category)
**Deprecation risk:** Low (well-maintained, large community)
**Notes:** Useful if we want to track our own website traffic or offer analytics as part of our product. NOT useful for researching competitor traffic.

---

### 2.8 Umami (Self-Hosted, Open Source)

**URL:** https://umami.is
**Type:** Open source, self-hosted (MIT license)

- **Self-hosted:** Completely free, no data limits, unlimited websites and events.
- **API:** Full REST API (pageviews, sessions, events, metrics). JWT bearer auth (self-hosted) or API keys (Umami Cloud).
- **Cloud:** Paid from $9/month (managed).
- **Tracking script:** 1-2KB (very lightweight).
- **Privacy:** No cookies, GDPR-compliant.

**Relevance to our use case:** LOW. Like Matomo — provides analytics for sites YOU own. Not a SimilarWeb alternative.
**Sufficiency for 25 niches:** Not applicable
**Deprecation risk:** Low (active open source project)
**Notes:** Same limitation as Matomo — first-party analytics, not third-party traffic estimation.

---

### 2.9 Keywords Everywhere Free SEO Tools

**URL:** https://keywordseverywhere.com/tools/free-seo-tools/
**Type:** Free web tools (no signup)

- **Includes:** Domain authority checker, site traffic estimator, keyword volume data.
- **Data source:** Moz's public link index (authority) + Google search volume data (traffic).
- **Daily usage allowance:** Exists but unspecified — "limited daily usage to keep the tools fast for everyone."
- **No signup or credit card required.**

**Commercial use:** Allowed
**Sufficiency for 25 niches:** Borderline — good for spot checks, daily limit prevents batch research.
**Data freshness:** Good (Moz/Google data)
**Deprecation risk:** Low (established tool, large user base)
**Notes:** Useful as a quick manual check tool but not for systematic batch research.

---

### 2.10 SEO Review Tools Website Authority Checker

**URL:** https://www.seoreviewtools.com/website-authority-checker/
**Type:** Free web tool

- **Data:** Domain Authority, Page Authority, backlink counts, website age, social media score.
- **Data source:** SEMrush API (switched from Moz in 2020).
- **Limits:** Free, no registration required. No published rate limit.
- **Bulk checking:** Manual entry (one domain at a time via web form).

**Commercial use:** Allowed
**Sufficiency for 25 niches:** Insufficient for programmatic/research use (manual web form only). OK for spot checks.
**Deprecation risk:** Low
**Notes:** Web-only, no API. Can't script it for batch research.

---

## PART 3: EXISTING TOOLS WE ALREADY HAVE — RELEVANCE ASSESSMENT

| Tool We Have | Relevance to Company/Traffic Research |
|---|---|
| **Firecrawl (100K credits)** | HIGH — can scrape company websites, Crunchbase, LinkedIn, etc. Primary data collection tool. |
| **DataForSEO ($50)** | HIGH — SERP data, keyword volumes, domain analytics. Traffic proxy via search data. |
| **Context7 MCP** | MEDIUM — code dependency data, not company data. |
| **BuiltWith** | MEDIUM — technology profiling of company websites (useful for segmentation). |
| **Wappalyzer (50 free credits)** | MEDIUM — tech stack detection (good for filtering by tech criteria). 50 credits/month limit. |
| **Hunter.io** | MEDIUM — email discovery for contacted companies. Not for batch research. |
| **Apollo.io free tier** | MEDIUM — 50-100 credits/month for company lookups. Good for enrichment, not batch. |
| **OpenAlex** | LOW — academic/open access data. Not relevant for company research. |
| **Reddit API** | LOW — social signal monitoring for niches. Supplementary only. |

---

## PART 4: RECOMMENDED STACK FOR 25 NICHE RESEARCH

### Primary Free Stack (Zero Cost)

| Tool | What It Provides | For 25 Niches |
|---|---|---|
| **OpenRegistry MCP** | Official company registry data (NL, BE, UK, DE, FR, etc.) — legal structure, officers, filings | Core European company identification |
| **Apify Website Traffic Analysis** | Free traffic estimates, global rank, SEO audit, WHOIS | Traffic + SEO baseline for each company |
| **Open PageRank API** | Domain authority scores (4.3M/day) | Company prioritization/ranking |
| **Ahrefs Free DR API** | Domain Rating (free, no unit consumption) | Cross-check ranking |
| **Firecrawl** | Scrape target company websites for technology, content, positioning | Company profile enrichment |
| **Apify Saas Enrichment** | AI company enrichment from 15+ sources (~500K results for $5) | Batch enrichment when needed |

### Key Limitations
1. **No single Crunchbase replacement** — the free stack requires combining 4-5 tools to get Crunchbase-level data
2. **Funding data gap** — EU funding data is fragmented. SEC Form D covers US only. OpenVC/Dealroom is VC-centric.
3. **No news monitoring** — can be added via RSS feeds + Firecrawl for free
4. **Traffic data is estimated** — no tool matches SimilarWeb's paid accuracy
5. **Manual integration** — no single dashboard; data lives across multiple tools

### If We Had Budget ($50-100/month)
- **Upgrade Apify** ($5 → $50): More actor runs, premium actors
- **Dealroom.co founders program** (free if eligible): 6 months Premium access
- **OpenRegistry Pro** ($9/month): Higher rate limits for batch processing
- **SimilarWeb Scraper on Apify** ($3.50/1K results): More accurate traffic data

---

## PART 5: VERIFICATION SUMMARY

| Tool | Free Tier Exists? | Exact Limits | Commercial Use? | Sufficient for 25 Niches? | Deprecation Risk |
|---|---|---|---|---|---|
| Crunchbase (free) | Barely | 5-11 views/mo, no API | Paid only | Insufficient | Low |
| StartupWiki | Yes | Unknown (early stage) | Likely | Borderline | Medium |
| Apify Saas Enrichment | Yes (pay-per-result) | $0.01/1K results | Yes | Sufficient | Low |
| ExploreYC | Yes | Free key, limits unstated | Yes | Borderline (YC+a16z only) | Low-Med |
| OpenRegistry MCP | Yes | 20 req/min (anon), 30 (signed in) | Yes | Sufficient | Low |
| UK Companies House | Yes | 600 req/5 min | Yes | UK-only | Low |
| Funding Signals API | Yes | Free key, daily refresh | Yes | Borderline (US-only) | Medium |
| Teahose MCP | Yes | 1,000 req/day (with key) | Yes | Insufficient (AI focus) | Low |
| People Data Labs | Yes | 100 records/month | Yes | Insufficient (too few) | Low |
| OpenCorporates | Yes | 50 calls/day, no commercial | Restricted | Insufficient | Medium |
| Dealroom | Minimal | 3-day trial only | Restricted | Insufficient | Low |
| Tracxn | Yes | Unclear | Likely restricted | Unknown | Low |
| Apollo.io (free) | Yes | 50-100 credits/mo | Yes | Borderline | Low |
| SimilarWeb (free) | Yes | 15 actions/day | Yes | Insufficient | Low |
| Apify Traffic Analysis | Yes | Free, no key, unlimited? | Yes | Sufficient | Medium |
| Apify SW Scraper | Pay-per-result | $3.50/1K | Yes | Borderline | Medium |
| Apify SW Intelligence | Pay-per-result | $10/1K | Yes | Borderline | Medium |
| Open PageRank | Yes | 4.3M domains/day | Yes | Sufficient | Low |
| Ahrefs Free DR | Yes | Free, no unit consumption | Yes (attribution) | Sufficient | Low |
| Keywords Everywhere | Yes | Daily allowance (unstated) | Yes | Borderline | Low |
| SEO Review Tools | Yes | Unlimited manual | Yes | Programmatic: No | Low |
| Matomo/Umami | Yes (self-hosted) | Unlimited (own sites only) | Yes | Wrong category | Low |
