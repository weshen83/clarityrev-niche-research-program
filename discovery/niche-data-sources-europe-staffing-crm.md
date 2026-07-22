# Niche-Specific Data Sources — Europe, Staffing & CRM Ecosystems

> **Context:** ClarityRev (revenue intelligence startup) evaluating 25 B2B niches. Based in Netherlands.
> **Active prospects:** Gapstars (staffing/recruitment), Befirm (B2B SaaS).
> **Date:** 2026-07-23
> **Supersedes/extends:** `free-apis-b2b-niche-research.md`, `data-sources-reference.md` — these cover global B2B data and web research APIs. This document covers three specialty areas those do not address.

---

## Table of Contents

1. [Sub-Track D1: European / Benelux Business Data](#sub-track-d1-european--benelux-business-data)
   - [Netherlands-Specific](#netherlands-specific)
   - [Belgium](#belgium)
   - [EU-Wide](#eu-wide)
   - [DACH Region](#dach-region-germany-austria-switzerland)
2. [Sub-Track D2: Staffing & Recruitment Niche Data](#sub-track-d2-staffing--recruitment-niche-data)
   - [ATS/CRM APIs (Beyond Bullhorn)](#atscrm-apis-beyond-bullhorn)
   - [Staffing Industry Data](#staffing-industry-data)
   - [Job Board APIs & Hiring Signals](#job-board-apis--hiring-signals)
   - [Staffing-Specific Signals](#staffing-specific-signals)
3. [Sub-Track D3: CRM & Platform Ecosystem APIs](#sub-track-d3-crm--platform-ecosystem-apis)
   - [CRM APIs for Free Developer Access](#crm-apis-for-free-developer-access)
   - [Platform Marketplaces for Distribution](#platform-marketplaces-for-distribution)
   - [Other Relevant Platform APIs](#other-relevant-platform-apis)
4. [Recommendations for ClarityRev](#recommendations-for-clarityrev)
5. [Signal Integration Architecture](#signal-integration-architecture)

---

## Sub-Track D1: European / Benelux Business Data

### Netherlands-Specific

#### 1.1 KVK (Kamer van Koophandel) — Dutch Business Registry API

| Field | Detail |
|-------|--------|
| **URL** | https://developers.kvk.nl/ |
| **API endpoint** | `https://opendata.kvk.nl/api/v1/hvds/basisbedrijfsgegevens/kvknummer` |
| **Free tier** | **Yes — Open Dataset (HVDS)** under CC BY 4.0. Licensed under Reuse of Government Information Act + EU Implementing Regulation 2023/138. |
| **Authentication** | API key (free registration) |
| **Rate limits** | **1 query per minute** — very restrictive |
| **Data fields (free)** | KVK number, start date, active status (J/N), insolvency codes (FAIL/SSAN/SURS), legal form (BV/NV only), first 2 digits of postal code, SBI activity codes, most recent XBRL financial accounts (balance sheet + P&L). |
| **Data NOT available (free)** | Company name, trading names, full address, directors, shareholders, UBOs — stripped by law under Dutch privacy rules. This is deliberate, not a bug. |
| **Paid upgrade** | Handelsregister REST subscription ~EUR 6.40/month + EUR 0.02/request. Digitaal uittreksel available per company. |
| **Commercial use** | Yes (CC BY 4.0) |
| **Deprecation risk** | Very low — government-mandated open data |
| **Sufficiency for 25 niches** | **INSUFFICIENT** — no company names, 1 req/min rate limit makes bulk research impractical. Only useful if you already have KVK numbers and only need SBI codes + financials. |

**Practical entry points:**
- **OpenRegistry MCP** (free, 30 req/min) — proxies KVK open data with better rate limits. See Section 4 below.
- **kvkapiR** (R package, CRAN) — community client for the KVK API.
- **Odoo module l10n_nl_kvk** — free test environment with limited company list.

---

#### 1.2 CBS (Centraal Bureau voor de Statistiek) — Statistics Netherlands Open Data API

| Field | Detail |
|-------|--------|
| **URL** | https://www.cbs.nl/en-gb/onze-diensten/open-data/statline-as-open-data |
| **API endpoint** | `https://opendata.cbs.nl/ODataApi/odata` (standard), `https://opendata.cbs.nl/ODataFeed/odata` (bulk) |
| **Free tier** | **Yes — completely free.** No API key required. CC BY 4.0 license. |
| **Rate limits** | Standard API: 10,000 cells per request. Bulk/Feed: no cell limit. |
| **What it provides** | All StatLine datasets: industry statistics, employment data, company demographics by SBI code, regional economic data, vacancy statistics, wage data. |
| **Key data categories** | Employment by industry (SBI), company counts by size class and region, vacancy figures (openings/filled), wage indices, economic growth by sector, startup/ bankruptcy rates. |
| **Client libraries** | `cbsodataR` (R, official), Python via OData, Power BI connector |
| **Commercial use** | Yes (CC BY 4.0) |
| **Deprecation risk** | Very low — national statistical institute |
| **Sufficiency for 25 niches** | **SUFFICIENT** — excellent for macro-level niche sizing, industry employment trends, and market validation. Not company-level data, but essential for "is this niche big enough?" questions. |

**Key CBS tables for niche research:**
- `84545ENG` — Vacancies (quarterly, seasonally adjusted)
- `85278ENG` — Business demography (births, deaths, survival rates by SBI)
- `83583NED` — Employment by economic activity (SBI 2008)
- Various regional tables broken down by province, COROP, and municipality

---

#### 1.3 Dutch Industry Associations — Staffing

| Association | Detail |
|-------------|--------|
| **ABU** (Algemene Bond Uitzendondernemingen) | ~360 members, ~3,150 branches. Publishes monthly Market Monitor (hours and turnover data). Member directory exists but no public API. Industry reports available on website. |
| **NBBU** (Nederlandse Bond van Bemiddelings- en Uitzendondernemingen) | Second major staffing association. Publishes industry data. No public API. |
| **VIA** | Federation of HR service providers. Industry representation. |

**Practical access:** Industry reports and member directories are accessible via web scraping. No known APIs. ABU publishes monthly market monitor reports with hours/turnover by sector (administrative, industrial, technical).

---

### Belgium

#### 1.4 KBO / BCE (Kruispuntbank van Ondernemingen / Crossroads Bank for Enterprises)

| Field | Detail |
|-------|--------|
| **URL** | https://economie.fgov.be (FPS Economy) |
| **Free access** | **Three tiers:** (1) Public Search web portal (free, no API), (2) Open Data CSV (free, weekly dump), (3) Public Search Web Service (paid: EUR 50 per 2,000 requests, SOAP/REST) |
| **Data available** | Enterprise number (10-digit), VAT number, company name (multi-language), status, legal form, registered address, NACEBEL activity codes, officers/directors (names, roles, appointment dates), establishment units, capital info, financial year-end, links to Moniteur Belge publications. |
| **Data NOT available** | Shareholder information, UBO register (restricted after CJEU ruling, requires legitimate interest). |
| **Commercial use** | Yes (open data CSV is free for reuse) |
| **Paid API** | EUR 50 per 2,000 requests for Public Search Web Service |
| **Deprecation risk** | Very low — government registry |
| **Sufficiency for 25 niches** | **BORDERLINE** — open data CSV (weekly) is free but not real-time. Paid API is affordable (~EUR 0.025/request). |

**Practical entry points:**
- **OpenRegistry MCP** — proxies KBO/BCE live with 30 req/min free tier
- **Fedict/lod-cbe** (GitHub) — open-source RDF conversion tools
- **Apify "Belgium KBO Company Scraper"** — pay-per-result scraping from public search

---

### EU-Wide

#### 1.5 EUROSTAT API

| Field | Detail |
|-------|--------|
| **URL** | https://ec.europa.eu/eurostat/web/main/data/web-services |
| **API endpoints** | Statistics API (JSON-stat 2.0): `https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/` |
| | SDMX 2.1: `https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1/` |
| | SDMX 3.0: `https://ec.europa.eu/eurostat/api/dissemination/sdmx/3.0/` |
| | Async API: `https://ec.europa.eu/eurostat/api/dissemination/1.0/async/` (for 500K-5M cells) |
| | Catalogue: `https://ec.europa.eu/eurostat/api/dissemination/catalogue/` |
| **Free tier** | **Completely free.** No API key, no registration, no authentication required. Unlimited access. |
| **Rate limits** | No explicit limits published (fair use expected) |
| **What it provides** | Detailed economic and industry statistics for all 27 EU member states + EFTA. Employment by industry (NACE), business demography, high-growth enterprise statistics, innovation statistics, R&D expenditure. |
| **Key datasets for niche research** | `nama_10_gdp` (GDP), `sisb_h_ov` (business demography by NACE), `bd_h_size` (enterprise size class), `htec_emp_reg2` (high-tech employment), `inn_cis9` (innovation statistics). |
| **Python client** | `eurostat` package on PyPI |
| **Commercial use** | Yes |
| **Deprecation risk** | Very low — European Commission |
| **Sufficiency for 25 niches** | **SUFFICIENT** — macro-level niche sizing and cross-country validation. Cannot identify individual companies. |

---

#### 1.6 EU Business Register — BRIS (Business Registers Interconnection System)

| Field | Detail |
|-------|--------|
| **URL** | https://e-justice.europa.eu (European e-Justice Portal) |
| **Free tier** | **Web search only** — free for individual company lookups. **No API exists.** |
| **Data available** | Company name, legal form, registered address, registration number, EUID, status (active/dissolved/liquidation), links to national register filings. |
| **Data NOT available** | Financials, ownership, shareholders, UBOs, credit data, employee counts, industry codes, contact info. |
| **Commercial use** | Manual searches OK, no programmatic access possible |
| **Sufficiency for 25 niches** | **INSUFFICIENT** — no API, no bulk search, individual lookups only. Not usable for programmatic research. |

---

#### 1.7 TED (Tenders Electronic Daily) — EU Procurement Data

| Field | Detail |
|-------|--------|
| **URL** | https://ted.europa.eu |
| **API endpoint** | `https://api.ted.europa.eu/v3/notices/search` (POST) — **no API key required** |
| **Free tier** | **Completely free/unlimited.** CC BY 4.0 for editorial content, CC0 for metadata (public domain, no attribution required for raw data). |
| **Rate limits** | No explicit limits published |
| **What it provides** | Public procurement notices: tenders, contract awards, PINs, corrigenda. Filterable by keyword, CPV code, buyer country (ISO alpha-3), publication date, notice type. |
| **Key uses for niche research** | Companies winning government contracts in specific sectors (CPV codes map to industries). Growth signal: companies consistently winning tenders. |
| **Bulk data** | Monthly XML packages available at `https://ted.europa.eu/packages/monthly` |
| **Third-party tools** | Apify "EU Tenders Scraper" (various actors, pay-per-run), `tedprocessor` (open-source Go tool), TEDective (FSFE project for OCDS data) |
| **Commercial use** | Yes (CC0 for metadata) |
| **Deprecation risk** | Very low — EU institution |
| **Sufficiency for 25 niches** | **SUFFICIENT** — excellent signal source for B2B niches where government contracts are relevant (IT services, consulting, facilities, construction, etc.) |

---

#### 1.8 EU Funding Database (CORDIS)

| Field | Detail |
|-------|--------|
| **URL** | https://cordis.europa.eu |
| **API** | https://cordis.europa.eu/data/cordis-api |
| **Free tier** | **Completely free** — no API key required. Horizon Europe/FP funding data. |
| **What it provides** | Companies that received EU research grants, project details, funding amounts. Growth signal: funded companies are typically innovative and scaling. |
| **Sufficiency for 25 niches** | **BORDERLINE** — only covers companies that won EU R&D grants. Useful signal but incomplete coverage. |

---

### DACH Region (Germany, Austria, Switzerland)

#### 1.9 Germany — Unternehmensregister / Handelsregister

| Source | Type | Cost | API? | Notes |
|--------|------|------|------|-------|
| **Official Unternehmensregister** | Government web portal | Free (basic search), EUR 1-4.50 per document download | No API | Manual search only, no programmatic |
| **Implisense** | Third-party API | Free tier available | Yes (REST) | ~2.5M active German companies, GDPR-compliant |
| **handelsregister.ai** | Third-party API | Developer-friendly pricing | Yes | Structured access to Handelsregister, Bundesanzeiger, shareholders lists, financial KPIs |
| **OpenRegistry** | MCP | Free: 30 req/min | Yes | Live from official German register, no caching |

**Best bet for programmatic free access:** Implisense (free API tier) or OpenRegistry (30 req/min, live data).

---

#### 1.10 Austria — Firmenbuch

| Field | Detail |
|-------|--------|
| **Official access** | HVD WebServices from Austrian Federal Ministry of Justice (BMJ) |
| **Free endpoint** | HX023 — Short Information (Kurzinformation): free XML extract with current registered data per EU Implementing Regulation 2023/138 |
| **Paid endpoints** | HX021 (current extract), HX022 (historical extract), HX090 (documents) — incur fees |
| **Authentication** | API key required from BMJ |
| **Free web portal** | https://justizonline.gv.at — manual search only |
| **Third-party tools** | **Firmenbuch AI** (firmenbuch.ai, free), **FinAPU Firmenbuch** (free, no registration), **firmenbuchat CLI** (open-source GitHub tool requiring official API key) |
| **Commercial use** | Yes for HX023 (free basic data) |

---

#### 1.11 Switzerland — ZEFIX (Zentraler Firmenindex)

| Field | Detail |
|-------|--------|
| **URL** | https://www.zefix.admin.ch |
| **API endpoint** | `https://www.zefix.admin.ch/ZefixPublicREST/` |
| **Free tier** | **Yes — completely free.** No authentication required. Open Government Data license (attribute source). |
| **Rate limits** | No explicit limits published (polite use expected) |
| **What it provides** | Company name, UID (CHE number), legal form, purpose (Zweck), canton, registered address, status (active/in liquidation/deleted), SOGC publication references, cantonal register links, EHRA-ID. |
| **Search by** | Company name (min 3 chars, wildcard support), UID (CHE number), canton, legal form, status |
| **Commercial use** | Yes (OGD license) |
| **Deprecation risk** | Very low — Federal Office of Justice |
| **Sufficiency for 25 niches** | **SUFFICIENT** — one of the best free European company registries. Canton-based filtering useful for geographic niche segmentation. |

---

### Cross-Cutting: OpenRegistry MCP (Free Tier)

| Field | Detail |
|-------|--------|
| **URL** | https://github.com/sophymarine/openregistry |
| **MCP endpoint** | `https://openregistry.sophymarine.com/mcp` |
| **Free tier** | **Anonymous:** 20 req/min per IP. **Signed-in free:** 30 req/min per user. No API key needed. **Commercial use allowed.** |
| **Coverage** | 30 national registries including: NL (KVK), BE (KBO), DE (Handelsregister), CH (Zefix), AT (Firmenbuch), UK (Companies House), FR (INSEE), plus many more |
| **Tools** | `search_companies`, `get_company_profile`, `get_officers`, `get_shareholders`, `get_persons_with_significant_control`, `get_charges`, `list_filings`, `fetch_document`, `get_financials`, `search_officers`, `get_officer_appointments` |
| **Key advantage** | Live, direct-from-government data. No cache, no stale data. Unmodified upstream payloads. |
| **Fan-out limit** | 3 distinct jurisdictions per 60s on free tier |
| **Paid tier** | Pro: $9/mo (180 req/min, 10 countries), Max: $29/mo (900 req/min, 30 countries) |
| **Sufficiency for 25 niches** | **SUFFICIENT** — single MCP server covering 30 registries with free 30 req/min is the best gateway for multi-country European company research. |

---

## Sub-Track D2: Staffing & Recruitment Niche Data

### ATS/CRM APIs (Beyond Bullhorn)

#### 2.1 Bullhorn REST API

| Field | Detail |
|-------|--------|
| **Official docs** | https://developer.bullhorn.com/ |
| **Sandbox/Test** | Available through Bullhorn Partner Program. Developer forums + open source documentation provided. |
| **Authentication** | OAuth 2.0 flow → access token → login call → `BhRestToken` + base REST URL |
| **Free tier** | **No standalone free tier.** Access requires partner program membership or being a Bullhorn customer. |
| **Rate limits** | Not publicly documented. 429 errors possible. |
| **What it covers** | Full REST API covering candidates, contacts, jobs, placements, notes, activities, attachments, custom objects, search, metadata. All objects accessible for CRUD operations. |
| **Sufficiency for 25 niches** | **GAPSTARS-SPECIFIC** — only relevant for staffing niche. Required architecture is already understood from the Gapstars demo build. |

**Key Bullhorn REST API endpoints (for context):**

| Category | Key Endpoints |
|----------|---------------|
| **Candidates** | `entity/Candidate/{id}`, `search/Candidate` |
| **Contacts** | `entity/ClientContact/{id}`, `search/ClientContact` |
| **Jobs** | `entity/JobOrder/{id}`, `search/JobOrder` |
| **Placements** | `entity/Placement/{id}`, `search/Placement` |
| **Activities** | `entity/Note/{id}`, `entity/Task/{id}` |
| **Metadata** | `meta/Candidate`, `meta/JobOrder` (field-level metadata) |

---

#### 2.2 Other Major ATS Platforms — Public Job Board APIs (Read-Only, Free)

Most major ATS platforms expose **unauthenticated, free, read-only job board APIs**. These are ideal for monitoring hiring signals at target companies — no partnership, no API key needed.

| Platform | Public API Endpoint | Key Quirks | Best For |
|----------|-------------------|-------------|----------|
| **Greenhouse** | `boards-api.greenhouse.io/v1/boards/{token}/jobs` | One GET returns all jobs (no pagination). HTML-escaped `content` field. | Staffing niche companies using Greenhouse |
| **Lever** | `api.lever.co/v0/postings/{company}?mode=json` | Flat JSON array. `createdAt` in epoch ms (not ISO). Unknown slugs return 404. | Staffing niche companies using Lever |
| **SmartRecruiters** | `api.smartrecruiters.com/v1/companies/{company}/postings` | Paginated (max 100, offset-based). Non-existent companies return 200 with `totalFound: 0` (trap). Full descriptions require separate `/postings/{id}` call. | Staffing niche companies using SmartRecruiters |
| **Workable** | `apply.workable.com/api/v1/widget/accounts/{account}` | Opaque continuation token for pagination. | Staffing niche companies using Workable |
| **Ashby** | `api.ashbyhq.com/posting-api/job-board/{company}` | Modern API, clean JSON | Growing SaaS companies |
| **Recruitee** | `api.recruitee.com/c/{company}/jobs` | Simple JSON response | European staffing |

**No free sandbox/developer accounts exist for write access** to these platforms' authenticated APIs. The job board endpoints are read-only public feeds.

---

#### 2.3 Unified ATS API Providers

For multi-company hiring signal monitoring, these normalize across all major ATS platforms:

| Service | Free Tier | Coverage | Best For |
|---------|-----------|----------|----------|
| **Unified.to ATS API** | No free tier (commercial) | Greenhouse, Lever, Workable, SmartRecruiters, and others | Production multi-ATS integration |
| **JobsPipe API** | **100 requests/month free** | Aggregates across all major ATS feeds into one schema | Low-volume hiring signal monitoring |

---

### Staffing Industry Data

#### 2.4 Staffing Industry Benchmarks

| Source | Type | Cost | Data Available |
|--------|------|------|---------------|
| **ABU Market Monitor** (NL) | Industry reports | Free (web) | Monthly hours/turnover by sector for Dutch staffing industry |
| **Staffing Industry Analysts** | Research firm | Paid reports | Global and European staffing market data, benchmarks |
| **NBBU/ABU Annual Reports** | Association publications | Free (web) | Dutch staffing market size, member statistics |
| **CBS StatLine** | Government statistics | Free (API) | Dutch employment by industry, vacancy data |
| **EUROSTAT** | EU statistics | Free (API) | European employment by NACE code, including staffing/temp employment |

**Dutch staffing market snapshot (2025, from ABU data):**
- Total market: EUR 9 billion
- ABU members: EUR 5.5 billion (360 members, 3,150 branches)
- 2025 trends: Hours -6% YoY, Turnover -1% YoY
- Sector splits (hours): Administrative -19%, Industrial -2%, Technical -10%

---

### Job Board APIs & Hiring Signals

#### 2.5 Job Posting Aggregators with Free Tiers

| Source | Free Tier | Coverage | Data Fields | Best For |
|--------|-----------|----------|-------------|----------|
| **Techmap** (via RapidAPI) | **1,000 jobs/month free** | 8.2M+ new/month, 250+ countries, 127+ sources | Title, company, location, description, date, type | Universal job data feed. No display restrictions — can store and analyze. Backfill to January 2020. |
| **Google Jobs** (via SerpApi) | **100 searches/month free** | Global job aggregation via Google | All Google Jobs fields | Supplementing other sources with search |
| **Apify Hiring-Signal Actors** (Mamba Labs) | **25 results/month free** | Greenhouse, Lever, Ashby, Workday, Rippling | Hiring signal scores (Low/Med/High), role categories, ATS detection | Detecting which companies are hiring, in which departments |
| **Apify Job Posting Monitor** | **25 rows/month free** | Google Jobs (Indeed, LinkedIn, Glassdoor, ZipRecruiter) | Enriched with company domain, LinkedIn URL, employee count, industry | Outbound-ready hiring signals + company enrichment |

#### 2.6 Indeed API Status (2025)

| What | Status |
|------|--------|
| **Indeed Publisher API** | **Discontinued 2023** — no longer available |
| **Indeed Job Search API** | **Deprecated** — not accepting new integrations |
| **Indeed Job Sync API** (GraphQL) | Active — requires ATS partner/employer account |
| **Indeed Sponsored Jobs API** | Active — requires paid account |
| **Indeed GraphQL (unofficial)** | Works (extract `indeed-api-key` from employer portal) — unreliable, keys may be revoked |

**Verdict:** Do not rely on Indeed for free, programmatic job data. Use Techmap or Apify alternatives instead.

#### 2.7 Netherlands-Specific Job Boards

| Source | Access Method | Cost | Notes |
|--------|--------------|------|-------|
| **Nationale Vacaturebank** | Apify scrapers | ~$1.50-$2.00 per 1,000 results | #1 Dutch job board, 100K+ listings. Multiple Apify actors available with OpenAPI definitions. |
| **Werk.nl** (UWV) | Apify scrapers | ~$1.00 per 1,000 results | Dutch government employment agency. 40+ fields per job including salary and recruiter contact. |
| **CBS Vacancy API** | OData (free) | Free | Aggregate statistics only (quarterly figures), not individual listings. |

---

### Staffing-Specific Signals

#### 2.8 Hiring Signal Detection — Summary of Free Approaches

| Method | Cost | What You Get | Sufficiency for 25 Niches |
|--------|------|-------------|--------------------------|
| **Direct ATS public job board APIs** (Greenhouse, Lever etc.) | Free/unlimited per company | Raw job postings, department, location, date posted | **SUFFICIENT** — direct feed, no intermediary |
| **Techmap API** (free tier) | 1,000 jobs/month | Universal job feed, 250+ countries | **SUFFICIENT** for low-volume monitoring |
| **Apify Hiring-Signal Actors** | 25 results/month free | Structured hiring scores, ATS detection, role categories | **INSUFFICIENT** for volume but useful for signal validation |
| **LinkedIn public job scraping** | Free (ToS violation risk) | Job postings | **HIGH RISK** — not recommended for production. ToS violation. |

#### 2.9 LinkedIn Job Data — Legal Landscape (2025)

| Aspect | Detail |
|--------|--------|
| **Terms of Service** | Explicitly prohibits scraping via Section 8.2 (no crawlers, bots, browser plugins) |
| **Legal precedent** | hiQ Labs vs LinkedIn: scraping public data (no login) is NOT CFAA violation, but IS a breach of contract. hiQ was later fined $500K and permanently banned. |
| **Practical risk** | Account bans, IP blocking, potential legal action. LinkedIn actively enforces against scraping tools (banned Seamless.AI, Apollo.io, PhantomBuster). |
| **Safe alternative** | Official LinkedIn API — no public Job Search API exists. Restricted to approved partners only. |
| **GDPR implications** | Processing scraped personal data triggers GDPR obligations (data minimization, consent, deletion rights) |

**Verdict:** Do not build production systems on LinkedIn scraping. Use official ATS public APIs, Techmap, or Apify actors instead.

---

## Sub-Track D3: CRM & Platform Ecosystem APIs

### CRM APIs for Free Developer Access

#### 3.1 HubSpot API

| Field | Detail |
|-------|--------|
| **URL** | https://developers.hubspot.com/ |
| **Free developer account** | **Yes** — free to create. No paid subscription required for API access. |
| **Rate limits (private apps on Free/Starter)** | Burst: 100 req/10s per app. Daily: **250,000 requests per account** (shared across all private apps). |
| **Rate limits (marketplace apps)** | 110 req/10s per HubSpot account that installs your app |
| **OAuth access tokens** | Expire after **6 months**, refresh token rotation supported |
| **Data accessible** | Contacts, Companies, Deals, Custom Objects, Line Items, Products, Tickets, Engagements, Timeline Events, Pipelines, Owners, Goals, CRM Search API, and 100+ more endpoints across marketing, sales, content, and operations APIs. |
| **Read-only OAuth scopes** | Available — can request `crm.objects.contacts.read`, `crm.objects.companies.read` etc. without write scopes. |
| **Private App tokens** | Alternative to OAuth — simpler for single-account integrations, same rate limits apply. |
| **Webhook support** | Yes — subscribe to object creation, property changes, deletion events |
| **Best for** | CRM-native signal delivery. HubSpot's API is the most generous free tier among major CRMs. |
| **Sufficiency for 25 niches** | **SUFFICIENT** — 250K daily requests is ample for multi-niche enrichment and signal delivery. |

**Key HubSpot API resources for ClarityRev:**
- CRM Objects (companies, contacts, deals) — core enrichment targets
- Associations API — link signals to CRM objects
- Search API — query indexed data
- Pipelines API — understand deal stages
- Timeline/Engagements — add signal context to records

---

#### 3.2 Salesforce API

| Field | Detail |
|-------|--------|
| **URL** | https://developer.salesforce.com/ |
| **Free developer edition** | **Yes** — free, full-featured Developer Edition org |
| **Rate limits (Developer Edition)** | **15,000 API calls per rolling 24-hour period**. Soft limit; system blocks at threshold with 403/`REQUEST_LIMIT_EXCEEDED`. |
| **Concurrent request limit** | **5 concurrent** long-running requests (20+ seconds). Production: 25. |
| **API types** | REST, SOAP, Bulk (up to 15,000 batches/24h), GraphQL, Streaming, Apex |
| **OAuth** | Full OAuth 2.0 flow support. Connected App registration in Developer Edition. |
| **Data accessible** | Standard objects (Account, Contact, Lead, Opportunity, Case, etc.), custom objects, custom fields, metadata, query via SOQL. |
| **Best for** | B2B companies already on Salesforce Enterprise or higher. Salesforce has a larger market share in enterprise (vs HubSpot in mid-market). |
| **Sufficiency for 25 niches** | **BORDERLINE** — 15K/day is workable for targeted enrichment but requires careful quota management. |

**Salesforce vs HubSpot for ClarityRev:**

| Aspect | HubSpot | Salesforce |
|--------|---------|------------|
| **Free tier daily limit** | 250,000 requests | 15,000 requests |
| **Developer edition** | Generous limits | Limited (15K/day) |
| **Marketplace listing** | Free, 3 active users required | Security review required, cost not explicit |
| **Typical prospect segment** | Mid-market | Enterprise |
| **Best for ClarityRev** | Primary signal delivery platform | Second integration target |

---

#### 3.3 Pipedrive API

| Field | Detail |
|-------|--------|
| **Free developer access** | Free developer account available, but **sandbox requires a paid plan** |
| **Free plan rate limits** | Burst: 20 req/2s (API token) / 80 req/2s (OAuth). Daily POST/PUT: 10,000. **Token-based limits** rolling out: 30,000 base tokens x plan multiplier (Lite=1). |
| **Free plan data** | All core CRM objects (deals, persons, organizations, activities, notes, pipelines, stages) |
| **Best for** | Small CRM-native deployments. Not ideal for ClarityRev: sandbox requires paid plan, rate limits are low on free. |

---

#### 3.4 Zoho CRM API

| Field | Detail |
|-------|--------|
| **Free developer account** | **Yes** — free Developer Edition includes all features of Ultimate Edition for testing |
| **Free edition API credits** | **5,000 API credits per 24-hour window** (Free Edition). Most API calls = 1 credit. |
| **Concurrency limit (Free)** | **5 concurrent calls** per organization per OAuth app |
| **Developer Edition** | Separate from Free Edition — full-featured for building/testing apps |
| **Data accessible** | All CRM objects, custom modules, custom functions, Blueprint, workflows |
| **Best for** | Companies on Zoho ecosystem. Lower API limits than HubSpot. |

---

#### 3.5 Freshsales (Freshworks CRM) API

| Field | Detail |
|-------|--------|
| **Free plan API limits** | **1,000 requests per hour, 400 requests per minute** (account-level, across all users/API keys) |
| **Rate limits by plan** | Free/Growth: 1,000/hr. Pro: 2,000/hr. Enterprise: 5,000/hr. Per-minute: 400 across all plans. |
| **Data accessible** | Contacts, accounts, deals, leads, notes, appointments, sales activities, custom fields |
| **Best for** | Budget-conscious SMBs. Lower limits than HubSpot but reasonable for light integration. |

---

### Platform Marketplaces for Distribution

#### 3.6 HubSpot App Marketplace

| Field | Detail |
|-------|--------|
| **Cost to join** | **Free** — no fees to become a technology partner |
| **Listing requirements** | Build an integration, get **3 active users**, submit for review |
| **API access** | Full platform APIs included. Well-documented with UI extensions, App Cards, workflow integrations. |
| **Ecosystem size** | 1,600+ technology partners, 288,000+ customers. 95% of customers have installed at least 1 app. Average: 9+ apps per customer. |
| **Revenue opportunity** | $36 billion ecosystem by 2029 |
| **Tiered benefits** | Partner manager, technical consulting, GTM support, co-selling at higher tiers |
| **Sufficiency for ClarityRev** | **HIGH** — free to list, low barrier (3 users), massive distribution potential for CRM-native signal delivery. |

#### 3.7 Salesforce AppExchange

| Field | Detail |
|-------|--------|
| **Cost to list** | Not explicitly free — security review required (can be costly). Specific listing fees not publicly confirmed. |
| **API access** | Full Salesforce API access via partner program. Developer Edition available. |
| **Security review** | Thorough security review required for listing — involves code scan, penetration testing, compliance checks. |
| **Best for** | Enterprise-focused apps targeting Salesforce customers. Higher bar to entry but access to enterprise buyers. |

**Recommendation:** Start with HubSpot Marketplace (free, low barrier, great for mid-market B2B). Move to Salesforce AppExchange when targeting enterprise-only niches.

---

### Other Relevant Platform APIs

#### 3.8 Accounting/ERP APIs

| Platform | Free Tier | REST API | Notes |
|----------|-----------|----------|-------|
| **Exact Online** (NL) | Developer subscription: **EUR 15/month** (not free). Test administrations included. | Yes (REST + OAuth 2.0) | Leading Dutch accounting/ERP. Developer sub includes 2 users, up to 100 linked administrations. Relevant for NL-based niches. |
| **Xero** | Free developer account available | Yes (REST + OAuth 2.0) | Global coverage, stronger in UK/AUS/NZ. Free developer tier with demo company data. |
| **QuickBooks Online** | Free developer account (sandbox) | Yes (REST + OAuth 2.0) | Largest market share globally. Free sandbox with sample company data. |
| **Twinfield** (Wolters Kluwer) | No free tier published | Yes (SOAP/XML) | Dutch accounting platform, relevant for NL niches. No known free developer access. |

**Relevance for ClarityRev:** Accounting/ERP data provides financial health signals (revenue trends, profitability, AR aging). Relevant for financial analysis niches, not necessarily all 25 niches.

#### 3.9 PSA (Professional Services Automation) APIs

| Platform | Free Tier | REST API | Relevant Niche |
|----------|-----------|----------|---------------|
| **ConnectWise Manage** | Partner program required | Yes (REST + OAuth) | MSP/IT services. No known free sandbox. |
| **Autotask** (Datto/Kaseya) | Partner program required | Yes (REST + API key) | MSP/IT services. No known free sandbox. |
| **Kimble** (Salesforce-native) | Requires Salesforce | Salesforce API-based | Enterprise professional services |

**Relevance for ClarityRev:** PSA data is relevant for MSP and professional services niches. However, lack of free sandbox/developer access makes these harder to integrate without a partner relationship.

#### 3.10 Insurance Platform APIs

| Platform | Free Tier | Relevant Niche |
|----------|-----------|---------------|
| **Applied Epic** | No public API or free tier | Insurance brokerages |
| **Vertafore** | Partner program only | Insurance agency management |
| **Guidewire** | Partner program only | P&C insurance carriers |

**Relevance for ClarityRev:** Low priority — insurance APIs are generally walled off behind partner programs. Would require partnering with an insurance tech company to access.

---

## Recommendations for ClarityRev

### Tier 1: Essential (Implement Immediately)

| Data Source | Cost | Purpose | Why |
|-------------|------|---------|-----|
| **HubSpot API** | Free (250K req/day) | CRM-native signal delivery | Most generous CRM free tier. Primary delivery platform for mid-market niches. |
| **OpenRegistry MCP** | Free (30 req/min) | Multi-country European company data | Single MCP server covering 30 registries (NL, BE, DE, CH, AT, UK, FR). Live, direct to government. |
| **EUROSTAT API** | Free/unlimited | Macro niche validation | Cross-country industry statistics for all EU + EFTA. Critical for market sizing. |
| **CBS OData API** | Free/unlimited | Netherlands niche validation | Industry employment, business demographics, vacancy statistics at SBI level. |
| **Greenhouse/Lever/SmartRecruiters public ATS APIs** | Free/unlimited per company | Staffing hiring signals | Unauthenticated, read-only job board feeds. No partnership needed. Ideal for Gapstars-type staffing prospects. |
| **TED EU Procurement API** | Free/unlimited | Government contract signals | Companies winning EU tenders. Growth signal + niche validation for B2G/B2B sectors. |

### Tier 2: Valuable (Add When Niche-Specific Need Arises)

| Data Source | Cost | Purpose | Trigger |
|-------------|------|---------|---------|
| **Exact Online API** | EUR 15/mo developer sub | Dutch accounting data | When targeting NL accounting/finance niches |
| **Implisense API** | Free tier available | German company data | When researching DE-based niches |
| **ZEFIX API** | Free/unlimited | Swiss company data | When researching CH-based niches |
| **KVK Open Dataset** | Free (1 req/min) | Dutch company validation | When you already have KVK numbers and need XBRL financials |
| **Techmap API** | 1,000 jobs/month free | Broad hiring signal monitoring | When staffing/recruitment niche is active |
| **Apify Hiring-Signal Actors** | 25 results/month free | Structured hiring intelligence | When validating hiring signal methodology |

### Tier 3: Monitor (Not Yet Needed)

| Data Source | Reason to Monitor | Trigger for Activation |
|-------------|-------------------|----------------------|
| **Salesforce AppExchange** | Enterprise distribution channel | When ClarityRev targets enterprise-only niches |
| **Belgium KBO paid API** (EUR 50/2K req) | Affordable paid option | When BE becomes a key market |
| **Austria Firmenbuch HVD** (HX023 free) | EU-mandated free data | When AT becomes a key market |
| **Pipedrive/Zoho/Freshsales APIs** | Alternative CRM delivery channels | When HubSpot-first strategy needs expansion |

### Anti-Recommendations (Avoid)

| Source | Why |
|--------|-----|
| **BRIS** (EU Business Register) | No API exists. Manual web search only. Use OpenRegistry instead. |
| **LinkedIn scraping** | ToS violation, legal risk, GDPR complications. Use official ATS public APIs. |
| **Indeed deprecated APIs** | No longer accepting new integrations. Use Techmap or Apify. |
| **PSA APIs** (ConnectWise, Autotask) | No free sandbox access. Only valuable if you have a partner relationship. |
| **OpenCorporates** (free tier) | 200 calls/month, non-commercial only. OpenRegistry free tier is vastly better. |

---

## Signal Integration Architecture

```
┌─────────────────────────────────────────────────────┐
│                   SIGNAL SOURCES                     │
├────────────┬───────────┬──────────┬─────────────────┤
│ Company    │ Staffing  │ CRM      │ Economic /      │
│ Registry   │ Hiring    │ Objects  │ Macro           │
│ Data       │ Signals   │          │                 │
├────────────┼───────────┼──────────┼─────────────────┤
│ OpenRegistry│ ATS APIs │ HubSpot  │ EUROSTAT        │
│ KVK/ZEFIX  │ Techmap   │ Salesf.  │ CBS             │
│ Implisense │ Apify     │ Pipedrive│ TED             │
│ ZOHO (Dev) │ JobsPipe  │ Zoho     │ CORDIS          │
└────────────┴───────────┴──────────┴─────────────────┘
       │           │           │           │
       ▼           ▼           ▼           ▼
┌─────────────────────────────────────────────────────┐
│           CLARITYREV SIGNAL FUSION LAYER             │
│  ┌──────────┐ ┌──────────┐ ┌─────────────────────┐ │
│  │ Company  │ │ Hiring   │ │ CRM Enrichment      │ │
│  │ Research │ │ Signals  │ │ Pipeline            │ │
│  └──────────┘ └──────────┘ └─────────────────────┘ │
└─────────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────┐
│           CRM-NATIVE DELIVERY                        │
│  ┌──────────┐ ┌──────────┐ ┌─────────────────────┐ │
│  │ HubSpot  │ │ Salesf.  │ │ Bullhorn (staffing) │ │
│  │ Primary  │ │ Second.  │ │ Gapstars-specific   │ │
│  └──────────┘ └──────────┘ └─────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

**Key integration insight:** The highest-value free sources (HubSpot API, OpenRegistry MCP, CBS/EUROSTAT, and public ATS APIs) cover ClarityRev's entire data pipeline from company discovery through signal fusion to CRM delivery — all at zero recurring data cost. Paid tiers only needed for rate limit expansion as volume scales.
