# MCP Server Discovery: Free Servers for B2B Niche Research

> **Status:** Complete — searched Smithery.ai, PulseMCP, MCP.so, Glama.ai, GitHub awesome lists, Apify, npm, and PyPI.
> **Known servers excluded** (already documented): Brave Search, Reddit Research, CrawlForge, SearXNG/Web Explorer, Jina AI, FetchSERP, SEC EDGAR, Google CSE, WhoisXML API, gregpriday Research Collection, Apify Research, B2B Data Gateway, Bright Data, Easy MCP AI WordPress, DataForSEO.

---

## LEGEND

| Column | Meaning |
|--------|---------|
| **Free Tier** | Requests/mo or credits on free tier |
| **25-niche viable?** | <500 requests = INSUFFICIENT; 500-2500 = BORDERLINE; >2500 = SUFFICIENT |
| **Auth** | API key needed, OAuth, or none |
| **Maintained** | Last commit/update in 2025-2026 |
| **Commercial** | Allowed on free tier? |

---

## 1. COMPANY RESEARCH & FIRMOGRAPHICS

### 1.1 CompanyScope MCP (Apify) — NEW
- **URL:** https://apify.com/constructive_wainscot/companyscope-mcp
- **Install:** Apify MCP config
- **Data:** Company descriptions, founding year, HQ, employee count, industry, revenue, founders, CEO — aggregates 12 free public sources (Wikipedia, Wikidata, SEC, tech stack detection, competitor discovery, patents)
- **Free tier:** Apify $5/mo free credits (~100 runs)
- **25-niche viable?** BORDERLINE with free credits, SUFFICIENT at $0.05/call
- **Auth:** Apify API key
- **Maintained:** Yes (2026)
- **Commercial:** Yes

### 1.2 Explorium B2B Data MCP — KNOWN EXTENDED
- **URL:** https://smithery.ai/servers/maayanyosef/mcp-explorium
- **Data:** Company search/enrichment by name, domain, attributes, firmographics, contact discovery
- **Free tier:** Free account available
- **25-niche viable?** BORDERLINE
- **Auth:** API key
- **Maintained:** Yes (Smithery score 75/100)
- **Commercial:** Yes

### 1.3 abm.dev MCP — NEW
- **URL:** https://smithery.ai/servers/abm-dev/gtm
- **Install:** `npx @abmdev/mcp`
- **Data:** 89 canonical fields per person+company (43 person, 46 company), 40 signals, 10 data sources resolved into one response, citations on every value with confidence scores
- **Free tier:** No free tier (pay-per-enrichment, ~$0.29/enrichment; promo LAUNCHCODES for free credits)
- **25-niche viable?** INSUFFICIENT (no free tier)
- **Auth:** API key
- **Maintained:** Yes (Score 98/100 Smithery)
- **Commercial:** Yes (paid)

### 1.4 enrich-mcp-plugin (GlobalSearchData) — NEW
- **URL:** https://smithery.ai/servers/globalsearchdata/enrich-mcp-plugin
- **Install:** One-click Smithery
- **Data:** Domain-to-company intelligence: company name, country, contacts, social profiles. No API key needed.
- **Free tier:** Free server, no API key
- **25-niche viable?** SUFFICIENT (unlimited on free server)
- **Auth:** None
- **Maintained:** Yes (Score 84/100)
- **Commercial:** Yes

### 1.5 DataForB2B MCP — NEW
- **URL:** https://smithery.ai/servers/datafor-b2b/dataforb2b
- **Data:** Live B2B data for sales/recruiting: search_company, enrich_company, search_people, enrich_profile
- **Free tier:** Paid (no free tier)
- **25-niche viable?** INSUFFICIENT
- **Auth:** API key
- **Maintained:** Yes (Score 82/100)
- **Commercial:** Yes (paid)

### 1.6 CompanyEnrich MCP — NEW
- **URL:** https://mcp.so/server/companyenrich
- **Install:** `npx mcp-remote` with bearer token
- **Data:** 30M+ companies, 170M+ people profiles. Company enrichment (60+ data points), semantic company search, AI-powered lookalikes, reverse email lookup, tech stack detection
- **Free tier:** 500 free credits on signup (1 credit = 1 company enrichment)
- **25-niche viable?** BORDERLINE (500 credits = 500 company lookups, enough for initial eval)
- **Auth:** API key
- **Maintained:** Yes
- **Commercial:** Yes

### 1.7 DataLayer MCP — NEW
- **URL:** https://github.com/datalayer-sh/mcp
- **Data:** 60M+ companies, 300M+ verified contacts. Person/company enrichment, search, technographics, headcount, job listings, buying intent signals (Google Ad Spend, web traffic, employee growth, hiring velocity)
- **Free tier:** 10 free credits on signup
- **25-niche viable?** INSUFFICIENT (only 10 free)
- **Auth:** OAuth 2.1
- **Maintained:** Yes (active GitHub)
- **Commercial:** Yes

### 1.8 EzBiz Business Intelligence MCP — NEW
- **URL:** https://smithery.ai/servers/ezbiz-services/business-intelligence
- **Install:** Hosted (URL + API key)
- **Data:** 8 AI-powered tools: competitor analysis, market research, industry research, web presence scoring (0-100), review aggregation/sentiment, SWOT, customer personas
- **Free tier:** 10 requests/month free
- **25-niche viable?** INSUFFICIENT (250 needed minimum)
- **Auth:** Free API key (mcp.ezbizservices.com/signup)
- **Maintained:** Yes (2026)
- **Commercial:** Yes

