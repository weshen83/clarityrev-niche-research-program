# SME Tool Reference: Tier 2 (Free MCP Servers) & Tier 3 (Free APIs)

> Compiled from official documentation, API docs, and community sources.
> Last updated: 2026-07-23

---

## Table of Contents

1. [Tier 2: Free MCP Servers](#tier-2-free-mcp-servers)
   - 1.1 OpenRegistry MCP
   - 1.2 Financial Hub MCP
   - 1.3 PaperPlain MCP
   - 1.4 Serper MCP
   - 1.5 Google CSE MCP
   - 1.6 TAM-MCP-Server
2. [Tier 3: Free APIs](#tier-3-free-apis)
   - 2.1 HubSpot API
   - 2.2 Registry Lookup
   - 2.3 GDELT Project
   - 2.4 EUROSTAT API
   - 2.5 OECD API
   - 2.6 TED API (Tenders Electronic Daily)
   - 2.7 Open PageRank API
   - 2.8 Brandfetch
   - 2.9 FRED API
   - 2.10 World Bank API
   - 2.11 IMF Data API
   - 2.12 YouTube Data API v3
   - 2.13 Public ATS Job Board APIs
   - 2.14 Currents API
   - 2.15 ZEFIX API
   - 2.16 UK Companies House API
   - 2.17 CBS StatLine OData API
   - 2.18 Techmap Job Postings API
3. [Integration Matrix: Which Tool for What](#3-integration-matrix)

---

## Tier 2: Free MCP Servers

### 1.1 OpenRegistry MCP

Real-time access to official national company registries across 30 jurisdictions. Direct-from-source, unmodified raw fields and raw filing bytes.

| Attribute | Detail |
|-----------|--------|
| **MCP endpoint** | `https://openregistry.sophymarine.com/mcp` |
| **Auth** | MCP OAuth 2.1 / DCR with passwordless email sign-in (anonymous also available) |
| **Rate limit (free)** | 20 req/min (anonymous) or 30 req/min (signed-in free user) |
| **Multi-country fan-out cap** | 3 distinct jurisdictions per rolling 60s window (free tiers) |
| **Paid starts** | $9/mo Pro (180 req/min, 10 countries) |
| **Jurisdictions** | 30 national registries including NL KVK, BE KBO, UK CH, DE Handelsregister |
| **Docs** | https://github.com/sophymarine/openregistry |
| **Schema explorer** | https://glama.ai/mcp/servers/sophymarine/openregistry/schema |
| **Best for** | Company registry lookups, director checks, financial filings |

**Available Tools:**

| Tool | What It Returns | B2B Niche Use |
|------|----------------|---------------|
| `search_companies` | Companies matching name/registration number, with jurisdiction, status, registry fields | Find companies in a niche by name pattern across 30 EU/UK registries |
| `get_company_profile` | Full statutory profile: legal name, address, status, registration date, legal form | Validate company identity and legal structure for prospect verification |
| `get_officers` | Current and historic officers/directors, appointment dates, resignation dates | Identify decision-makers per company (managing directors, board members) |
| `get_shareholders` | Shareholder list, share types, ownership percentages | Understand ownership structure in privately held niche companies |
| `get_psc` | Persons with Significant Control (UBO), control types, nature of control | Ultimate beneficial ownership — useful for group structures in niche |
| `list_filings` | Filing history with category, description, date, filing type | Track financial events: annual accounts filed, director changes, incorporations |
| `fetch_document` | Raw filing document (PDF/HTML bytes) | Deep-dive into actual filed accounts, annual reports, change notifications |
| `get_financials` | Filed accounts surface: turnover, profit/loss, assets, employees | Revenue/employee sizing of niche companies (where filed) |

**Usage Pattern:**

```bash
# The MCP server is configured in your MCP client config:
# {
#   "mcpServers": {
#     "openregistry": {
#       "command": "npx",
#       "args": ["-y", "@sophymarine/openregistry-mcp"]
#     }
#   }
# }

# Once configured, tools are invoked by the AI agent:
# search_companies({ query: "DataSnipper", jurisdiction: "NL" })
# get_company_profile({ company_number: "12345678", jurisdiction: "NL" })
# get_officers({ company_number: "12345678", jurisdiction: "NL" })
# get_financials({ company_number: "12345678", jurisdiction: "NL" })
```

**Rate Limit Behavior:**

When exceeded, returns HTTP 429 with JSON-RPC error body containing `retry_after_ms`. The limit window is fixed-rolling (not adaptive), so clients should honour `retry_after_ms` exactly — exponential backoff is unnecessary.

```json
{
  "jsonrpc": "2.0",
  "error": {
    "code": -32000,
    "message": "rate-limited",
    "data": {
      "reason": "rate-limited",
      "retry_after_ms": 12400,
      "scope": "ip"
    }
  }
}
```

**Key Tips:**
- Free tier (~28,800 requests/day sustained) offers ~576x the daily headroom of OpenCorporates' free tier (50 calls/day)
- The UK Companies House upstream adapter has a 600 requests/5 min ceiling with a small 10-second in-adapter dedup cache
- NL jurisdiction uses "NL" (uppercase, ISO country code)
- Unmodified raw fields means you get the upstream registry's exact field names, not normalized labels
- For 25-niche research: use `search_companies` per niche to find all registered entities, then batch `get_financials` for revenue sizing

---

### 1.2 Financial Hub MCP

MCP server connecting AI assistants to SEC EDGAR, FRED, and Finnhub financial data.

| Attribute | Detail |
|-----------|--------|
| **NPM package** | `financial-hub-mcp` (v1.3.1) |
| **License** | MIT |
| **Auth (SEC EDGAR)** | None required — uses SEC free public APIs; set `SEC_USER_AGENT_EMAIL` env var |
| **Auth (FRED)** | Free API key from fred.stlouisfed.org required |
| **Auth (Finnhub)** | Free API key from finnhub.io required |
| **Rate limit** | SEC: 10 req/sec (built-in token-bucket limiter); FRED: 120 req/min |
| **Pricing** | Completely free — no paid tiers |
| **Docs** | https://www.npmjs.com/package/financial-hub-mcp |
| **Best for** | Public company financial analysis, corporate events, economic indicators |

**Available Tools:**

| Tool | What It Returns | B2B Niche Use |
|------|----------------|---------------|
| `search_company` | SEC-registered companies matching name/ticker with CIK numbers | Find public companies in a niche |
| `get_filings` | Recent SEC filings (10-K, 10-Q, 8-K) with form type, date, description | Public competitor financial analysis |
| `get_financial_metrics` | XBRL financial data normalized across 20+ concepts: revenue, net income, assets, liabilities | Benchmark public companies in niche by revenue, margin, growth |
| `analyze_financials` | Computed ratios (profit margin, ROE, ROA, debt/equity, current ratio) + YoY growth + 3/5yr CAGR + composite health grade (A-F) | Competitor financial health scoring |
| `compare_companies` | Side-by-side financial comparison across multiple tickers | Competitive landscape financial benchmarking |
| `search_filings_text` | Full-text search across all SEC EDGAR filings since 2001 | Find mentions of niche technologies, competitors, market sizing in filings |
| `get_corporate_events` | Recent 8-K events classified by significance (high/medium/low) | Track material events: CEO changes, M&A, new partnerships in niche |
| `screen_stocks` | Stock screening by financial criteria | Filter public companies by financial characteristics relevant to niche |

**Usage Pattern:**

```bash
# MCP client config:
# {
#   "mcpServers": {
#     "financial-hub": {
#       "command": "npx",
#       "args": ["-y", "financial-hub-mcp"],
#       "env": {
#         "SEC_USER_AGENT_EMAIL": "your@email.com",
#         "FRED_API_KEY": "your_fred_key"
#       }
#     }
#   }
# }

# Agent-invoked tools:
# get_filings({ ticker: "ADBE", form_type: "10-K" })
# get_financial_metrics({ ticker: "ADBE" })
# get_corporate_events({ cik: "0000796343", significance: "high" })
```

**Key Tips:**
- SEC EDGAR requires a valid User-Agent email — the server rejects requests without one (SEC policy, not financial-hub policy)
- For niche research: `search_filings_text` is the most powerful tool — search for niche keywords across all SEC filings to find relevant public companies, competitors, and market sizing mentions
- Built-in caching (LRU with TTL) reduces redundant calls
- FRED data is US-specific and requires a separate free API key
- **FRED non-commercial use restriction**: Verify applicability for commercial research — FRED API is free but data may have use restrictions

---

### 1.3 PaperPlain MCP

Free MCP server providing access to 200M+ peer-reviewed papers from PubMed, ArXiv, and Semantic Scholar.

| Attribute | Detail |
|-----------|--------|
| **NPM package** | `paperplain-mcp` (v1.2.5) |
| **License** | MIT |
| **Auth** | None required (no API key, no account) |
| **Rate limit** | Dependent on upstream APIs: PubMed (generous), ArXiv (strict under parallel load), Semantic Scholar (~1 req/s unauthenticated) |
| **Pricing** | Completely free and open-source |
| **Docs** | https://socket.dev/npm/package/paperplain-mcp |
| **Best for** | Academic research, technology validation, niche domain expertise |

**Available Tools:**

| Tool | What It Returns | B2B Niche Use |
|------|----------------|---------------|
| `search_research` | Papers with title, authors, abstract, published date, URL, DOI, citation count, source | Validate technology claims in niche, find academic research on niche domain |
| `fetch_paper` | Full metadata and abstract for a specific paper by ArXiv ID, PubMed ID, or DOI | Deep-dive into specific research relevant to niche |
| `find_paper_by_title` | Find a specific paper when only title is known (uses Semantic Scholar title match) | Locate known papers; optional year parameter |

**Usage Pattern:**

```bash
# MCP client config:
# {
#   "mcpServers": {
#     "paperplain": {
#       "command": "npx",
#       "args": ["-y", "paperplain-mcp"]
#     }
#   }
# }

# Agent-invoked:
# search_research({ query: "revenue intelligence B2B SaaS", domain: "general", max_results: 5 })
# fetch_paper({ id: "10.1000/xyz123", source: "doi" })
# find_paper_by_title({ title: "Market Sizing for Vertical SaaS", year: 2024 })
```

**Auto-Routing:**
- Health/medical queries -> PubMed + Semantic Scholar
- CS/AI queries -> ArXiv + Semantic Scholar
- General queries -> All three sources

**Key Tips:**
- Pass a Semantic Scholar API key via `S2_API_KEY` env var to raise rate limit from ~1 req/s to 100 req/s
- When rate-limited, `search_research` returns a `warnings` field explaining which source failed
- Returns real DOIs and PMIDs — no hallucinated citations
- Use for niche technology validation: search for research papers on the niche domain's technical or business aspects
- The `domain` parameter optimizes routing: use "health" for medical niches, "cs" for software niches

---

### 1.4 Serper MCP

MCP server providing Google search results via Serper.dev API — low latency, structured JSON.

| Attribute | Detail |
|-----------|--------|
| **MCP packages** | `serper-search-mcp`, `serper-dev-mcp`, `go-serper-mcp-server` (multiple implementations) |
| **API key required** | Yes — free from https://serper.dev |
| **Free tier** | 2,500 free queries (one-time starter credits) |
| **Paid starts** | $50/month for 50,000 searches (~$0.001/search) |
| **Latency** | 1-2 seconds typical |
| **Concurrency** | 300 queries/second default |
| **Best for** | Web search, SERP data, Google results in MCP-native format |

**Available Tools (varies by package — typical set):**

| Tool | What It Returns | B2B Niche Use |
|------|----------------|---------------|
| `search` | Google organic results: title, link, snippet, position | General web research on niche |
| `news_search` | Google News results | Recent news about niche companies, technologies |
| `image_search` | Google Image results | Brand assets, logos, product images |
| `places_search` | Google Places / local business results | Find niche businesses by location |
| `scholar_search` | Google Scholar results | Academic papers related to niche |
| `search_similar` | "People also searched for" results | Discover related niches, indirect competitors |
| `autocomplete` | Google Autocomplete suggestions | Keyword discovery — what users search for in niche |

**Usage Pattern:**

```bash
# MCP client config:
# {
#   "mcpServers": {
#     "serper": {
#       "command": "npx",
#       "args": ["-y", "serper-search-mcp"],
#       "env": {
#         "SERPER_API_KEY": "your_key_here"
#       }
#     }
#   }
# }

# Agent-invoked:
# search({ query: "accounting firms Netherlands SME niche 2026", num: 10 })
# news_search({ query: "revenue intelligence startup funding", num: 5 })
# autocomplete({ query: "best accounting software for" })
```

**Key Tips:**
- Free 2,500 queries are one-time credits — not monthly recurring. Use strategically for niche validation, not bulk operations
- At $0.30/1,000 queries on pay-as-you-go, bulk niche research costs pennies
- Combine with Firecrawl: use Serper MCP for discovery, then Firecrawl `scrape` for page content extraction
- Results are uncached Google queries — always fresh
- For 25-niche scoring: budget ~50 queries per niche for initial validation = 1,250 queries, then use pay-as-you-go for deeper research

---

### 1.5 Google CSE MCP

MCP server providing Google Custom Search Engine results.

| Attribute | Detail |
|-----------|--------|
| **Package** | `mcp-google-cse` by Richard-Weiss |
| **Quota** | 100 searches/day free (Google CSE default without billing) |
| **Auth** | Google Custom Search API key + CX engine ID |
| **Setup time** | ~5 min via Google Cloud Console + Programmable Search Engine |
| **Best for** | Google-specific search results in MCP-native workflows |

**Available Tool:**

| Tool | What It Returns | B2B Niche Use |
|------|----------------|---------------|
| `google_search` | Title, link, snippet for each result | Google-specific web search for niche companies, competitors |

**Parameters:**
- `search_term` (required) — the query string
- `geolocation` (optional, default: "us") — country code for geo-targeted results
- `language` (optional, default: "lang_en") — result language
- `num_results` (optional, default: 10, max: 10) — number of results

**Usage Pattern:**

```bash
# MCP client config:
# {
#   "mcpServers": {
#     "google-cse": {
#       "command": "npx",
#       "args": ["-y", "mcp-google-cse"],
#       "env": {
#         "GOOGLE_API_KEY": "your_api_key",
#         "GOOGLE_CX": "your_cx_engine_id"
#       }
#     }
#   }
# }

# Agent-invoked:
# google_search({ search_term: "site:linkedin.com/company accounting software Netherlands" })
```

**Key Tips:**
- The tool returns only search results (title, link, snippet) — not page content. Chain with `mcp-server-fetch` or Firecrawl for content extraction
- 100 searches/day is sufficient for targeted niche validation but not bulk operations
- Google CSE can be configured to search specific sites, which is powerful for niche discovery (e.g., only search Crunchbase + LinkedIn for a niche)
- For higher volume, set up billing on Google Cloud (pay-as-you-go)
- Use site-specific operators (`site:linkedin.com/company`, `site:crunchbase.com`) to target structured data sources

---

### 1.6 TAM-MCP-Server (Market Sizing MCP)

Open-source MCP server for market sizing, TAM/SAM calculations, and industry research. Integrates 8 economic data sources.

| Attribute | Detail |
|-----------|--------|
| **Package** | `@gvaibhav/tam-mcp-server` |
| **License** | MIT |
| **Auth** | None required for basic operation; API keys needed for commercial data providers (FRED, Alpha Vantage, Nasdaq) |
| **Pricing** | Free and open-source |
| **Node version** | 18+ |
| **Tools** | 28 tools across 3 tiers |
| **Prompts** | 15 business prompts (funding pitches, PE analysis, corporate strategy, ESG) |
| **Docs** | https://github.com/gvaibhav/TAM-MCP-Server |
| **Best for** | Rapid market sizing, TAM/SAM estimation, niche market opportunity sizing |

**Data Sources Integrated:**

| Source | Type | Data Provided |
|--------|------|---------------|
| **Bureau of Labor Statistics (BLS)** | US Government | Employment, wages, industry statistics |
| **U.S. Census Bureau** | US Government | Industry surveys, market size data |
| **Federal Reserve (FRED)** | US Government | 800K+ economic time series |
| **International Monetary Fund (IMF)** | International | Global economic indicators |
| **OECD** | International | Country-level economic statistics |
| **World Bank** | International | Development indicators |
| **Alpha Vantage** | Commercial | Company financials, stock data |
| **Nasdaq Data Link** | Commercial | Financial datasets |

**Tool Categories:**

| Tier | # Tools | Capabilities |
|------|---------|-------------|
| 1 (Data Access) | 13 | Direct queries to external data sources for raw financial/economic data |
| 2 (Foundation) | 4 | Basic TAM calculation, market size estimation |
| 3 (Advanced) | 11 | Market forecasting, segment analysis, opportunity identification, cross-source validation, multi-market comparison |

**Usage Pattern:**

```bash
# MCP client config:
# {
#   "mcpServers": {
#     "tam-mcp": {
#       "command": "npx",
#       "args": ["-y", "@gvaibhav/tam-mcp-server"]
#     }
#   }
# }

# Agent-invoked (conceptual):
# calculate_tam({ industry: "accounting software", region: "Netherlands" })
# market_size_estimate({ niche: "revenue intelligence", segments: ["SMB", "Mid-Market"] })
```

**Key Tips:**
- Smart defaults: $10B base market, 15% growth rate, 5-year projections for zero-friction startup sizing
- Use for initial niche opportunity sizing (TAM/SAM/SOM estimates per niche)
- Cross-source data validation tool helps reconcile conflicting data
- Combined with DataForSEO search volume data, this gives a complete demand-side + supply-side market picture
- Commercial data providers (Alpha Vantage, Nasdaq) require separate free API keys

---

## Tier 3: Free APIs

### 2.1 HubSpot API

CRM-native API for contact and company enrichment. The primary delivery channel for ClarityRev's signal output.

| Attribute | Detail |
|-----------|--------|
| **Free tier** | Yes — Free CRM tier available |
| **Rate limit (free)** | 100 requests per 10 seconds per portal (or per app per account via OAuth) |
| **Key endpoints** | Contacts, Companies, Deals, Engagements APIs all available on free tier |
| **Paid starts** | $20/seat/mo (Starter) — raises rate limit to 250 req/10s |
| **Auth** | API key (legacy) or OAuth 2.0 (recommended) |
| **Docs** | https://developers.hubspot.com/docs/overview |
| **Best for** | CRM-native signal delivery, contact enrichment, company enrichment |

**Key Endpoints:**

| Endpoint | What It Returns | B2B Niche Use |
|----------|----------------|---------------|
| `GET /crm/v3/objects/contacts` | Contact list with properties (email, name, company, custom fields) | Lead list management, enrichment |
| `POST /crm/v3/objects/contacts` | Create/update contact with custom properties | Ingest enriched prospect data into CRM |
| `GET /crm/v3/objects/companies` | Company list with properties (name, domain, industry, revenue, employees) | Company-level CRM data management |
| `PATCH /crm/v3/objects/companies/{id}` | Update company properties | Enrich company records with signal data |
| `POST /crm/v3/objects/companies/search` | Search companies by domain, name, or custom property | Match research data to CRM records |
| `POST /crm/v3/properties/contact` | Create custom contact properties | Define niche-specific data fields |
| `GET /crm/v3/objects/deals` | Deal pipeline data | Sales pipeline analysis per niche |

**Usage Pattern:**

```bash
# Search company by domain
curl -X POST "https://api.hubapi.com/crm/v3/objects/companies/search" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "filterGroups": [{
      "filters": [{
        "propertyName": "domain",
        "operator": "EQ",
        "value": "example.com"
      }]
    }]
  }'

# Batch create/update contacts (for ingesting research data)
curl -X POST "https://api.hubapi.com/crm/v3/objects/contacts/batch/upsert" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "inputs": [{
      "idProperty": "email",
      "id": "contact@company.com",
      "properties": {
        "company": "Example Corp",
        "jobtitle": "CTO",
        "hs_lead_status": "OPEN"
      }
    }]
  }'
```

**Key Tips:**
- 100 req/10s = ~10 req/s sustained — sufficient for moderate enrichment, consider batching for scale
- Use batch endpoints (`/batch/upsert`, `/batch/read`) to maximize throughput within rate limits
- Custom properties must be created via the Properties API before use in search/update
- For 25-niche delivery: create a separate custom property per niche to tag contacts/companies
- Integration pattern: DataForSEO -> enrichment logic -> HubSpot API = signal delivery pipeline
- HubSpot's search endpoint supports complex filtering (AND/OR groups, multiple property conditions)

---

### 2.2 Registry Lookup

Free API providing access to 521M+ legal entities across 309 jurisdictions in 244 countries.

| Attribute | Detail |
|-----------|--------|
| **Free tier** | 5,000 free API calls per month |
| **Coverage** | 521M+ entities, 309 jurisdictions, 244 countries |
| **Auth** | Free API key signup (no credit card required) |
| **Rate limit** | Not publicly specified |
| **Paid starts** | Enterprise pricing for deeper data (ownership, ESG, supply chain) |
| **Best for** | Global company registry lookup, entity verification, jurisdiction discovery |

**Key Features:**

| Feature | What It Returns | B2B Niche Use |
|---------|----------------|---------------|
| **Company search by name** | Registration details, jurisdiction, legal form, status | Find companies in niche across global registries |
| **Registry number lookup** | Full entity profile with addresses, status | Verify specific company identity |
| **Jurisdiction browsing** | Available registries by country | Discover which registries cover which niches |
| **Autocomplete** | Company name suggestions | Quick company lookup during research |

**Usage Pattern:**

```bash
# Search company by name
curl "https://api.registry-lookup.com/v1/search?q=DataSnipper&jurisdiction=NL" \
  -H "Authorization: Bearer YOUR_API_KEY"

# Lookup by registry number
curl "https://api.registry-lookup.com/v1/company?registry_id=12345678&jurisdiction=NL" \
  -H "Authorization: Bearer YOUR_API_KEY"
```

**Key Tips:**
- 5,000 calls/month = ~166 calls/day, sufficient for targeted niche validation but not bulk
- The free tier covers registry-level data (names, IDs, jurisdictions, status); deeper data (ownership, supply chain) requires enterprise pricing via Veridion
- Includes an MCP server for AI agent integration
- For 25-niche research: use strategically for niche-specific company lookups where OpenRegistry doesn't have jurisdiction coverage

---

### 2.3 GDELT Project

Global news monitoring API covering 100K+ outlets in 65 languages.

| Attribute | Detail |
|-----------|--------|
| **Pricing** | Completely free |
| **Coverage** | 100K+ news outlets, 65 languages, 200+ countries |
| **API URL** | `https://api.gdeltproject.org/api/v2/doc/doc` |
| **Rate limit** | ~1 request per 5 seconds (be polite) |
| **Auth** | None required |
| **Docs** | https://blog.gdeltproject.org/gdelt-2-0-api-dev-testing/ |
| **Best for** | News monitoring, intent signals, trend detection, competitive intelligence |

**Key Endpoints:**

| Endpoint | What It Returns | B2B Niche Use |
|----------|----------------|---------------|
| `/api/v2/doc/doc` | News articles matching query with timestamps, source, tone, locations, people, organizations | Niche news monitoring, competitor mentions, industry trends |
| `/api/v2/doc/gkg` | Global Knowledge Graph: themes, emotions, events, counts over time | Trend analysis — topic volume over time, emotional tone shifts |
| `/api/v2/doc/geo` | Geo-tagged event data | Geographic distribution of niche-related news |
| `/api/v2/doc/wordcloud` | Word cloud from article corpus | Key terms and themes in niche coverage |

**Query Parameters:**

| Parameter | Description | Example |
|-----------|-------------|---------|
| `query` | Full-text search (boolean operators supported) | `"revenue intelligence" AND startup` |
| `mode` | Output mode: `artlist` (article list), `timelinevol`, `timelinevolraw`, `sourcecountry` | `mode=artlist` |
| `format` | Response format: `json`, `html`, `csv` | `format=json` |
| `maxrecords` | Max articles returned (default 75, max 250) | `maxrecords=50` |
| `startdatetime` | Start date (YYYYMMDDHHMMSS) | `startdatetime=20260101000000` |
| `enddatetime` | End date | `enddatetime=20260701000000` |
| `sourcecountry` | Filter by country code | `sourcecountry=NL` |
| `sourcelang` | Filter by language code | `sourcelang=dutch` |

**Usage Pattern:**

```bash
# Search recent news about a niche topic
curl "https://api.gdeltproject.org/api/v2/doc/doc?query=%22accounting%20software%22%20AND%20%22Netherlands%22&mode=artlist&format=json&maxrecords=50"

# Get timeline of news volume for a niche
curl "https://api.gdeltproject.org/api/v2/doc/doc?query=%22revenue%20intelligence%22&mode=timelinevol&format=json"

# Get tone analysis for niche mentions
curl "https://api.gdeltproject.org/api/v2/doc/doc?query=%22AI%20accounting%22&mode=tone&format=json&timelinesmooth=5"
```

**Key Tips:**
- Rate limit is undocumented but aggressive scraping will trigger IP blocks — minimum 5-second delay between requests
- Boolean operators supported: `AND`, `OR`, `NOT`, `"phrase matching"`, `()` for grouping
- `sourcecountry=NL` filters for Dutch news sources — useful for Netherlands-focused niche research
- The tone field (sentiment score, -100 to +100) can be used for competitive sentiment analysis
- For 25-niche research: set up recurring niche queries and track volume/tone trends over time
- Combine with Currents API (next) for more flexible article retrieval — GDELT is better for trend analytics, Currents for article content

---

### 2.4 EUROSTAT API

Free API providing EU industry statistics by NACE code. No authentication required.

| Attribute | Detail |
|-----------|--------|
| **Base URL** | `https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/` |
| **Auth** | None required |
| **Rate limit** | ~30 requests/min (best practice); no hard limit documented |
| **Pricing** | Completely free — open data |
| **License** | Creative Commons Attribution 4.0 |
| **Data coverage** | EU27 + EFTA + candidate countries |
| **Best for** | EU market sizing by NACE code, industry statistics, economic indicators |

**Key Endpoints:**

| Endpoint Pattern | What It Returns | B2B Niche Use |
|------------------|----------------|---------------|
| `/data/{dataset}.json` | Dataset values in JSON format | Industry statistics for niche market sizing |
| `/data/{dataset}.csv` | Dataset as CSV | Bulk download for spreadsheet analysis |
| `/data/{dataset}?params` | Filtered data by NACE code, geo, time period | NACE-code-specific industry sizing |

**Key Datasets for B2B Research:**

| Dataset Code | Description | Use Case |
|-------------|-------------|----------|
| `sbs_na_ind_r2` | Structural business statistics by NACE Rev.2 — number of enterprises, turnover, employment | Count companies in niche industry; estimate total market revenue |
| `nama_10_a64` | GDP and main components by industry (NACE A64) | Industry value added — size the industry's GDP contribution |
| `employ` | Employment by industry (full-time equivalent) | Employee headcount in niche industry |
| `sbs_sc_1b_se_r2` | Business demography by size class | Split niche by company size (SME vs large) |

**Usage Pattern:**

```bash
# Get structural business data for "Computer programming, consultancy" (NACE J62)
# Number of enterprises in Netherlands, 2022
curl "https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/sbs_na_ind_r2.json?NACE_R2=J62&geo=NL&time=2022"

# Get employment in accounting activities (NACE M69.2) for all EU countries
curl "https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/employ.json?nace=M69.2&geo=EU27_2020&time=2022"

# Get number of enterprises in legal/accounting activities for Netherlands
curl "https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/sbs_sc_1b_se_r2.json?nace=M69&geo=NL&indic=NB&time=2022"
```

**NACE-to-Niche Mapping Strategy:**

| Niche Example | NACE Code | NACE Description |
|--------------|-----------|-----------------|
| Accounting software | M69.2 | Accounting, bookkeeping, auditing activities |
| Recruitment tech | N78.1 | Employment placement agencies |
| Legal tech for SMEs | M69.1 | Legal activities |
| Consulting | M70.22 | Business and other management consultancy |
| IT services | J62.0 | Computer programming, consultancy |
| Facility management | N81 | Services to buildings and landscape |

**Key Tips:**
- NACE codes are hierarchical — use broad 2-digit (e.g., M69) for industry sizing, narrow 4/5-digit for specific sub-markets
- Dataset codes can change between catalog revisions — verify via the Eurostat data browser first
- JSON response can be large; use CSV format for bulk downloads
- Cache aggressively — data updates infrequently (quarterly or annually)
- For 25-niche research: create a NACE-to-niche mapping table, then batch query across all niches for consistent market sizing
- Not all datasets have data for all years or all countries — check data availability via the Eurostat metadata API

---

### 2.5 OECD API

Free, public API providing economic and social data for 40+ member countries and 100+ partner economies.

| Attribute | Detail |
|-----------|--------|
| **Base URL** | `https://sdmx.oecd.org/public/rest` (v1.5) or `https://sdmx.oecd.org/public/rest/v2` |
| **Auth** | None required |
| **Rate limit** | No official limits documented; "reasonable use" expected |
| **Pricing** | Completely free |
| **Data coverage** | 40+ member countries, 100+ partner economies, 900+ datasets |
| **Best for** | Cross-country economic comparison, industry statistics, macro-level market sizing |

**Key Endpoints:**

| Endpoint | What It Returns | B2B Niche Use |
|----------|----------------|---------------|
| `GET /data/{dataflow}/{key}` | Time series data for specified indicator and countries | Industry statistics by country |
| `GET /dataflow/{agencyId}/{resourceId}/{version}` | Metadata about available datasets | Discover datasets relevant to niche |
| `GET /datastructure/{agencyId}/{resourceId}/{version}` | Data structure definitions (dimensions, attributes) | Understand data model for querying |
| `GET /codelist/{agencyId}/{resourceId}/{version}` | Code lists for dimension values | Find correct codes for countries, industries |

**Common Dataflows for B2B Research:**

| Dataflow | Code | Description |
|----------|------|-------------|
| Quarterly National Accounts | QNA | GDP, value added by industry |
| Labour Force Statistics | LFS | Employment by industry, unemployment |
| Structural Business Statistics | SBS | Enterprises, turnover, employment by industry |
| Science, Technology and Patents | STI | R&D spending, patents by industry |
| Entrepreneurship Indicators | ETCR | Business creation rates, self-employment |

**Usage Pattern:**

```bash
# Get GDP for Netherlands, quarterly, 2020-2024
curl "https://sdmx.oecd.org/public/rest/data/OECD.SDD.NAD,DSD_NAMAIN1@DF_QNA,1.0/.NL.B1GQ......?format=jsondata&startPeriod=2020-Q1&endPeriod=2024-Q4"

# Get self-employment rate (entrepreneurship indicator)
curl "https://sdmx.oecd.org/public/rest/data/OECD.ECO.MBC,DSD_MBC@DF_MBC_PUB,1.0/.NL.SEMP.NSAA?format=jsondata"
```

**Key Tips:**
- Prefer SDMX-JSON format (`format=jsondata`) for programmatic access
- Use the OECD Data Explorer (oecd.org) "Developer API" tool to interactively build queries
- Country codes follow ISO 3166 (NL = Netherlands, DE = Germany, etc.)
- For bulk jobs, add a 1-second delay between requests
- The new SDMX 2.1 API (launched 2024) replaces the legacy OECD.Stat API
- For 25-niche research: use OECD for cross-country validation of market size estimates from EUROSTAT and national sources

---

### 2.6 TED API (Tenders Electronic Daily)

EU government contract awards — a growth signal for B2B niche companies.

| Attribute | Detail |
|-----------|--------|
| **Official URL** | https://ted.europa.eu |
| **API v3** | Free, open, no authentication required |
| **TEDective (OSS)** | https://api.tedective.org — OCDS-compliant JSON, docs at /docs and /redoc |
| **Rate limit** | Not officially documented for TED v3; TEDective is updated monthly |
| **Pricing** | Completely free |
| **Coverage** | All 27 EU member states + EEA + candidate countries |
| **Best for** | Growth signals via government contracts, competitive landscape via procurement data |

**Available Data:**

| Data Type | What It Returns | B2B Niche Use |
|-----------|----------------|---------------|
| **Tender notices** | Contract award details: buyer, winner, value, CPV code, date | Which companies win government contracts in the niche |
| **Contract values** | Awarded contract amounts | Revenue sizing for niche companies serving government |
| **CPV codes** | Common Procurement Vocabulary classification | Map niche to government procurement categories |
| **Buyer data** | Government buyer names, departments | Identify target government buyers for niche |

**Usage Pattern:**

```bash
# TEDective API — search tenders by CPV code
# CPV 48000000 = Software and information systems
curl "https://api.tedective.org/tenders?cpv=48000000&country=NL&limit=50"

# Search by keyword + country
curl "https://api.tedective.org/tenders?query=accounting&country=NL&limit=10"

# Get tender details
curl "https://api.tedective.org/tenders/{tender_id}"
```

**CPV Codes for Common B2B Niches:**

| Niche | CPV Code |
|-------|----------|
| Accounting software | 48440000 (accounting software package) |
| HR/recruitment software | 48450000 (time accounting or HR software) |
| CRM software | 48460000 (analytical/accounting/CRM software) |
| IT consulting | 72220000 (systems and technical consulting) |
| Business intelligence | 72320000 (database services) |

**Key Tips:**
- TEDective provides OCDS (Open Contracting Data Standard) compliant JSON — cleaner than raw TED XML
- Bulgarian buyers are over-represented due to national transparency requirements — adjust weighting accordingly
- Use CPV code filtering for precise niche targeting
- For 25-niche research: identify which niches have government procurement activity; high contract volume = validated demand, low = limited government market
- TED data updates daily; TEDective processes at least monthly

---

### 2.7 Open PageRank API

Domain authority scoring via Google PageRank data.

| Attribute | Detail |
|-----------|--------|
| **Endpoint** | `https://openpagerank.com/api/v1.0/getPageRank` |
| **Auth** | Free API key (sign up at domcop.com/openpagerank) |
| **Batch limit** | Max 100 domains per API request |
| **Rate limit** | ~10,000 calls/hour (Apify actor estimate) |
| **Pricing** | Free tier available (exact daily limit needs verification via signup) |
| **Output** | `page_rank_integer` (0-10), `page_rank_decimal`, `rank` |
| **Best for** | Domain authority scoring, website credibility assessment |

**Usage Pattern:**

```bash
# Check PageRank for multiple competitor domains at once
curl "https://openpagerank.com/api/v1.0/getPageRank?domains[]=google.com&domains[]=apple.com&domains[]=accountingsoftware.nl" \
  -H "API-OPR: YOUR_API_KEY"

# Response format:
# {
#   "status": 200,
#   "response": [
#     {
#       "domain": "google.com",
#       "page_rank_integer": 10,
#       "page_rank_decimal": 9.72,
#       "rank": 1
#     }
#   ]
# }
```

**Key Tips:**
- Batch up to 100 domains per request — always batch to minimize rate limit consumption
- PageRank 0-2 = low authority (new sites, SMBs); 3-5 = moderate; 6-10 = high authority
- Use for competitive analysis: compare domain authority of companies in a niche
- For 25-niche research: batch score all discovered companies per niche to identify market leaders (high PR) vs. new entrants (low PR)
- NOTE: Exact daily limit for free tier needs verification — check official site

---

### 2.8 Brandfetch

Company logo and brand data API.

| Attribute | Detail |
|-----------|--------|
| **Free tier** | Logo API: 500K requests/month (soft fair-use limit) |
| **Brand Search API** | 500K requests/month on free tier |
| **Brand API (separate)** | $99/month for 2,500 calls |
| **Rate limit** | 100 req/sec sustained; burst cap 30K req/5 min |
| **Auth** | Free API key (no credit card required) |
| **Attribution** | Not required |
| **Paid starts** | Growth plan from $99/month (for higher Brand API volume) |
| **Docs** | https://docs.brandfetch.com |
| **Best for** | Company logos, brand colors, social links, company description |

**Key Endpoints:**

| Endpoint | What It Returns | B2B Niche Use |
|----------|----------------|---------------|
| `GET /v2/brand/{domain}` | Logo (SVG/PNG), brand colors, fonts, social links, company description | Visual brand enrichment for prospect profiles |
| `GET /v2/company/{domain}` | Company description, industry, founded year, employee count | Quick company enrichment data |
| `GET /v2/search?query={name}` | Logo URL, domain for named company | Find company logo when only name is known |

**Usage Pattern:**

```bash
# Get brand data for a company
curl "https://api.brandfetch.io/v2/brand/example.com" \
  -H "Authorization: Bearer YOUR_API_KEY"

# Search for company by name
curl "https://api.brandfetch.io/v2/search?query=DataSnipper" \
  -H "Authorization: Bearer YOUR_API_KEY"
```

**Key Tips:**
- 500K free requests/month is extremely generous — sufficient for all 25-niche research combined
- The free Logo API is completely separate from the paid Brand API — stick with Logo API for free tier research
- Monitor usage via `x-api-key-approximate-usage` response header; 80% triggers email warning
- Essential for website/enrichment workflows: logos for all identified niche companies
- Combine with OpenRegistry or Registry Lookup for fuller enrichment: registry data + brand data = comprehensive company profile

---

### 2.9 FRED API (Federal Reserve Economic Data)

US macro-economic data — 800K+ time series.

| Attribute | Detail |
|-----------|--------|
| **Base URL** | `https://api.stlouisfed.org/fred/` |
| **Auth** | Free API key from research.stlouisfed.org |
| **Rate limit** | 120 req/min (with key); 30 req/min (without); ~6,000 req/day |
| **Pricing** | Completely free (no paid tier exists) |
| **Data coverage** | US economic data: GDP, employment, CPI, interest rates, industry production |
| **Best for** | US macro-economic context for niche market sizing |

**Key Endpoints:**

| Endpoint | What It Returns | B2B Niche Use |
|----------|----------------|---------------|
| `/fred/series/observations` | Time series data values | Historical economic trends relevant to niche |
| `/fred/series/search` | Search available series by keyword | Find relevant economic indicators for niche |
| `/fred/series` | Series metadata (title, units, frequency) | Understand data context |
| `/fred/category` | Category listing and series within categories | Browse economic sectors |

**Usage Pattern:**

```bash
# Get GDP data (series ID: GDP)
curl "https://api.stlouisfed.org/fred/series/observations?series_id=GDP&api_key=YOUR_API_KEY&file_type=json"

# Search for industry-specific series
curl "https://api.stlouisfed.org/fred/series/search?search_text=accounting%20services&api_key=YOUR_API_KEY&file_type=json"

# Get recession dates for context
curl "https://api.stlouisfed.org/fred/series/observations?series_id=USREC&api_key=YOUR_API_KEY&file_type=json"
```

**Key Tips:**
- Add a 0.6-second delay between calls to stay under 120/min ceiling
- HTTP 429 indicates rate limit hit — implement retry logic
- **Non-commercial use restriction**: FRED API data terms of use state "non-commercial use only" — verify applicability for ClarityRev's commercial research pipeline. Data itself is public domain, but API access terms may restrict commercial redistribution
- FRED is US-specific — for EU niche research, prefer EUROSTAT or OECD
- Use for US market sizing context when niches have meaningful US market component
- Some key series IDs: GDP, UNRATE (unemployment), PAYEMS (non-farm payrolls), CPIAUCSL (CPI), DGS10 (10-year Treasury)

---

### 2.10 World Bank API

Global economic and development indicators — free, unlimited, no authentication.

| Attribute | Detail |
|-----------|--------|
| **Base URL** | `https://api.worldbank.org/v2` |
| **Auth** | None required |
| **Rate limit** | No official limits |
| **Pricing** | Completely free |
| **License** | CC BY 4.0 (commercial use permitted with attribution) |
| **Data coverage** | 200+ countries, 16,000+ indicators, data from 1960 |
| **Formats** | JSON, XML, JSONP, JSON-stat |
| **Best for** | Global economic context, country comparison, macro market sizing |

**Key Endpoints:**

| Endpoint | What It Returns | B2B Niche Use |
|----------|----------------|---------------|
| `GET /indicator/{code}` | Metadata for a specific indicator | Understand indicator definition |
| `GET /country/{code}/indicator/{code}` | Time series data for one country | Country-level market context |
| `GET /country/all/indicator/{code}` | Data for all countries | Global comparison for niche |
| `GET /country/{code}` | Country metadata (region, income level, capital) | Country profile for niche targeting |

**Key Indicators for B2B Research:**

| Code | Indicator | Use Case |
|------|-----------|----------|
| `NY.GDP.MKTP.CD` | GDP (current US$) | Market size context |
| `NY.GDP.PCAP.CD` | GDP per capita | Proxy for buyer purchasing power |
| `SP.POP.TOTL` | Population | TAM ceiling |
| `SL.UEM.TOTL.ZS` | Unemployment (% labor force) | Labor market context |
| `FP.CPI.TOTL.ZG` | Inflation, consumer prices | Economic stability |
| `IC.BUS.EASE.XQ` | Ease of doing business rank | Business environment for niche |
| `SE.ADT.LITR.ZS` | Adult literacy rate | Digital adoption proxy |
| `IT.NET.USER.ZS` | Internet users (% pop) | Digital readiness |
| `GB.XPD.RSDV.GD.ZS` | R&D expenditure (% GDP) | Innovation investment |

**Usage Pattern:**

```bash
# Get GDP for Netherlands, 2019-2023
curl "https://api.worldbank.org/v2/country/NL/indicator/NY.GDP.MKTP.CD?format=json&date=2019:2023"

# Get internet users (% population) for all EU countries, latest year
curl "https://api.worldbank.org/v2/country/EUU/indicator/IT.NET.USER.ZS?format=json&date=2022:2023"

# Get country metadata
curl "https://api.worldbank.org/v2/country/NL?format=json"
```

**Key Tips:**
- Country codes are ISO 3-letter uppercase: NLD, USA, GBR (not NL, US, GB)
- The `?per_page=` parameter controls how many results per page (max 50, default 10)
- Use `?mrv=1` (most recent value) to get the latest available data point without specifying a date
- For 25-niche research: build a country profile matrix with key indicators as a quick-filter for market attractiveness
- CC BY 4.0 permits commercial use with attribution — safe for ClarityRev's pipeline
- Cache aggressively — data updates infrequently

---

### 2.11 IMF Data API

Global financial and economic data — free, no API key required for key endpoints.

| Attribute | Detail |
|-----------|--------|
| **DataMapper API** | `https://www.imf.org/external/datamapper/api/v1` |
| **Legacy SDMX API** | `http://dataservices.imf.org/REST/SDMX_JSON.svc/` |
| **Auth** | None required (DataMapper and legacy SDMX are key-free) |
| **SDMX 3.0** | `https://api.imf.org/external/sdmx/3.0` — requires subscription key |
| **Rate limit** | No official limits; 1 req/sec recommended |
| **Pricing** | Completely free |
| **Coverage** | 190+ countries, World Economic Outlook + Financial Statistics + more |
| **Best for** | Macro-economic context, country financial health, global market sizing |

**Key Endpoints (DataMapper API):**

| Endpoint | What It Returns | B2B Niche Use |
|----------|----------------|---------------|
| `GET /api/v1/indicators` | All available indicator codes | Discover relevant indicators for niche |
| `GET /api/v1/{indicator}?periods={year}` | Indicator values for all countries | Cross-country comparison |
| `GET /api/v1/{indicator}/{country}?periods={year}` | Single country indicator | Country-level economic context |

**Key Indicators:**

| Code | Description | Use Case |
|------|-------------|----------|
| `NGDP_RPCH` | Real GDP growth (% change) | Market growth context |
| `PCPIPCH` | CPI inflation (% change) | Economic stability |
| `BCA_NGDPD` | Current account balance (% GDP) | External economic position |
| `GGXWDG_NGDP` | Government gross debt (% GDP) | Fiscal health |
| `LUR` | Unemployment rate (%) | Labor market |
| `NGDPD` | GDP, current prices (USD billions) | Market size |
| `NGDPDPC` | GDP per capita (USD) | Buyer purchasing power proxy |

**Usage Pattern:**

```bash
# Real GDP growth for all countries in 2024 — no key needed
curl "https://www.imf.org/external/datamapper/api/v1/NGDP_RPCH?periods=2024"

# GDP per capita for select countries
curl "https://www.imf.org/external/datamapper/api/v1/NGDPDPC?periods=2024"

# Legacy SDMX — get CPI for US and China, 2020-2025
curl "http://dataservices.imf.org/REST/SDMX_JSON.svc/CompactData/IFS/M.US+CN.PCPI_IX?startPeriod=2020&endPeriod=2025"
```

**Key Tips:**
- The DataMapper API is the simplest option — just use indicator codes and periods
- For 25-niche research: combine IMF GDP data with EUROSTAT industry data to estimate niche market sizes at country level
- IMF data updates infrequently (semi-annual WEO reports, monthly IFS) — cache long-term
- Country codes: DataMapper uses ISO 3-letter codes; legacy SDMX uses 2-letter codes
- The legacy SDMX endpoint (`dataservices.imf.org`) is HTTP, not HTTPS — verify mixed content settings

---

### 2.12 YouTube Data API v3

Video content search and competitor channel analysis.

| Attribute | Detail |
|-----------|--------|
| **Free quota** | 10,000 quota units per day per Google Cloud project |
| **Auth** | Google Cloud API key (from Google Cloud Console) |
| **Quota cost** | Search = 100 units; video details = 1 unit; channel list = 1 unit |
| **Max daily searches** | ~100 search queries (10,000 / 100) |
| **Paid** | Cannot directly pay — request free quota increase via Google form |
| **Best for** | Competitor channel analysis, video content research, niche content discovery |

**Key Endpoints:**

| Endpoint | Quota Cost | What It Returns | B2B Niche Use |
|----------|-----------|-----------------|---------------|
| `search.list` | 100 units | Videos, channels, playlists matching query | Discover competitor content in niche |
| `videos.list` | 1 unit | Video metadata: title, description, stats (views, likes, comments) | Analyze content performance |
| `channels.list` | 1 unit | Channel metadata: subscriber count, video count, total views | Assess competitor channel size |
| `playlistItems.list` | 1 unit | Items within a playlist | Content series and curriculum analysis |
| `commentThreads.list` | 1 unit | Top-level comments on video | Community engagement, VOC from comments |
| `captions.list` | 50 units | Caption/subtitle tracks | Content analysis, transcript NLP |

**Usage Pattern:**

```bash
# Search for niche-related videos
curl "https://www.googleapis.com/youtube/v3/search?part=snippet&q=accounting%20software%20comparison&type=video&maxResults=10&key=YOUR_API_KEY"

# Get video statistics
curl "https://www.googleapis.com/youtube/v3/videos?part=statistics,snippet&id=VIDEO_ID&key=YOUR_API_KEY"

# Get channel info
curl "https://www.googleapis.com/youtube/v3/channels?part=statistics&id=CHANNEL_ID&key=YOUR_API_KEY"
```

**Key Tips:**
- Search is the most expensive operation (100 units/call). Use it sparingly — prefer `videos.list` and `channels.list` (1 unit each) for analysis
- 10,000 units/day = ~100 search queries or ~10,000 video detail lookups
- The quota resets at midnight Pacific Time
- For 25-niche research: use one search per niche to find top channels, then batch channel stats
- Video comments are excellent for VOC research in software/tech niches — users often detail pain points and alternatives
- Caption data (50 units/video) can be used for NLP content analysis of competitor videos

---

### 2.13 Public ATS Job Board APIs

Free, unlimited, no-auth APIs from major ATS platforms (Greenhouse, Lever, Ashby, Workable, etc.)

| Attribute | Detail |
|-----------|--------|
| **Auth** | None required — fully public |
| **Rate limit** | None documented; be polite (1-2 req/sec) |
| **Pricing** | Completely free and unlimited |
| **Coverage** | Any company using these ATS platforms (thousands of companies) |
| **Best for** | Hiring signals, team growth analysis, competitive intelligence |

**Platform Endpoints:**

| ATS | Endpoint Pattern | Notes |
|-----|-----------------|-------|
| **Greenhouse** | `https://boards-api.greenhouse.io/v1/boards/{company}/jobs?content=true` | Returns ALL open jobs in one response (no pagination); `content=true` gives full HTML descriptions |
| **Lever** | `https://api.lever.co/v0/postings/{company}?mode=json` | Returns flat JSON array; `descriptionPlain` gives clean text |
| **Ashby** | `https://api.ashbyhq.com/posting-api/job-board/{company}` | Structured JSON with departments, locations, teams |
| **SmartRecruiters** | `https://api.smartrecruiters.com/v1/companies/{company}/postings` | Paginated; supports filtering |
| **Workable** | `https://{company}.workable.com/api/v1/jobs/` | Returns all active jobs; includes descriptions |

**Usage Pattern:**

```bash
# Greenhouse — all jobs for a company
curl "https://boards-api.greenhouse.io/v1/boards/stripe/jobs?content=true" | jq '.jobs[] | {title: .title, location: .location.name, updated_at: .updated_at}'

# Lever — all jobs for a company
curl "https://api.lever.co/v0/postings/spotify?mode=json" | jq '.[] | {title: .text, location: .categories.location, type: .workplaceType}'

# Ashby — all jobs with departments
curl "https://api.ashbyhq.com/posting-api/job-board/stripe?includeCompensation=true"
```

**Auto-Detecting ATS Type:**

```bash
# Check for Greenhouse
curl -s "https://boards-api.greenhouse.io/v1/boards/stripe/jobs" | jq '.meta'

# Check for Lever (404 = not Lever)
curl -s -o /dev/null -w "%{http_code}" "https://api.lever.co/v0/postings/spotify?mode=json"

# Or scrape the careers page URL for ATS signature:
# Greenhouse: boards.greenhouse.io/{company}
# Lever: jobs.lever.co/{company}
# Ashby: jobs.ashbyhq.com/{company}
```

**Data You Can Extract:**

| Data Point | Greenhouse | Lever | B2B Niche Use |
|-----------|-----------|-------|---------------|
| Job title | `title` | `text` | What roles are they hiring for? |
| Department | `departments[].name` | `categories.team` | Which teams are growing? |
| Location | `location.name` | `categories.location` | Geographic expansion signals |
| Posting date | `updated_at` (ISO-8601) | `createdAt` (epoch ms) | Hiring velocity |
| Description | `content` (HTML-escaped) | `descriptionPlain` (text) | Tech stack, role details |
| Remote status | Infer from location | `workplaceType` | Remote/workplace strategy |
| Compensation | Rare | Sometimes | Salary benchmarks |

**Key Tips:**
- Greenhouse requires HTML unescaping for `content` field: `html.unescape()` in Python, `.text` in Node.js cheerio
- Lever dates are in epoch milliseconds — divide by 1000 for standard UNIX timestamp
- Both APIs return current open positions only (not historical) — take periodic snapshots for trend analysis
- For 25-niche research: identify which niche companies use each ATS, then batch query hiring signals weekly
- Hiring velocity (jobs added/closed per month) is a proxy for company growth stage:
  - 0-5 open roles = stable / early
  - 5-20 = growing
  - 20+ = scaling fast
- Cross-reference with Techmap API (next section) for broader hiring signal coverage

---

### 2.14 Currents API

News monitoring API with access to 26M+ article archive. Best free-tier news API for developers.

| Attribute | Detail |
|-----------|--------|
| **Base URL** | `https://api.currentsapi.services` |
| **Free tier** | 1,000 requests/day (no credit card required) |
| **Auth** | Free API key (sign up at currentsapi.services) |
| **Endpoints** | Latest News, Search (V1 and V2) |
| **History** | Up to 30 days on free tier |
| **Coverage** | 14,000+ sources, 20+ languages |
| **Paid starts** | $69/month (75K req/mo) |
| **Best for** | News monitoring, brand mention tracking, competitor news |

**Key Endpoints:**

| Endpoint | What It Returns | B2B Niche Use |
|----------|----------------|---------------|
| `GET /v1/latest-news` | Recently indexed articles — no keyword required | Fresh monitoring feed for niche |
| `GET /v1/search` | Keyword + date-based article search across archive | Historical news discovery about niche companies |
| `GET /v1/available/languages` | Available language codes | Multi-language niche monitoring |
| `GET /v1/available/categories` | Available category taxonomy | Filter niche by category |

**Search Parameters:**

| Parameter | Description | Example |
|-----------|-------------|---------|
| `keywords` | Search keywords (boolean: spaces are AND, commas are OR) | `"revenue intelligence", accounting` |
| `language` | 2-letter language code | `en`, `nl`, `de` |
| `country` | 2-letter country code | `US`, `NL` |
| `category` | Category filter (V2: canonical taxonomy) | `economy_business_finance`, `science_technology` |
| `start_date` | Start date (format: YYYY-MM-DD) | `2026-06-01` |
| `end_date` | End date | `2026-07-23` |
| `domain` | Specific news source domain | `techcrunch.com` |
| `page_size` | Results per page (max: 300) | `50` |

**Usage Pattern:**

```bash
# Search for niche-specific news
curl -H "Authorization: Bearer YOUR_API_KEY" \
  "https://api.currentsapi.services/v1/search?keywords=accounting%20software%20Netherlands&language=en&page_size=10"

# Latest news in categories relevant to niche
curl -H "Authorization: Bearer YOUR_API_KEY" \
  "https://api.currentsapi.services/v1/latest-news?category=economy_business_finance&language=en&country=NL"

# Get available V2 categories
curl "https://api.currentsapi.services/v2/available/categories"
```

**Key Tips:**
- Monitor `X-RateLimit-Remaining` response header to track daily quota consumption
- V2 endpoints use canonical category taxonomy: `economy_business_finance`, `science_technology`, `politics_government`, etc.
- Free tier covers up to 30 days of history — for deeper archives, use GDELT (free, unlimited history) instead
- 1,000 requests/day = ~30K/month = sufficient for daily niche monitoring across 25 niches (~40 req/day per niche)
- V2 Search supports cursor pagination for deep archive traversal; V1 uses offset pagination
- For 25-niche research: set up daily search requests per niche, collect into a monitoring dataset

---

### 2.15 ZEFIX API

Swiss company registry — free, no authentication required.

| Attribute | Detail |
|-----------|--------|
| **Base URL** | `https://www.zefix.ch/ZefixREST/api/v1` (undocumented — reverse-engineered from official site) |
| **Auth** | None required |
| **Rate limit** | Not documented; be polite |
| **Pricing** | Completely free — public data under Open Government Data Switzerland |
| **Coverage** | All Swiss commercial register entries |
| **Best for** | Swiss company lookup, Swiss niche market sizing |

**Key Lookup Methods:**

| Method | What It Returns | B2B Niche Use |
|--------|----------------|---------------|
| **Name search** | Companies matching name with legal form, address, status | Find Swiss niche companies |
| **UID lookup** | Company by Swiss UID (CHE-xxx.xxx.xxx) | Verify specific Swiss entity |
| **EHRAID lookup** | Full company profile by internal register ID | Deep company profile |
| **Legal form list** | All Swiss legal forms (AG, GmbH, etc.) | Understand legal structure landscape |

**Usage Pattern:**

```bash
# Search by name (reverse-engineered — may need canton filter)
curl "https://www.zefix.ch/ZefixREST/api/v1/company/search?name=DataSnipper&canton=ZH"

# Lookup by UID
curl "https://www.zefix.ch/ZefixREST/api/v1/company/uid/CHE-123.456.789"
```

**Key Tips:**
- The REST API v1 is publicly undocumented — it's the same API zefix.ch website uses internally. Endpoints may change without notice
- **Board members, signatories, and governance details are NOT available** through ZEFIX REST API v1. Need that? Use the ZefixPublicREST API (requires free registration: email zefix@bj.admin.ch for Basic Auth credentials)
- Searching by canton without a name filter may return API errors
- UID format: CHE-xxx.xxx.xxx (e.g., CHE-123.456.789)
- Several open-source MCP servers wrap ZEFIX: `mcp-server-zefix`, `swiss-apis-mcp`, `register-mcp`
- For 25-niche research: ZEFIX is essential only if the niche has meaningful Swiss market component; otherwise skip

---

### 2.16 UK Companies House API

UK company registry — 600 requests per 5 minutes, free API key.

| Attribute | Detail |
|-----------|--------|
| **Base URL** | `https://api.companieshouse.gov.uk` |
| **Auth** | Free API key (HTTP Basic Auth: key as username, blank password) |
| **Rate limit** | 600 requests per 5 minutes (~2 req/sec) |
| **Higher limits** | Available by contacting Companies House |
| **Pricing** | Completely free |
| **Coverage** | All UK-registered companies (~5M+ active) |
| **Best for** | UK company research, director profiles, financial filings |

**Key Endpoints:**

| Endpoint | What It Returns | B2B Niche Use |
|----------|----------------|---------------|
| `/company/{number}` | Company profile: address, status, SIC code, accounts, officers | UK company verification — legal name, address, SIC code for niche classification |
| `/company/{number}/officers` | Current and historic officers (directors, secretaries) | Identify decision-makers at UK niche companies |
| `/company/{number}/filing-history` | Filing history with category, description, date, type | Track incorporation, annual accounts, director changes |
| `/company/{number}/charges` | Registered charges (loans, mortgages) and satisfaction status | Financial obligations — potential distress signal |
| `/company/{number}/persons-with-significant-control` | PSC entries with control type, nature of control | Ultimate ownership — useful for group structures in niche |
| `/company/{number}/insolvency` | Insolvency records | Distress signal — flags companies to deprioritize |
| `/company/{number}/uk-establishments` | UK establishment details | Branch offices of foreign entities |
| `/search/companies` | Company search by name or number | Find UK companies in a niche |
| `/disqualified-officers/{officer_id}` | Disqualified director information | Risk flag for companies led by disqualified directors |

**Usage Pattern:**

```bash
# Search company by name
curl -u "YOUR_API_KEY:" "https://api.companieshouse.gov.uk/search/companies?q=DataSnipper"

# Get company profile
curl -u "YOUR_API_KEY:" "https://api.companieshouse.gov.uk/company/12345678"

# Get officers (directors)
curl -u "YOUR_API_KEY:" "https://api.companieshouse.gov.uk/company/12345678/officers"

# Get filing history
curl -u "YOUR_API_KEY:" "https://api.companieshouse.gov.uk/company/12345678/filing-history"

# Get latest accounts
curl -u "YOUR_API_KEY:" "https://api.companieshouse.gov.uk/company/12345678/filing-history?category=accounts"
```

**Key Tips:**
- Rate limit is per API key — if you hit 600/5min, wait for the window to reset (HTTP 429)
- Use the Streaming API for real-time changes: 2 concurrent connections per account, delivers live company data changes across 9 categories
- SIC codes classify business activity — use SIC code filtering to segment UK companies by niche
- The `/company/{number}/filing-history` endpoint can filter by `category=accounts` to find filed financials
- For 25-niche research: UK is the largest EU market for most B2B niches — Companies House is essential for:
  1. Company count by SIC code (market sizing)
  2. Director identification (decision-makers)
  3. Account filings (revenue data for non-limited-company alternatives)
- Key SIC codes mapping: `62020` = IT consulting, `69201` = accounting, `70229` = management consulting, `78300` = HR/employment

---

### 2.17 CBS StatLine OData API

Statistics Netherlands open data — Netherlands-specific market sizing by SBI code.

| Attribute | Detail |
|-----------|--------|
| **Base URL** | `https://opendata.cbs.nl` |
| **Endpoints** | `/ODataCatalog/` (search), `/ODataApi/` (data), `/ODataFeed/` (bulk) |
| **Auth** | None required |
| **Rate limit** | None documented; be reasonable |
| **Pricing** | Completely free — open government data |
| **License** | Open data (CC BY 3.0 NL for most datasets) |
| **Coverage** | Netherlands-specific: demographics, economy, industry stats, labor, prices |
| **Best for** | Netherlands market sizing by SBI code, Dutch niche analysis |

**Key Endpoints:**

| Endpoint | What It Returns | B2B Niche Use |
|----------|----------------|---------------|
| `/ODataCatalog/` | Searchable catalog of available datasets | Find datasets relevant to niche |
| `/ODataApi/{dataset}` | Full dataset in OData JSON format | Industry statistics per SBI code |
| `/ODataFeed/{dataset}` | Bulk download endpoint (no row limit) | Large dataset extraction |

**Key Dimensions:**

| Dimension | Description | Example Value |
|-----------|-------------|---------------|
| `BedrijfstakkenBranchesSBI2008` | SBI 2008 industry classification | `T001081` (accounting) |
| `Perioden` | Time period | `2022MM01` |
| `RegioS` | Region (NL, provinces, municipalities) | `NL` or `NL33` (Zuid-Holland) |
| `Kenmerken` | Statistical characteristics | `Bedrijven` (enterprises) |
| `Leeftijd` | Age groups (for demographic data) | |

**SBI Code Examples for B2B Niche Research:**

| SBI Code | Description | Datasets |
|----------|-------------|----------|
| `M69.2` | Accounting, bookkeeping, auditing | `sbs_na_ind_r2`, `employ` |
| `J62` | Computer programming, consultancy | `sbs_na_ind_r2`, `innovatie` |
| `N78` | Employment/recruitment | `sbs_na_ind_r2` |
| `M70.22` | Business consultancy | `sbs_na_ind_r2` |
| `S95.11` | Computer repair | `sbs_na_ind_r2` |

**Usage Pattern:**

```bash
# Search catalog for datasets about business statistics
curl "https://opendata.cbs.nl/ODataCatalog/?$filter=substringof('bedrijven',Title) or substringof('enterprises',Title)"

# Get enterprises count by SBI code for Netherlands (dataset 84287NED)
# Filter: SBI = accounting activities, Year = 2022
curl "https://opendata.cbs.nl/ODataFeed/84287NED?$filter=BedrijfstakkenBranchesSBI2008 eq 'T001081' and Perioden eq '2022'"

# List all SBI codes available in a dataset (dimension metadata)
curl "https://opendata.cbs.nl/ODataApi/84287NED/DimensionValues?$filter=Dimension eq 'BedrijfstakkenBranchesSBI2008'"
```

**Key Tips:**
- SBI 2008 is the Dutch standard business classification, closely aligned with NACE Rev. 2 — the first 4 characters of SBI match NACE
- Use `/ODataFeed/` for large extractions — it has no row limits and supports OData pagination via `odata.nextLink`
- Dataset IDs are numeric (e.g., `84287NED`) — find them via the Catalog endpoint
- For 25-niche research: CBS is the go-to for Dutch-specific market sizing when a niche has NL as a primary market
- The R package `cbsodata4` and Python package `cbsodata` provide wrappers — but direct HTTP is just as easy
- SBI dimension values use internal CBS keys (like `T001081`) which map to human-readable titles in the dimension metadata — always query the metadata first
- Datasets are usually available in Dutch only (variable names, titles, descriptions are in Dutch)

---

### 2.18 Techmap Job Postings API

Aggregated job posting API with ATS detection — 1,000 free postings/month.

| Attribute | Detail |
|-----------|--------|
| **Base URL** | `https://daily-international-job-postings.p.rapidapi.com/api/v2/jobs/search` |
| **Free tier** | 100 API requests/month (BASIC plan via RapidAPI) |
| **Free postings** | ~1,000/month (100 requests x 10 results/request) |
| **Auth** | RapidAPI key (free signup + subscription to BASIC plan) |
| **Coverage** | 1,800+ sources across 198+ countries |
| **Paid starts** | ~e300/month per country (higher volume) or e0.002/job record |
| **Best for** | Hiring signals, growth analysis, tech stack inference from job descriptions |

**Key Endpoints:**

| Endpoint | What It Returns | B2B Niche Use |
|----------|----------------|---------------|
| `GET /api/v2/jobs/search` | Job postings with full description, metadata, ATS source | Hiring signals per niche |
| `GET /api/v2/jobs/count` | Total matching posting count | Hiring volume in niche — proxy for market activity |

**Key Parameters:**

| Parameter | Description | Example |
|-----------|-------------|---------|
| `dateCreated` | Date range (YYYY-MM-DD or YYYY-MM) | `2026-07` |
| `portal` | Source filter | `techmap`, `greenhouse`, `lever`, `jobteaser`, `ycombinator` |
| `countryCode` | 2-letter ISO country | `us`, `nl`, `de`, `uk` |
| `company` | Company name filter | `Microsoft` |
| `title` | Job title with boolean operators | `"accountant" +"AI"` |
| `skills` | Required skills | `python, azure, sql` |
| `workPlace` | Work arrangement | `remote`, `hybrid`, `onsite` |
| `industry` | Industry classification | |
| `occupation` | Occupation category | |

**Usage Pattern:**

```bash
# Search for accounting software jobs in Netherlands, July 2026
curl -X GET "https://daily-international-job-postings.p.rapidapi.com/api/v2/jobs/search?dateCreated=2026-07&countryCode=nl&title=accountant&workPlace=remote" \
  -H "Authorization: Bearer YOUR_RAPIDAPI_KEY"

# Count hiring demand for a niche skill
curl -X GET "https://daily-international-job-postings.p.rapidapi.com/api/v2/jobs/count?dateCreated=2026-07&skills=revenue+intelligence" \
  -H "Authorization: Bearer YOUR_RAPIDAPI_KEY"
```

**Key Tips:**
- 100 requests/month = ~3-4 requests/day — use strategically for targeted niche validation, not bulk
- The `portal` parameter is powerful: filter by specific ATS (techmap, greenhouse, lever) to cross-reference with direct ATS results
- For 25-niche research: use Techmap as a first-pass hiring signal scanner, then deep-dive via direct ATS APIs
- Higher tiers unlock additional endpoints: `/distinct` (distinct field values) and `/statistics` (statistical summaries)
- `dateCreated` parameter is required

---

## 3. Integration Matrix

### 3.1 Which Tool for What

| Research Task | Primary Tool | Secondary Tool | Why |
|-------------|-------------|----------------|-----|
| **Company registry lookup (NL)** | OpenRegistry MCP (NL jurisdiction) | CBS StatLine OData | OpenRegistry = real-time, direct from KVK; CBS = aggregated statistics |
| **Company registry lookup (UK)** | UK Companies House API | OpenRegistry MCP (UK jurisdiction) | Companies House is canonical; OpenRegistry passthrough has higher rate limits potentially |
| **Company registry lookup (global)** | Registry Lookup | OpenRegistry MCP | Registry Lookup covers 521M entities across 309 jurisdictions |
| **Company registry lookup (Switzerland)** | ZEFIX API | — | Only Swiss-specific source |
| **Market sizing (EU by NACE)** | EUROSTAT API | TAM-MCP-Server | EUROSTAT gives official EU industry stats; TAM-MCP provides calculation framework |
| **Market sizing (NL specific)** | CBS StatLine OData | EUROSTAT API | CBS provides Netherlands-specific SBI data with finer granularity |
| **Market sizing (global macro)** | World Bank API / IMF Data API | OECD API | World Bank covers 200+ countries; IMF for financial indicators; OECD for developed economies |
| **Public company financials** | Financial Hub MCP | — | SEC EDGAR access via MCP; normalized XBRL data |
| **News monitoring** | Currents API (recent) + GDELT Project (historical + trends) | — | Currents = 1,000 req/day for daily feeds; GDELT = unlimited for trend analysis |
| **Academic research** | PaperPlain MCP | — | 200M+ peer-reviewed papers via single MCP tool |
| **Web search** | Serper MCP (2,500 free queries) | Google CSE MCP (100/day) | Serper = higher free quota, lower latency; Google CSE = Google-native results |
| **Hiring signals (direct ATS)** | Public ATS Job Board APIs (Greenhouse, Lever, Ashby) | — | Free, unlimited, no auth — per-company hiring intelligence |
| **Hiring signals (aggregated)** | Techmap Job Postings API | — | Aggregated across 1,800+ sources, but limited free tier |
| **Domain authority scoring** | Open PageRank API | — | Batch check up to 100 domains/request |
| **Brand data** | Brandfetch (Logo API) | — | 500K free requests/month — company logos + brand colors |
| **US macro-economic data** | FRED API (verify non-commercial restriction) | Financial Hub MCP (FRED tool) | 800K+ US time series |
| **Video content research** | YouTube Data API v3 | — | 100 search queries/day free |

### 3.2 Capacity for 25-Niche Evaluation

| Tool | Budget for 25 Niches | Limiting Factor |
|------|---------------------|-----------------|
| **OpenRegistry MCP** | 30 req/min free = ~1,200 req/day across all niches | Multi-country fan-out cap (3 jurisdictions/60s) |
| **Financial Hub MCP** | Unlimited (SEC data is free) | 10 req/sec SEC limit (built-in rate limiter handles this) |
| **PaperPlain MCP** | Unlimited | Upstream API rate limits (ArXiv strict, Semantic Scholar 1 req/s) |
| **Serper MCP** | 2,500 queries one-time | One-time credits — use for initial validation only |
| **Google CSE MCP** | 100 searches/day = ~4 searches/niche/day | Useful for targeted lookups, not bulk |
| **TAM-MCP-Server** | Unlimited | Quality depends on data source API keys provided |
| **HubSpot API** | 100 req/10s = ~10 req/s | More than sufficient for CRM delivery |
| **Registry Lookup** | 5,000 calls/month = ~200 calls/niche/month | Budget strategically — deep lookups only |
| **GDELT Project** | Unlimited | 1 req/5s = ~17K req/day — more than sufficient |
| **EUROSTAT API** | ~30 req/min | Dataset updates are quarterly — cache after first pull |
| **OECD API** | Unlimited (reasonable use) | Build 1-sec delay into bulk jobs |
| **TED API** | Unlimited | Monthly refresh cycle via TEDective |
| **Open PageRank API** | Batch up to 100 domains/req | Verify free daily limit |
| **Brandfetch** | 500K req/month | Effectively unlimited for 25 niches |
| **FRED API** | 120 req/min, 6K req/day | US-only; verify non-commercial restriction |
| **World Bank API** | Unlimited | Most resilient global data source |
| **IMF Data API** | Unlimited (1 req/sec recommended) | Cache aggressively — data updates semi-annually |
| **YouTube Data API v3** | 10K units/day = ~100 search queries | Search is expensive (100 units/call); use video/channel list (1 unit/call) for analysis |
| **ATS Job Board APIs** | Unlimited per company | Each company needs separate API call — scalable for targeted lists |
| **Currents API** | 1,000 req/day = 40 req/niche/day | Generous for daily monitoring |
| **ZEFIX API** | Unlimited (reasonable use) | Switzerland-only; only if niche has Swiss market |
| **UK Companies House API** | 600 req/5 min = 7,200 req/hr | Sufficient for UK market research across all niches |
| **CBS StatLine OData API** | Unlimited | Netherlands-only; essential for NL-centric niches |
| **Techmap Job Postings API** | 100 req/month | Strictest free tier — use as initial signal, then direct ATS APIs |

### 3.3 Recommended Multi-Tool Workflows

**Niche Market Sizing Pipeline:**
```
1. EUROSTAT API → get # enterprises + turnover by NACE code (EU-wide industry baseline)
2. CBS StatLine OData → get NL-specific SBI breakdown (Netherlands market sizing)
3. World Bank API → get GDP per capita + internet penetration (buyer readiness context)
4. OECD API → cross-country comparison (validate market size estimates)
5. TAM-MCP-Server → calculate TAM/SAM from collected data (opportunity sizing)
```

**Competitor Discovery Pipeline:**
```
1. Serper MCP → search for niche keywords, discover top companies (initial discovery)
2. Registry Lookup / Companies House → verify company details + directors (entity verification)
3. OpenRegistry MCP → get financial filings for key companies (revenue sizing)
4. Brandfetch → collect logos + brand data for prospect profiles (visual enrichment)
```

**Hiring Signal Pipeline:**
```
1. Techmap Job Postings API → aggregate hiring counts across 1,800+ sources (macro signal)
2. Public ATS APIs → deep-dive into specific niche companies (micro analysis)
3. YouTube Data API → search for employer brand videos (qualitative signal)
```

**News Monitoring Pipeline:**
```
1. Currents API → daily keyword search (daily monitoring, 1,000 req/day)
2. GDELT Project → weekly trend analysis + tone scores (trend analytics)
3. TED API → government contract awards (growth signal — public sector deals)
```

### 3.4 Integration with Core Tools

| Core Tool | How It Connects to These APIs |
|-----------|-------------------------------|
| **Firecrawl** | Firecrawl scrapes the web pages discovered via Serper/Google CSE searches. Use Firecrawl's `search` as an alternative to Serper, or chain Serper discovery -> Firecrawl `scrape` for content extraction |
| **DataForSEO** | DataForSEO provides organic SERP data and keyword volumes; the APIs here fill the gaps DataForSEO doesn't cover: actual hiring signals (ATS APIs), government contracts (TED), registry data (OpenRegistry), and economic statistics (EUROSTAT, OECD, World Bank) |
| **Apify** | Multiple Apify actors wrap these APIs (ATS scraper, TED scraper, OpenPageRank checker) — Apify provides ready-made JSON outputs with built-in rate limiting |

---

## 4. Quick-Reference: Free Tier Summary

| Tool | Free Quota | API Key | Auth Required | Limit Resets |
|------|-----------|---------|---------------|-------------|
| OpenRegistry MCP | 30 req/min (signed-in) | No (OAuth) | Per minute |
| Financial Hub MCP | Unlimited (SEC data) | No (SEC) | 10/sec (SEC) |
| PaperPlain MCP | Unlimited | No | Varies by upstream |
| Serper MCP | 2,500 queries (one-time) | Yes | One-time |
| Google CSE MCP | 100 searches/day | Yes (Google) | Daily |
| TAM-MCP-Server | Unlimited | Varies by source | Varies |
| HubSpot API | 100 req/10s | Yes (OAuth) | Rolling 10s |
| Registry Lookup | 5,000 calls/month | Yes | Monthly |
| GDELT Project | Unlimited | No | ~1 req/5s (soft) |
| EUROSTAT API | ~30 req/min | No | Rolling |
| OECD API | Unlimited (reasonable use) | No | Best practice: 1/s |
| TED API | Unlimited | No | Not documented |
| Open PageRank API | ~10K req/hr | Yes | Per hour |
| Brandfetch Logo API | 500K req/month | Yes | Monthly (soft) |
| FRED API | 6,000 req/day | Yes | 120/min + daily |
| World Bank API | Unlimited | No | None published |
| IMF Data API | Unlimited (key-free) | No (DataMapper) | Best practice: 1/s |
| YouTube Data API v3 | 10K units/day | Yes (Google) | Daily (Pacific midnight) |
| ATS Job APIs | Unlimited | No | Be polite (1-2/s) |
| Currents API | 1,000 req/day | Yes | Daily |
| ZEFIX API | Unlimited | No | Not documented |
| UK Companies House | 600 req/5 min | Yes | Rolling 5 min |
| CBS StatLine OData | Unlimited | No | None published |
| Techmap Job Postings | 100 req/month | Yes (RapidAPI) | Monthly |

---

## 5. Key Takeaways

1. **For highest free capacity across 25 niches**: OpenRegistry MCP (company data, 30 req/min), World Bank API (macro data, unlimited), IMF Data API (financial data, unlimited), and Public ATS APIs (hiring signals, unlimited per company) offer the most generous free tiers.

2. **For Netherlands-specific research**: CBS StatLine OData (NL industry stats) + OpenRegistry MCP (NL KVK) + EUROSTAT API (EU baseline with NL data) provides complete coverage.

3. **For UK market research**: UK Companies House API (600 req/5 min) is the canonical source with the best documentation. OpenRegistry MCP provides an alternative passthrough.

4. **For news monitoring at scale**: GDELT Project (unlimited, trend analytics) + Currents API (1,000 req/day, article retrieval) = complete news monitoring pipeline. GDELT for volume and trends, Currents for actual article content.

5. **For hiring signals**: The Public ATS APIs (Greenhouse, Lever, Ashby) are free and unlimited per company. Techmap provides aggregation across 1,800+ sources but with a strict 100 req/month free tier. Start with Techmap for discovery, then use direct ATS APIs for deep analysis.

6. **For market sizing**: EUROSTAT (EU NACE) + CBS (NL SBI) + World Bank (global macro) + OECD (cross-country) gives multi-level market sizing. TAM-MCP-Server provides the calculation framework.

7. **Watch for restrictions**: FRED API has non-commercial use restrictions (verify applicability). ZEFIX API v1 is undocumented (reverse-engineered). Open PageRank free daily limit needs verification. Google CSE is limited to 100 searches/day.

8. **MCP-native tools** (OpenRegistry, Financial Hub, PaperPlain, Serper, TAM-MCP) can be integrated directly into AI agent workflows without custom API code — faster to prototype but may have different rate limit behavior than direct API calls.
