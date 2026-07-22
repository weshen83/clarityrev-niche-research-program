# B2B Research Data Sources & APIs — Comprehensive Reference

> **Status:** Living reference document.
> **Last updated:** 2026-07-22
> **Purpose:** Single source of truth for all data sources, APIs, and MCP servers available for B2B niche research, competitive intelligence, and market sizing. Covers paid, freemium, and free tiers.

---

## Table of Contents

1. [DataForSEO — Complete Endpoint Reference](#1-dataforseo--complete-endpoint-reference)
2. [Other B2B Data Providers](#2-other-b2b-data-providers)
3. [Free & Open-Source Data APIs](#3-free--open-source-data-apis)
4. [MCP Servers for Research](#4-mcp-servers-for-research)
5. [Use Case Matrix: Which Source for What?](#5-use-case-matrix-which-source-for-what)
6. [Pricing Comparison Summary](#6-pricing-comparison-summary)

---

## 1. DataForSEO — Complete Endpoint Reference

### 1.1 Platform Overview

| Attribute | Detail |
|-----------|--------|
| **Business model** | Pay-as-you-go (no subscription) |
| **Minimum deposit** | $50 (new users get $1 test credit) |
| **Authentication** | HTTP Basic Auth (username + password from dashboard) |
| **API format** | REST, JSON-encoded |
| **Rate limit** | 2,000 API calls/min, max 30 simultaneous requests |
| **SDKs** | Python, TypeScript/JS, Java, PHP, C# (.NET) |
| **Docs** | https://docs.dataforseo.com/v3/ |
| **MCP Server** | Available (npm: `@cdilorenzo/mcp-dataforseo`) |

### 1.2 SERP API — Search Engine Results Data

Retrieves real-time SERP data for Google, Bing, Yahoo, YouTube, and others.

| Endpoint | What It Returns | B2B Niche Use |
|----------|----------------|---------------|
| `serp/google/organic/live` | Organic search results (title, URL, snippet, position, featured snippet data) | See what keywords drive traffic to competitor sites, find ranking content patterns |
| `serp/google/local_pack/live` | Local pack results (maps, phone, reviews, hours) | Find local competitors in a niche, validate local demand |
| `serp/google/maps/live` | Google Maps listing data per search | Discover companies in a niche by location, get contact data |
| `serp/google/news/live` | Google News results | Track competitor press coverage, industry news |
| `serp/google/ai_mode/live/advanced` | Google AI Mode / AI Overview results | See how AI-generated search results frame a niche (new signal type) |
| `serp/google/images/live` | Google Image results | Brand monitoring, visual content strategy |
| `serp/google/events/live/advanced` | Google Events results | Industry events, conferences in a niche |
| `serp/google/local_finder/live/advanced` | Local finder with map results | Company discovery by category + location |

**Pricing (per 1,000 requests):**

| Queue | First Page (10 results) | Each Additional Page |
|-------|------------------------|---------------------|
| Standard (~5 min) | $0.60 | $0.45/1k |
| High Priority (~1 min) | $1.20 | $0.90/1k |
| Live (<60s) | $2.00 | $1.50/1k |

> **Note:** Depth-based billing effective Sep 2025 — base price covers first 10 results. Per-SERP = 10 results for Google Organic, 20 for Local Finder, 40 for Ads Search, 100 for News/Images/Maps.

### 1.3 Keywords Data API — Search Volume & Keyword Intelligence

| Endpoint | What It Returns | B2B Niche Use |
|----------|----------------|---------------|
| `keywords/google/search_volume/live` | Monthly search volume, CPC, competition for up to 1,000 keywords/request | Market sizing: quantify demand for niche-related terms |
| `keywords/google/keywords_for_site/live` | Related keyword suggestions for a domain | Discover what keywords competitors rank for, content gap analysis |
| `keywords/google/search_suggestions/live` | Google autocomplete suggestions | Buyer language discovery (what people actually type) |
| `keywords/google/ads_traffic_by_keywords/live` | Estimated ad traffic, impressions, cost | Ad spend intelligence for competitive niches |
| `keywords/bing/search_volume/live` | Bing search volume data | Validate demand across engines |

**Pricing:** Charged per request, not per keyword — sending 1 or 1,000 keywords costs the same. v3 is 50% cheaper than v2.

### 1.4 DataForSEO Labs API — Competitive & Domain Intelligence

The most powerful section for B2B niche research. Uses proprietary database of 4.8B+ keywords.

| Endpoint | What It Returns | B2B Niche Use |
|----------|----------------|---------------|
| `dataforseo_labs/google/competitors_domain/live` | Full competitive landscape: intersecting keywords, ETV, position distribution, clickstream data (age/gender) | **Core competitor profiling** — who competes for the same keywords |
| `dataforseo_labs/google/serp_competitors/live` | All domains ranking for specific keywords (up to 200/request) + avg position, ETV, visibility | **SERP ownership analysis** — who owns the first page for niche terms |
| `dataforseo_labs/google/domain_intersection/live` | Keywords where TWO specified domains both rank in same SERP | **Contested territory** — exact keyword overlap between you and a competitor |
| `dataforseo_labs/google/page_intersection/live` | Page-level intersection (like domain intersection but for individual pages) | **Content gap analysis** at page level |
| `dataforseo_labs/google/ranked_keywords/live` | All keywords any domain/URL ranks for + SERP position | **Full keyword footprint** of any competitor |
| `dataforseo_labs/google/domain_rank_overview/live` | Domain ranking distribution + ETV + paid traffic cost | **Competitor traffic estimation** |
| `dataforseo_labs/google/relevant_pages/live` | Every page on a domain + their rankings and traffic | **Competitor content strategy audit** |
| `dataforseo_labs/google/subdomains/live` | Subdomains of a target + ranking distribution | **Company site structure analysis** |
| `dataforseo_labs/google/keyword_ideas/live` | Keyword suggestions based on a seed keyword | **Niche keyword discovery** |
| `dataforseo_labs/google/related_keywords/live` | Semantically related keywords | **Topic cluster discovery** |
| `dataforseo_labs/google/historical_rank_overview/live` | Historical domain visibility over time | **Competitor trajectory analysis** (rising/falling) |
| `dataforseo_labs/google/historical_serps/live` | Complete historical SERP snapshots (incl. featured snippets) | **SERP evolution tracking** |
| `dataforseo_labs/google/categories/live` | Google Ads categories for a domain | **Industry classification** |
| `dataforseo_labs/google/domain_metrics_by_categories/live` | Up to 1,000 domains by category + historical metrics | **Industry landscape mapping** |
| `dataforseo_labs/google/bulk_keyword_difficulty/live` | Keyword difficulty scores (0-100) for up to 1,000 keywords | **Content strategy prioritization** |
| `dataforseo_labs/google/bulk_traffic_estimation/live` | Monthly traffic estimates for up to 1,000 domains | **Market sizing — total addressable demand** |
| `dataforseo_labs/google/top_searches/live` | Top performing searches for a domain | **Best-performing content identification** |
| `dataforseo_labs/google/search_intent/live` | Intent classification for keywords | **Buyer intent detection** (informational/commercial/transactional) |
| `dataforseo_labs/google/historical_bulk_traffic_estimation/live` | Historical traffic estimates for up to 1,000 domains | **Market growth tracking** |
| `dataforseo_labs/google/domain_whois_overview/live` | Whois data + ranking/traffic enrichment | **Company ownership, domain expiry monitoring** |

**Labs API Pricing:**

| Feature | Task Setup | Per Item | 1K Items Cost |
|---------|-----------|----------|---------------|
| Most standard endpoints | $0.012 | $0.00012 | $0.132 |
| Keyword Difficulty (bulk) | — | — | $0.025/1k keywords |
| Search Intent | $0.0012 | $0.00012 | $0.1212 |
| Historical Rank (domains) | $0.12 | $0.0012/month | $127.20 (1k domains, 6mo) |
| Historical SERPs | — | $0.00012/SERP | $1.20 (1k SERPs, 10mo) |
| Historical Bulk Traffic | $0.10 | $0.001/domain | $1,320 (1M domains) |
| Bulk Traffic Estimation | $0.10 | $0.001/domain | — |
| Clickstream data | — | cost x2 | — |
| Amazon Bulk Search Vol | $0.01/req | $0.0001/keyword | — |
| ID List | Free | Free | Free |

### 1.5 Backlinks API — Link Intelligence

| Endpoint | What It Returns | B2B Niche Use |
|----------|----------------|---------------|
| `backlinks/summary/live` | Backlink profile summary (total links, domains, IPs, etc.) | **Competitor authority assessment** |
| `backlinks/backlinks/live` | Individual backlinks with URL, anchor, type, attributes | **Competitor link building strategy** |
| `backlinks/anchors/live` | Anchor text distribution + all backlink metrics per anchor | **Link profile content analysis** |
| `backlinks/referring_domains/live` | Detailed referring domain list per target | **Link prospect discovery** |
| `backlinks/domain_pages/live` | Pages on a domain with backlink data | **Best-linked content identification** |
| `backlinks/domain_intersection/live` | Link intersection (up to 5 competitors) | **Link gap / unlinked mentions discovery** |
| `backlinks/page_intersection/live` | Page-level link intersection | **Content partnership opportunities** |
| `backlinks/competitors/live` | Find competitors by backlink overlap | **Indirect competitor discovery** |
| `backlinks/history/live` | Historical backlink trends | **Competitor growth trajectory** |
| `backlinks/timeseries_new_lost_summary/live` | New/lost backlinks timeline | **Real-time competitor monitoring** |
| `backlinks/bulk_referring_domains/live` | Referring domain counts for up to 1,000 targets | **Bulk competitor comparison** |
| `backlinks/bulk_backlinks/live` | Bulk backlink counts for up to 1,000 targets | **Mass authority scoring** |
| `backlinks/bulk_ranks/live` | Bulk domain rank/authority | **Authority benchmarking** |
| `backlinks/bulk_spam_score/live` | Bulk spam score | **Link quality filtering** |

### 1.6 OnPage API — Technical SEO & Content Analysis

| Endpoint | What It Returns | B2B Niche Use |
|----------|----------------|---------------|
| `on_page/content_parsing` | Page content (header, footer, primary, secondary, tables, contacts, ratings, offers, comments) | **Competitor page structure analysis, contact extraction** |
| `on_page/pages` | Per-page metrics (meta, readability scores, Core Web Vitals, spellcheck, SEO checks) | **Content quality benchmarking** |
| `on_page/summary` | Domain-wide: CMS, SSL, crawl stats, duplicate content, broken links | **Competitor site health audit** |
| `on_page/lighthouse/live` | Lighthouse performance metrics | **Page speed competitive analysis** |

**Pricing:** Content Parsing = **free**. Pages endpoint = **free**. Only posting a task costs.

### 1.7 Business Data API — Company & Review Data

| Endpoint | What It Returns | B2B Niche Use |
|----------|----------------|---------------|
| `business_data/google/my_business_info/live` | GMB profile: name, address, phone, hours, category, website, rating | **Company verification, local data enrichment** |
| `business_data/google/reviews/live` | Customer reviews from Google (up to 4,490) | **Competitor sentiment analysis, VOC research** |
| `business_data/google/extended_reviews/live` | Reviews aggregated from Google, TripAdvisor, Yelp, Trustpilot (up to 1,000) | **Multi-platform reputation intelligence** |
| `business_data/business_listings/live` | Business listings search (find companies by category, keyword, location) | **Company discovery in a niche** |
| `business_data/trustpilot/reviews/live` | Trustpilot reviews for a company | **B2B brand reputation analysis** |
| `business_data/tripadvisor/reviews/live` | TripAdvisor reviews | **Location-based business research** |

### 1.8 Domain Analytics API — Technographics & Whois

| Endpoint | What It Returns | B2B Niche Use |
|----------|----------------|---------------|
| `domain_analytics/technologies/domain_technologies/live` | Technology stack of a domain (CMS, frameworks, analytics, CDN, etc.) | **Technographic segmentation** — which tech do companies in a niche use |
| `domain_analytics/technologies/domains_by_technology/live` | **Find ALL domains using a specific technology** | **Lead discovery** — find all companies using a specific tool/tech |
| `domain_analytics/technologies/aggregation_technologies/live` | Other technologies commonly used alongside a given tech | **Tech stack pattern discovery** |
| `domain_analytics/technologies/technologies/list` | Full catalog of available technologies (free) | **Research planning** |
| `domain_analytics/technologies/technology_stats/live` | Statistics on technology adoption across the web | **Market penetration analysis** |
| `domain_analytics/whois/live` | Whois records + enriched with SERP/ranking/traffic/backlink data | **Company discovery, domain portfolio analysis** |

**Pricing:** Cheap compared to Labs — ~$1.21 per 1K domains by technology lookup. Whois: $0.12/task + $0.0012/item.

### 1.9 Content Analysis API — Content Intelligence

| Endpoint | What It Returns | B2B Niche Use |
|----------|----------------|---------------|
| `content_analysis/search/live` | Web content matching a search query, with sentiment, top keywords, page types | **Content marketing research, brand mention monitoring** |
| `content_analysis/sentiment_analysis/live` | Sentiment analysis of content matching a query | **Market sentiment tracking for a niche** |
| `content_analysis/rating_distribution/live` | Rating distribution by page type, category, language | **Review landscape analysis** |
| `content_analysis/categories` | Content categories taxonomy | **Content categorization** |

### 1.10 Other APIs

| API | Key Endpoints | B2B Niche Use |
|-----|---------------|---------------|
| **Merchant API** | Google Shopping products, sellers, prices | Competitive pricing intelligence |
| **App Data API** | App info, reviews, rankings (Google Play, App Store) | SaaS competitor analysis via app stores |
| **AI Optimization API** | LLM mentions, AI keyword volume, LLM scraper (ChatGPT/Gemini) | GEO (Generative Engine Optimization) — how your brand appears in AI answers |
| **Content Generation API** | AI content creation | — |
| **Social Media API** | Pinterest pins, Facebook interactions | Social engagement benchmarking |

### 1.11 AI-Optimized Responses

Appending `.ai` to ANY endpoint URL returns cropped JSON optimized for LLMs:
- Reduced service fields (only `id`, `status_code`, `status_message`)
- Empty/null/false fields removed from items arrays
- Floats rounded to 3 decimal places
- `monthly_searches` simplified (e.g., `{"2025-03": 201000}`)
- No additional charge

### 1.12 Recommended 4-Step Competitor Analysis Workflow (Labs API)

1. **Bulk Keyword Difficulty** — Score difficulty to gauge entry feasibility
2. **SERP Competitors** — Pull top-ranking domains for target keywords
3. **Competitors Domain** — Profile each competitor's full ranking footprint
4. **Domain Intersection** — Find exact keyword overlap (contested territory)

---

## 2. Other B2B Data Providers

### 2.1 Apollo.io

| Attribute | Detail |
|-----------|--------|
| **Free tier** | Yes ($0/mo, credit card not required) |
| **Key data** | 200M+ contacts, company profiles, intent data, enrichment |
| **API availability** | Yes (limited on free plan) |
| **Rate limits (free)** | Not publicly specified; lower quotas than paid |
| **Paid starts** | $49/user/month (Basic) |
| **Best for** | Contact discovery, company enrichment, lead lists |

**Free plan limits:**
- Email credits: ~1,200/year (some report 720/mo)
- Mobile credits: 5/mo
- Export credits: 10/mo
- Data/search credits: 50-100/mo
- 1 intent topic
- 2 active email sequences
- Limited API quotas

### 2.2 Hunter.io

| Attribute | Detail |
|-----------|--------|
| **Free tier** | Yes (perpetual, renews monthly) |
| **Free credits** | ~25 searches + ~50 verifications/mo (unified credit system) |
| **API availability** | Yes (included on free plan) |
| **Key data** | Email finding, email verification, domain search |
| **Paid starts** | $49/month (500 searches, 1,000 verifications) |
| **Best for** | Email discovery for outbound, contact enrichment |

### 2.3 BuiltWith

| Attribute | Detail |
|-----------|--------|
| **Free tier** | Yes (API: 1 req/sec, ~2,000 lookups/day) |
| **API availability** | Yes (free limited API) |
| **Key data** | Web technologies (JS libs, analytics, CDN, CRM embeds, chat widgets) |
| **Free API limit** | Technographics: technology tag counts by group/category |
| **Paid starts** | $295/month (for deeper technographics) |
| **Best for** | Quick technographic lookup, SMB tech stack analysis |

### 2.4 Wappalyzer

| Attribute | Detail |
|-----------|--------|
| **Free tier** | Yes (50 credits/month) |
| **API availability** | Yes |
| **Key data** | CMS, frameworks, databases, analytics, payment systems |
| **Free credits** | 50/mo (1 credit per URL lookup) |
| **Rate limit** | 10 requests/second |
| **Paid starts** | $250/month (5,000 credits) |
| **Best for** | Competitive technographics, lead list building by tech |

### 2.5 Crunchbase

| Attribute | Detail |
|-----------|--------|
| **Free tier** | Removed in 2025 — no free API tier exists |
| **Paid starts** | $49/month (Basic plan) |
| **Rate limit** | 200 calls/min (all paid tiers) |
| **Key data** | Company profiles, funding, acquisitions, people, investors |
| **Best for** | Startup discovery, investor analysis, funding landscape |

### 2.6 Clearbit (HubSpot Breeze Intelligence)

| Attribute | Detail |
|-----------|--------|
| **Free tier** | Removed April 30, 2025 — only Autocomplete API remains free |
| **What's free** | Autocomplete API (company name → logo/domain, no key needed) |
| **Current access** | Only via paid HubSpot Starter+ seats (~$20/seat/mo) |
| **Key data** | Company enrichment, contact enrichment, buyer intent |
| **Best for** | Formerly: lead enrichment; now only via HubSpot ecosystem |

### 2.7 LinkedIn Sales Navigator API

| Attribute | Detail |
|-----------|--------|
| **Free tier** | None |
| **Official access** | SNAP Partner Program — applications paused as of Aug 2025 |
| **Subscription required** | Advanced Plus + approved partnership |
| **Alternatives** | Third-party scraping tools (ToS risk), CRM integrations |
| **Best for** | (Not accessible without partner approval) |

### 2.8 Google Trends Data

| Method | Cost | Reliability | B2B Use |
|--------|------|-------------|---------|
| **pytrends** (unofficial Python lib) | Free | Low (38% success rate at scale, rate limits) | Prototyping niche demand checks |
| **SerpApi Trends endpoint** | Free: 100 searches/mo; Paid: $50/mo for 5k | High | Production-ready trending data |
| **DataForSEO Trends API** | Per-request pricing | High | Integrated with other SEO data |

### 2.9 SimilarWeb

| Attribute | Detail |
|-----------|--------|
| **Free tier** | Web interface only (no free API) |
| **API pricing** | ~$500-$3,000+/month (custom) |
| **Key data** | Traffic estimates, traffic sources, keywords, audience |
| **Best for** | Traffic benchmarking (when budget allows) |

### 2.10 Reddit API

| Attribute | Detail |
|-----------|--------|
| **Free tier** | Yes (non-commercial) |
| **Rate limit** | 100 queries/min (authenticated); 10/min (unauthenticated) |
| **Commercial pricing** | $0.24 per 1,000 API calls |
| **Pushshift** | Free for historical data; status uncertain for near-real-time |
| **Best for** | B2B VOC research, pain point discovery, community monitoring |

---

## 3. Free & Open-Source Data APIs

| Source | Cost | What It Provides | Best for |
|--------|------|------------------|----------|
| **Company Researcher** (icp-researcher) | Free + API keys (Exa.ai + Anthropic) | Full company enrichment via web research (LinkedIn, Crunchbase, news, social) | Deep company profile on demand |
| **Company Atlas** | Free (open source) | Firmographic REST API (top 1,000 Fortune US companies) | US company firmographics |
| **SEC EDGAR** | Free (public data) | Company financial filings, XBRL data | Public company financial analysis |
| **Google Data Commons** | Free | 200K+ statistical variables, 200+ datasets (demographics, economy) | Market sizing, demographic analysis |
| **S&P Global / DUNL.org** | Free | 25M+ company identifiers (Creative Commons licensed) | Company identity and matching |
| **OpenAlex** | Free | 250M+ academic works, author data | Academic research into niche areas |
| **Crunchbase (web scrape)** | Free (via Apify actors or custom scrape) | Company data (no API key needed if scraping web interface) | Startup discovery without API costs |
| **Wikipedia API** | Free (public) | Company descriptions, history, financials, references | Company background research |
| **GitHub API** | Free (5,000 req/hr authenticated) | Repository data, organization profiles, code metrics | Developer tools niche research |

---

## 4. MCP Servers for Research

### 4.1 Search MCP Servers

| MCP Server | Free Tier | Key Features | B2B Use Case |
|-----------|-----------|-------------|-------------|
| **Brave Search MCP** | 2,000 req/mo (or self-host for unlimited free) | Web, news, image, video, local business search | General web research, competitor news |
| **Tavily MCP** | 1,000 searches/mo (student verification) | Clean structured answers + source URLs + relevance scoring | Research synthesis, fact-checking |
| **Exa Search MCP** | 1,000 credits (~$10 value, no recurring free) | Semantic search, 100M+ academic papers, AI-optimized results | High-quality search, academic references |
| **Perplexity Search MCP** | Requires API key | Detailed contextual results with citations | In-depth research queries |
| **SearXNG MCP** | Unlimited free (self-hosted, open source) | Meta-search across engines, no API key needed | Private, uncapped web search |
| **OpenWebSearch MCP** | Free, no API keys | Multi-engine (Bing, Baidu, Brave, Exa, GitHub) | Broad multi-engine coverage |
| **Keenable Web Search MCP** | Free, no account needed | Ranked results + markdown page fetching | Simple research integration |
| **GroundRoute** | $10 free credit | Single API for 6 engines (Serper, Brave, Exa, Tavily, Firecrawl, Perplexity) | Multi-engine comparison |
| **Jina AI MCP** | 10M tokens free | Reader, search, academic search (arXiv) | Web + academic research |
| **Bright Data MCP** | 5,000 req/mo free | Web search + scraping-as-markdown, anti-blocking | Large-scale data collection |
| **Web Explorer MCP** | Unlimited free (self-hosted) | Private web search via local SearXNG + Playwright | Privacy-focused research |
| **Google CSE MCP** | 100 searches/day free | Google search via Custom Search Engine | Google-specific search results |

### 4.2 Specialized Research MCP Servers

| MCP Server | Free Tier | Key Features | B2B Use Case |
|-----------|-----------|-------------|-------------|
| **Reddit Research MCP** | Free (hosted, no credentials needed) | Semantic search across 20K+ active subreddits, research reports | B2B VOC, pain point discovery, community trends |
| **WhoisXML API MCP** | Free (server) + free API credits on signup | 17 APIs for WHOIS, DNS, reverse lookups, IP intelligence, subdomains | Company infrastructure research, domain investigation |
| **CrawlForge MCP Server** | 1,000 free credits (no credit card) | 27 tools: scraping, crawling, deep research, SERP rank tracking, autonomous research agent | Multi-purpose web research |
| **Research MCP Collection (gregpriday)** | Mix of free tiers | 5 servers: Perplexity, Serper (2,500 free queries), Data Commons, Wolfram Alpha (2,000 free/mo) | Unified research toolkit |
| **Apify MCP Research Server** | Pay-per-event ($0.01/search) | GDELT news search, OpenAlex academic search, AI summarization | News + academic research |
| **SEC EDGAR MCP** | Free (MIT license, public data) | Company submissions, financial concepts, XBRL data across companies | Public company financial analysis |
| **b2b-data-gateway-mcp** | Free | Integrates GitHub API, Fake Store API, OpenMeteo, REST Countries | Multi-source B2B data (generic) |
| **FetchSERP MCP** | 250 free credits | Domain analysis (backlinks, DNS, WHOIS, SSL, tech stack), keyword research, SERP analysis | SEO + domain intelligence |
| **Easy MCP AI (WordPress)** | Free | 215 tools including GA4, Search Console, Semrush, DataForSEO, Ahrefs integrations | WordPress site data + SEO intelligence |

### 4.3 MCP Discovery Platforms

| Platform | What It Hosts | URL |
|----------|--------------|-----|
| **Smithery** | 15,000+ MCP servers, hosted + searchable | https://smithery.ai |
| **PulseMCP** | MCP server directory, 15,870+ listings | https://pulsemcp.com |
| **MCP.so** | Searchable MCP server registry | https://mcp.so |
| **Awesome MCP Servers** (ever-works) | Curated list on GitHub | https://github.com/ever-works/awesome-mcp-servers |

---

## 5. Use Case Matrix: Which Source for What?

### 5.1 Competitor Analysis

| Use Case | Best Source(s) | Why |
|----------|---------------|-----|
| Find all competitors ranking for your keywords | **DataForSEO Labs** — SERP Competitors + Competitors Domain | Full visibility into who owns SERP real estate |
| Analyze competitor SEO strategy | **DataForSEO Labs** — Ranked Keywords + Relevant Pages + Historical Rank | Every keyword/page they rank for + trajectory |
| Discover indirect competitors | **DataForSEO Backlinks** — Competitors endpoint | Competitors who share your backlink profile |
| Monitor competitor content strategy | **DataForSEO Labs** — Relevant Pages + Top Searches | See best-performing content per domain |
| Track competitor pricing | **DataForSEO Merchant API** | Google Shopping pricing data |
| Analyze competitor backlinks | **DataForSEO Backlinks** — Full suite | Link building strategy, link gap analysis |

### 5.2 Market Sizing

| Use Case | Best Source(s) | Why |
|----------|---------------|-----|
| Quantify search demand for niche terms | **DataForSEO Keywords API** — Search Volume | Monthly volume, CPC, competition for any keyword set |
| Estimate total addressable market size | **DataForSEO Labs** — Bulk Traffic Estimation for 1K domains | Aggregate traffic of all players in a niche |
| Count companies in a niche | **DataForSEO Business Data** — Business Listings; **DataForSEO Domain Analytics** — Domains by Technology | Find all companies by category or tech stack |
| Assess market growth rate | **DataForSEO Labs** — Historical Bulk Traffic Estimation | Traffic trends over time for all niche players |
| Geographic demand distribution | **DataForSEO Keywords API** — Search Volume by location | Regional demand hot spots |
| Industry size (revenue, employees) | **Company Atlas**, **S&P Global DUNL.org**, **Apollo.io** | Business demographics |

### 5.3 Buyer Intent Detection

| Use Case | Best Source(s) | Why |
|----------|---------------|-----|
| What searches imply purchase intent | **DataForSEO Labs** — Search Intent endpoint | Commercial/transactional intent classification |
| What prospects search before buying | **DataForSEO Keywords API** — Search Suggestions (autocomplete) + Related Keywords | Real buyer language discovery |
| Trending topics in a niche | **Google Trends** (via SerpApi or pytrends); **DataForSEO Trends API** | Rising interest signals |
| Social proof of pain points | **Reddit API** / **Reddit Research MCP** | Organic VOC from niche communities |
| Competitor customer feedback | **DataForSEO** — Business Data Reviews; **Reddit** | VOC from review platforms + Reddit |

### 5.4 Company / Competitor Discovery

| Use Case | Best Source(s) | Why |
|----------|---------------|-----|
| Find all companies using a technology | **DataForSEO Domain Analytics** — Domains by Technology | Perfect for tech-based niche segmentation |
| Find companies in a Google Maps category | **DataForSEO Business Data** — Business Listings | Category-based company discovery |
| Discover new startups in a space | **Apollo.io**, **Crunchbase** (web/paid), **Company Researcher** | Funding stage, recent launches |
| Validate company existence + contact info | **Hunter.io** (email), **Apollo.io** (company + contacts), **DataForSEO OnPage** (contact extraction) | Multi-source verification |

### 5.5 Content Strategy Research

| Use Case | Best Source(s) | Why |
|----------|---------------|-----|
| Find content gaps vs competitors | **DataForSEO Labs** — Domain Intersection + Page Intersection | Exact keyword overlap analysis |
| Identify best-performing content | **DataForSEO Labs** — Relevant Pages + Top Searches + Ranked Keywords | Traffic-driving content per competitor |
| Discover topic clusters | **DataForSEO Labs** — Related Keywords; **Keywords API** — Keywords for Site | Semantic topic discovery |
| Assess content difficulty | **DataForSEO Labs** — Bulk Keyword Difficulty | Feasibility scoring per topic |
| Analyze competitor content quality | **DataForSEO OnPage** — Pages (readability, word count, meta) | Content quality benchmarking |

### 5.6 Technographics / Tech Stack Analysis

| Use Case | Best Source(s) | Why |
|----------|---------------|-----|
| What tech stack does a company use | **DataForSEO Domain Analytics** — Domain Technologies; **BuiltWith** (free); **Wappalyzer** (free tier) | Detailed tech stack per domain |
| Find all companies using a specific tool | **DataForSEO Domain Analytics** — Domains by Technology | Bulk lead discovery by tech |
| Tech co-occurrence patterns | **DataForSEO Domain Analytics** — Aggregation Technologies | Complementary tech adoption insights |

---

## 6. Pricing Comparison Summary

### 6.1 Free Tier Availability

| Source | Free Tier | Free API Access | Useful for Production |
|--------|-----------|----------------|----------------------|
| **DataForSEO** | No free tier ($50 min deposit) | Only with deposit | Yes (pay-as-you-go, low cost) |
| **Apollo.io** | Yes | Limited quotas | No (testing only) |
| **Hunter.io** | Yes | Yes (25 searches/mo) | Low volume only |
| **BuiltWith** | Yes | Yes (~2K lookups/day) | Low volume OK |
| **Wappalyzer** | Yes | Yes (50 credits/mo) | Very low volume |
| **Crunchbase** | Removed 2025 | None | No (paid only) |
| **Clearbit** | Removed Apr 2025 | Autocomplete only | No |
| **Reddit API** | Yes (non-commercial) | Yes (100 req/min) | Non-commercial only |
| **Google Trends** | No official free (pytrends is unofficial) | pytrends (free, unreliable) | No (unreliable) |
| **SimilarWeb** | Web interface only | No free API | No |
| **SEC EDGAR** | Yes | Yes (unlimited, public data) | Yes |

### 6.2 Approximate Cost Comparison for Common Tasks

| Task | DataForSEO | Apollo.io | Hunter.io | BuiltWith | Wappalyzer |
|------|-----------|-----------|-----------|-----------|------------|
| **SERP check (1 keyword)** | $0.0006 (std) | N/A | N/A | N/A | N/A |
| **Keyword volume (100 keywords)** | $0.0006 (per req) | N/A | N/A | N/A | N/A |
| **Company tech stack (1 domain)** | ~$0.0012 | Free (limited) | N/A | Free | 1 credit |
| **Email find (1 person)** | N/A | Free (limited) | 1 credit (~$0.10 free) | N/A | N/A |
| **Backlink profile (1 domain)** | ~$0.012 | N/A | N/A | N/A | N/A |
| **Competitor keyword overlap** | ~$0.012 + $0.00012/item | N/A | N/A | N/A | N/A |
| **100 companies by tech** | ~$1.21 | Varies (credit cost) | N/A | Paid only | 50 credits (free) |
| **Business reviews (1 company)** | ~$0.012/task | N/A | N/A | N/A | N/A |

### 6.3 Best Value by Budget

| Budget | Recommended Stack |
|--------|------------------|
| **$0/mo** | BuiltWith free API + Wappalyzer free (50 credits) + Hunter.io free (25 searches) + Reddit API + free MCP servers (Brave/self-hosted SearXNG + Reddit Research MCP) + OpenAlex + SEC EDGAR |
| **$50-100/mo** | DataForSEO deposit ($50 = ~83K SERP checks or ~380K Labs items) + Hunter.io Growth ($99) + BuiltWith free |
| **$200-500/mo** | DataForSEO ($50-200) + Apollo.io Basic ($49) + Wappalyzer Pro ($250) + Hunter.io |
| **$1,000+/mo** | DataForSEO (scaled) + Apollo.io Organization + SimilarWeb API + Crunchbase API + LinkedIn SNAP (if approved) |

---

## Key Takeaways

1. **DataForSEO is the single most comprehensive API for B2B niche research** — 13 API categories covering SERP, keywords, backlinks, on-page, domain analytics (technographics + whois), business data (reviews + listings), and competitive intelligence via Labs API. Pay-as-you-go starting at $0.0006 per SERP makes it highly cost-effective.

2. **For cheapest competitor analysis workflow**: DataForSEO Labs (Competitors Domain + SERP Competitors + Domain Intersection + Bulk Keyword Difficulty) gives full competitive landscape for pennies.

3. **For contact enrichment**: Hunter.io (25 free searches/mo) + Apollo.io (free tier) for low volume; DataForSEO OnPage content parsing (free) for extracting contacts from competitor pages.

4. **For technographics**: DataForSEO Domain Analytics ($1.21/1K companies) beats BuiltWith ($295/mo paid) and Wappalyzer ($250/mo) on cost at scale. BuiltWith free API is sufficient for occasional lookups.

5. **For VOC / pain point research**: Reddit API + Reddit Research MCP (both free) is the best combo for organic B2B community insights.

6. **For market sizing**: DataForSEO Keywords API (search volume) + Labs Bulk Traffic Estimation gives TAM estimates at minimal cost.

7. **MCP ecosystem**: Free MCP servers (Brave Search, Reddit Research, CrawlForge, SearXNG) enable AI-agent-driven research without API costs. Smithery.ai and PulseMCP are the best discovery platforms.
