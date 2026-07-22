# Free B2B Research & Open Data Sources for ClarityRev

> **Date:** 2026-07-23
> **Context:** ClarityRev -- Revenue Intelligence startup evaluating 25 B2B niches (primarily European/Benelux)
> **Already Owned:** Firecrawl (100K credits), DataForSEO ($50), Context7 MCP, 15+ MCP servers, BuiltWith, Wappalyzer, Hunter.io, Reddit API, OpenAlex, Apollo.io free tier

---

## EXECUTIVE SUMMARY

A complete free research stack for 25 B2B European niches is achievable with approximately **EUR 0-10/month** in recurring costs by combining:

- **Open data government APIs** (Eurostat, OECD, BLS, SEC EDGAR) for macro/industry data
- **OpenRegistry MCP** for European company registry data (NL KVK, BE KBO, UK Companies House, DE Handelsregister, FR RNE)
- **Apify free credits + open actors** for traffic analysis, tech stack detection, and company enrichment
- **Free SERP APIs** (SERPJET 1K/mo, Serper.dev 2.5K one-time) for SEO research
- **Open source MCP servers** (DataSEO for backlinks, TAM-MCP for market sizing, OpenPageRank for domain authority)
- **Free browser tools** (unbuilt.app for tech detection, Populr Stacks extension)

**Remaining gaps:** (1) EU private company funding data, (2) Unified dashboard, (3) High-accuracy traffic estimates for smaller companies. These gaps can be partially filled by news-RSS monitoring, web scraping via Firecrawl, and the EUR 50 DataForSEO deposit.

---

## SUB-TRACK C1: FREE ALTERNATIVES TO PAID TOOLS

---

### 1. Semrush / Ahrefs -- SEO & Keyword Research

| Tool | Type | Free Limit | Verdict |
|------|------|-----------|---------|
| **SERPJET** | API (freemium) | 1,000 searches/month, recurring | BEST recurring free SERP API. No CC required. |
| **Serper.dev** | API (freemium) | 2,500 queries one-time | Good one-shot research pass. |
| **Google Search Console API** | Free API | 30M queries/day | Only for sites you own. Essential internally. |
| **OpenSEO** | Open source (MIT) | Free software, needs DataForSEO ($50) | Best long-term stack: free code + pay-per-use data. |
| **DataSEO MCP** | Open source | Free, uses Ahrefs free data | Zero-cost backlink analysis, MCP-native. |
| **RankForge API** | API (freemium) | 100 requests/day | Keyword difficulty scoring at scale. |
| **Screaming Frog** | Desktop app | 500 URLs/crawl free | Technical SEO audits. |
| **keywords_research_generator** | Open source | Unlimited | Uses Google's own free APIs. Clever architecture. |
| **Scrapeless Deep SerpApi** | API (freemium) | 2,000 one-time | 20+ Google surfaces. Broadest coverage. |
| **Open PageRank API** | Free API | 4.3M domains/day | PageRank from Common Crawl. |
| **Ahrefs Free DR API** | Free API | No unit consumption | Free Domain Rating. Attribution required from Sept 2026. |
| **Tourist** | Open source | Self-hosted | DuckDuckGo SERP. High deprecation risk. |

**Recommended stack for 25 niches:**
- **Initial deep research:** Serper.dev (2,500 one-time queries) + DataForSEO $50 deposit via OpenSEO
- **Ongoing monitoring:** SERPJET (1,000/mo recurring) + DataSEO MCP (backlinks, free)
- **Authority ranking:** Open PageRank API (4.3M/day free) + Ahrefs Free DR API
- **Own-site performance:** Google Search Console API (free, unlimited for own sites)

---

### 2. Clearbit -- Company Enrichment