### 1.9 Wokelo AI MCP — NEW
- **URL:** https://mcp.so/server/wokelo-ai-mcp-server/Wokelo%20AI
- **Data:** 100M+ companies, 30+ premium data sources, 25 tools: company enrichment, bulk screening, buyer/target identification, market mapping, earnings calls, SEC filings, Glassdoor reviews, G2 reviews, news signals. SOC 2 Type II + ISO 27001.
- **Free tier:** None (paid only)
- **25-niche viable?** INSUFFICIENT
- **Auth:** API key
- **Maintained:** Yes (released Apr 2026)
- **Commercial:** Yes (paid)

### 1.10 Coresignal MCP — NEW
- **URL:** https://coresignal.com/blog/coresignal-mcp-server/
- **Data:** 75M+ company records (500+ fields), 696M+ employee records, 448M+ job postings. Multi-source Company/Employee/Jobs APIs
- **Free tier:** 200 Collect + 400 Search credits free trial (7-14 days)
- **25-niche viable?** BORDERLINE (enough for evaluation window)
- **Auth:** API key
- **Maintained:** Yes
- **Commercial:** Yes (trial only)

### 1.11 OpenRegistry MCP — NEW
- **URL:** https://github.com/sophymarine/openregistry
- **Install:** URL `https://mcp.openreg.is/mcp` (anonymous)
- **Data:** Real-time data from 30 official national company registries (UK Companies House, France RNE, Ireland CRO, Norway Brreg, Netherlands KVK, etc.). Company search, profiles, officers, shareholders, charges, filings, financial documents
- **Free tier:** Anonymous: 20 req/min, 3-country cross-border fan-out. Signed in: 30 req/min. Commercial use OK.
- **25-niche viable?** SUFFICIENT (unlimited free tier with rate limits, 20/min = 1200/hr)
- **Auth:** None for anonymous
- **Maintained:** Yes (active GitHub, May-Jun 2026)
- **Commercial:** Yes (explicitly allows commercial)

### 1.12 EU Company MCP Server — NEW
- **URL:** https://github.com/AiAgentKarl/eu-company-mcp-server
- **Data:** Europe-wide via GLEIF, VIES, Eurostat, OpenSanctions. 13 tools: company search, VAT validation, beneficial ownership, sanctions screening, insolvency search, EU economic statistics
- **Free tier:** Completely free, no API key needed
- **25-niche viable?** SUFFICIENT
- **Auth:** None
- **Maintained:** Yes (2026)
- **Commercial:** Yes

### 1.13 Qonoro Intelligence MCP — NEW
- **URL:** https://mcp.so/servers/qonoro-mcp-server
- **Data:** 18 tools: company enrichment, person enrichment, competitor analysis, sales signals, intent signals, job change detection, news sentiment, revenue qualification, email/phone/URL validation, NAICS classification
- **Free tier:** None (pay-per-call via USDC/x402)
- **25-niche viable?** INSUFFICIENT
- **Auth:** None (wallet-based)
- **Maintained:** Yes
- **Commercial:** Yes (paid)

### 1.14 HasData MCP — NEW
- **URL:** https://glama.ai/mcp/connectors/com.hasdata.mcp/has-data
- **Data:** 40+ scraping/search tools: Amazon products (title, brand, pricing, availability, reviews, images), Google Search, Google Maps, Google Trends, Airbnb, social media
- **Free tier:** Glama gateway "100% free" for call logging; tool costs TBD
- **25-niche viable?** UNCERTAIN
- **Auth:** API key
- **Maintained:** Yes (2026)
- **Commercial:** TBD

### 1.15 Derrick App MCP — NEW
- **URL:** https://beta.mcp.so/zh/servers/derrick-mcp
- **Data:** Business email finder, LinkedIn profile enrichment, company search for sales prospecting. API key persisted across sessions.
- **Free tier:** Unknown
- **Auth:** API key
- **Maintained:** Yes
- **Commercial:** TBD

---

## 2. CONTACT ENRICHMENT & EMAIL FINDING

### 2.1 @flipfactory-it/mcp-leadgen — NEW
- **URL:** https://www.npmjs.com/package/@flipfactory-it/mcp-leadgen
- **Install:** `npx @flipfactory-it/mcp-leadgen`
- **Data:** business_search (DuckDuckGo + website scraping for phone/email/address), contact_enrich (scrape any website for emails/phones/social links), email_find (pattern matching + MX verification, confidence scoring), CSV/JSON export
- **Free tier:** Completely free, no API keys needed. Rate limits: 10 searches/min, 15 enrichments/min, 30 email lookups/min
- **25-niche viable?** SUFFICIENT (unlimited free, rate-limited)
- **Auth:** None
- **Maintained:** Yes (v2.0.2, 2026)
- **Commercial:** Yes

