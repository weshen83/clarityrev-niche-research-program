# C1e: Free Alternatives to PitchBook/CB Insights + IBISWorld/Statista

**Date:** 2026-07-23
**Status:** Research Complete
**Context:** ClarityRev — Revenue Intelligence startup researching 25 B2B niches (primarily European/Benelux)

**Already Owned:** Firecrawl (100K credits), DataForSEO ($50), Context7 MCP, 15+ MCP servers, BuiltWith, Wappalyzer, Hunter.io, Reddit API, OpenAlex, Apollo.io free tier

---

## PART A: PITCHBOOK / CB INSIGHTS ALTERNATIVES (Funding & Startup Data)

---

### 1. SEC EDGAR API (Form D)
- **URL:** https://www.sec.gov/edgar
- **Type:** Government API — completely free, no API key required
- **Free tier limits:** 10 requests/second max; no monthly quota. Must send a declared User-Agent header with contact info.
- **Commercial use:** Allowed — US government data is public domain
- **Sufficiency for 25 niches:** Insufficient alone — covers US-only private placements under Regulation D. EU companies not included. No investor identities or valuations. But as a supplementary free signal source for US-based target companies, it is excellent.
- **Data freshness:** Filings due within 15 days of first sale; data appears in EDGAR within minutes of acceptance
- **Deprecation risk:** Low — SEC is a government agency; the API is stable and well-documented
- **Notes:** Every US company raising private capital (seed through Series C+) must file Form D. You get exact raise amounts, issuer name, industry category, date of first sale, number of investors. You do NOT get: investor identities, valuations, or share prices. ~35% of filings are pooled investment funds (not operating companies) — needs filtering. ~30% are amendments, not new raises. For EU/Benelux coverage, you need other sources. Can be combined with Apify actors for structured output (see below).

---

### 2. Crunchbase Free Tier (Web Platform)
- **URL:** https://www.crunchbase.com
- **Type:** Free tier (web only, no API)
- **Free tier limits:** ~11 profile views per month. No exports, no alerts, no advanced search filters, no predictions, no CRM integrations.
- **Commercial use:** Allowed (within those limits)
- **Sufficiency for 25 niches:** Insufficient — 11 profile views/month is too restrictive for systematic research across 25 niches. At most useful for occasional lookups of a specific company.
- **Data freshness:** Paid plans have 30-day signals; free tier likely lags further
- **Deprecation risk:** Medium — the free tier has been progressively restricted (API killed in 2025); further erosion likely
- **Notes:** Crunchbase killed its free API entirely as of 2025. The free web tier is a "taste" only. Crunchbase Pro ($49/month annual, 2,000 exports/month) is the cheapest useful plan but still limited. For systematic niche research, this is not sufficient on the free tier. Consider Zorepo or OpenPitch instead.

---

### 3. OpenPitch (MCP Server — Open Source)
- **URL:** https://github.com/avierovich/openpitch (MCP: `avierovich-openpitch` on LobeHub)
- **Type:** Open source (MIT License) MCP-native intelligence layer
- **Free tier limits:** Completely free — no API key, no signup. Runs on free GitHub Actions. Data committed as plain JSON in the repo. Use via `uvx --from openpitch openpitch-mcp` or `pip install openpitch`.
- **Commercial use:** Allowed (MIT License)
- **Sufficiency for 25 niches:** Borderline — currently covers ~50 top AI startups dynamically selected by VC attention (valuation + funding + investor quality), plus a MENA segment. For general B2B niches (not AI-specific), coverage is likely too narrow. However, the architecture is extensible and open source — you could fork and point at your own niche.
- **Data freshness:** Daily pipeline via GitHub Actions
- **Deprecation risk:** Medium — v0.1.0, early-stage project. Active but single-maintainer risk. Could become unmaintained. However, since it's open source and runs entirely on free infrastructure, it won't "break" overnight.
- **Notes:** Strengths: fully sourced and confidence-scored data, contradiction detection, version-tracked audit log. Weaknesses: narrow coverage (AI-focused), early version. Best used as a supplementary intelligence layer for AI-startup-related niches, not as primary funding data source for general B2B niches.

---