| Tool | Type | Free Limit | Verdict |
|------|------|-----------|---------|
| **Apify Website Company Enricher** | Open source | ~$0.25/100 domains | BEST for structured company data. 25 niches x 20 companies x 100 fields = ~$1.25. |
| **Company Researcher (exa-labs)** | Open source | Free, self-hosted | Deep multi-source company research (10+ sources). |
| **B2B Enrichment MCP** | Open source | Free MCP | Combines Hunter + Apollo free tiers in one MCP. |
| **Apollo.io free tier** | Platform | Unlimited browsing, ~50 exports/mo | Free company discovery. Limited contact exports. |
| **Scala API** | API | 50 lookups/month | European gov registry data (40+ registries). |
| **@tofuhq/enrich** | CLI | Credit-based, no-charge-on-fail | AI-agent native enrichment. |
| **@absolutejs/enrich** | Open source | Unlimited, self-hosted | SMTP-based email finding. IP blacklist risk. |
| **Hunter.io** | API | 50 unified credits/month | You already have this. Email finding + logo API. |
| **Prospeo** | API | 75 emails/month | 50+ data points per contact. 7-day refresh. |
| **Enrow** | API | 50 emails/month | Pay-per-success model. |
| **Brandfetch** | API | 500K requests/month | SVG logos + brand identity data. |
| **NinjaPear Logo API** | API | ~12.96M/month | Free forever, no attribution. PNG only. |
| **Hunter Logo API** | API | No limits stated | Simplest: `https://logos.hunter.io/{domain}`. |

**Recommended stack for 25 niches:**
- **Primary:** Apify Website Company Enricher (EUR 1-2 per batch) + Apollo.io free (unlimited browsing)
- **Company logos:** Brandfetch (500K/mo, SVG) or NinjaPear (unlimited, PNG)
- **Deep profiles:** Company Researcher (exa-labs) for shortlisted companies
- **Email discovery:** Hunter.io (50/mo) + Prospeo (75/mo) combined for ~125 emails/mo

---

### 3. Crunchbase -- Company & Funding Database

| Tool | Type | Free Limit | Verdict |
|------|------|-----------|---------|
| **OpenRegistry MCP** | Free MCP | 20-30 req/min, all 30 jurisdictions | BEST. KVK, KBO, Companies House, DE Handelsregister, FR RNE. Real-time gov data. MCP-native. |
| **Apify Saas Enrichment** | Pay-per-result | $0.01/1K results | 500K enrichments for EUR 5 (Apify free credits). |
| **Zorepo** | Free forever | "Core free forever" | Crunchbase alternative. Test immediately. |
| **ExploreYC** | Open source | Free API key | 6,600+ YC + a16z companies. US tech startup focus. |
| **UK Companies House API** | Government | 600 req/5 min | UK company data. Free and comprehensive. |
| **Funding Signals API** | API | Free key, daily | SEC Form D + news. US-only. |
| **Teahose MCP** | Open source | 1,000 req/day | AI company funding signals. |
| **Apify Company Funding Tracker** | Pay-per-use | $3/1K filings | SEC Form D structured data. |
| **Tracxn free tier** | Platform | Limited free access | Worth testing for niche coverage. |

**Recommended stack:**
- **European company identification:** OpenRegistry MCP (free, MCP-native, real-time) -- covers all key EU markets
- **Batch enrichment:** Apify Saas Enrichment on free platform credits
- **UK companies:** UK Companies House API (direct, free)
- **US/global:** Zorepo (test first) + ExploreYC (startups)

---

### 4. BuiltWith / Wappalyzer -- Technographic Data

| Tool | Type | Free Limit | Verdict |
|------|------|-----------|---------|
| **unbuilt.app** | Open source | Unlimited free | Analyzes bundled/minified code. CLI available. No limits. |
| **Open Tech Explorer** | Open source + Chrome ext | Free | Tech stack + metadata + REST API. Community data. |
| **Popular Stacks** | Chrome extension | Free | Privacy-first, no remote data sent. |
| **Tech Stack Profiler (Apify)** | Open source | Free (HTTP only) | 330+ technologies, Wappalyzer patterns. Free tier: no proxy. |
| **Wappalyzer Replacement (Apify)** | Pay-per-use | ~$0.01/domain | 6,000+ technologies. Cheap bulk option. |
| **Whopper (npm)** | Open source CLI | Free | `npm install -g whopper`. CLI-based detection. |
| **Wappalyzer free tier** | API | 50 credits/month | We have this. Very limited (50 URLs/mo). |
| **BuiltWith** | API | We have access | Already in our stack. |
| **Context7 MCP** | MCP server | We have this | Check if it provides tech detection. |