### 2.2 @prospeo/prospeo-mcp-server — NEW
- **URL:** https://www.npmjs.com/package/@prospeo/prospeo-mcp-server
- **Data:** enrich_person (email + mobile from LinkedIn URL or name+company), enrich_company, search_person/search_company, bulk enrichment
- **Free tier:** Credits-based (free tier unknown)
- **25-niche viable?** INSUFFICIENT (likely)
- **Auth:** API key
- **Maintained:** Yes (v1.1.0)
- **Commercial:** Yes

### 2.3 Encrata MCP — NEW
- **URL:** https://github.com/Encratahq/encrata-mcp
- **Data:** lookup_email, validate_email, phone_lookup, check_breaches, company_search, IP intelligence, dark web search, social profile lookup, domain intelligence
- **Free tier:** Signup at encrata.com (free tier TBD)
- **25-niche viable?** UNCERTAIN
- **Auth:** API key (free signup)
- **Maintained:** Yes
- **Commercial:** TBD

### 2.4 B2B Enrichment MCP (Hunter + Apollo) — NEW
- **URL:** https://github.com/Aleksey-Panf/b2b-enrichment-mcp
- **Install:** Python 3.11+, local
- **Data:** Combines Hunter.io (email finding/verification) + Apollo.io (firmographics: headcount, revenue, funding, tech stack)
- **Free tier:** Hunter: 50 req/mo + 50 verifications. Apollo: unlimited company enrichment on free plan
- **25-niche viable?** BORDERLINE (Hunter limit may bind, Apollo is viable)
- **Auth:** API keys (Hunter free, Apollo free)
- **Maintained:** Yes (GitHub)
- **Commercial:** Yes

---

## 3. FINANCIAL DATA & FUNDING

### 3.1 Financial Hub MCP — NEW
- **URL:** https://www.npmjs.com/package/financial-hub-mcp
- **Install:** `npx financial-hub-mcp`
- **Data:** Full SEC EDGAR (no API key), XBRL normalization, 10-K/10-Q/8-K search, financial metrics, stock screening, full-text filing search, corporate events, company comparisons; FRED economic indicators (free key); Finnhub market data (30 req/s free)
- **Free tier:** Completely free (SEC/FRED/Finnhub free tiers)
- **25-niche viable?** SUFFICIENT
- **Auth:** None for SEC; free keys for FRED/Finnhub
- **Maintained:** Yes (npm v1.3.1)
- **Commercial:** Yes

### 3.2 World Intelligence MCP Server — NEW
- **URL:** https://github.com/marc-shade/world-intel-mcp
- **Data:** 113 tools across 30+ domains: SEC filings (3 tools), markets, FX, bonds, earnings, news, conflict, military, cyber, climate, company enrichment. Live Leaflet dashboard, SSE streaming.
- **Free tier:** All data from free public APIs — no paid subscriptions
- **25-niche viable?** SUFFICIENT
- **Auth:** None
- **Maintained:** Yes (active GitHub)
- **Commercial:** Yes

### 3.3 SEC Funding Tracker MCP — NEW
- **URL:** https://glama.ai/mcp/servers/ssaikrishna862/sec-funding-mcp
- **Data:** SEC Form D filings as structured funding signals: company name, amount raised, industry, location, executives, direct SEC filing URL
- **Free tier:** 10 filings/call, no signup required
- **25-niche viable?** BORDERLINE (free tier enough for light eval)
- **Auth:** None for free
- **Maintained:** Yes
- **Commercial:** Yes (free tier); Pro $9/mo

### 3.4 Startup Funding & Investor Intel MCP (Apify) — NEW
- **URL:** https://apify.com/seibs.co/mcp-startup-funding-intel
- **Data:** Crunchbase-grade funding data from SEC Form D filings + press. 4 tools: get_recent_rounds, get_company_funding, get_investor_portfolio, find_fresh_raises
- **Free tier:** $0.005/tool call + pass-through ($0.006-0.012/record). list_tools is free.
- **25-niche viable?** INSUFFICIENT (pay-per-call adds up)
- **Auth:** Contact email required
- **Maintained:** Yes
- **Commercial:** Yes

### 3.5 Fundraise MCP Server — NEW
- **URL:** https://github.com/zavora-ai/mcp-fundraise
- **Data:** 16 tools: SAFE conversion, dilution modeling, valuation, runway calculation, metric benchmarking, term sheet comparison; SEC EDGAR search for SAFE agreements; YC company search (2,000+ companies) — all live APIs
- **Free tier:** Open source, zero configuration, free public APIs
- **25-niche viable?** SUFFICIENT
- **Auth:** None
- **Maintained:** Yes (v1.0.0, May 2026)
- **Commercial:** Yes

### 3.6 Octagon MCP Server — NEW
- **URL:** https://hexmos.com/freedevtools/mcp/finance--fintech/OctagonAI--octagon-mcp-server/
- **Data:** SEC filings for 8,000+ public companies (10-K, 10-Q, 8-K, 20-F, S-1), earnings transcripts (10 years), financial metrics, stock data; 3M+ private companies, 500k+ funding deals, 2M+ M&A/IPO transactions, Form 13F
- **Free tier:** Requires API key (pricing TBD)
- **25-niche viable?** UNCERTAIN
- **Auth:** API key required
- **Maintained:** Yes
- **Commercial:** TBD

---

## 4. JOB POSTING DATA & HIRING SIGNALS

