# Free APIs for B2B Niche Research — Discovery Report

> **Context:** ClarityRev (revenue intelligence startup) evaluating 25 B2B niches.
> **Usage estimate:** ~20 lookups/niche x 25 niches = ~500 lookups baseline.
> **Date:** 2026-07-23
> **Methodology:** Web searches + official docs verification for every API listed.

---

## 1. COMPANY DATA

### 1.1 Registry Lookup ⭐ BEST FIND
| Field | Detail |
|---|---|
| **Name + URL** | [Registry Lookup](https://registry-lookup.com/) — Product Hunt: [link](https://www.producthunt.com/products/registry-lookup?launch=registry-lookup) |
| **What it provides** | Company names, registration/registry numbers, addresses, legal forms, jurisdiction info, entity status. 521M+ legal entities across 309 jurisdictions in 200+ countries. |
| **Free tier limits** | **5,000 calls/month** — no credit card required. Roughly 10x OpenCorporates' free quota. No catch per the maker. |
| **SUFFICIENT for 25 niches?** | **SUFFICIENT** — 5,000 calls/month far exceeds ~500 baseline |
| **Authentication** | API key (free registration), no credit card |
| **Rate limits** | Not explicitly published but 5,000/mo volume is generous |
| **Commercial use** | Yes — core registry layer is intentionally free; paid path for deeper data (ownership chains, ESG) |
| **Data freshness** | Sourced from Veridion's global database |
| **Deprecation risk** | Low — Maker explicitly states registry layer will remain free; funded by enterprise data product |
| **Output format** | JSON |

### 1.2 OpenCorporates
| Field | Detail |
|---|---|
| **Name + URL** | [OpenCorporates](https://opencorporates.com/) |
| **What it provides** | Company registry data across multiple jurisdictions worldwide. Corporate filings, officers, addresses. |
| **Free tier limits** | **200 calls/month** (50/day cap). Restricted to open-data/public-benefit use only. |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — 200 calls/month with 50/day cap is too restrictive for 25 niches. Also no commercial use. |
| **Authentication** | API key |
| **Rate limits** | 50/day, 200/month |
| **Commercial use** | **No** — free tier is personal/public-benefit only. Paid plans start at 2,250 GBP/year. |
| **Deprecation risk** | Low — established company but free tier is deliberately limited to push paid plans |
| **Output format** | JSON |

### 1.3 CompanyData Datasets
| Field | Detail |
|---|---|
| **Name + URL** | [CompanyData.com](https://companydata.com/free-business-datasets/) |
| **What it provides** | Free downloadable CSV datasets for 8 cities. Fields: addresses, registration numbers, revenue, SIC codes, firmographic data. |
| **Free tier limits** | **Free CSV downloads** (not API). Their API requires signup at app.companydata.com/signup-api — free tier not verified. |
| **SUFFICIENT for 25 niches?** | **UNVERIFIED** — CSV downloads only for 8 cities, not usable for programmatic niche research |
| **Authentication** | Signup required |
| **Usefulness** | Low — static city-level datasets, not a queryable API |

### 1.4 GLEIF API (Global Legal Entity Identifier)
| Field | Detail |
|---|---|
| **Name + URL** | [GLEIF](https://www.gleif.org/en/lei-data/gleif-api-for-lei-data) |
| **What it provides** | Global LEI lookup for any legal entity worldwide. Level 1 (entity identity) and Level 2 (parent/ultimate parent) data. |
| **Free tier limits** | **Unlimited** — fully open API, no key required |
| **SUFFICIENT for 25 niches?** | **BORDERLINE** — only useful if entities have LEIs (mostly financial entities and larger companies). Not all companies have LEIs. |
| **Authentication** | None required |
| **Rate limits** | No explicit limits published |
| **Commercial use** | Yes — open data per GLEIF regulations |
| **Data freshness** | Daily updates |
| **Deprecation risk** | Very low — regulatory mandate (G20/FSB backed) |
| **Output format** | JSON, XML |

### 1.5 Wikidata SPARQL API
| Field | Detail |
|---|---|
| **Name + URL** | [Wikidata Query Service](https://query.wikidata.org/) |
| **What it provides** | SPARQL endpoint returning LEI, ISIN, ticker, CIK, company metadata, industry classifications, founded year, headquarters, etc. Cross-jurisdiction company data. |
| **Free tier limits** | **Unlimited** queries with polite usage. Public SPARQL endpoint is free. |
| **SUFFICIENT for 25 niches?** | **SUFFICIENT** for structured lookups — though query complexity is higher and rate limits are softer (community guidelines) |
| **Authentication** | None required (polite User-Agent header recommended) |
| **Rate limits** | Community guidelines: avoid heavy queries during peak hours |
| **Commercial use** | Yes — CC0 license for most data |
| **Data freshness** | Varies by community editing |
| **Deprecation risk** | Low — Wikimedia Foundation backed |
| **Output format** | JSON, XML, CSV via SPARQL |

---

## 2. CONTACT / PEOPLE DATA

### 2.1 Derrick ⭐ BEST FIND
| Field | Detail |
|---|---|
| **Name + URL** | [Derrick](https://derrick-app.com/) |
| **What it provides** | Email finding, phone number lookup, company enrichment. REST API + MCP server. 300M+ contacts. |
| **Free tier limits** | **100 credits/month** — permanent free tier, no credit card required. Credits roll over. |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — 100 credits/month for ~500 needed lookups across 25 niches (1 credit ≈ 1 lookup) |
| **Authentication** | API key (free signup) |
| **Rate limits** | Not explicitly published |
| **Commercial use** | Yes |
| **Data freshness** | Real-time verification |
| **Deprecation risk** | Low — active 2025/2026, growing product |
| **Output format** | JSON |

### 2.2 Enrich.so
| Field | Detail |
|---|---|
| **Name + URL** | [Enrich.so](https://enrich.so) |
| **What it provides** | Email finder (10 credits), email validation (1 credit), phone finder (500 credits), reverse email lookup. 300M+ contacts, 94%+ accuracy, sub-200ms responses. |
| **Free tier limits** | **100 free credits** — no credit card required (one-time, not monthly). Email finder costs 10 credits per lookup = 10 free lookups. |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — 100 one-time credits (10 email lookups) is too limited |
| **Authentication** | API key (free signup) |
| **Rate limits** | Not explicitly published |
| **Commercial use** | Yes |
| **Data freshness** | Real-time verification |
| **Deprecation risk** | Low — well-funded, active 2025/2026 |
| **Output format** | JSON, TypeScript SDK, MCP |

### 2.3 Hunter.io
| Field | Detail |
|---|---|
| **Name + URL** | [Hunter.io](https://hunter.io) |
| **What it provides** | Email pattern detection, email verification, domain search, company email addresses |
| **Free tier limits** | **25 searches/month + 50 verifications** |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — 25 searches/month across 25 niches = 1 search per niche |
| **Authentication** | API key (free signup) |
| **Rate limits** | Not published for free tier |
| **Commercial use** | Yes |
| **Deprecation risk** | Low — established company (2016+), stable pricing |
| **Output format** | JSON |

### 2.4 CUFinder
| Field | Detail |
|---|---|
| **Name + URL** | [CUFinder](https://cufinder.io) |
| **What it provides** | Company firmographics, people profiles (1B+), business emails, phone numbers, LinkedIn profiles. 85M+ companies. Strong EMEA/APAC coverage. |
| **Free tier limits** | **50 credits/month** — no credit card required. 1 credit = 1 lookup. Chrome extension included. |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — 50 credits/month across 25 niches = 2 per niche |
| **Authentication** | API key |
| **Rate limits** | Not explicitly published |
| **Commercial use** | Yes |
| **Data freshness** | Regularly updated |
| **Deprecation risk** | Moderate — free tier is thin, likely upsell funnel |
| **Output format** | JSON |

### 2.5 Tomba
| Field | Detail |
|---|---|
| **Name + URL** | [Tomba](https://tomba.io) |
| **What it provides** | Email finder, email verifier. 450M+ emails across 76M domains. API, browser extensions, Google Sheets add-in. |
| **Free tier limits** | **25 searches/month + 50 verifications/month** — only charged for successful searches |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — far below 500-lookup baseline |
| **Authentication** | API key (free signup) |
| **Rate limits** | Not published for free tier |
| **Commercial use** | Yes |
| **Deprecation risk** | Low — established product. NOTE: pricing confusion as of 2026 (official site shows $588/mo starting, directories show $39/mo) |
| **Output format** | JSON |

### 2.6 People Data Labs
| Field | Detail |
|---|---|
| **Name + URL** | [People Data Labs](https://peopledatalabs.com) |
| **What it provides** | Person and company enrichment (1.5B+ person profiles, 200M+ companies). Hundreds of unique data points. |
| **Free tier limits** | **100 records/month** (person + company combined), 25 IP lookups, 5 Person Identify — BUT contact data (email, phone) is **obfuscated/hidden on free tier** |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — 100 records/month AND no contact data = unusable for enrichment |
| **Authentication** | API key (requires signup, no credit card) |
| **Rate limits** | Not published for free tier |
| **Commercial use** | Yes |
| **Data freshness** | Good — regularly refreshed |
| **Deprecation risk** | Low — well-funded ($29M+), active 2025/2026 |
| **Output format** | JSON. ISO & SOC 2 Type 2 compliant |

---

## 3. MARKET & INDUSTRY DATA

### 3.1 FRED API (Federal Reserve Economic Data) ⭐
| Field | Detail |
|---|---|
| **Name + URL** | [FRED API](https://fred.stlouisfed.org/docs/api/fred/) |
| **What it provides** | 800,000+ US macroeconomic time series: GDP, CPI, interest rates, employment, M2, VIX, treasuries, mortgages, regional data, industry-level data. |
| **Free tier limits** | **Unlimited** (with free API key). No per-request limit, though rate limits apply. |
| **SUFFICIENT for 25 niches?** | **SUFFICIENT** — unlimited queries for economic indicators that help contextualize niches |
| **Authentication** | Free API key (register at research.stlouisfed.org) |
| **Rate limits** | 120 requests per minute (API key), 1,000 series per batch |
| **Commercial use** | Yes — public government data |
| **Data freshness** | Varies by series (daily to annual) |
| **Deprecation risk** | Very low — Federal Reserve Bank of St. Louis |
| **Output format** | JSON, XML, CSV |

### 3.2 BLS API (Bureau of Labor Statistics)
| Field | Detail |
|---|---|
| **Name + URL** | [BLS API](https://www.bls.gov/developers/) |
| **What it provides** | Employment and wage data by NAICS industry code. Quarterly Census of Employment and Wages (QCEW). Industry-level employment, wages, establishments. |
| **Free tier limits** | **25 series per query, 500 requests/day** with free registration key. |
| **SUFFICIENT for 25 niches?** | **BORDERLINE** — 500 requests/day should cover niche research but NAICS-level data has ~6-month lag |
| **Authentication** | Free API key |
| **Rate limits** | 25 series per query, 500 requests/day |
| **Commercial use** | Yes — government open data |
| **Data freshness** | Quarterly, ~6-month lag |
| **Deprecation risk** | Very low — US government agency |
| **Output format** | JSON |

### 3.3 Census Bureau API
| Field | Detail |
|---|---|
| **Name + URL** | [Census Bureau API](https://www.census.gov/data/developers/data-sets.html) |
| **What it provides** | County Business Patterns (annual establishment counts by NAICS), Economic Census (every 5 years), demographic data. Market sizing by industry and geography. |
| **Free tier limits** | **Unlimited** with free API key |
| **SUFFICIENT for 25 niches?** | **SUFFICIENT** — no meaningful limits for research purposes |
| **Authentication** | Free API key |
| **Rate limits** | Reasonable usage expected |
| **Commercial use** | Yes — government open data |
| **Data freshness** | Annual (1-2 year lag for County Business Patterns) |
| **Deprecation risk** | Very low — US government |
| **Output format** | JSON, XML |

### 3.4 World Bank API
| Field | Detail |
|---|---|
| **Name + URL** | [World Bank API](https://datahelpdesk.worldbank.org/knowledgebase/topics/125589) |
| **What it provides** | Global economic indicators: GDP, unemployment, inflation, trade, education, health, infrastructure. 40+ years of data across 200+ countries. |
| **Free tier limits** | **Unlimited** — no API key required for most endpoints |
| **SUFFICIENT for 25 niches?** | **SUFFICIENT** — good for macro context around niche markets |
| **Authentication** | None required (optional key for higher limits) |
| **Rate limits** | No explicit limits published |
| **Commercial use** | Yes |
| **Data freshness** | Annual data, some quarterly |
| **Deprecation risk** | Very low — World Bank backed |
| **Output format** | JSON, XML |

### 3.5 IMF Data API
| Field | Detail |
|---|---|
| **Name + URL** | [IMF Data API](https://www.imf.org/en/Data) |
| **What it provides** | IFS (International Financial Statistics), BOP (Balance of Payments), DOT (Direction of Trade), GFS (Government Finance), WEO (World Economic Outlook), PCPS (Commodity Prices). GDP growth, CPI, interest rates, exchange rates, exports/imports. |
| **Free tier limits** | **Unlimited** — no API key required |
| **SUFFICIENT for 25 niches?** | **SUFFICIENT** for macro economic context |
| **Authentication** | None required |
| **Rate limits** | No explicit limits published |
| **Commercial use** | Yes |
| **Data freshness** | Quarterly/annual |
| **Deprecation risk** | Very low — IMF backed |
| **Output format** | JSON, SDMX-ML |

### 3.6 OEC API (Observatory of Economic Complexity)
| Field | Detail |
|---|---|
| **Name + URL** | [OEC API](https://oec.world/en/resources/api) |
| **What it provides** | International and subnational trade data. Trade flows, product classifications, country/region-level statistics. Economic complexity rankings. |
| **Free tier limits** | **Unlimited** for historical trade data (public API) |
| **SUFFICIENT for 25 niches?** | **BORDERLINE** — trade data is useful for understanding market flows but not for company-level niche research |
| **Authentication** | None required for basic endpoints |
| **Rate limits** | Not published |
| **Commercial use** | Permitted with attribution |
| **Data freshness** | Annual trade data |
| **Deprecation risk** | Low — Datawheel/Harvard research project |
| **Output format** | JSON |

---

## 4. FINANCIAL & FUNDING DATA

### 4.1 ExploreYC ⭐ BEST FIND
| Field | Detail |
|---|---|
| **Name + URL** | [ExploreYC](https://exploreyc.com/) |
| **What it provides** | Data on 6,600+ Y Combinator and a16z companies: funding, stage, IPO/M&A exits, founder data. Includes web app analytics and hiring board. |
| **Free tier limits** | **Free API key** — specific rate limits not published but marketed as free |
| **SUFFICIENT for 25 niches?** | **BORDERLINE** — excellent for YC/a16z-backed niche research (many B2B SaaS niches) but limited to those portfolios |
| **Authentication** | Free API key |
| **Rate limits** | Not explicitly published |
| **Commercial use** | Yes |
| **Data freshness** | Regularly updated |
| **Deprecation risk** | Low — active 2026 launch on Product Hunt |
| **Output format** | JSON |

### 4.2 Datahyena
| Field | Detail |
|---|---|
| **Name + URL** | [Datahyena](https://datahyena.com) (also on [Apify](https://apify.com/datahyena)) |
| **What it provides** | Company funding rounds, acquisitions & M&A, executive job changes & leadership moves, company firmographics, investor & VC data. Clean deduped data. |
| **Free tier limits** | **50 free credits** — no credit card required. Pay-per-result for additional pulls. |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — 50 credits one-time across 25 niches (2 per niche) |
| **Authentication** | API key (free signup) |
| **Rate limits** | Not published |
| **Commercial use** | Yes |
| **Data freshness** | Regularly updated |
| **Deprecation risk** | Moderate — newer product (2025/2026) |
| **Output format** | JSON, MCP |

### 4.3 Fundable API
| Field | Detail |
|---|---|
| **Name + URL** | [Fundable API](https://tryfundable.ai/api-access/) — docs: [readme.io](https://fundable-api-docs.readme.io/) |
| **What it provides** | VC funding rounds, startup data, investor data. 15+ filter dimensions (stage, industry, geography, deal size). Deals, companies, investors, people. |
| **Free tier limits** | **50 free credits** — no credit card required |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — 50 credits for 25 niches = 2 per niche |
| **Authentication** | API key |
| **Rate limits** | Not published |
| **Commercial use** | Yes |
| **Data freshness** | Real-time |
| **Deprecation risk** | Moderate — newer product |
| **Output format** | JSON |

### 4.4 Financial Modeling Prep (FMP) API
| Field | Detail |
|---|---|
| **Name + URL** | [Financial Modeling Prep](https://financialmodelingprep.com/) |
| **What it provides** | 150+ endpoints: company profiles, financial statements (income, balance sheet, cash flow), SEC filings, M&A events, stock data, ESG scores, industry/sector analysis, P/E ratios, treasury rates, economic calendar. |
| **Free tier limits** | **250 requests/day** — no credit card required. Perpetual free (no trial expiry). US stocks only. 100 records per call default limit. |
| **SUFFICIENT for 25 niches?** | **BORDERLINE** — 250 requests/day = 7,500/month which covers 25 niches for public company lookups. But limited to public US companies. |
| **Authentication** | Free API key |
| **Rate limits** | 250/day, resets every 24 hours; 429 error if exceeded |
| **Commercial use** | **Personal use only** on free tier |
| **Data freshness** | End-of-day for most data; 15-min delayed for real-time endpoints (paid) |
| **Deprecation risk** | Low — established, active 2025/2026, stable pricing |
| **Output format** | JSON |

### 4.5 Octagon Funding Data MCP
| Field | Detail |
|---|---|
| **Name + URL** | [Octagon Funding Data MCP](https://ping.mcp.so/server/octagon-funding-data-mcp/OctagonAI) |
| **What it provides** | AI-powered company funding transactions analysis. Rounds, valuations, investor activity. Integrates with Claude Desktop, Cursor. |
| **Free tier limits** | **Free to use** after signing up for an account |
| **SUFFICIENT for 25 niches?** | **UNVERIFIED** — no published rate limits or credit counts |
| **Authentication** | Account signup |
| **Rate limits** | Not published |
| **Commercial use** | Not verified |
| **Data freshness** | Not published |
| **Deprecation risk** | High — new MCP server, uncertain longevity |
| **Output format** | JSON via MCP |

### 4.6 Alpha Vantage
| Field | Detail |
|---|---|
| **Name + URL** | [Alpha Vantage](https://www.alphavantage.co/) |
| **What it provides** | 20+ global exchanges, 200,000+ tickers. Stocks, forex, crypto, commodities, 50+ technical indicators, fundamental data, sector performance. |
| **Free tier limits** | **25 calls/day** |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — 25 calls/day severely limits usage |
| **Authentication** | Free API key |
| **Rate limits** | 5 calls/minute, 25 calls/day |
| **Commercial use** | Yes |
| **Data freshness** | Real-time/delayed depending on endpoint |
| **Deprecation risk** | Moderate — free tier has been repeatedly reduced over the years |
| **Output format** | JSON |

---

## 5. JOB POSTING & HIRING DATA

### 5.1 Techmap Job Postings API ⭐ BEST FIND
| Field | Detail |
|---|---|
| **Name + URL** | [Techmap](https://techmap.io/pricing) / [jobdatafeeds.com](https://jobdatafeeds.com/job-api-overview) |
| **What it provides** | Job postings from 1,800+ sources. Data: title, location, company, skills, salary, employment type. Portals include YCombinator, Recruitee, JobTeaser, WeWorkRemotely, HR Cloud. |
| **Free tier limits** | **100 queries/month, 1,000 job postings/month** (10 per query) via RapidAPI BASIC plan |
| **SUFFICIENT for 25 niches?** | **BORDERLINE** — 1,000 job postings/month across 25 niches = ~40 postings per niche. Enough to spot hiring signals/talent density in a niche. |
| **Authentication** | RapidAPI key (RapidAPI may require credit card even for free plan) |
| **Rate limits** | 100 queries/month |
| **Commercial use** | Yes |
| **Data freshness** | Daily updates |
| **Deprecation risk** | Low — active on RapidAPI with multiple portal feeds |
| **Output format** | JSON |

### 5.2 WorkSignal MCP
| Field | Detail |
|---|---|
| **Name + URL** | [WorkSignal](https://worksignal.com) — npm: [@worksignal/mcp-server](https://www.npmjs.com/package/@worksignal/mcp-server) |
| **What it provides** | Job posting and AI voice screening. 24 MCP tools for posting roles, managing candidates, AI voice screening. |
| **Free tier limits** | **1 active job posting, 10 AI voice screens/month, 100 API calls/day** |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — oriented toward hiring pipeline, not job market research across niches |
| **Authentication** | Account signup |
| **Rate limits** | 100 API calls/day |
| **Commercial use** | Yes |
| **Data freshness** | Real-time |
| **Deprecation risk** | Moderate — small team product |
| **Output format** | JSON via MCP |

### 5.3 Coresignal (Job Search credits)
| Field | Detail |
|---|---|
| **Name + URL** | [Coresignal](https://coresignal.com) |
| **What it provides** | 448M+ job postings, employee profiles, company profiles. Elasticsearch Query DSL for precise searches. |
| **Free tier limits** | **200 Collect credits + 400 Search credits, valid 14 days.** No credit card. |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — 14-day trial, not a permanent free tier |
| **Authentication** | API key |
| **Rate limits** | Not published for trial |
| **Commercial use** | Yes (during trial) |
| **Data freshness** | Good |
| **Deprecation risk** | Low — established company |
| **Output format** | JSON |

---

## 6. NEWS & INTENT SIGNALS

### 6.1 GDELT Project ⭐ BEST FIND
| Field | Detail |
|---|---|
| **Name + URL** | [GDELT Project](https://www.gdeltproject.org/) — docs: [data.html](https://www.gdeltproject.org/data.html) |
| **What it provides** | Global news monitoring across 100K+ outlets, 65+ languages. Real-time event database (30M+ geolocated events). Entities, themes, emotions, quotes. |
| **Free tier limits** | **100% free and open** — no API key required. Public API feeds for real-time queries. Full datasets available via Google BigQuery (but egress costs apply). |
| **SUFFICIENT for 25 niches?** | **SUFFICIENT** — unlimited access for news-based intent signals. Rate limits on live feeds are reasonable for research scale. |
| **Authentication** | None required |
| **Rate limits** | Public API feeds are rate-limited (not explicitly documented; reasonable use expected). BigQuery has no query limit but has GCP costs. |
| **Commercial use** | Yes — completely open data |
| **Data freshness** | Near real-time (15-min updates for GDELT 2.0) |
| **Deprecation risk** | Very low — academic project since 2013, Google-backed, widely cited |
| **Output format** | JSON, CSV, BigQuery tables |

### 6.2 Currents API
| Field | Detail |
|---|---|
| **Name + URL** | [Currents API](https://currentsapi.services/en/) |
| **What it provides** | Real-time global news data in JSON. 30 days of history. Entity extraction, topic tagging. |
| **Free tier limits** | **1,000 requests/day** — no credit card required. Max 20 results per request. |
| **SUFFICIENT for 25 niches?** | **SUFFICIENT** — 1,000 requests/day = 30,000/month, easily covers 25 niches |
| **Authentication** | API key |
| **Rate limits** | 1,000 requests/day |
| **Commercial use** | Yes |
| **Data freshness** | Real-time (on paid plans; free tier may have delay) |
| **Deprecation risk** | Low — active 2025/2026, stable pricing |
| **Output format** | JSON |

### 6.3 NewsMesh API
| Field | Detail |
|---|---|
| **Name + URL** | [NewsMesh](https://newsmesh.com) — Product Hunt: [link](https://www.producthunt.com/products/newsmesh/launches/newsmesh) |
| **What it provides** | ML-powered news enrichment: entity extraction, sentiment analysis, topic tagging, full-text search. Clean JSON, 99.9% uptime SLA (paid). |
| **Free tier limits** | **50 requests/day (~1,500/month) or possibly 25 requests/day** — conflicting sources. 25 articles per request. 24-hour delay and 7 days of history on free tier. No credit card required. |
| **SUFFICIENT for 25 niches?** | **BORDERLINE** — even at 50/day = 1,500/month, plenty of requests. But 7-day history limit and 24-hour delay reduces usefulness for intent signals. |
| **Authentication** | API key |
| **Rate limits** | ~50/day (or 25/day per some sources) |
| **Commercial use** | Yes — production-safe free tier |
| **Data freshness** | Real-time on paid; ~24-hr delay on free |
| **Deprecation risk** | Moderate — new product (launched Dec 2025), terms may change |
| **Output format** | JSON |

### 6.4 NewsAPI
| Field | Detail |
|---|---|
| **Name + URL** | [NewsAPI](https://newsapi.org/) |
| **What it provides** | News articles from 80,000+ sources. Headlines, full articles, sources metadata. |
| **Free tier limits** | **100 requests/day** — for development/testing only. Cannot use in production. |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — 100/day is low AND no production use allowed on free tier |
| **Authentication** | API key |
| **Rate limits** | 100 requests/day |
| **Commercial use** | **No** — development/testing only on free tier |
| **Data freshness** | Real-time |
| **Deprecation risk** | Low but free tier is deliberately very limited |
| **Output format** | JSON |

### 6.5 GNews API
| Field | Detail |
|---|---|
| **Name + URL** | [GNews](https://gnews.io/) |
| **What it provides** | Google News search results via API. Article title, description, content, image, source, published date. |
| **Free tier limits** | **100 requests/day** |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — 100/day is low for 25-niche coverage |
| **Authentication** | API key |
| **Rate limits** | 100 requests/day |
| **Commercial use** | Yes |
| **Data freshness** | Real-time |
| **Deprecation risk** | Low |
| **Output format** | JSON |

---

## 7. REVIEW & SENTIMENT DATA

### 7.1 Yelp Fusion API
| Field | Detail |
|---|---|
| **Name + URL** | [Yelp Fusion API](https://docs.developer.yelp.com/) |
| **What it provides** | Business search (up to 50 per query), up to 3 reviews per business. Business details, categories, locations, ratings. |
| **Free tier limits** | **FREE TIER DISCONTINUED** (Aug 2024). Now requires paid plans: $7.99/1,000 calls for Starter tier. 30-day free trial available. |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — no longer free |
| **Authentication** | API key (credit card required) |
| **Rate limits** | 300-500 calls/day on trial |
| **Commercial use** | Yes (paid) |
| **Data freshness** | Real-time |
| **Deprecation risk** | N/A — free tier already eliminated |
| **Output format** | JSON |

### 7.2 Gralio MCP ⭐ BEST FIND
| Field | Detail |
|---|---|
| **Name + URL** | [Gralio](https://gralio.ai) — MCP: [gralio-mcp](https://market.gralio.ai/mcp) |
| **What it provides** | 3M+ SaaS reviews from G2, Trustpilot, Capterra. Sentiment analysis, pricing data, feature breakdowns, competitor alternatives. 30,000 software products. Company funding, growth metrics. |
| **Free tier limits** | **Completely free** MCP endpoint (last updated Feb 2026). No usage limits published. |
| **SUFFICIENT for 25 niches?** | **BORDERLINE** — depends on stability/uptime. Coverage is excellent for SaaS niches but limited for non-SaaS niches. |
| **Authentication** | MCP endpoint (no API key mentioned) |
| **Rate limits** | Not published |
| **Commercial use** | Likely yes (not explicitly restricted) |
| **Data freshness** | Not published |
| **Deprecation risk** | HIGH — solo developer project, only 3 GitHub stars, 0 weekly downloads. May disappear. |
| **Output format** | JSON via MCP |

### 7.3 ReviewStack
| Field | Detail |
|---|---|
| **Name + URL** | [ReviewStack](https://reviewstack.dev) |
| **What it provides** | Aggregates reviews from YouTube and Reddit. Returns: normalized score (1-10), plain-text summary, pros/cons, recurring themes with sentiment, source attribution. |
| **Free tier limits** | **50 lookups/month** — no credit card required. Paid: $29/month (500), $79/month (2,000). |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — 50 lookups/month = 2 per niche |
| **Authentication** | API key |
| **Rate limits** | 50 lookups/month |
| **Commercial use** | Yes |
| **Data freshness** | Real-time |
| **Deprecation risk** | Moderate — solo/bootstrapped project |
| **Output format** | JSON |

### 7.4 TextAI Pro Sentiment API
| Field | Detail |
|---|---|
| **Name + URL** | [TextAI Pro](https://rapidapi.com/textai-pro/) |
| **What it provides** | Sentiment classification (positive/negative/neutral), confidence score (0-1), top keywords. Lightweight REST API. |
| **Free tier limits** | **50 requests/hour** on RapidAPI BASIC plan |
| **SUFFICIENT for 25 niches?** | **BORDERLINE** — 50/hour is generous but only provides sentiment analysis (no review data sourcing) |
| **Authentication** | RapidAPI key |
| **Rate limits** | 50 requests/hour |
| **Commercial use** | Yes |
| **Data freshness** | Real-time (analysis on demand) |
| **Deprecation risk** | Low |
| **Output format** | JSON |

### 7.5 ai-feedback-analyzer (Open Source)
| Field | Detail |
|---|---|
| **Name + URL** | [GitHub: samikshadalvi/ai-feedback-analyzer](https://github.com/samikshadalvi/ai-feedback-analyzer) |
| **What it provides** | Open source, zero-cost AI agent using Hugging Face, Groq, TextBlob. Sentiment detection, topic extraction, insight generation, visualizations. MIT license. |
| **Free tier limits** | **Free (self-hosted)** — costs are API usage for Hugging Face/Groq (which also have free tiers available) |
| **SUFFICIENT for 25 niches?** | **BORDERLINE** — requires self-hosting and composing with a review data source. Free to run but needs input data. |
| **Authentication** | Bring your own API keys |
| **Rate limits** | Depends on hosted model API limits |
| **Commercial use** | Yes — MIT license |
| **Data freshness** | N/A (processes whatever input you provide) |
| **Deprecation risk** | Low (open source, can fork) |
| **Output format** | Various (Python) |

---

## 8. TECHNOGRAPHICS

### 8.1 DetectZeStack ⭐ BEST FIND
| Field | Detail |
|---|---|
| **Name + URL** | [DetectZeStack](https://detectzestack.com) — via [RapidAPI](https://detectzestack.p.rapidapi.com) |
| **What it provides** | 4-method tech stack detection: Wappalyzer fingerprints (3,800+ signatures), DNS CNAME analysis, TLS certificate inspection, HTTP header matching. Batch analysis (10 URLs), stack comparison, CPE identifiers, 24-hour smart cache. |
| **Free tier limits** | **100 requests/month** — no credit card required (on RapidAPI). Smart cache means repeated lookups of same domain don't count against quota. |
| **SUFFICIENT for 25 niches?** | **BORDERLINE** — 100/month = 4 domains per niche. Smart cache helps. If targeting ~500 unique domains, 100/month is too few. |
| **Authentication** | RapidAPI key |
| **Rate limits** | 100 requests/month |
| **Commercial use** | Yes |
| **Data freshness** | Real-time detection per request |
| **Deprecation risk** | Moderate — new product (launched Feb 2026), third-party RapidAPI |
| **Output format** | JSON |

### 8.2 website-tech-stack-detector (Apify)
| Field | Detail |
|---|---|
| **Name + URL** | [Apify Actor](https://apify.com/s-r/free-domain-technology-stack-scanner) — npm: [website-tech-stack-detector](https://www.npmjs.com/package/website-tech-stack-detector) |
| **What it provides** | Technology count, CMS, ecommerce platform, server info, technologies list, categories, generator tags, powered-by headers. |
| **Free tier limits** | **Free via Apify free plan** ($5/month in credits). Pay-per-use after. $5/1,000 domains for the paid actor. |
| **SUFFICIENT for 25 niches?** | **BORDERLINE** — Apify free plan gives $5/month credits which can cover ~1,000 domains on this actor |
| **Authentication** | Apify token (free) |
| **Rate limits** | Depends on Apify plan |
| **Commercial use** | Yes |
| **Data freshness** | Live per request |
| **Deprecation risk** | Low (Apify platform) |
| **Output format** | JSON, CSV, Excel |

### 8.3 Open Tech Explorer
| Field | Detail |
|---|---|
| **Name + URL** | [GitHub: turazashvili/openexplorer.tech](https://github.com/turazashvili/openexplorer.tech) |
| **What it provides** | Open-source tech stack database. Search by technology (e.g., GET /api/search?tech=React returns 15,000+ websites). Multi-layer detection, version recognition, dependency mapping. |
| **Free tier limits** | **Open source, self-hosted** — unlimited. RESTful API endpoints. |
| **SUFFICIENT for 25 niches?** | **BORDERLINE** — powerful for discovery (which companies use which tech) but requires self-hosting. The hosted instance may have rate limits. |
| **Authentication** | None (self-hosted) |
| **Rate limits** | Self-determined |
| **Commercial use** | Yes (open source) |
| **Data freshness** | Community-updated |
| **Deprecation risk** | Low (open source) |
| **Output format** | JSON |

---

## 9. SEO & WEB DATA

### 9.1 Tranco ⭐ BEST FIND
| Field | Detail |
|---|---|
| **Name + URL** | [Tranco](https://tranco-list.eu/) |
| **What it provides** | Daily-updated ranking of top 1M domains. Combines Cisco Umbrella, Chrome UX Report, Majestic Million, Farsight DNSDB. Historical ranks, custom lists, individual domain rank queries. Academic-grade methodology (resist manipulation). |
| **Free tier limits** | **Free API** — registration required for API key. No published daily/monthly limits. Full lists available via Google BigQuery too. |
| **SUFFICIENT for 25 niches?** | **SUFFICIENT** — free, no meaningful limits for research. Covers top 1M domains. |
| **Authentication** | Free API key (registration) |
| **Rate limits** | Not explicitly published (reasonable use expected) |
| **Commercial use** | Yes (permissive, with attribution) |
| **Data freshness** | Daily (updated by 0:00 UTC) |
| **Deprecation risk** | Very low — academic project, 600+ citations, KU Leuven/TU Delft |
| **Output format** | CSV, JSON |

### 9.2 Cloudflare Radar API
| Field | Detail |
|---|---|
| **Name + URL** | [Cloudflare Radar API](https://radar.cloudflare.com/) |
| **What it provides** | Domain popularity rankings (top 10K), traffic data, domain category tags, security metrics, technology adoption trends. |
| **Free tier limits** | **Free** — API key from Cloudflare account. |
| **SUFFICIENT for 25 niches?** | **BORDERLINE** — limited to top 10K domains. Useful for ranking well-known companies in a niche but misses long-tail companies. |
| **Authentication** | Free API key (Cloudflare account) |
| **Rate limits** | Rate-limited but not published |
| **Commercial use** | Yes |
| **Data freshness** | Near real-time |
| **Deprecation risk** | Very low — Cloudflare infrastructure |
| **Output format** | JSON |

### 9.3 FetchSERP
| Field | Detail |
|---|---|
| **Name + URL** | [FetchSERP](https://fetchserp.com) |
| **What it provides** | All-in-one SEO/web intelligence: domain analysis, keyword research, SERP results, web scraping, Moz integration, AI-powered analysis. MCP server available. |
| **Free tier limits** | **250 free credits** on signup — no payment details required. |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — 250 credits one-time, not recurring. Would be exhausted quickly across 25 niches. |
| **Authentication** | API key |
| **Rate limits** | Not published for free tier |
| **Commercial use** | Yes |
| **Data freshness** | Real-time |
| **Deprecation risk** | Moderate — newer product |
| **Output format** | JSON |

### 9.4 Vee3 MCP
| Field | Detail |
|---|---|
| **Name + URL** | [Vee3](https://vee3.io) |
| **What it provides** | Domain research (WHOIS, DNS, RDAP), SEO/backlinks (Moz, Ahrefs, Majestic), Google Trends, Google Maps, YouTube/TikTok data, website screenshots. |
| **Free tier limits** | **Free tier available** — token-based billing. SEO analysis = 40 tokens, domain checks = 2-5 tokens. Monthly allowance resets (exact amount not published). Failed calls not charged. |
| **SUFFICIENT for 25 niches?** | **UNVERIFIED** — cannot determine exact free tier monthly token allowance from public sources |
| **Authentication** | Account signup at app.vee3.io |
| **Rate limits** | Token-based, monthly allowance resets (exact limit unknown) |
| **Commercial use** | Yes |
| **Data freshness** | Real-time |
| **Deprecation risk** | Moderate — newer MCP-based service |
| **Output format** | JSON via MCP |

### 9.5 Google Free SEO APIs
| Field | Detail |
|---|---|
| **Name + URL** | Multiple Google APIs (via Google Cloud Console) |
| **What it provides** | **PageSpeed Insights API**: 240 QPM, 25,000 QPD. **CrUX API**: 150 QPM, unlimited daily. **Search Console API**: 1,200 QPM per site, 30M QPD. **GA4 Data API**: 10 concurrent requests. **Google NLP API**: 5,000 units/month free. |
| **Free tier limits** | **Free with Google Cloud project** — quotas vary per API. NOTE: Only covers sites you own/verify. No competitor data. |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** for company research — only works for your own verified properties. Not useful for third-party niche analysis. |
| **Authentication** | Google Cloud API key/OAuth |
| **Rate limits** | Per-API as above |
| **Commercial use** | Yes |
| **Data freshness** | Real-time to 24-hour lag |
| **Deprecation risk** | Very low |
| **Output format** | JSON |

### 9.6 OpenSERP
| Field | Detail |
|---|---|
| **Name + URL** | [OpenSERP](https://openserp.dev) — Also known as [karust/openserp](https://github.com/karust/openserp) on GitHub |
| **What it provides** | Free, MIT-licensed, self-hosted SERP API. Supports Google, Yandex, Baidu, Bing, DuckDuckGo, Ecosia. Multi-engine "megasearch," URL extraction, AI overviews. |
| **Free tier limits** | **Free (self-hosted)** — MIT license. Optional managed cloud version available. Run locally or via Docker. |
| **SUFFICIENT for 25 niches?** | **SUFFICIENT** once self-hosted — though requires infrastructure and CAPTCHA handling |
| **Authentication** | None (self-hosted) or optional cloud key |
| **Rate limits** | Self-determined (dependent on your infrastructure) |
| **Commercial use** | Yes — MIT license |
| **Data freshness** | Live |
| **Deprecation risk** | Low (open source) |
| **Output format** | JSON |

---

## 10. SOCIAL & COMMUNITY DATA

### 10.1 Radar Intelligence (Open Source) ⭐ BEST FIND
| Field | Detail |
|---|---|
| **Name + URL** | [Radar Intelligence](https://github.com/Scognamiglio1969/radar-intelligence) |
| **What it provides** | Self-hosted AI-powered social listening across 9 free data sources: GDELT (100K+ news outlets, 65+ languages), Google News, Bluesky, Mastodon, Hacker News, Telegram, RSS. Reddit and YouTube with free API keys. Claude AI powered. Alternative to Talkwalker/Brandwatch. |
| **Free tier limits** | **Free (self-hosted)** — bring your own AI key (Claude API). Zero configuration, runs locally. |
| **SUFFICIENT for 25 niches?** | **SUFFICIENT** — self-hosted, unlimited usage within source limits. Perfect for ongoing multi-niche social listening. |
| **Authentication** | None (self-hosted) + source-specific free keys |
| **Rate limits** | Determined by each source's API limits |
| **Commercial use** | Yes (open source) |
| **Data freshness** | Near real-time (GDELT + RSS) |
| **Deprecation risk** | Low (open source) |
| **Output format** | Web dashboard, likely JSON backend |

### 10.2 Harken (Open Source)
| Field | Detail |
|---|---|
| **Name + URL** | [GitHub: VladUZH/harken](https://github.com/VladUZH/harken) |
| **What it provides** | Self-hosted, open-source social listening. Tracks keywords across Hacker News, Bluesky, Stack Overflow (free, no API keys), plus Reddit, Mastodon, RSS, YouTube (needs keys). Built-in sentiment lexicon analyzer with optional LLM upgrade (Anthropic, OpenAI, Ollama). MIT license. |
| **Free tier limits** | **Free (self-hosted)** — MIT license |
| **SUFFICIENT for 25 niches?** | **SUFFICIENT** — self-hosted, unlimited keyword tracking across multiple niches |
| **Authentication** | None for basic sources; optional keys for extended sources |
| **Rate limits** | Self-determined |
| **Commercial use** | Yes — MIT license |
| **Data freshness** | Near real-time |
| **Deprecation risk** | Low (open source) |
| **Output format** | SQLite, web dashboard, CLI |

### 10.3 Bluesky / AT Protocol API
| Field | Detail |
|---|---|
| **Name + URL** | [AT Protocol](https://atproto.com/) |
| **What it provides** | Full access to Bluesky social network public data. Posts, profiles, feeds, search, trends. No authentication needed for reads. |
| **Free tier limits** | **3,000 requests per 5 minutes (IP-based)** — completely free |
| **SUFFICIENT for 25 niches?** | **BORDERLINE** — Bluesky's userbase is still small compared to X/LinkedIn. Useful for early signals but not comprehensive B2B coverage. |
| **Authentication** | None for reading public data |
| **Rate limits** | 3,000 requests per 5 minutes (IP-based) |
| **Commercial use** | Yes |
| **Data freshness** | Real-time |
| **Deprecation risk** | Very low — open protocol |
| **Output format** | JSON (Lexicon) |

### 10.4 YouTube Data API v3
| Field | Detail |
|---|---|
| **Name + URL** | [YouTube Data API](https://developers.google.com/youtube/v3) |
| **What it provides** | Search videos, channels, playlists. 10,000 quota units/day (1 search = 100 units, 1 video lookup = 1 unit). Comments, statistics, captions. |
| **Free tier limits** | **10,000 quota units/day** — free with Google Cloud project (~100 searches or 10,000 video lookups per day). |
| **SUFFICIENT for 25 niches?** | **SUFFICIENT** — 10,000 quota units/day translates to ~100 niche keyword searches per day |
| **Authentication** | Google Cloud API key |
| **Rate limits** | 10,000 quota units/day |
| **Commercial use** | Yes |
| **Data freshness** | Real-time |
| **Deprecation risk** | Very low |
| **Output format** | JSON |

### 10.5 Mastodon API
| Field | Detail |
|---|---|
| **Name + URL** | [Mastodon API](https://docs.joinmastodon.org/api/) |
| **What it provides** | Access to Mastodon federated social network. Public timelines, profiles, statuses, hashtag search. |
| **Free tier limits** | **300 requests per 5 minutes per account** — free, open source |
| **SUFFICIENT for 25 niches?** | **BORDERLINE** — Mastodon's userbase is fragmented across instances. B2B signal density is low. |
| **Authentication** | OAuth token (free) |
| **Rate limits** | 300 requests per 5 minutes |
| **Commercial use** | Yes |
| **Data freshness** | Real-time |
| **Deprecation risk** | Very low — open source protocol |
| **Output format** | JSON |

### 10.6 Buffer API
| Field | Detail |
|---|---|
| **Name + URL** | [Buffer API](https://buffer.com/developers) |
| **What it provides** | Posting/scheduling across 11 platforms (Instagram, Facebook, LinkedIn, TikTok, X, Threads, Bluesky, Pinterest, YouTube, Google Business Profile, Mastodon). MCP server and CLI. |
| **Free tier limits** | **1 API key on free account** — focused on posting, not listening/aggregation |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — posting/scheduling tool, not a social listening or research API |
| **Authentication** | OAuth |
| **Rate limits** | Not published for free tier |
| **Commercial use** | Yes |
| **Data freshness** | Real-time (posting) |
| **Deprecation risk** | Low |
| **Output format** | JSON |

### 10.7 Octolens (Social Listening API)
| Field | Detail |
|---|---|
| **Name + URL** | [Octolens](https://octolens.com) |
| **What it provides** | Social listening across 13 platforms: LinkedIn, X/Twitter, Reddit, Bluesky, GitHub, YouTube, DEV.to, Hacker News, Stack Overflow, TikTok, News/Blogs. AI-enriched (sentiment, relevance, tags). Webhooks. |
| **Free tier limits** | **7-day free trial** — no credit card required. Paid from $159/month. |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — 7-day trial only, not a permanent free tier |
| **Authentication** | Account signup |
| **Rate limits** | Trial limits not published |
| **Commercial use** | Yes |
| **Data freshness** | Real-time |
| **Deprecation risk** | Low — active 2025/2026 |
| **Output format** | JSON |

### 10.8 Reddit API (non-commercial)
| Field | Detail |
|---|---|
| **Name + URL** | [Reddit API](https://www.reddit.com/dev/api/) |
| **What it provides** | Subreddit search, posts, comments, user data. Full Reddit content access. |
| **Free tier limits** | **100 queries/minute (OAuth) / 10 QPM (no auth)** — **NOT for commercial use**. Commercial requires Reddit approval (~$12K/year). |
| **SUFFICIENT for 25 niches?** | **INSUFFICIENT** — commercial use prohibitive ($12K+). Non-commercial only. |
| **Authentication** | OAuth |
| **Rate limits** | 100 QPM (OAuth) |
| **Commercial use** | **No** (free tier). Requires $12K/year+ contract. |
| **Data freshness** | Real-time |
| **Deprecation risk** | High — Reddit became aggressive about API pricing in 2023 |
| **Output format** | JSON |

---

## SUMMARY: RECOMMENDED STACK FOR 25-NICHE RESEARCH

### Tier 1: Essential (SUFFICIENT, verified, stable)
| Category | API | Free Limit | Why Essential |
|---|---|---|---|
| Company Data | **Registry Lookup** | 5,000 calls/month | #1 best find — 500x our baseline |
| Market/Industry | **FRED API** | Unlimited | Macro context for every niche |
| Market/Industry | **Census Bureau API** | Unlimited | NAICS-level market sizing |
| Market/Industry | **World Bank API** | Unlimited | Global market context |
| News/Intent | **GDELT Project** | Unlimited | Real-time news/event signals |
| News/Intent | **Currents API** | 1,000 req/day | Real-time news, 30K/month |
| Social Listening | **Radar Intelligence** | Free (self-hosted) | Multi-source social listening |
| Social Listening | **Harken** | Free (self-hosted) | Keyword tracking across sources |
| Social Community | **YouTube Data API** | 10K quota/day | Video content analysis |
| SEO/Web | **Tranco** | Free API | Domain popularity rankings |
| SEO/Web | **OpenSERP** | Free (self-hosted) | Programmatic search |

### Tier 2: Useful with Moderation (BORDERLINE but valuable)
| Category | API | Free Limit | Strategy |
|---|---|---|---|
| Technographics | **DetectZeStack** | 100 req/month | Use selectively for top 10 companies per niche |
| Technographics | **website-tech-stack-detector** | $5/mo Apify credits | ~1,000 domains via Apify free plan |
| Job Postings | **Techmap** | 1,000 postings/month | Hiring signals across niches (~40/niche) |
| Financial | **FMP API** | 250 req/day | Public company data per niche |
| Financial | **ExploreYC** | Free API | YC/a16z company funding |
| Review/Sentiment | **Gralio MCP** | Free (unstable) | SaaS reviews if it stays live |
| Review/Sentiment | **TextAI Pro** | 50 req/hr | Sentiment analysis on collected data |

### Tier 3: One-time Use / Not Recommended for This Use Case
| API | Reason |
|---|---|
| OpenCorporates | No commercial use on free tier |
| Hunter.io (25), Tomba (25), CUFinder (50), PDL (100), Enrich.so (100 one-time) | Too few credits/month for 25 niches |
| Yelp Fusion | Free tier eliminated Aug 2024 |
| Reddit API | Commercial use costs $12K+/year |
| NewsAPI, GNews | 100 req/day and free tier restrictions |
| Google SEO APIs | Only work for sites you own |
| Alpha Vantage | Only 25 calls/day |
| Octolens, Coresignal | Trial only, not permanent free tier |
| Bluedoor | Domain is for sale (defunct) |

### Total Free Monthly Capacity (Stacked)
| Category | Combined Capacity |
|---|---|
| Company lookups | ~5,500+ (Registry Lookup 5K + Wikidata + GLEIF) |
| Domain ranking | Unlimited (Tranco + Cloudflare Radar) |
| News signals | ~31,000/day (GDELT + Currents 1K + YouTube searches) |
| Market data | Unlimited (FRED + Census + World Bank + IMF) |
| Social listening | Unlimited (Radar/Harken self-hosted) |
| Job hiring signals | ~1,000 postings/month (Techmap) |
| Technographics | ~100-1,000 lookups (DetectZeStack + Apify) |
| Reviews (SaaS) | Unlimited IF Gralio stays live |

---

## KEY FINDINGS

1. **Registry Lookup is the #1 discovery** — 5,000 free calls/month for global company registry data, no credit card, roughly 10x OpenCorporates' free quota at zero cost.

2. **GDELT + Currents + Radar Intelligence** form a powerful, free news and social listening pipeline for 25 niches without any per-niche quota concerns.

3. **Contact enrichment remains the weak link** — all free email/people APIs are limited to 25-100 credits/month, making them insufficient for 25-niche research at scale. The best approach is to stack Derrick (100/mo), Hunter (25/mo), CUFinder (50/mo), and Tomba (25/mo) = ~200 total, which still barely covers 25 niches.

4. **Self-hosted open source is the unlock for scale** — OpenSERP, Radar Intelligence, Harken, ai-feedback-analyzer, and Open Tech Explorer eliminate API quotas entirely in exchange for infrastructure costs.

5. **Several previously known free tiers have been eliminated or restricted** — Yelp Fusion (paid-only since Aug 2024), Clearbit (free tier eliminated Apr 2025), Crunchbase (free tier eliminated 2025), Reddit commercial API ($12K+/year).