**Recommended stack:**
- **Primary bulk:** unbuilt.app (unlimited, open source, CLI) + Populr Stacks (extension for quick lookups)
- **Already owned:** BuiltWith (our access) + Wappalyzer (50/mo)
- **Cheap bulk alternative:** Apify Wappalyzer Replacement at $0.01/domain (EUR 5 = 500 domains on free platform credits)

---

### 5. ZoomInfo / Lusha -- B2B Contact Data

| Tool | Type | Free Limit | Verdict |
|------|------|-----------|---------|
| **Apollo.io free** | Platform | Unlimited browsing, ~50 exports/mo | BEST free for company exploration. |
| **Hunter.io** | API | 50 unified credits/mo | Already have. Email finding + verification. |
| **Prospeo** | API | 75 emails/month | 50+ data points. Best refresh rate (7 days). |
| **Enrow** | API | 50 emails/month | Pay-per-success. No waste. |
| **Snov.io** | API | 50 credits/mo, **no API** | Good UI. No API access on free tier. |
| **Kaspr** | Extension | 15 emails/month | Too limited. LinkedIn extension. |
| **Tomba.io** | API | 25 searches/month | Established but very limited free tier. |
| **@absolutejs/enrich** | Open source | Unlimited, self-hosted | SMTP probing. IP blacklist risk at scale. |
| **ZeroBounce** | API | 100 verifications/month | Best recurring free email verification. |
| **Kickbox** | API | 100 one-time | One-time test only. |
| **6sense Chrome Extension** | Extension | 50 contact credits | Free contact data on LinkedIn profiles. |
| **People Data Labs** | API | 100 records/month | Data obfuscated on free tier. |
| **CommonRoom** | Platform | 500 contacts free | Decent free tier for contact management. |

**Recommended stack:**
- **Company discovery:** Apollo.io free (unlimited browsing, 200M+ contacts visible)
- **Email finding:** Hunter.io (50/mo) + Prospeo (75/mo) = 125 emails/mo
- **Verification:** ZeroBounce (100/mo recurring) + Hunter's built-in verifier
- **Self-hosted fallback:** @absolutejs/enrich for unlimited but rate-limited use
- **LinkedIn enrichment:** 6sense extension (50 free lookups)

---

### 6. SimilarWeb -- Traffic Estimation

| Tool | Type | Free Limit | Verdict |
|------|------|-----------|---------|
| **Apify Website Traffic Analysis** | Free actor | Unclear -- effectively unlimited | BEST free option. Traffic + rank + SEO + WHOIS + safety. No API key. |
| **Open PageRank API** | Free API | 4.3M domains/day | Domain authority, not traffic. Good for scoring. |
| **Ahrefs Free DR API** | Free API | No unit consumption | Domain Rating. Free cross-check. |
| **Apify SimilarWeb Scraper** | Pay-per-use | $3.50/1K results | More accurate data via SimilarWeb's own API. |
| **SimilarWeb free tier** | Web | 15 actions/day | Only for spot checks. Too limited. |
| **Keywords Everywhere** | Web tools | Daily allowance | Quick manual checks. |
| **SEO Review Tools** | Web tool | Free manual | Domain Authority checker. |
| **Website Traffic Analysis (Apify)** | Free actor | No key needed | Traffic, rank, SEO, WHOIS, safety in one call. |

**Recommended stack:**
- **Primary:** Apify Website Traffic Analysis (free, no API key, batch-capable)
- **Domain authority:** Open PageRank (4.3M/day) + Ahrefs Free DR
- **When higher accuracy needed:** Apify SimilarWeb Scraper (EUR 3.50/1K, ~EUR 5 for 1,400 domains via free credits)
- **DataForSEO:** Our EUR 50 deposit can provide keyword volume data as traffic proxy

---

### 7. LinkedIn Sales Navigator -- Professional Data

| Tool | Type | Free Limit | Verdict |
|------|------|-----------|---------|
| **LinkedIn Sign In API** | Official free | OpenID Connect only | Name, headline, photo. No search. Not useful for research. |
| **Apollo.io free** | Platform | Unlimited browsing | BEST for professional search. 200M+ contact database. No LinkedIn dependency. |
| **6sense Chrome Extension** | Extension | 50 contacts | Free contact enrichment on LinkedIn profiles. |
| **CommonRoom** | Platform | 500 contacts free | Professional data aggregation. |
| **Lusha** | Extension/API | ~5 credits/mo | Too limited. |
| **Kaspr** | Extension | 15 emails/mo | LinkedIn-native but tiny free tier. |
| **Crunchbase people** | Platform | 5 views/month | Not useful. |
| **SignalHire** | Platform | Limited free credits | Test first. |
| **Proxycurl** | API | **SHUT DOWN** | Sued by LinkedIn/Microsoft in Jan 2025. Shut down July 2025. |