### 4.1 mcp-server-linkedin-zero (PyPI) — NEW
- **URL:** https://pypi.org/project/mcp-server-linkedin-zero/0.2.0/
- **Install:** `pip install mcp-server-linkedin-zero`
- **Data:** 23 tools — no LinkedIn login needed. Search public LinkedIn jobs, job details, salary extraction, job trends, industry insights, company discovery, resume analysis, job matching, CSV/JSON export
- **Free tier:** Completely free, open source, no login
- **25-niche viable?** SUFFICIENT
- **Auth:** None ("public_no_login_read_only" mode)
- **Maintained:** Yes (PyPI 0.2.0)
- **Commercial:** Yes

### 4.2 hs-linkedin-mcp (HiredSignal) — NEW
- **URL:** https://lobehub.com/mcp/michaeltabet-hs-linkedin-mcp
- **Data:** 10 tools: resolve real ATS apply URLs, search jobs with 19+ filters, search hiring posts, Easy Apply inspection/submission, messages, connection requests. Uses your own signed-in Brave browser via CDP.
- **Free tier:** MIT-licensed, free. Dry-run mode default for safety.
- **25-niche viable?** SUFFICIENT (requires own LinkedIn)
- **Auth:** Your LinkedIn session
- **Maintained:** Yes (MIT license)
- **Commercial:** Yes

### 4.3 visajobs-mcp — NEW
- **URL:** https://github.com/neosh11/visa-jobs-mcp
- **Data:** 12 core tools: job search, visa-aware filtering, pagination, saved/ignored jobs, employer contact extraction, local-first private storage
- **Free tier:** Free, open source
- **25-niche viable?** SUFFICIENT
- **Auth:** Your LinkedIn session
- **Maintained:** Yes
- **Commercial:** Yes

### 4.4 LinkedIn Hiring Signals MCP (Apify) — NEW
- **URL:** https://apify.com/foxlabs/linkedin-hiring-signals/api/mcp
- **Data:** Open-role count, hiring velocity (7/30/90 days), department breakdown
- **Free tier:** Apify credits ($0.005+ per call)
- **Auth:** Apify API key
- **Maintained:** Yes
- **Commercial:** Yes

---

## 5. TECHNographics & TECH STACK DETECTION

### 5.1 site-audit-mcp — NEW
- **URL:** https://socket.dev/npm/package/site-audit-mcp
- **Install:** `npx site-audit-mcp`
- **Data:** Website performance analysis, WHOIS lookup, DNS records, SSL info, tech stack detection
- **Free tier:** Completely free, no API key needed
- **25-niche viable?** SUFFICIENT
- **Auth:** None
- **Maintained:** Yes (v0.1.0, Mar 2026)
- **Commercial:** Yes

### 5.2 mcp-diagnostics — NEW
- **URL:** https://github.com/kame6493-del/mcp-diagnostics
- **Data:** DNS, SSL, HTTP headers, security audit, WHOIS, tech stack detection. Works with Claude, Cursor, VS Code
- **Free tier:** Free, open source
- **25-niche viable?** SUFFICIENT
- **Auth:** None
- **Maintained:** Yes (v1.0.0, Apr 2026)
- **Commercial:** Yes

### 5.3 TheirStack MCP — NEW
- **URL:** https://theirstack.com/en/blog/best-technographic-mcp.md
- **Data:** Frontend AND backend technology detection (via job postings + website analysis)
- **Free tier:** 200 credits/month free
- **25-niche viable?** BORDERLINE (200 credits)
- **Auth:** API key
- **Maintained:** Yes
- **Commercial:** Yes

### 5.4 detectzestack-mcp — NEW
- **URL:** https://github.com/mlugo-apx/detectzestack-mcp
- **Data:** Tech stack detection, security headers, SSL certs, DNS records, vulnerabilities
- **Free tier:** 100 requests/month via RapidAPI
- **25-niche viable?** INSUFFICIENT
- **Auth:** RapidAPI key
- **Maintained:** Yes (Apr 2026)
- **Commercial:** Yes

### 5.5 PredictLeads Technographics MCP — NEW
- **URL:** https://www.producthunt.com/products/predictleads-technographics-dataset
- **Data:** Technology adoption curves, migrations, competitive shifts from 100M+ companies, 19M+ sources (websites, jobs, DNS, cookies, partnerships, docs). First/last seen timestamps. Pricing estimates for tech spend.
- **Free tier:** 100 API credits/month free
- **25-niche viable?** INSUFFICIENT
- **Auth:** API key
- **Maintained:** Yes
- **Commercial:** Yes

### 5.6 Tech Stack Intel MCP (Apify) — NEW
- **URL:** https://apify.com/seibs.co/mcp-tech-stack-intel
- **Data:** Detect stacks, sales triggers, technology relationships
- **Free tier:** $0.005/tool call + upstream
- **Auth:** Apify API key
- **Maintained:** Yes
- **Commercial:** Yes

---

## 6. SEO, KEYWORD & SERP DATA

### 6.1 serpjet-mcp — NEW
- **URL:** https://www.npmjs.com/package/serpjet-mcp
- **Data:** Clean structured JSON for 10 Google result types: web, images, videos, news, shopping (with prices), maps, places, scholar, patents, autocomplete
- **Free tier:** 1,000 free searches/month, recurring (resets monthly). No credit card required.
- **25-niche viable?** SUFFICIENT (40 searches per niche)
- **Auth:** API key (free signup)
- **Maintained:** Yes
- **Commercial:** Yes