### 4. Zorepo
- **URL:** https://zorepo.com (Product Hunt: https://www.producthunt.com/products/zorepo)
- **Type:** Free forever — AI-powered startup database
- **Free tier limits:** "Core search & export will be free forever." No credit card required. Exact query/export limits not specified in available docs.
- **Commercial use:** Presumably allowed (no restrictions found)
- **Sufficiency for 25 niches:** Potentially sufficient — positions itself as a completely free Crunchbase alternative. Uses multi-source scraping + LLM entity resolution from news, filings, and socials. Self-healing models flag inconsistencies.
- **Data freshness:** Not specified — likely near-real-time given the scraping pipeline
- **Deprecation risk:** High — this appears to be a newer/smaller player. No large institutional backing visible. Business model unclear (how do they sustain "free forever"?). Risk of shutdown or tier reduction.
- **Notes:** Could be a strong option if it delivers on its promises. Recommended approach: test immediately for your top 3 niches to validate coverage and data quality. If good, use as primary Crunchbase alternative with SEC EDGAR as backup. If not, fall back to other tools.

---

### 5. DataSignals Lab MCP
- **URL:** https://apify.com/datasignalslab/datasignals-mcp
- **Type:** Freemium MCP server on Apify with free tier
- **Free tier limits:** 50 MCP calls/month. Tools `confluence_signals`, `resolve_company`, and `usage` are always free (don't count toward limit). Free previews of every report. Free weekly signal digest. No credit card required for free tier.
- **Commercial use:** Allowed (Apify platform terms)
- **Sufficiency for 25 niches:** Borderline — 50 calls/month is enough for occasional checks but not systematic monitoring of 25 niches. Upgrade to Pro ($29/month) gives 2,000 calls/month which would be sufficient.
- **Data freshness:** Real-time (SEC-based signals)
- **Deprecation risk:** Low-Medium — runs on Apify platform, has clear paid tier indicating sustainability. Medium risk if they change free tier terms.
- **Notes:** Includes a `startup_funding_form_d` tool that surfaces SEC Form D filings. Also includes company resolution and confluence signals. At $29/month for 2,000 calls, this is a cost-effective paid upgrade path that's still far cheaper than PitchBook.

---

### 6. Signal by NFX
- **URL:** https://signal.nfx.com
- **Type:** Free investor database
- **Free tier limits:** Completely free — ~18,830-20,000 curated VC investors. AI-powered investor matching, warm introduction path discovery, curated lists by sector/stage. Limited export functionality.
- **Commercial use:** Allowed (intended for startup fundraising use)
- **Sufficiency for 25 niches:** Insufficient for funding data — this is an investor database, not a funding/company database. However, it is excellent for the investor research component of niche analysis (who invests in what sectors/stages).
- **Data freshness:** Curated — updated periodically by NFX team
- **Deprecation risk:** Low — NFX is a well-known venture firm; Signal is a free tool they maintain as ecosystem investment. Stable.
- **Notes:** Not a substitute for PitchBook's company/funding data. Use as a supplementary tool when you need to identify which VCs invest in your target niches. Specifically useful for Benelux/European niche analysis if the database's coverage extends beyond US (check coverage before relying on it).

---

### 7. OpenVC
- **URL:** https://www.openvc.app
- **Type:** Freemium investor database
- **Free tier limits:** Core features free — 20,000+ verified investors (VCs, angels, family offices, accelerators). Unlimited search, deck sharing with analytics, fundraising CRM, unlimited team members. Downloadable dataset for offline/CRM use.
- **Commercial use:** Allowed for fundraising purposes
- **Sufficiency for 25 niches:** Insufficient for funding data — investor database only, not a company/funding database. Useful for investor discovery within niches.
- **Data freshness:** Ongoing curation
- **Deprecation risk:** Low-Medium — has a paid tier ($99/month Premium) indicating sustainability. Popular in startup ecosystem.
- **Notes:** Premium ($99/month or $299/year) adds outreach automation, auto-follow-ups, fundability tests. For ClarityRev's purposes, the free tier is sufficient for investor discovery. Export the dataset for CRM import.

---

### 8. Apify Company Funding Tracker (SEC Form D)
- **URL:** https://apify.com/automation-lab/company-funding-tracker
- **Type:** Pay-per-use Apify actor
- **Free tier limits:** No free usage — pay-per-result. $0.005 per run start cost + $3.00 per 1,000 filings ($1.80/1,000 with Gold discount). Apify's Free subscription plan covers platform usage costs.
- **Commercial use:** Allowed
- **Sufficiency for 25 niches:** Potentially sufficient for US coverage — at $3.00 per 1,000 filings, very cheap for bulk monitoring. Combined with SEC EDGAR raw access, this provides affordable structured funding data for US companies in any niche.
- **Data freshness:** Real-time (pulls from SEC EDGAR)
- **Deprecation risk:** Low — runs on Apify marketplace, actively maintained
- **Notes:** Structured output — cleaner than raw SEC EDGAR. Only US filings. For EU coverage you need other sources. If you're researching US-based companies in your niches, this is one of the cheapest structured data options available.

---

### 9. Apify Public Web Funding Signal
- **URL:** https://apify.com/coregent/funding-signal-finder-from-public-web
- **Type:** Pay-per-use Apify actor
- **Free tier limits:** No free usage — $4.00 per 1,000 results ($2.40/1,000 with Gold discount). Charges only for valid, unique funding-signal rows. Platform usage included on Free plan.
- **Commercial use:** Allowed
- **Sufficiency for 25 niches:** Potentially useful — finds funding signals from news, press releases, RSS feeds, and optional SEC Form D filings. Covers more sources than pure SEC EDGAR, including international sources. Returns source URL, amount, stage, investors, confidence score.
- **Data freshness:** Near-real-time (web monitoring)
- **Deprecation risk:** Low — Apify marketplace
- **Notes:** Broader coverage than pure SEC EDGAR (includes news/press releases from international sources). For EU/Benelux niches, this may pick up funding announcements that SEC filings miss. Cost is modest for targeted monitoring.

---

### 10. NVCA (National Venture Capital Association)
- **URL:** https://nvca.org
- **Type:** Free annual reports + PitchBook-NVCA Venture Monitor
- **Free tier limits:** Free Q2 2026 Venture Monitor report available. No investor directory — reports only.
- **Commercial use:** Allowed (public reports)
- **Sufficiency for 25 niches:** Insufficient as a data source — macro-level market context only. Not a substitute for PitchBook's company-level data.
- **Data freshness:** Quarterly reports
- **Deprecation risk:** Low — established industry association
- **Notes:** Useful for macro context of venture capital trends but not for individual company/niche funding data.

---

### 11. AngelList / Wellfound Free Tier
- **URL:** https://wellfound.com
- **Type:** Free browsing (no API)
- **Free tier limits:** Free to browse fund profiles, see deal-level investments, sector browsing. No export, no contact data, no portfolio conflict detection, no deal velocity data. Manual research intensive.
- **Commercial use:** Allowed (intended use)
- **Sufficiency for 25 niches:** Insufficient for systematic research — manual browsing only, no programmatic access, no free API. Labor-intensive to cover 25 niches. Best for ad-hoc investor lookups.
- **Data freshness:** Active ecosystem (Wellfound is actively used by startups)
- **Deprecation risk:** Low-Medium — Wellfound is an active platform but has increasingly focused on hiring over fundraising data
- **Notes:** No free API exists. Third-party scrapers (e.g., Apify Wellfound Scraper at $1.96/1,000 results) are available for structured access but at a cost. For ClarityRev's purposes, manual browsing is too slow for 25 niches.

---

### 12. Tracxn Free Tier
- **URL:** https://tracxn.com
- **Type:** Freemium
- **Free tier limits:** Limited free version exists — restricted exports, older UI, thinner data on early-stage. 5M+ companies, 3,000+ sectors, 50+ geographies.
- **Commercial use:** Allowed (within free tier limits)
- **Sufficiency for 25 niches:** Insufficient — free tier is too limited for systematic research. Paid plans at $500+/month are cheaper than PitchBook but still expensive for bootstrapped stage.
- **Data freshness:** Freemium data likely lags paid tiers
- **Deprecation risk:** Low — established company with institutional customers
- **Notes:** Tracxn's strength is emerging markets (India, SE Asia) and deep sector mapping. If your niches include emerging markets, the free tier may offer better value than Crunchbase. But for European/Benelux focus, other tools are more relevant.

---

### 13. SwitchPitch Explorer
- **URL:** https://switchpitch.com/news-explorer-launch.html
- **Type:** Free to start (startup discovery)
- **Free tier limits:** Free — unlimited users, AI-powered startup recommendations based on natural language descriptions. 20 startup recruits per challenge limit. No API. No pipeline management.
- **Commercial use:** Allowed
- **Sufficiency for 25 niches:** Insufficient for systematic research — designed for enterprise innovation teams sourcing startups for specific challenges, not for systematic funding data gathering across niches.
- **Data freshness:** Unknown
- **Deprecation risk:** Medium — free tier may be a lead generation funnel for their paid enterprise product
- **Notes:** Not a PitchBook alternative. Different use case. Included for completeness but likely irrelevant for ClarityRev's needs.

---

### 14. Dealroom.co
- **URL:** https://dealroom.co
- **Type:** Paid only (no free tier beyond trial)
- **Free tier limits:** No free tier. 3-day trial (50 export credits) or 14-day trial. Requires 3-seat minimum for paid plans.
- **Commercial use:** N/A (paid)
- **Sufficiency for 25 niches:** N/A — not free
- **Data freshness:** Strong (well-maintained platform)
- **Deprecation risk:** Low — established European startup intelligence platform (covers 2M-3.2M companies, 225K+ investors)
- **Notes:** Relevant because Dealroom is the best European-focused funding database. Paid plans start at ~$13,700/year for 3 seats — out of budget. But includes strong EU/Benelux coverage. Consider if funding becomes available.

---

## PART B: IBISWORLD / STATISTA ALTERNATIVES (Market Research & Industry Data)

---

### 1. Eurostat API (NACE Industry Data)
- **URL:** https://ec.europa.eu/eurostat/web/main/data/web-services
- **Type:** Government API — completely free, no registration required
- **Free tier limits:** No authentication required. Multiple API types: Statistics API (JSON-stat 2.0), SDMX 2.1 and 3.0, async API for large datasets, catalogue API. Rate limits exist but are undocumented.
- **Commercial use:** Allowed — EU open data license (Creative Commons BY or similar). Check specific dataset licenses. Attribution required.
- **Sufficiency for 25 niches:** Sufficient — Eurostat provides comprehensive EU industry statistics by NACE code (the EU equivalent of NAICS). Covers employment, production, turnover, and other key metrics across all industry sectors. Since ClarityRev focuses on European/Benelux niches, this is one of the most directly relevant free sources.
- **Data freshness:** Varies by dataset — some annual, some quarterly. Typically ~6-18 month lag.
- **Deprecation risk:** Low — EU government infrastructure, stable and well-maintained
- **Notes:** **Top recommendation for EU industry data.** NACE codes map cleanly to industry categories. For Benelux-specific niches, this is the canonical free source. Combine with national statistical offices of Netherlands (CBS), Belgium (Statbel), and Luxembourg (STATEC) for deeper local data. API is SDMX-based which requires some technical setup but is well-documented.

---

### 2. OECD Data API
- **URL:** https://www.oecd.org/en/data/insights/data-explainers/2024/09/api.html
- **Type:** Government API — completely free, no authentication required
- **Free tier limits:** No authentication required. Rate limiting implemented (no documented numeric limit) — "use the service responsibly." Recommended: add 1s delay between requests for bulk jobs.
- **Commercial use:** Allowed — subject to OECD Terms and Conditions. CC BY 4.0 for most data.
- **Sufficiency for 25 niches:** Borderline-sufficient — OECD data is macro-level (GDP, productivity, innovation, trade by industry) rather than granular market sizing. Good for cross-country comparisons and macro context for each niche. Not a substitute for IBISWorld's detailed industry reports.
- **Data freshness:** Annual for most industry data. Some quarterly for macro indicators.
- **Deprecation risk:** Low — established international organization
- **Notes:** OECD data is authoritative and methodologically rigorous. Best used as a macro-context layer: industry productivity trends, R&D spending by sector, trade flows, digital economy indicators. Combine with Eurostat for EU-level granularity. The SDMX-based API requires some technical investment.

---

### 3. US Census Bureau API (NAICS Industry Data)
- **URL:** https://www.census.gov/data/developers/data-sets.html
- **Type:** Government API — free
- **Free tier limits:** 500 requests/day without API key. Free API key (sign up online) removes daily limit. County Business Patterns data by NAICS code (2- to 6-digit). Data on establishments, employment, payroll at national/state/county/ZIP level.
- **Commercial use:** Allowed — with attribution: "This product uses the Census Bureau Data API but is not endorsed or certified by the Census Bureau." Must not identify individuals/households.
- **Sufficiency for 25 niches:** Borderline-sufficient — excellent for US industry context but ClarityRev focuses on European/Benelux. For any US companies in your niches, the CBP data is gold-standard free data. For EU niches, use Eurostat instead.
- **Data freshness:** County Business Patterns: annual, ~1 year lag. Economic Census: every 5 years (2022 is latest).
- **Deprecation risk:** Low — US federal government
- **Notes:** For US industry data, this is the best free alternative to IBISWorld. The Economic Census provides the most comprehensive industry data every 5 years. For ClarityRev's Benelux focus, use this only if your niche analysis crosses into US markets.

---

### 4. Bureau of Labor Statistics (BLS) API
- **URL:** https://www.bls.gov/developers/home.htm
- **Type:** Government API — free
- **Free tier limits:** v1: 25 series/day, 10 series/request, 10 years of data. v2 (free key): 500 queries/day, 50 series/request, 20 years of data.
- **Commercial use:** Allowed — public domain data. No attribution required.
- **Sufficiency for 25 niches:** Borderline-sufficient for US niches — provides employment and wage data by NAICS industry code. Not a substitute for IBISWorld's market sizing reports. Provides context (industry employment trends, wage benchmarks) but not market size/revenue data directly.
- **Data freshness:** Monthly for CES (Current Employment Statistics). Quarterly for QCEW. ~1-6 month lag.
- **Deprecation risk:** Low — US federal government
- **Notes:** BLS data is public domain and can be freely used commercially. Best for: employment trends by industry, wage benchmarks for roles in your target niches, regional concentration analysis. Combine with Census Bureau data for a fuller picture of US industries.

---

### 5. FRED API (Federal Reserve Economic Data)
- **URL:** https://fred.stlouisfed.org/docs/api/fred/
- **Type:** Free API (requires free API key)
- **Free tier limits:** 800,000+ economic time series. 120 requests/minute per API key. ~6,000 requests/day.
- **Commercial use:** **Restricted** — free tier is for non-commercial use only. No AI/ML training. No caching or archiving. Attribution required. No paid enterprise tier available.
- **Sufficiency for 25 niches:** Borderline (with caveat) — provides GDP, CPI, industry output, productivity, employment, and financial data at macro level. Useful for macro context around each niche. But the non-commercial restriction is a problem for ClarityRev.
- **Data freshness:** Varies — daily, weekly, monthly, quarterly, annual depending on series
- **Deprecation risk:** Low — Federal Reserve Bank of St. Louis
- **Notes:** **Commercial use restriction is a dealbreaker** unless you're using it purely for internal research and not building the data into a product. For internal niche screening (not redistributing the data), the risk may be acceptable. The TAM-MCP-Server wraps FRED and other sources; check its compliance posture.

---

### 6. World Bank API
- **URL:** https://data.worldbank.org/developers
- **Type:** Government API — completely free, no API key required
- **Free tier limits:** No API key required for standard use. Optional registration for higher rate limits. 16,000+ development indicators across 200+ economies. 50 records/page default (can increase to 1,000).
- **Commercial use:** Allowed — CC BY 4.0 license. Attribution required.
- **Sufficiency for 25 niches:** Borderline-sufficient — provides macro-economic and development data by country/region. Useful for: GDP per capita trend data for target countries, industry value-add as % of GDP, ease of doing business indicators, startup ecosystem metrics. Not granular enough for market sizing within specific B2B niches.
- **Data freshness:** Annual for most indicators; some quarterly. Varies by indicator.
- **Deprecation risk:** Low — international organization
- **Notes:** Best used as a macro-economic overlay: "What is the size and growth rate of the economy where this niche operates?" Not a substitute for industry-specific market research. Combine with Eurostat for EU granularity.

---

### 7. Helgi Library
- **URL:** https://www.helgilibrary.com
- **Type:** Freemium statistics portal
- **Free tier limits:** "Plenty of free information" including free reports and charts. 180+ countries, 30+ sectors, 500+ companies, 5M+ data points. Paid options: pay-per-indicator at $2.99 each, or monthly subscription.
- **Commercial use:** Restricted — free tier likely limited to personal/non-commercial use. Check their terms.
- **Sufficiency for 25 niches:** Potentially borderline — the free tier's sector coverage (30 sectors) and country coverage (180+) is broad. However, free tier limits and data depth (5M datapoints across 30 sectors = ~167K datapoints/sector, which is thin for deep analysis) need testing.
- **Data freshness:** Not specified — likely periodic updates
- **Deprecation risk:** Medium — smaller platform, sustainability unclear
- **Notes:** Positioned as an affordable alternative to Statista. The pay-per-indicator model ($2.99) could be useful for targeted data points. Recommended approach: test for 3 sample niches to assess free tier utility before relying on it. If free tier is too limited, the subscription may still be cheaper than Statista.

---

### 8. Qoery.com
- **URL:** https://qoery.com
- **Type:** AI-powered freemium data engine
- **Free tier limits:** 250 queries/month on free tier. Indexes 50M+ observations, 1.2M+ series from ~10,000 sources (World Bank, Eurostat, OECD, etc.). Returns structured CSV. API access available (Python, JS, cURL).
- **Commercial use:** Check their terms — early-stage platform
- **Sufficiency for 25 niches:** Borderline — 250 queries/month is enough for initial research across 25 niches (~10 queries/niche for basic data). But not enough for ongoing monitoring. Paid plans likely needed for sustained use.
- **Data freshness:** Varies by source (pulls from existing public datasets)
- **Deprecation risk:** High — early-stage startup (just launched on Product Hunt). Very high risk of free tier changes or shutdown.
- **Notes:** Hacker News launch positions it as "killing Statista's $490/month model." Focused on economic and demographic data — not industry-specific market sizing. Some early-user reports of occasional query failures. Promising but unproven. Use as a discovery tool, not a production data source.

---

### 9. OpenAlex API
- **URL:** https://openalex.org
- **Type:** Open access (CC0) scholarly data — free
- **Free tier limits:** 100,000 requests/day, max 10 requests/second. Full data snapshot available for download (CC0, monthly updates). Premium/Institutional subscriptions available for higher throughput.
- **Commercial use:** Allowed — CC0 license. No restrictions on commercial use. Can redistribute.
- **Sufficiency for 25 niches:** Insufficient for market sizing — OpenAlex is a scholarly database (research papers, authors, institutions, topics). Does NOT provide company funding data or market research reports. However, it is **very useful for academic research on industries**: research output by topic, expert identification, institutional research centers relevant to each niche.
- **Data freshness:** Monthly data updates
- **Deprecation risk:** Low — nonprofit (OurResearch), well-funded, broadly adopted
- **Notes:** ClarityRev already has OpenAlex. Keep in the toolkit as a research discovery tool (who publishes on what topics, which institutions lead research in a niche). Not a substitute for IBISWorld/Statista but a complementary intelligence layer for the "research ecosystem" aspect of niche analysis.

---

### 10. TAM-MCP-Server
- **URL:** https://github.com/gvaibhav/TAM-MCP-Server
- **Type:** Open source (MIT) MCP server
- **Free tier limits:** Free and open source. Integrates 8 free data sources (Alpha Vantage, BLS, Census, FRED, IMF, Nasdaq Data Link, OECD, World Bank). 28 tools across 3 tiers. Each source's free tier limits apply individually.
- **Commercial use:** Allowed — MIT License. But downstream data source terms apply (e.g., FRED is non-commercial).
- **Sufficiency for 25 niches:** Potentially useful — wraps multiple government data sources into a single MCP interface. Can do TAM/SAM calculations, market size estimation, industry analysis. Useful as a ClarityRev internal tool for initial niche market sizing.
- **Data freshness:** Depends on each source (BLS monthly, Census annual, FRED daily/weekly)
- **Deprecation risk:** Low-Medium — open source, maintained by community
- **Notes:** **Highly relevant for ClarityRev.** Since ClarityRev already uses MCP servers, this integrates naturally into the stack. Run `npx @gvaibhav/tam-mcp-server` and connect it. Note: the `MARKET_DATA_API_KEY` env var is only needed if you want to integrate with paid sources (IBISWorld, Statista, Grand View Research) — the free government sources work without it. The Alpha Vantage integration (25 requests/day free) is the tightest bottleneck.

---

### 11. Insights Association Resource Library
- **URL:** https://www.insightsassociation.org/Resources/Reports-Library
- **Type:** Free reports (membership-based)
- **Free tier limits:** Several free full-length industry reports available, including "GDQ Data Quality Benchmarking Report (H1 2026)" and "The U.S. Insights & Analytics Industry Report (2025)." Most reports likely require membership for full access.
- **Commercial use:** Check individual report licenses
- **Sufficiency for 25 niches:** Insufficient for systematic niche research — limited number of free reports covering specific topics, not a comprehensive alternative to IBISWorld.
- **Data freshness:** Varies; some 2025/2026 reports available
- **Deprecation risk:** Low — established trade association
- **Notes:** Useful for market research industry context but not a substitute for IBISWorld's 700+ industry coverage.

---

### 12. Valye
- **URL:** https://valye.com
- **Type:** Free AI-powered public company research
- **Free tier limits:** Free — AI-powered reports on public companies. Covers fundamentals, filings, business drivers, market developments. No obvious limits mentioned.
- **Commercial use:** Presumably allowed (check terms)
- **Sufficiency for 25 niches:** Insufficient — covers public companies only. Most of ClarityRev's target niches involve private companies. Not a substitute for IBISWorld's private industry coverage.
- **Data freshness:** Real-time for public company data
- **Deprecation risk:** Medium — newer platform
- **Notes:** Useful only for the public company angle of niche research (e.g., if a niche is dominated by public companies or if you need public competitor benchmarks).

---

### 13. Statista Free Tier
- **URL:** https://www.statista.com
- **Type:** Freemium
- **Free tier limits:** Limited access to selected historical statistics, industry overviews, and market size summaries. Download limited to PNG/PDF. No CSV/XLS/PPT. Limited Research AI tool access. No full reports.
- **Commercial use:** Not allowed on free tier — basic plan at $400-600/year is needed for commercial use.
- **Sufficiency for 25 niches:** Insufficient on free tier — too restricted. The basic paid plan ($400-600/year) is affordable for a bootstrapped startup and might be worth considering for 25 niche reports.
- **Data freshness:** Varies; some data updated regularly
- **Deprecation risk:** Low — established company
- **Notes:** Statista's $49/month (annual) basic plan is actually quite affordable compared to IBISWorld ($2,850/report) or PitchBook ($20K+/year). For ClarityRev's budget, the basic paid plan could be a worthwhile investment for market sizing data across 25 niches. Question: is it better to buy Statista basic or build from free government APIs? If time is the constraint, Statista basic ($49/month) saves significant engineering time vs. custom API integration.

---

### 14. IBISWorld Free Snapshots
- **URL:** https://www.ibisworld.com
- **Type:** Free teaser
- **Free tier limits:** Brief free snapshots of US industries with key figures (revenue, employment, growth rate, major players). Extremely limited — essentially a "taste" to encourage purchase of full reports ($2,850 each).
- **Commercial use:** Not applicable (too limited)
- **Sufficiency for 25 niches:** Insufficient — the free snapshots provide a 2-3 sentence overview. Not usable for systematic research.
- **Data freshness:** Reports updated periodically
- **Deprecation risk:** N/A
- **Notes:** IBISWorld reports are the gold standard for US industry analysis but are prohibitively expensive for a bootstrapped startup. Do not rely on the free snapshots.

---

### 15. Library Access (Business Source Complete, etc.)
- **URL:** Via academic/public library portals
- **Type:** Institutional subscription access (not free to public)
- **Free tier limits:** Free if you have university/public library access. Includes: Business Source Complete (industry/market research reports from Datamonitor, country reports, SWOT analyses), Mergent Intellect/First Research (200+ industry reports), SimplyAnalytics, S&P Global NetAdvantage, Mintel reports, Passport (Euromonitor), and sometimes IBISWorld itself.
- **Commercial use:** Restricted — academic licenses typically prohibit commercial use. Personal research and academic use only.
- **Sufficiency for 25 niches:** Potentially useful for initial research (non-commercial). If a founder or team member has university library access, this can be a goldmine for initial niche screening.
- **Data freshness:** Varies by database
- **Deprecation risk:** N/A (library subscriptions active if available)
- **Notes:** **If anyone on the team has university alumni library access, this is the single best free resource.** Business Source Complete alone provides thousands of Datamonitor industry reports that are comparable to IBISWorld in quality (though more concise). Check your local public library — many subscribe to business databases. Note: commercial use restrictions mean you cannot use this data in client-facing deliverables, but it's fine for internal niche assessment.

---

## PART C: SYNTHESIS & RECOMMENDATIONS

### Recommended Free/Low-Cost Stack for ClarityRev

| Need | Primary Tool | Cost | Backup Tool | Cost |
|---|---|---|---|---|
| **EU industry data (market sizing)** | Eurostat API (NACE) | Free | CBS/Statbel/STATEC national stats | Free |
| **US industry data (market sizing)** | Census Bureau API + BLS API | Free | TAM-MCP-Server (wraps both) | Free |
| **EU startup funding data** | Dealroom (paid) - out of budget for now | $13.7K/yr | News scraping (Apify $4/1K results) + manual | ~$20-50/mo |
| **US startup funding data** | SEC EDGAR API (raw) | Free | Apify Company Funding Tracker | ~$3/1K filings |
| **Free Crunchbase alternative** | Zorepo | Free (test first) | SwitchPitch Explorer | Free |
| **Investor discovery** | Signal by NFX | Free | OpenVC | Free |
| **AI-native funding intelligence** | OpenPitch (open source MCP) | Free | DataSignals Lab MCP | 50 calls/mo free |
| **Macro-economic context** | World Bank + OECD APIs | Free | Qoery.com (250 queries/mo free) | Free |
| **Academic/research ecosystem** | OpenAlex (already owned) | Free (100K req/day) | — | — |
| **Market sizing MCP (all-in-one)** | TAM-MCP-Server | Free (MIT) | — | — |

### Most Cost-Effective Paid Upgrade (when budget allows)

1. **Statista Basic Plan** ($49/month or $400-600/year) — single most cost-effective paid upgrade for market sizing across all 25 niches
2. **DataSignals Lab MCP Pro** ($29/month) — 2,000 calls/month for funding signals, cheap enough to run continuously
3. **Apify Platform credits** (~$50/month) — for running funding signal and company data actors

### Key Gaps (Unresolvable with Free Tools)

1. **European private company valuations** — no free source. Only Dealroom, PitchBook, or Sifted Pro provide this.
2. **Comprehensive company-level financials for private EU companies** — limited even with paid tools.
3. **Real-time funding monitoring for EU startups** — SEC EDGAR covers US only. EU equivalents (if they exist) vary by country.
4. **Benelux-specific industry deep-dives** — national statistical offices provide good macro data but not the "industry report" format IBISWorld offers.

### Immediate Next Steps

1. **Test Zorepo** for 3 target niches — if coverage is good, adopt as primary Crunchbase alternative
2. **Set up Eurostat API connection** — fundamental for any EU niche research
3. **Install TAM-MCP-Server** in ClarityRev's MCP stack — provides market sizing tools via already-owned MCP infrastructure
4. **Evaluate OpenPitch** — if niche analysis includes AI startups, this is immediately useful; otherwise fork for other niches
5. **Check team members' library access** — if anyone has university affiliation, get access to Business Source Complete for Datamonitor industry reports