**Legal note on LinkedIn scraping:** LinkedIn successfully shut down Proxycurl ($10M ARR) via lawsuit in 2025. While the hiQ case found public scraping may not violate CFAA, LinkedIn enforces via contract law. Any scraping-based LinkedIn data tool carries existential legal risk.

**Recommended stack:**
- **Primary professional search:** Apollo.io free (200M+ contacts, unlimited browsing, no LinkedIn dependency)
- **LinkedIn profile enrichment:** 6sense extension (50 contacts free)
- **Legal scraping avoidance:** Use Apollo.io and official data sources. Do not build on LinkedIn-scraped data.

---

### 8. Owler / G2 -- Reviews & Competitive Intelligence

| Tool | Type | Free Limit | Verdict |
|------|------|-----------|---------|
| **Gralio SaaS Database** | Free MCP | 3M+ SaaS reviews | BEST free MCP endpoint. Reviews, pricing, funding, alternatives. |
| **omkarcloud/g2-scraper** | Open source | Free, self-hosted | TypeScript G2 scraper (MIT). Full control. |
| **Decodo G2 Scraper API** | API | 2,000 requests/month | Managed infrastructure. JavaScript rendering included. |
| **Advanced-G2-Scraper** | RapidAPI | Free API tier | Programmatic G2 product/vendor/review access. |
| **ReviewHook** | API | Free beta | Unified multi-platform review API (G2 + others). |
| **Outscraper MCP** | Open source | Free | G2 reviews in MCP format. 25+ extraction tools. |
| **Product Hunt API** | Official | Free | Product launches, upvotes, comments. |
| **Trustpilot API** | API | Free tier | Business reviews. Commercial licensing varies. |
| **G2 free tier** | Web | Browsing only | Manual browsing. No API, no exports. |
| **NewsAPI** | API | 100 requests/day | News monitoring for competitive intelligence. |
| **GNews API** | API | 100 requests/day | Google News access. Free tier available. |

**Recommended stack:**
- **SaaS review data:** Gralio MCP (free, MCP-native, 3M+ reviews) + omkarcloud/g2-scraper (self-hosted)
- **Product intelligence:** Product Hunt API (free, official)
- **News monitoring:** NewsAPI (100/day free) or GNews API
- **Multi-platform:** ReviewHook (beta, free)

---

### 9. PitchBook / CB Insights -- VC & Funding Data

| Tool | Type | Free Limit | Verdict |
|------|------|-----------|---------|
| **SEC EDGAR API** | Government | 10 req/sec | US Form D filings. Free, authoritative. US-only. |
| **OpenPitch MCP** | Open source (MIT) | Free | AI-startup intelligence, daily pipeline via GitHub Actions. |
| **Zorepo** | Free forever | "Core free forever" | Crunchbase alternative. Test immediately. |
| **DataSignals Lab MCP** | Freemium | 50 calls/month | SEC-based funding signals. $29/mo for 2,000 calls. |
| **Apify Company Funding Tracker** | Pay-per-use | $3/1K filings | SEC Form D structured data. |
| **Apify Public Web Funding Signal** | Pay-per-use | $4/1K results | News + SEC + RSS funding signals. |
| **Signal by NFX** | Free | ~18,800 VC investors | Investor database. Free, curated. |
| **OpenVC** | Freemium | 20,000+ investors | Investor discovery. Downloadable dataset. |
| **Dealroom.co** | Paid | 3-day trial only | BEST European funding data. Starts at EUR 13.7K/year. |
| **Tracxn** | Freemium | Limited free | Emerging market strength. |