### 6.2 serper-search-mcp — NEW
- **URL:** https://www.npmjs.com/package/serper-search-mcp
- **Data:** 8 search tools: web, images, videos, news, shopping, places, deep research, RAG contexts. "People Also Ask", Knowledge Graph, Answer Box data
- **Free tier:** 2,500 free queries/month (Serper). No credit card.
- **25-niche viable?** SUFFICIENT (100 per niche)
- **Auth:** API key (free Serper account)
- **Maintained:** Yes
- **Commercial:** Yes

### 6.3 SEO Automation MCP — NEW
- **URL:** https://github.com/modelcontextprotocol/servers/issues/4037
- **Data:** 10 SEO tools: Google Suggest, SERP data, web crawling, OpenLinkProfiler. No paid API dependency.
- **Free tier:** Completely free, no paid APIs
- **25-niche viable?** SUFFICIENT
- **Auth:** None
- **Maintained:** Yes (2026)
- **Commercial:** Yes

### 6.4 Stackwise-digital/seo-mcp — NEW
- **URL:** https://github.com/Stackwise-digital/seo-mcp
- **Data:** 28 SEO rules (meta, content, technical, performance), site crawling, deep page analysis, LLM-based AI analysis. Optional Ahrefs Firehose.
- **Free tier:** Free, open source. No API keys required for core.
- **25-niche viable?** SUFFICIENT
- **Auth:** None (core)
- **Maintained:** Yes (Apr 2026)
- **Commercial:** Yes

### 6.5 DataSEO MCP — NEW
- **URL:** https://github.com/egebese/dataseo-mcp
- **Data:** Backlink analysis, keyword research, traffic estimation, keyword difficulty, SERP data via Ahrefs free tools automation
- **Free tier:** Free (Ahrefs free tools)
- **25-niche viable?** SUFFICIENT
- **Auth:** None
- **Maintained:** Yes
- **Commercial:** Educational/research use

### 6.6 atomno-mcp-seo-audit — NEW
- **URL:** https://pypi.org/project/atomno-mcp-seo-audit/
- **Data:** Technical SEO audits: site health score, 78 checks across 8 categories, GEO sub-score (AI-search visibility)
- **Free tier:** Free tier (no key, no signup)
- **25-niche viable?** SUFFICIENT
- **Auth:** None
- **Maintained:** Yes
- **Commercial:** Yes (free tier)

---

## 7. REVIEW AGGREGATION & SENTIMENT

### 7.1 Review Intelligence MCP Server (Apify) — NEW
- **URL:** https://apify.com/alizarin_refrigerator-owner/review-intelligence-mcp-server
- **Data:** Reviews from G2, Capterra, Trustpilot, Google, Yelp, Facebook, TripAdvisor, Angi, BBB, Healthgrades, HomeAdvisor (11+ platforms). Sentiment analysis, AI response generation.
- **Free tier:** Demo Mode is free, no API key. Then $0.05/execution.
- **25-niche viable?** BORDERLINE (Demo mode may limit)
- **Auth:** Apify API key for production
- **Maintained:** Yes
- **Commercial:** Yes

### 7.2 Competitive Intelligence MCP Server (Apify) — NEW
- **URL:** https://apify.com/alizarin_refrigerator-owner/competitive-intelligence-mcp-server
- **Data:** 16-in-1: G2, Capterra, Clutch, GoodFirms, Glassdoor, Trustpilot, BBB, Yelp, tech stack detection, Facebook Ads, Crunchbase funding, Reddit/Quora
- **Free tier:** Demo Mode is free, no API key. Then $0.01-0.03/event.
- **25-niche viable?** BORDERLINE
- **Auth:** Apify API key for production
- **Maintained:** Yes
- **Commercial:** Yes

### 7.3 @pullapi/glassdoor-scraper-mcp — NEW
- **URL:** https://www.npmjs.com/package/@pullapi/glassdoor-scraper-mcp
- **Data:** Glassdoor: company overviews, employee reviews, ratings, salary data, CEO approval, job listings
- **Free tier:** npm package (usage TBD)
- **Auth:** Unknown
- **Maintained:** Yes
- **Commercial:** TBD

---

## 8. SOCIAL LISTENING & COMMUNITY MONITORING

### 8.1 reddit-rss-mcp — NEW
- **URL:** https://github.com/ninjackster/reddit-rss-mcp
- **Data:** Read Reddit via RSS feeds. No API key/OAuth. Works when Reddit blocks anonymous JSON. Search, browse subreddits, read comments.
- **Free tier:** Completely free, no credentials. Flat comments (no threading), ~25 results/call.
- **25-niche viable?** SUFFICIENT
- **Auth:** None
- **Maintained:** Yes (May 2026)
- **Commercial:** Yes

### 8.2 achetronic/reddit-mcp — NEW
- **URL:** https://github.com/achetronic/reddit-mcp
- **Data:** 10 tools: discover subreddits, trending posts, sentiment analysis, crossover community detection. Uses public Reddit JSON endpoints.
- **Free tier:** No auth needed. ~60 req/min rate limit.
- **25-niche viable?** SUFFICIENT
- **Auth:** None
- **Maintained:** Yes (v0.1.1, Mar 2026)
- **Commercial:** Yes

### 8.3 zavora-ai/mcp-pr (PR/Social Listening) — NEW
- **URL:** https://github.com/zavora-ai/mcp-pr
- **Data:** Brand monitoring, media sentiment analysis, crisis detection, social listening, share of voice, press release formatting. Reddit monitoring tool included.
- **Free tier:** All free, no API keys needed (uses GDELT, Reddit, Wikipedia)
- **25-niche viable?** SUFFICIENT
- **Auth:** None
- **Maintained:** Yes (May 2026)
- **Commercial:** Yes

### 8.4 Trends MCP (Apify/trendsmcp) — NEW
- **URL:** https://apify.com/trendsmcp/trendsmcp-mcp
- **Data:** Trend data across 25+ sources including Reddit (subreddit subscribers, hot posts, world news)
- **Free tier:** 100 requests/month, no credit card
- **25-niche viable?** INSUFFICIENT
- **Auth:** Apify API key
- **Maintained:** Yes
- **Commercial:** Yes

---

## 9. NEWS MONITORING & INTENT SIGNALS

### 9.1 PeakMetrics MCP Server — NEW
- **URL:** https://www.globenewswire.com/de/news-release/2026/01/20/3221739/0/en/PeakMetrics-Launches-MCP-Server-to-Bring-Live-Narrative-Intelligence-Into-AI-Assistants.html
- **Data:** Live narrative intelligence: emerging narratives, coordinated/manipulated activity detection, risk indicators
- **Free tier:** Enterprise/government (pricing TBD)
- **25-niche viable?** INSUFFICIENT
- **Auth:** API key
- **Maintained:** Yes (Jan 2026)
- **Commercial:** TBD

### 9.2 Stealthee MCP-tools — NEW
- **URL:** https://github.com/rainbowgore/Stealthee-MCP-tools
- **Data:** Early-signal radar for product launches: search web + tech ecosystems, score product-related changes (changelogs, sitemaps) for competitive intelligence
- **Free tier:** Open source (uses Tavily + OpenAI — your keys)
- **25-niche viable?** BORDERLINE (cost of Tavily/OpenAI calls)
- **Auth:** Your own API keys
- **Maintained:** Yes
- **Commercial:** Yes

### 9.3 Salesmotion MCP Server — NEW
- **URL:** https://salesmotion.io/blog/salesmotion-mcp-launch
- **Data:** 13 tools: account insights, signal search, contact discovery. Tracks buying signals, exec changes, earnings calls, job postings, funding rounds, competitive moves
- **Free tier:** Unknown
- **Auth:** API key
- **Maintained:** Yes (2026)
- **Commercial:** TBD

---

## 10. ACADEMIC RESEARCH & PAPER SEARCH

### 10.1 paperplain-mcp — NEW
- **URL:** https://www.npmjs.com/package/paperplain-mcp
- **Data:** 200M+ peer-reviewed papers from PubMed, arXiv, Semantic Scholar. Full abstracts, DOIs, citation counts
- **Free tier:** Free, zero config, no API key. Optional free Semantic Scholar key for higher rate limits (1->100 req/s)
- **25-niche viable?** SUFFICIENT
- **Auth:** None (optional free API key)
- **Maintained:** Yes (Mar 2026)
- **Commercial:** Yes

### 10.2 academic-search-mcp — NEW
- **URL:** https://www.npmjs.com/package/academic-search-mcp
- **Data:** Multi-source: Semantic Scholar, Google Scholar (Puppeteer), arXiv, CrossRef, OpenAlex, Scopus, CORE, IEEE Xplore, Wiley, Unpaywall, Sci-Hub
- **Free tier:** Free (CrossRef, arXiv key-free). API keys optional.
- **25-niche viable?** SUFFICIENT
- **Auth:** None for CrossRef/arXiv
- **Maintained:** Yes
- **Commercial:** Yes

### 10.3 resp_mcp — NEW
- **URL:** https://github.com/monk1337/resp_mcp
- **Data:** SERP-free scholarly search: arXiv, Semantic Scholar, OpenReview, OpenAlex, DBLP, Crossref, ACM, ACL Anthology, 27+ AI/ML/NLP/CV conferences
- **Free tier:** No API keys required
- **25-niche viable?** SUFFICIENT
- **Auth:** None
- **Maintained:** Yes (Jul 2026)
- **Commercial:** Yes

### 10.4 semantic-scholar-mcp — NEW
- **URL:** https://github.com/yogsoth-ai/semantic-scholar-mcp
- **Data:** Semantic Scholar Academic Graph API: paper lookup, citation tracing, author profiles, recommendations, advanced search with filters
- **Free tier:** Free (API key optional for higher rate limits)
- **25-niche viable?** SUFFICIENT
- **Auth:** None (optional free key)
- **Maintained:** Yes (May 2026)
- **Commercial:** Yes

### 10.5 mcp-research (francojc) — NEW
- **URL:** https://github.com/francojc/mcp-research
- **Data:** arXiv, Semantic Scholar, Google Scholar. Zotero integration, field-specific search, citation analysis, BibTeX/RIS export
- **Free tier:** Free, open source
- **25-niche viable?** SUFFICIENT
- **Auth:** None
- **Maintained:** Yes (Feb 2026)
- **Commercial:** Yes