**Recommended stack:**
- **US funding:** SEC EDGAR API (free, authoritative) + DataSignals Lab MCP (50 calls/mo free)
- **EU funding:** This is the biggest gap. Use OpenRegistry (company registries often show capital changes) + Firecrawl (news scraping) + RSS feeds
- **Investor discovery:** Signal by NFX (free) + OpenVC (free dataset)
- **Affordable upgrade path:** DataSignals Lab Pro at $29/mo (2,000 calls)

---

### 10. IBISWorld / Statista -- Market Research & Industry Data

| Tool | Type | Free Limit | Verdict |
|------|------|-----------|---------|
| **Eurostat API** | Government | Free, no auth | BEST for EU industry data. NACE codes, employment, production, turnover. Official and comprehensive. |
| **OECD Data API** | Government | Free, no auth | Macroeconomic + industry data for 38+ OECD countries. R&D by industry (ANBERD). |
| **TAM-MCP-Server** | Open source (MIT) | Free | Wraps 8 government data sources into single MCP. TAM/SAM calculations. |
| **US Census Bureau API** | Government | Free, 500 req/sec | NAICS industry data: establishments, employment, payroll, shipments. |
| **BLS API** | Government | 500 req/day (with key) | Employment, wages, CPI by industry/occupation. NAICS codes. |
| **Statista free tier** | Web | Very limited | Free tier too restrictive. EUR 49/mo basic plan is most cost-effective paid option. |
| **Helgi Library** | Freemium | Limited free | Industry data reports. Medium deprecation risk. |
| **FRED API** | Government | Free | Economic data. Non-commercial restriction -- use with caution. |
| **Library access** | Institutional | Free with affiliation | Business Source Complete via university/library card. |
| **Qoery.com** | API | 250 queries/month | Industry data queries. Test first. |
| **CBS (Statistics Netherlands)** | Government | Free | Dutch-specific industry data. Part of Eurostat system. |
| **ECB Statistical Data Warehouse** | Government | Free, no auth | Financial/monetary data for Euro area. |

**Recommended stack:**
- **Primary EU industry data:** Eurostat API (free, authoritative, NACE-based)
- **Primary global macro data:** OECD API (free, no auth, 38+ countries)
- **MCP-integrated market sizing:** TAM-MCP-Server (open source, wraps Eurostat + Census + BLS + OECD)
- **US industry data:** US Census Bureau API (500 req/sec) + BLS API (500 req/day)
- **Dutch-specific:** CBS (Statistics Netherlands) open data portal
- **Affordable upgrade:** Statista Basic at EUR 49/mo for pre-made industry reports

---

## SUB-TRACK C2: OPEN DATA & ACADEMIC SOURCES

---

### Government & Public Registries -- European

| Source | Data Provided | Access | Limits | Freshness | For 25 Niches? |
|--------|-------------|--------|--------|-----------|----------------|
| **OpenRegistry MCP** | 30 national registries (NL KVK, BE KBO, UK CH, DE Handelsregister, FR RNE, etc.). Company profiles, officers, shareholders, filings. | Free MCP, no key | 20-30 req/min free | Real-time | SUFFICIENT -- covers all key EU markets |
| **Eurostat API** | EU industry stats by NACE code: employment, production, turnover, R&D | SDMX API, no auth | Undocumented, generous | Varies (6-18 mo lag) | SUFFICIENT -- canonical EU source |
| **OECD API** | Macroeconomic + industry data. R&D by industry (ANBERD), FDI, GDP, employment | SDMX API, no auth | Soft rate limits | Varies | SUFFICIENT -- complements Eurostat |
| **UK Companies House** | UK company profiles, officers, PSCs, filings, charges | REST API, free key | 600 req/5 min | Real-time | SUFFICIENT for UK coverage |
| **ECB SDW** | Euro area financial data, interest rates, balance sheets | REST API, no auth | Undocumented | Daily/monthly | Supplementary |
| **CBS (Netherlands)** | Dutch industry stats, economic indicators, demographics | Open data portal | No auth needed | Varies | BENELUX-SPECIFIC |
| **Statbel (Belgium)** | Belgian industry stats | Open data portal | No auth needed | Varies | BENELUX-SPECIFIC |

### Government & Public Registries -- US