---

## 11. BUSINESS REGISTRIES & GOVERNMENT DATA

### 11.1 Global Database MCP Server — NEW
- **URL:** https://www.globaldatabase.com/introducing-the-global-database-mcp-server
- **Data:** 400 government registries across 200+ countries, 600M+ companies. Company profiles, financials, shareholders/UBO, group structures
- **Free tier:** Commercial (free tier not specified)
- **25-niche viable?** UNCERTAIN
- **Auth:** API key
- **Maintained:** Yes
- **Commercial:** Yes

### 11.2 Commonwealth Corporate Registry MCP (Apify) — NEW
- **URL:** https://github.com/apifyforge/commonwealth-corporate-registry-mcp
- **Data:** Australia ABN, Canada Corporation, NZ Companies Office, UK Companies House, OpenCorporates, GLEIF LEI. Concordance scoring, A-F identity verification grades
- **Free tier:** $0.05/tool call (Apify credits)
- **25-niche viable?** INSUFFICIENT
- **Auth:** Apify API key
- **Maintained:** Yes
- **Commercial:** Yes

### 11.3 Brreg MCP Server (Norway) — NEW
- **URL:** https://www.npmjs.com/package/@nordio/brreg-mcp-server
- **Data:** Norwegian company registry: companies, roles, subunits, annual accounts. NACE code handling
- **Free tier:** Free, public, keyless
- **25-niche viable?** SUFFICIENT (for Norway-specific)
- **Auth:** None
- **Maintained:** Yes
- **Commercial:** Yes

### 11.4 Thailand Data MCP Server (Apify) — NEW
- **URL:** https://apify.com/kindly_rafter/thailand-data-mcp
- **Data:** Thailand DBD registry: company lookup by 13-digit juristic ID, address normalization, holidays, VAT/WHT reference
- **Free tier:** Free, no API keys needed
- **25-niche viable?** SUFFICIENT (for Thailand-specific)
- **Auth:** None
- **Maintained:** Yes
- **Commercial:** Yes

---

## 12. CRM DATA ACCESS

### 12.1 HubSpot Official MCP — NEW DETAILS
- **URL:** mcp.hubspot.com
- **Data:** 40+ tools: contacts, companies, deals, tickets, products, invoices, quotes, subscriptions, segments, calls, emails, meetings, notes, tasks
- **Free tier:** Free on all HubSpot tiers (including free)
- **25-niche viable?** SUFFICIENT (if you have HubSpot data)
- **Auth:** OAuth 2.0
- **Maintained:** Yes (official, GA Apr 2026)
- **Commercial:** Yes

### 12.2 Windsor MCP — NEW
- **URL:** https://github.com/windsor-ai/windsor_mcp
- **Data:** Connects to 325+ sources: HubSpot, Salesforce, Pipedrive, Zoho CRM, and 321+ marketing/analytics tools
- **Free tier:** Free forever plan at Windsor.ai
- **25-niche viable?** SUFFICIENT (data connector)
- **Auth:** OAuth via Windsor.ai
- **Maintained:** Yes
- **Commercial:** Yes

### 12.3 zavora-ai/mcp-crm — NEW
- **URL:** https://github.com/zavora-ai/mcp-crm
- **Data:** Unified Rust binary: Salesforce, HubSpot, Zoho CRM, Pipedrive. Unified contacts, deals, pipelines
- **Free tier:** Open source (your CRM API keys)
- **25-niche viable?** SUFFICIENT
- **Auth:** Your CRM API keys
- **Maintained:** Yes
- **Commercial:** Yes

---

## 13. E-COMMERCE & MARKETPLACE DATA

### 13.1 ZooData MCP — NEW
- **URL:** https://www.toolworthy.ai/tool/zoodata
- **Data:** URL-to-structured-JSON for e-commerce: product, competitor, market, category data. 15-min BSR refreshes, 30-min price refreshes
- **Free tier:** 1,000 free credits, no credit card
- **25-niche viable?** BORDERLINE
- **Auth:** API key (free signup)
- **Maintained:** Yes
- **Commercial:** Yes

---

## 14. GEOLOCATION & DEMOGRAPHICS

### 14.1 civic-library-mcp — NEW
- **URL:** https://www.npmjs.com/package/civic-library-mcp
- **Data:** Geocoding, census tract lookups, Opportunity Zone checks, ACS demographics, FEMA flood zones. All from free federal open data.
- **Free tier:** 4 of 5 tools free, no key. get_tract_demographics needs free Census key.
- **25-niche viable?** SUFFICIENT
- **Auth:** None (optional free Census key)
- **Maintained:** Yes (v0.1.2, 2026)
- **Commercial:** Yes

### 14.2 mcp-civic-data (EricGrill) — NEW
- **URL:** https://github.com/EricGrill/mcp-civic-data
- **Data:** 34 free public data APIs: Census demographics, World Bank, FRED, BLS, BEA. Location input as city, ZIP, address, coordinates.
- **Free tier:** 23 of 34 sources need no API key
- **25-niche viable?** SUFFICIENT
- **Auth:** None (23 sources); free keys for others
- **Maintained:** Yes
- **Commercial:** Yes