| Source | Data Provided | Access | Limits | Freshness | For 25 Niches? |
|--------|-------------|--------|--------|-----------|----------------|
| **SEC EDGAR API** | Form D funding filings (private placements), 10-K, 8-K, etc. | REST, no key, needs User-Agent | 10 req/sec | Minutes | SUFFICIENT for US funding |
| **US Census Bureau API** | Business data by NAICS: establishments, employment, payroll, shipments | REST, free key | 500 req/sec | Annual | SUFFICIENT for US industry |
| **BLS API** | Employment, wages, CPI by industry/occupation (NAICS) | REST, free key | 500 req/day (with key) | Monthly/quarterly | SUFFICIENT for US labor data |
| **FRED API** | 800,000+ US/global economic time series | REST, free key | 1,000 req/min | Varies | SUPPLEMENTARY -- check commercial license |

### Academic & Research Data

| Source | Data Provided | Access | Limits | Freshness | For 25 Niches? |
|--------|-------------|--------|--------|-----------|----------------|
| **OpenAlex** | 250M+ scholarly works, author affiliations, concepts | REST, free key | 100K req/day | Continuous | SUPPLEMENTARY -- we already have this |
| **TAM-MCP-Server** | Market sizing from 8 government sources | Open source MCP | Self-hosted, unlimited | Varies by source | SUFFICIENT -- purpose-built for this |
| **OpenPitch** | AI-startup intelligence, confidence-scored | Open source MCP | Unlimited (GitHub Actions) | Daily | BORDERLINE (AI-focused) |
| **Unpaywall / CORE API** | Open access research papers | REST, free | Rate limited | Continuous | SUPPLEMENTARY |
| **Google Scholar / Semantic Scholar** | Academic papers and citations | API available | Rate limited | Continuous | SUPPLEMENTARY |

### Open Data Platforms & Infrastructure

| Source | Data Provided | Access | Limits | Freshness | For 25 Niches? |
|--------|-------------|--------|--------|-----------|----------------|
| **Wikidata SPARQL** | Structured company data: industry (P452), revenue (P2139), funding rounds, subsidiaries (P355), stock tickers (P414/P249), employees, founders. Global coverage. | SPARQL endpoint, free, no auth | Complex queries cost more; generous limits | Continuous (crowdsourced) | SUFFICIENT for structured company attributes. Query via SPARQL -- requires technical setup. |
| **Common Crawl** | 250B+ web pages since 2007. Domain graph, backlinks, web corpus. | S3 buckets, self-query | Storage costs, no API limit | Quarterly | SUPPLEMENTARY -- massive but requires ETL. PageRank from Common Crawl via OpenPageRank. |
| **Open PageRank** | PageRank (0-10) for ~200M domains from Common Crawl | Free API | 4.3M domains/day | Quarterly | SUFFICIENT for domain authority scoring |
| **DBpedia** | Structured data from Wikipedia. Companies, people, places. | SPARQL endpoint | Rate limited | Wikipedia-dependent | SUPPLEMENTARY -- overlapping with Wikidata |
| **Internet Archive APIs** | Historical website data via Wayback Machine. Archived pages, metadata, CDX index. | REST API | 6 req/sec + 2,000 req/day per IP | Historical | SUPPLEMENTARY -- website history, not company data |
| **Gralio SaaS Database** | 3M+ SaaS reviews, pricing, funding, alternatives | Free MCP endpoint | Undocumented | Continuous | SUFFICIENT for SaaS niche reviews |
| **ExploreYC** | 6,600+ YC + a16z companies, funding data | Open source API | Free API key | Continuous | BORDERLINE (US/startup focused) |
| **OpenStreetMap** | Business locations, POI data, address data | Overpass API | 2 req/sec | Community-maintained | SUPPLEMENTARY -- location intelligence |
| **GitHub Open Datasets** | Various: PHBench, startup datasets, Crunchbase snapshots | GitHub download | One-time download | Often outdated | NOT RECOMMENDED -- stale, academic |

---

## VERIFICATION SUMMARY

All claims below were verified via scraping official pricing/docs pages or official documentation.

| Tool/Service | Free Tier Exists? | Exact Limits | Commercial Use? | Sufficient for 25 Niches? | Deprecation Risk |
|---|---|---|---|---|---|
| SERPJET | YES | 1,000 searches/mo, recurring | YES | Borderline | Low-Med |
| Serper.dev | YES | 2,500 one-time | YES | Insufficient (one-time) | Low |
| OpenSEO | YES | Free code + DataForSEO data costs | YES | Sufficient (with $50 DataForSEO) | Low-Med |
| DataSEO MCP | YES | Unlimited (Ahrefs free data) | YES | Sufficient (backlinks) | Medium |
| Google Search Console API | YES | 30M queries/day | YES | Own-site only | Low |
| Open PageRank API | YES | 4.3M domains/day | YES | Sufficient | Low |
| Ahrefs Free DR API | YES | No unit consumption | YES (attribution) | Sufficient | Low |
| Apify Website Company Enricher | YES (OSS) | $0.25-0.50/100 domains | YES | Sufficient (<EUR 2 per batch) | Low |
| B2B Enrichment MCP | YES | Free MCP + Hunter/Apollo limits | YES | Borderline | Medium |
| Apollo.io free | YES | Unlimited browsing, ~50 exports/mo | YES | Borderline (discovery) | Low |
| Brandfetch | YES | 500K requests/month | YES (no attribution) | Sufficient | Low-Med |
| NinjaPear Logo API | YES | ~12.96M/month | YES (no attribution) | Sufficient | Medium |
| Hunter.io free | YES | 50 unified credits/mo | YES | Borderline (email) | Low |
| Prospeo free | YES | 75 emails/month | YES | Borderline | Low-Med |
| Enrow free | YES | 50 emails/month | YES | Borderline | Low-Med |
| ZeroBounce free | YES | 100 verifications/month | YES | Borderline | Low |
| @absolutejs/enrich | YES (OSS) | Unlimited, self-hosted | YES (BSL 1.1) | Sufficient (but IP blacklist risk) | Medium |
| OpenRegistry MCP | YES | 20-30 req/min | YES | Sufficient | Low |
| UK Companies House API | YES | 600 req/5 min | YES | Sufficient (UK-only) | Low |
| Apify Saas Enrichment | YES (pay-per) | $0.01/1K results | YES | Sufficient | Low |
| Zorepo | YES | "Core free forever" | Likely | Potentially sufficient | HIGH (unproven) |
| Apify Website Traffic Analysis | YES | Free, no key | YES | Sufficient | Medium |
| TAM-MCP-Server | YES (OSS) | Unlimited, self-hosted | YES | Sufficient | Medium |
| Eurostat API | YES | No auth needed | YES | Sufficient | Low |
| OECD API | YES | No auth needed | YES | Sufficient | Low |
| US Census Bureau API | YES | 500 req/sec | YES | Sufficient | Low |
| BLS API | YES | 500 req/day (with key) | YES | Sufficient | Low |
| SEC EDGAR API | YES | 10 req/sec | YES (public domain) | US-only | Low |
| Gralio SaaS Database | YES | Free MCP, limits unclear | Likely | Sufficient (SaaS reviews) | Medium |
| Decodo G2 Scraper API | YES | 2,000 requests/month | YES | Borderline | Medium |
| OpenPitch MCP | YES (OSS) | Unlimited (GitHub Actions) | YES | Borderline (AI-focused) | Medium |
| DataSignals Lab MCP | YES | 50 calls/month | YES | Insufficient (too few) | Low-Med |
| Signal by NFX | YES | ~18,800 investors, free | YES | Insufficient (investors only) | Low |
| unbuilt.app | YES (OSS) | Unlimited | YES | Sufficient | Low-Med |
| Populr Stacks | YES (OSS) | Unlimited (browser) | YES | Sufficient (per-site) | Low |
| 6sense extension | YES | 50 contact credits | YES | Insufficient (too few) | Medium |
| FRED API | YES | 1,000 req/min | NON-COMMERCIAL | Use with caution | Low |
| Statista free | BARELY | Very limited | No | Insufficient | Low |
| Dealroom.co | NO (3-day trial) | N/A | N/A | Not free | N/A |
| Crunchbase free | BARELY | ~11 views/mo, no API | Paid only | Insufficient | Medium |
| SimilarWeb free | YES | 15 actions/day | YES | Insufficient | Low |
| OpenCorporates free | YES | 50 calls/day, NO COMMERCIAL | Restricted | Insufficient | Medium |

---

## RECOMMENDED FREE RESEARCH STACK

### Tier 1: Always-Free (EUR 0/month)