### 14.3 census-geocoding-mcp — NEW
- **URL:** https://github.com/hesscl/census-geocoding-mcp
- **Data:** US Census Geocoding: geocode addresses, reverse-geocode, tracts, blocks, counties, congressional districts. Batch up to 10K records.
- **Free tier:** No API key required. Covers Puerto Rico.
- **25-niche viable?** SUFFICIENT
- **Auth:** None
- **Maintained:** Yes (Feb 2026)
- **Commercial:** Yes

---

## 15. WIKIPEDIA / WIKIDATA KNOWLEDGE GRAPH

### 15.1 mcp-wikipedia (pipeworx) — NEW
- **URL:** https://github.com/pipeworx-io/mcp-wikipedia
- **Data:** Wikipedia REST API: search articles, summaries, sections, random articles
- **Free tier:** Free, no auth
- **25-niche viable?** SUFFICIENT
- **Auth:** None
- **Maintained:** Yes
- **Commercial:** Yes

### 15.2 mcp-wikiviews (pipeworx) — NEW
- **URL:** https://github.com/pipeworx-io/mcp-wikiviews
- **Data:** Wikipedia pageview statistics
- **Free tier:** Free, no auth
- **25-niche viable?** SUFFICIENT
- **Auth:** None
- **Maintained:** Yes (Apr-Jun 2026)
- **Commercial:** Yes

---

## 16. DATA ENRICHMENT PLATFORMS (MULTI-SOURCE)

### 16.1 Enrich.so MCP — NEW
- **URL:** https://www.enrich.so/mcp
- **Data:** 40+ enrichment tools: email finder, email validation, reverse email lookup, phone lookup, lead finding (150M+ leads, 135+ filters), company enrichment, LinkedIn follower analysis
- **Free tier:** URL-based config. Pricing TBD.
- **Auth:** API key
- **Maintained:** Yes
- **Commercial:** TBD

### 16.2 GoCreative MCP — NEW
- **URL:** https://mcp.so/servers/gocreative-agent-api
- **Data:** 385+ pay-per-call tools: sanctions/PEP screening, KYB, OFAC crypto-wallet checks, company & contact enrichment, SEC/FRED/market data, crypto/DeFi, prediction-market odds
- **Free tier:** Keyless payment in USDC on Base/Solana. No subscriptions.
- **25-niche viable?** INSUFFICIENT (pay-per-call)
- **Auth:** None (wallet-based)
- **Maintained:** Yes
- **Commercial:** Yes

### 16.3 Zapier MCP — NEW
- **URL:** https://zapier.com/blog/zaps-tables-interfaces-mcp/
- **Data:** 8,000+ apps, 30,000+ actions. AI agents can send emails, create CRM contacts, manage calendar, process refunds, create tasks, etc.
- **Free tier:** 100 tasks/month (~50 MCP calls). No credit card required.
- **25-niche viable?** BORDERLINE (50 calls enough for simple eval)
- **Auth:** OAuth via Zapier
- **Maintained:** Yes (official)
- **Commercial:** Yes

---

## TOP 10 MOST VALUABLE DISCOVERIES FOR 25-NICHE EVALUATION

Ranked by: free tier generosity, data richness, relevance to B2B niche evaluation, and ease of setup.

| Rank | Server | Free Tier | Why It Matters |
|------|--------|-----------|----------------|
| **1** | **OpenRegistry MCP** | Unlimited (20 req/min) | Official company registry data from 30 countries, real-time, commercial use OK |
| **2** | **Financial Hub MCP** | Unlimited (SEC free) | Full SEC filings, financial metrics, corporate events — no API key needed |
| **3** | **World Intelligence MCP** | Unlimited (113 tools) | SEC, markets, news, company enrichment — every tool from free APIs |
| **4** | **paperplain-mcp** | Unlimited | 200M+ academic papers from PubMed/arXiv/Semantic Scholar, zero config |
| **5** | **serper-search-mcp** | 2,500 queries/mo | SERP data with Knowledge Graph, PAA — great for competitive keyword intel |
| **6** | **mcp-server-linkedin-zero** | Unlimited | 23 tools for LinkedIn jobs, salaries, trends — no login needed |
| **7** | **Stackwise-digital/seo-mcp** | Unlimited | 28 SEO rules, crawling — no API keys, LLM-based analysis |
| **8** | **@flipfactory-it/mcp-leadgen** | Unlimited | Email finding, contact scraping, phone lookup — all free, rate-limited |
| **9** | **EU Company MCP Server** | Unlimited | 13 tools for European company data, VAT validation, sanctions, insolvency |
| **10** | **reddit-rss-mcp** | Unlimited | Reddit monitoring via RSS when JSON is blocked — no credentials needed |

---

## SUMMARY STATISTICS

- **Total MCP servers discovered (not previously known):** 65+
- **Servers with sufficient free tier for 25 niche evals:** ~30
- **Servers with no free tier / insufficient free tier:** ~20
- **Servers with unknown pricing:** ~15
- **Categories covered:** 16 (Company, Contacts, Financial, Jobs, Technographics, SEO, Reviews, Social, News, Academic, Registries, CRM, E-com, Geo, Wikipedia, Platforms)