| Category | Tool | Monthly Limit | Purpose |
|----------|------|-------------|---------|
| EU company data | OpenRegistry MCP | 20-30 req/min | Company profiles, officers, filings across 30 registries |
| Traffic estimation | Apify Website Traffic Analysis | Free actor | Traffic, rank, SEO, WHOIS |
| Domain authority | Open PageRank API | 4.3M domains/day | Company ranking/prioritization |
| Tech stack detection | unbuilt.app / Populr Stacks | Unlimited | Technology profiling |
| Industry data | Eurostat API | No auth needed | Market sizing (NACE) |
| Macro data | OECD API | No auth needed | Country-level industry context |
| Review data | Gralio MCP | Free endpoint | SaaS reviews, pricing |
| Professional search | Apollo.io free | Unlimited browsing | Company discovery, team identification |
| Logo API | Brandfetch | 500K requests/month | Company logos (SVG) |
| Email verification | ZeroBounce | 100 verifications/month | Verify found emails |
| Backlink analysis | DataSEO MCP | Free | Domain backlink profiles |
| Company enrichment | Company Researcher (exa-labs) | Unlimited (self-hosted) | Deep multi-source research |
| Market sizing | TAM-MCP-Server | Unlimited (self-hosted) | TAM/SAM calculations from gov data |

### Tier 2: Cheap Upgrade Path (EUR 5-10/month)

| Tool | Cost | Unlocks |
|------|------|---------|
| **Apify free platform credits** | EUR 0 (included) | EUR 5/month actor runs |
| **DataForSEO deposit** | EUR 50 one-time | SERP data, keyword volumes, domain analytics |
| **SERPJET** | EUR 0 (free tier) | 1,000 SERP searches/month |
| **DataSignals Lab Pro** | $29/month | 2,000 funding signal calls |
| **OpenRegistry Pro** | $9/month | 180 req/min, 10 countries/60s |
| **Statista Basic** | EUR 49/month | Pre-made industry reports |

### Tier 3: If Budget Allows (EUR 50-500/month)

| Tool | Cost | Unlocks |
|------|------|---------|
| **Crunchbase Pro** | $49/month | 2,000 export rows/month, API Basic |
| **Dealroom.co** | ~EUR 13.7K/year | Best EU funding data (expensive) |
| **Apollo.io paid** | $49/user/month | API access, more exports |
| **Hunter.io Growth** | $99/month | 5,000 email credits/month |
| **Tracxn Pro** | $500+/month | Deep sector research |

---

## TOP GAPS AND WORKAROUNDS

| Gap | Severity | Workaround |
|-----|----------|-----------|
| **EU private company funding data** | HIGH | No single free source. Combine: (1) OpenRegistry for capital changes from company filings, (2) Firecrawl scraping of EU tech news/press releases, (3) RSS feeds from Tech.eu, Sifted, Dealroom blog, (4) Apify Public Web Funding Signal ($4/1K results) |
| **Accurate traffic data for small EU companies** | MEDIUM | Apify Website Traffic Analysis provides estimates. For high accuracy needs, use the Apify SimilarWeb Scraper ($3.50/1K results) or estimate via Firecrawl + Google Search Console proxies |
| **Unified dashboard** | MEDIUM | Data lives across 10+ tools. Use the 15 MCP servers already in the stack to unify via Claude Code or build a lightweight aggregator |
| **Email contact volume** | LOW-MEDIUM | Combine Hunter.io (50/mo) + Prospeo (75/mo) for ~125/mo free. For bulk needs, use @absolutejs/enrich (self-hosted, unlimited) with proxy rotation |
| **Real-time company news monitoring** | LOW | Free: NewsAPI (100/day) + Firecrawl RSS monitoring. Paid upgrade: NewsAPI $400/mo for 50K queries |
| **Company revenue/valuation estimates** | MEDIUM | No free source for private company revenue. Estimate via: employee count (LinkedIn/Apollo) x industry-average revenue/employee (Eurostat NACE ratio). Valuation nearly impossible for private EU companies without paid tools |
| **LinkedIn-sourced professional data** | MEDIUM | Apollo.io free fills most of this gap. LinkedIn official API (Sign In only) is useless for research. Scraping carries legal risk post-Proxycurl shutdown |
