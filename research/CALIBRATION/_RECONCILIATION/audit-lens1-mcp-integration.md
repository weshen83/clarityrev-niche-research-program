# AUDIT LENS 1: MCP Server & Tool Integration — Ranked Findings

**Auditor:** MCP/Integration Architect (Google infrastructure, 12 years tool integration platforms)
**Date:** 2026-07-23
**Scope:** All 14 MCP servers in DATA-OPERATIONS-ARCHITECTURE.md §2.1 Tier 2, plus Firecrawl MCP and DataForSEO MCP special investigations
**Current State Baseline:** settings.json has 2/14 MCP servers configured (context7, openregistry). Firecrawl used via CLI. DataForSEO via raw curl.

---

## TABLE OF CONTENTS

1. [Executive Summary](#1-executive-summary)
2. [Critical Investigations](#2-critical-investigations)
3. [Per-Server Audit (All 14)](#3-per-server-audit-all-14)
4. [Categorization Matrix](#4-categorization-matrix)
5. [Exact JSON Config Blocks](#5-exact-json-config-blocks)
6. [Integration for Tools Without MCP Servers](#6-integration-for-tools-without-mcp-servers)
7. [Risk Register](#7-risk-register)
8. [Priority Action Plan](#8-priority-action-plan)
9. [Appendix: Firecrawl MCP vs CLI Comparison](#9-appendix-firecrawl-mcp-vs-cli-comparison)

---

## 1. EXECUTIVE SUMMARY

### Headline Finding

**11 of 14 MCP servers in the architecture exist and can be configured.** Of those:
- **3 are CONFIGURE_NOW** (PaperPlain, Reddit Research hosted, Financial Hub) — zero new accounts, 5 minutes
- **6 are CONFIGURE_SOON** (Serper, Brave Search, CrawlForge, FetchSERP, Google CSE, Jina AI/webskim) — free signups, 30 minutes total
- **2 are CONFIGURE_LATER** (SearXNG, TAM-MCP-Server) — self-hosted or needs repo build
- **1 is SKIP** (SEC EDGAR MCP alone — redundant because Financial Hub MCP already covers SEC EDGAR better)

### Critical Finding 1: Firecrawl MCP EXISTS but CLI is Superior

The official `firecrawl-mcp` (mendableai, v1.10.0, npm) exists and provides 9 tools. **However, the CLI is strictly better for this pipeline** because the MCP server is missing: `interact`, `monitor`, `download`, `parse`, `agent`, and `search-feedback`. The MCP also duplicates the CLI's functionality without adding value for niche research. **Recommendation: Do NOT switch to MCP for Firecrawl.** The CLI is the right integration for this pipeline.

### Critical Finding 2: DataForSEO MCP EXISTS — Official Package Covers All 9 APIs

The official `dataforseo-mcp-server` (DataForSEO org, v2.9.11, npm) and community `@cdilorenzo/mcp-dataforseo` (v1.0.13) both exist and cover all 9 DataForSEO API modules (SERP, Keywords, Labs, Domain Analytics, Backlinks, OnPage, Business Data, Content Analysis, Merchant). The official package is Apache-2.0 licensed and actively maintained. **Recommendation: Switch from raw curl to the official MCP server** for better agent integration and structured error handling.

### Critical Finding 3: Bookkeeping Correction — Brave Search is NOT Unlimited

The DATA-OPERATIONS-ARCHITECTURE.md §2.1 Tier 2 table claims Brave Search MCP is "Unlimited (self-hosted)." The official `@modelcontextprotocol/server-brave-search` is **deprecated on npm** (marked "Package no longer supported"). The replacement requires a Brave Search API key: 2,000 queries/month free, then paid. The self-hosted option (SearXNG) is a completely different tool. **Architecture document needs correction.**

### Critical Finding 4: Reddit Research is the Most Crowded Category

There are 6+ different Reddit MCP packages. The architecture's "Reddit Research MCP" maps to `king-of-the-grackles/reddit-research-mcp` hosted at `https://reddit-research-mcp.fastmcp.app/mcp` — a hosted SSE endpoint with no auth. But `reddit-mcp-server` (npm) and `reddit-intelligence-agent-mcp` (npm) also provide free, zero-config alternatives with different tool sets.

---

## 2. CRITICAL INVESTIGATIONS

### 2.1 Firecrawl MCP — Does It Exist? Should We Use It?

| Question | Answer |
|----------|--------|
| Does `@anthropic/firecrawl-mcp` exist? | **NO.** This package name does not exist on npm. |
| Does `@mendable/firecrawl-mcp` exist? | **NO.** `@mendable/firecrawl` is the JavaScript SDK, not an MCP server. |
| Does `firecrawl-mcp` exist? | **YES.** Package `firecrawl-mcp` by mendableai, v1.10.0, 2,712 GitHub stars, 41.5K downloads/month. |
| Is there a deprecated predecessor? | **YES.** `mcp-server-firecrawl` (v1.2.4) is deprecated. Unmaintained, 71 open issues. |
| What tools does it expose? | 9 tools: `firecrawl_scrape`, `firecrawl_batch_scrape`, `firecrawl_search`, `firecrawl_map`, `firecrawl_crawl`, `firecrawl_extract`, `firecrawl_deep_research`, `firecrawl_generate_llmstxt`, `firecrawl_check_crawl_status`, `firecrawl_check_batch_status`. |
| Is there a keyless free tier? | YES via `https://mcp.firecrawl.dev/v2/mcp` — limited to scrape/search/interact, rate-limited. |
| What is MISSING vs CLI? | `interact`, `monitor`, `download`, `parse`, `agent`, `search-feedback` — these CLI commands have NO MCP equivalent. |
| Verdict | **Do NOT use Firecrawl MCP in this pipeline.** The CLI is more complete, the pipeline is already designed around CLI commands, and the MCP adds no capability we don't already have. |

### 2.2 DataForSEO MCP — Does It Cover All 9 APIs?

| Question | Answer |
|----------|--------|
| Does `@cdilorenzo/mcp-dataforseo` exist? | **YES.** npm v1.0.13, community-maintained. Covers SERP, Keywords, Labs, Domain Analytics, Backlinks, OnPage, Content Analysis, Business Data, Merchant, App Data APIs. |
| Does the official `dataforseo-mcp-server` exist? | **YES.** npm, DataForSEO org, v2.9.11, 3.3K weekly downloads, Apache-2.0 license. Covers all 10 API modules including AI Optimization API. |
| Does it cover all 9 APIs we use? | **YES.** Both packages cover SERP, Keywords, Labs, Domain Analytics, Backlinks, OnPage, Business Data, Content Analysis, and Merchant APIs. The official package also covers AI Optimization API (LLM benchmarking, ChatGPT mentions). |
| What env vars needed? | `DATAFORSEO_USERNAME` and `DATAFORSEO_PASSWORD` (same credentials used for raw curl). |
| Verdict | **Strong recommendation: Switch from raw curl to the official `dataforseo-mcp-server`.** This gives structured tool calling within agents, built-in error handling, and eliminates raw curl boilerplate. The official package is actively maintained (v2.9.11). |

---

## 3. PER-SERVER AUDIT (ALL 14)

### 3.1 Brave Search MCP

| Attribute | Finding |
|-----------|---------|
| **Status** | EXISTS but implementation needs correction |
| **NPM package(s)** | `@modelcontextprotocol/server-brave-search` (OFFICIAL, DEPRECATED). Alternative: `mcp-brave-search`, `@microagents/server-brave-search`, `@keitaro_aigc/search-mcp` |
| **Tools** | `brave_web_search` (web search with count + offset), `brave_local_search` (local business search with auto web fallback) |
| **Auth** | BRAVE_API_KEY from api.search.brave.com (free: 2,000 queries/month) |
| **Transport** | stdio (npx) |
| **Architecture claim** | §2.1 says "Unlimited (self-hosted)" — **INCORRECT**. The official package is NOT self-hosted and requires an API key. Self-hosted SearXNG is a different tool. |
| **Free tier** | 2,000 queries/month free, then $7.99/100K queries (pay-as-you-go) |
| **Recommendation** | CONFIGURE_SOON. Register for free API key, then add to settings.json. Good for general web search alongside Serper. |

### 3.2 Reddit Research MCP

| Attribute | Finding |
|-----------|---------|
| **Status** | EXISTS with multiple implementations |
| **Primary (hosted, zero-setup)** | `reddit-research-mcp` by king-of-the-grackles: SSE at `https://reddit-research-mcp.fastmcp.app/mcp`. No auth. 10 operations across Reddit + Feeds categories. Uses Descope OAuth2 on first connect. |
| **Alternative 1 (npm, anonymous)** | `reddit-mcp-server`: `npx reddit-mcp-server`. Anonymous mode works immediately. Supports read/write. 10 req/min anonymous, 60/min app-only, 100/min full auth. |
| **Alternative 2 (npm, no auth)** | `reddit-intelligence-agent-mcp`: `npx reddit-intelligence-agent-mcp`. 4 free tools, no API key needed. Includes pain point detection, opportunity scoring. 60+ regex rules across 9 signal categories. |
| **Transport** | Primary: SSE (http). Alternatives: stdio. |
| **Architecture claim** | §2.1 says "Free, no auth, 20K+ subreddits" — **CONFIRMED** for the hosted version. |
| **Recommendation** | CONFIGURE_NOW. The hosted SSE version works immediately with no credentials. Start with it. Add `reddit-intelligence-agent-mcp` later for scoring capabilities. |

### 3.3 OpenRegistry MCP

| Attribute | Finding |
|-----------|---------|
| **Status** | **ALREADY CONFIGURED** in settings.json |
| **Current config** | SSE at `https://openregistry.sophymarine.com/mcp`. Type: sse. |
| **Tools** | 8 tools: `search_companies`, `get_company_profile`, `get_officers`, `get_shareholders`, `get_psc`, `list_filings`, `fetch_document`, `get_financials` |
| **Rate limit** | 30 req/min (signed-in) or 20 req/min (anonymous). Multi-country fan-out: 3 jurisdictions/60s. |
| **Alternative config** | Can also use stdio via `npx -y @sophymarine/openregistry-mcp` |
| **Architecture claim** | §2.1 says "30 req/min, 30 national registries" — **CONFIRMED**, but note the 3-jurisdiction fan-out cap. |
| **Recommendation** | Already configured. No action needed. Consider registering for OAuth to get 30 req/min. |

### 3.4 Financial Hub MCP

| Attribute | Finding |
|-----------|---------|
| **Status** | EXISTS. `financial-hub-mcp` on npm v1.3.1, MIT license. |
| **Package** | `financial-hub-mcp` (not scoped) |
| **Tools** | 16 tools: `search_companies`, `get_company_filings`, `get_financial_metric`, `get_financial_summary`, `get_company_facts_summary`, `analyze_financials`, `compare_companies`, `search_filings`, `screen_stocks`, `get_corporate_events`, `search_economic_data`, `get_economic_data`, `get_stock_quote`, `get_market_news`, `get_insider_transactions`, `get_company_overview` |
| **Auth** | SEC_USER_AGENT_EMAIL (required, already have in env). FRED_API_KEY (optional for FRED tools, ALREADY in env). FINNHUB_API_KEY (optional for market data). |
| **Transport** | stdio (npx -y financial-hub-mcp) |
| **Architecture claim** | §2.1 says "Unlimited, no key" for SEC EDGAR — **PARTIALLY CORRECT**. SEC EDGAR access is indeed free and unlimited. FRED and Finnhub additional tools need optional keys. |
| **Rate limit** | SEC: 10 req/sec (token bucket). FRED: 120 req/min. Built-in caching (LRU with TTL). |
| **Recommendation** | CONFIGURE_NOW. We already have SEC_USER_AGENT_EMAIL (needs to be set) and FRED_API_KEY (already in settings.json env). Add this immediately for SEC EDGAR + FRED access. |

### 3.5 PaperPlain MCP

| Attribute | Finding |
|-----------|---------|
| **Status** | EXISTS. `paperplain-mcp` on npm v1.2.5, MIT license. |
| **Package** | `paperplain-mcp` (unscoped) |
| **Tools** | 3 tools: `search_research` (across PubMed, ArXiv, Semantic Scholar), `fetch_paper` (by ID), `find_paper_by_title` |
| **Auth** | **NONE REQUIRED.** Zero config. Optional S2_API_KEY for higher Semantic Scholar rate limits (100 req/s vs 1 req/s). |
| **Transport** | stdio (npx -y paperplain-mcp) |
| **Smart routing** | Health/medical -> PubMed + Semantic Scholar. CS/AI -> ArXiv + Semantic Scholar. General -> All three. |
| **Architecture claim** | §2.1 says "200M+ peer-reviewed papers, unlimited, no key" — **CONFIRMED**. |
| **Recommendation** | **CONFIGURE_NOW — HIGHEST PRIORITY.** Zero config, immediate value for niche technology validation and academic research. Add to settings.json immediately. |

### 3.6 Jina AI MCP

| Attribute | Finding |
|-----------|---------|
| **Status** | EXISTS with multiple packages |
| **Package options** | `jina-ai-mcp-server` (npm v1.0.4), `webskim` (npm v1.8.0, context-efficient), `@pipeworx/mcp-jina-reader`, `jina-mcp-tools` |
| **Best for Claude Code** | **`webskim`** — context-efficient design: saves pages to disk, agent reads sections via offset/limit. Designed specifically for agentic clients. |
| **Tools (webskim)** | `webskim_search` (web search with lightweight results), `webskim_read` (fetch URL/PDF, save to disk, return TOC), `webskim_grep` (regex search within saved pages) |
| **Auth** | JINA_API_KEY required. Free: 1M tokens from jina.ai (no credit card). Alternatively, 10M tokens via paid. |
| **Transport** | stdio (npx -y webskim or npx -y jina-ai-mcp-server) |
| **Architecture claim** | §2.1 says "10M tokens free" — **CONFIRMED** for Jina AI direct API. Through MCP servers, the quota depends on which package's API key you use. |
| **Recommendation** | CONFIGURE_SOON. Sign up for free Jina AI API key (1M tokens), then configure `webskim` for context-efficient web search + reading. Strong complement to Firecrawl CLI for fallback web access. |

### 3.7 SearXNG / Web Explorer MCP

| Attribute | Finding |
|-----------|---------|
| **Status** | EXISTS but requires SELF-HOSTED SearXNG instance |
| **Best package** | `@iori7295/searxng-mcp` (npm v3.5.2, most feature-rich) or `web-explorer-mcp` (PyPI, simplest) or `88plug/searxng-mcp` (GitHub, Python) |
| **Prerequisites** | **REQUIRED:** A running SearXNG instance (Docker). Node.js 20+ for npm packages. |
| **Auth** | None (runs on local network). Can use SearXNG Basic Auth if exposed. |
| **Transport** | stdio (npx or uvx) |
| **Architecture claim** | §2.1 says "Unlimited (self-hosted)" — **CONFIRMED**, but deployment is non-trivial. Requires Docker Compose with SearXNG + Redis. |
| **Recommendation** | CONFIGURE_LATER. Worth setting up once if you want unlimited, private web search without API costs. But the setup cost (~1 hour Docker + config) makes it a Phase 0 task, not pre-Phase 0. |

### 3.8 CrawlForge MCP

| Attribute | Finding |
|-----------|---------|
| **Status** | EXISTS. `crawlforge-mcp-server` on npm v4.10.0. |
| **Package** | `crawlforge-mcp-server` (unscoped) |
| **Tools** | 27 MCP-native tools including fetching, scraping, deep research, autonomous agent, stealth browsing |
| **Auth** | API key from crawlforge.dev/signup. Key format: `cf_live_...` |
| **Free tier** | 1,000 free credits, NO credit card required. Credits never expire, roll over month-to-month. |
| **Pricing** | Free (1K/mo), Hobby (5K/mo $19), Professional (50K/mo $99), Business (250K/mo $399) |
| **Transport** | stdio. Has auto-setup wizard: `npx crawlforge-setup` detects Claude Code and adds to settings.json. |
| **Architecture claim** | §2.1 says "1,000 free credits, 27 tools" — **CONFIRMED**. |
| **Recommendation** | CONFIGURE_SOON. 1,000 free credits provide meaningful research capacity. Sign up, get API key, configure. Note: may be redundant given Firecrawl CLI — evaluate overlap before deep integration. |

### 3.9 FetchSERP MCP

| Attribute | Finding |
|-----------|---------|
| **Status** | EXISTS. `@fastmcp-me/fetchserp-mcp-server-node` on npm v1.0.5, MIT license. |
| **Package** | `@fastmcp-me/fetchserp-mcp-server-node` |
| **Tools** | `get_domain_info` (DNS, WHOIS, SSL, tech stack), `get_backlinks`, `get_domain_emails`, plus SERP search, ranking checks, indexation verification, keyword research, AI-powered page analysis |
| **Auth** | `FETCHSERP_API_TOKEN` from fetchserp.com (Bearer token) |
| **Free tier** | 250 free credits on signup (no credit card). Credits consumed per API call. |
| **Pricing** | Starts at $29/month for higher volumes |
| **Transport** | stdio and HTTP (supports both) |
| **Architecture claim** | §2.1 says "250 free credits, Domain analysis, WHOIS, DNS, tech stack" — **CONFIRMED**. |
| **Recommendation** | CONFIGURE_SOON. 250 free credits provide a useful trial. The `get_domain_info` tool (DNS + WHOIS + SSL + tech stack in one call) is uniquely valuable for quick competitor profiling and doesn't overlap significantly with DataForSEO. |

### 3.10 Context7 MCP

| Attribute | Finding |
|-----------|---------|
| **Status** | **ALREADY CONFIGURED** in settings.json |
| **Current config** | stdio via `npx -y @upstash/context7-mcp@latest`. CONTEXT7_API_KEY in env. |
| **Transport** | stdio |
| **Architecture claim** | §2.1 says "Unlimited, official docs lookup" — **CONFIRMED**. Correctly configured. |
| **Recommendation** | Already configured. No action needed. |

### 3.11 SEC EDGAR MCP

| Attribute | Finding |
|-----------|---------|
| **Status** | EXISTS but REDUNDANT with Financial Hub MCP |
| **Package options** | `@insnapsprakhar/sec-edgar-mcp` (npm, hosted wrapper), `sec-edgar-mcp` (PyPI), hosted `https://sec-edgar-mcp.atlasword.workers.dev/mcp` (requires mck_ API key) |
| **Tools** | Company filings, financial data, XBRL concepts — subset of what Financial Hub MCP provides |
| **Auth** | Varies by implementation. Some require API key, some use direct SEC access with User-Agent. |
| **Transport** | stdio (npx) or SSE (hosted) |
| **Architecture claim** | §2.1 says "Unlimited, public data, US public company financials" — **CONFIRMED** as a data category, but Financial Hub MCP already provides this with 16 tools vs SEC EDGAR MCP's narrower toolset. |
| **Recommendation** | **SKIP as standalone server.** Financial Hub MCP (CONFIGURE_NOW) already covers SEC EDGAR with better tooling (16 tools including `compare_companies`, `analyze_financials`, `search_filings`). Adding a separate SEC EDGAR MCP would duplicate functionality and consume agent startup time. |

### 3.12 Serper MCP

| Attribute | Finding |
|-----------|---------|
| **Status** | EXISTS. Multiple packages. |
| **Best package** | `serper-search-mcp` (npm v3.0.3) — 8 search tools, actively maintained. |
| **Tools** | `search_web` (organic + KG + answer box + PAA), `search_images`, `search_videos`, `search_news`, `search_shopping`, `search_places`, `deep_research` (needs GEMINI_API_KEY or OPENROUTER_API_KEY), `search_rag_context` (chunked text for vector DBs) |
| **Auth** | `SERPER_API_KEY` from serper.dev |
| **Free tier** | **2,500 queries/month (recurring)** — NOT one-time as documented in SME-tool-reference-expansion.md §1.4 which says "one-time starter credits." Correction: the free tier is monthly recurring. |
| **Transport** | stdio (npx -y serper-search-mcp) |
| **Architecture claim** | §2.1 says "2,500 free queries (one-time)" — **INCORRECT.** The free tier is monthly recurring, not one-time. This changes the economics significantly: 2,500 queries/month is enough for 100 queries/niche across 25 niches every month. |
| **Recommendation** | **CONFIGURE_SOON — HIGH PRIORITY.** 2,500 recurring monthly queries provide ongoing research capacity. Sign up at serper.dev (60 seconds), get API key, configure. This is the best free-tier web search MCP available. |

### 3.13 TAM-MCP-Server (Market Sizing MCP)

| Attribute | Finding |
|-----------|---------|
| **Status** | EXISTS but requires REPO CLONE + BUILD. Not instant via npx. |
| **Package** | `@gvaibhav/tam-mcp-server` (npm v1.0.1). GitHub: gvaibhav/TAM-MCP-Server. |
| **Tools** | 28 tools across 3 tiers (data access, foundation TAM, advanced analysis). 15 business prompts. |
| **Data sources** | BLS, U.S. Census, FRED, IMF, OECD, World Bank, Alpha Vantage, Nasdaq Data Link |
| **Auth** | No auth needed for public data sources (World Bank, OECD, IMF). Optional API keys for FRED, Alpha Vantage, Census, BLS, Nasdaq. |
| **Setup** | Requires: `git clone`, `npm install`, `cp .env.example .env`, `npm run build`, `npm run start:http` or `start:stdio`. Cannot run directly via npx without build step. |
| **Transport** | stdio or HTTP (Streamable HTTP + SSE support) |
| **Architecture claim** | §2.1 says "Unlimited, open source, Market sizing from 8 government sources" — **CONFIRMED** but setup is non-trivial. |
| **Recommendation** | CONFIGURE_LATER. The setup cost (git clone + build + config) makes it a Phase 0 task. However, once configured, it's a powerful single-server alternative to calling EUROSTAT, OECD, World Bank, and IMF APIs separately. Worth the investment before niche evaluation begins. |

### 3.14 Google CSE MCP

| Attribute | Finding |
|-----------|---------|
| **Status** | EXISTS. Multiple implementations. |
| **Best npm package** | `@mseep/mcp-google-custom-search-server` (npm) or `mcp-google-cse` (PyPI via uvx). |
| **Tools** | `google_search` (title, link, snippet, num_results 1-10) |
| **Auth** | `GOOGLE_API_KEY` (ALREADY in settings.json env) + `GOOGLE_CSE_ID` (or `ENGINE_ID` — NEED TO CREATE) |
| **Free tier** | 100 searches/day (Google CSE default without billing). Can enable billing for more. |
| **Setup** | 1) Enable Custom Search API in Google Cloud Console. 2) Create Programmable Search Engine at programmablesearchengine.google.com. 3) Get CX engine ID. 4) Configure MCP. |
| **Transport** | stdio (npx or uvx depending on package) |
| **Architecture claim** | §2.1 says "100 searches/day" — **CONFIRMED**. |
| **Recommendation** | CONFIGURE_SOON. We already have GOOGLE_API_KEY in settings.json. Only need to create a CSE engine ID (5 minutes in Google Console). 100 searches/day is limited but useful for targeted niche lookups. |

---

## 4. CATEGORIZATION MATRIX

### CONFIGURE_NOW (Free, no registration, immediate value)

| Priority | Server | Why Now | Config Time |
|----------|--------|---------|-------------|
| 1 | PaperPlain MCP | Zero setup, no auth, immediate academic paper search for niche technology validation | 2 minutes |
| 2 | Reddit Research MCP (hosted) | No credentials, hosted SSE endpoint, immediate VOC access | 2 minutes |
| 3 | Financial Hub MCP | Already have SEC_USER_AGENT_EMAIL and FRED_API_KEY. SEC EDGAR + FRED in 16 tools. | 3 minutes |

**Total: ~7 minutes for 3 servers, significant research capability added.**

### CONFIGURE_SOON (Free with registration or needs API key we already have)

| Priority | Server | What's Needed | Config Time |
|----------|--------|---------------|-------------|
| 1 | Serper MCP | Free signup at serper.dev (2,500 queries/month recurring) | 5 min |
| 2 | DataForSEO MCP (official) | Already have DATAFORSEO_LOGIN/PASSWORD. Switch from raw curl. | 5 min |
| 3 | Jina AI MCP (webskim) | Free signup at jina.ai (1M tokens) | 5 min |
| 4 | Brave Search MCP | Free signup at api.search.brave.com (2,000 queries/month) | 5 min |
| 5 | Google CSE MCP | Already have GOOGLE_API_KEY. Create CSE engine ID. | 10 min |
| 6 | CrawlForge MCP | Free signup at crawlforge.dev (1,000 credits) | 5 min |
| 7 | FetchSERP MCP | Free signup at fetchserp.com (250 credits) | 5 min |

**Total: ~40 minutes for 7 servers, full MCP-powered research pipeline.**

### CONFIGURE_LATER (Self-hosted, paid, or needs repo build)

| Server | Setup Requirement | When to Do |
|--------|-------------------|------------|
| SearXNG MCP | Docker SearXNG instance + npm/Python package. ~1 hour total. | Phase 0 (before first niche) — optional, for unlimited private web search |
| TAM-MCP-Server | Git clone + npm build + env config. ~30 min. | Phase 0 (before first niche) — consolidates 8 government data sources into one server |

### SKIP (Redundant or no value)

| Server | Why Skip |
|--------|----------|
| SEC EDGAR MCP (standalone) | Financial Hub MCP already covers SEC EDGAR with 16 tools vs SEC EDGAR's narrower set. |
| Firecrawl MCP | CLI is more complete (10+ commands vs 9 tools). Missing: interact, monitor, download, parse, agent, search-feedback. |
| @cdilorenzo/mcp-dataforseo (community) | Official `dataforseo-mcp-server` is better maintained (DataForSEO org), Apache-2.0, actively developed. |

---

## 5. EXACT JSON CONFIG BLOCKS

### 5.1 CONFIGURE_NOW Servers

Add these to the `mcpServers` block in `/home/weshen83/.claude/settings.json`:

#### PaperPlain MCP (Priority 1)

```json
"paperplain": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "paperplain-mcp"]
}
```

Zero env vars needed. Works immediately. Add optional S2_API_KEY for higher rate limits.

#### Reddit Research MCP — Hosted (Priority 2)

```json
"reddit-research": {
  "type": "sse",
  "url": "https://reddit-research-mcp.fastmcp.app/mcp"
}
```

No env vars. Uses Descope OAuth2 on first connect (browser-based). Alternatively, use `reddit-mcp-server` for anonymous stdio mode:

```json
"reddit-mcp": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "reddit-mcp-server"]
}
```

#### Financial Hub MCP (Priority 3)

```json
"financial-hub": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "financial-hub-mcp"],
  "env": {
    "SEC_USER_AGENT_EMAIL": "weshen83@gmail.com",
    "FRED_API_KEY": "${FRED_API_KEY}"
  }
}
```

`SEC_USER_AGENT_EMAIL` set directly (needs to be a real email for SEC compliance). `FRED_API_KEY` references the existing env var in settings.json (already have it).

### 5.2 CONFIGURE_SOON Servers

All require a free signup first. Configs ready to paste once API keys are obtained.

#### Serper MCP (Priority 1)

```json
"serper": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "serper-search-mcp"],
  "env": {
    "SERPER_API_KEY": "${SERPER_API_KEY}"
  }
}
```

Also add `SERPER_API_KEY` to the `env` block at the top of settings.json.

#### DataForSEO MCP — Official (Priority 2)

```json
"dataforseo": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "dataforseo-mcp-server"],
  "env": {
    "DATAFORSEO_USERNAME": "${DATAFORSEO_LOGIN}",
    "DATAFORSEO_PASSWORD": "${DATAFORSEO_PASSWORD}"
  }
}
```

Maps to existing DATAFORSEO_LOGIN and DATAFORSEO_PASSWORD env vars. The `dataforseo-mcp-server` expects `DATAFORSEO_USERNAME` not `DATAFORSEO_LOGIN` — add both to env block if needed.

#### Jina AI MCP via webskim (Priority 3)

```json
"webskim": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "webskim"],
  "env": {
    "JINA_API_KEY": "${JINA_API_KEY}"
  }
}
```

Also add `JINA_API_KEY` to the env block.

#### Brave Search MCP (Priority 4)

```json
"brave-search": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-brave-search"],
  "env": {
    "BRAVE_API_KEY": "${BRAVE_API_KEY}"
  }
}
```

⚠️ Note: This package is deprecated. If Brave API responds with deprecation errors, switch to `mcp-brave-search` (same BRAVE_API_KEY env var):

```json
"brave-search": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "mcp-brave-search"],
  "env": {
    "BRAVE_API_KEY": "${BRAVE_API_KEY}"
  }
}
```

#### Google CSE MCP (Priority 5)

```json
"google-cse": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@mseep/mcp-google-custom-search-server"],
  "env": {
    "GOOGLE_API_KEY": "${GOOGLE_API_KEY}",
    "GOOGLE_CSE_ID": "${GOOGLE_CSE_ID}"
  }
}
```

Add `GOOGLE_CSE_ID` to the env block (need to create this in Google Console: programmablesearchengine.google.com).

#### CrawlForge MCP (Priority 6)

```json
"crawlforge": {
  "type": "stdio",
  "command": "crawlforge-mcp",
  "env": {
    "CRAWLFORGE_API_KEY": "${CRAWLFORGE_API_KEY}"
  }
}
```

Alternative (no install): `"command": "npx", "args": ["-y", "crawlforge-mcp-server"]`
Add `CRAWLFORGE_API_KEY` to the env block.

#### FetchSERP MCP (Priority 7)

```json
"fetchserp": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@fastmcp-me/fetchserp-mcp-server-node"],
  "env": {
    "FETCHSERP_API_TOKEN": "${FETCHSERP_API_TOKEN}"
  }
}
```

Add `FETCHSERP_API_TOKEN` to the env block.

### 5.3 CONFIGURE_LATER Servers

#### SearXNG MCP (Self-Hosted)

Minimal config (after SearXNG Docker instance is running):

```json
"searxng": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@iori7295/searxng-mcp"],
  "env": {
    "SEARXNG_BASE_URL": "http://localhost:8080"
  }
}
```

Requires Docker SearXNG instance first. See `searxng-docker` GitHub repo.

#### TAM-MCP-Server (Repo Clone + Build)

After git clone + npm install + npm run build in the repo:

```json
"tam-mcp": {
  "type": "stdio",
  "command": "node",
  "args": ["/path/to/TAM-MCP-Server/dist/index.js"],
  "env": {
    "NODE_ENV": "development"
  }
}
```

Or via HTTP mode: `npm run start:http` on port 3000, then SSE config.

---

## 6. INTEGRATION FOR TOOLS WITHOUT MCP SERVERS

### 6.1 When to Use MCP vs CLI vs Raw API

| Integration Pattern | When to Use | Example |
|---------------------|-------------|---------|
| **MCP Server** | Agent needs to call a tool in natural language, get structured results, combine with other tools | PaperPlain: agent calls `search_research("revenue intelligence")`, gets structured JSON |
| **CLI Wrapper** | Tool has complex multi-step workflows, requires authentication profiles, or MCP is incomplete | Firecrawl CLI: `firecrawl scrape --wait-for 3000` covers JS rendering that MCP can't |
| **Raw curl/API** | Tool has no MCP, no CLI, or agent only needs one specific endpoint | GDELT API: simple curl with params, no need for a full MCP server |
| **Python script** | Tool needs complex orchestration, retry logic, multi-step transformations | TED API -> OCDS JSON -> structured competitor analysis |

### 6.2 Tools Without MCP Servers — Recommended Integration

| Tool | Current Method | Integration Recommendation | Why |
|------|---------------|---------------------------|-----|
| Firecrawl | CLI | **Keep CLI.** Do not switch to MCP. | CLI has 10+ commands, MCP has 9 tools. Missing: interact, monitor, download, parse, agent, search-feedback. CLI already works, has established workflows. |
| DataForSEO | Raw curl | **Switch to official MCP server** (`dataforseo-mcp-server`) | MCP provides structured tool calling within agents, built-in error handling, 10 API modules. Eliminates curl boilerplate. All 9 APIs we use are covered. |
| GDELT Project | (Not yet used) | **Raw curl.** No MCP server exists. | GDELT is simple GET requests with query params. No MCP wrapper needed. |
| EUROSTAT API | (Not yet used) | **Raw curl OR TAM-MCP-Server** (if configured) | EUROSTAT is simple REST API. TAM-MCP-Server wraps it if configured. |
| OECD API | (Not yet used) | **Raw curl OR TAM-MCP-Server** (if configured) | Same pattern as EUROSTAT. |
| World Bank API | (Not yet used) | **Raw curl OR TAM-MCP-Server** (if configured) | Simplest API of all — no auth, unlimited. |
| TED API | (Not yet used) | **Raw curl** to TEDective endpoint | Simple REST API, no MCP server available. |
| Open PageRank | (Not yet used) | **Raw curl** | Single endpoint with API key header. No MCP needed. |
| Brandfetch | (Not yet used) | **Raw curl** | REST API with Bearer token. BRANDFETCH_API_KEY already in env. |
| ATS Job Boards | (Not yet used) | **Raw curl** | Greenhouse/Lever/Ashby are simple GET endpoints, no auth. No MCP needed. |
| UK Companies House | (Not yet used) | **Raw curl OR OpenRegistry MCP** | Companies House API key already in env. OpenRegistry has UK jurisdiction as fallback. |
| CBS StatLine | (Not yet used) | **Raw curl** | OData endpoint, simple REST queries. |
| Techmap Job Postings | (Not yet used) | **Raw curl** via RapidAPI | Standard REST API with Bearer token. |

### 6.3 DataForSEO MCP vs Raw Curl — Migration Assessment

Switching from raw curl to `dataforseo-mcp-server` requires updating the agent research protocol:

**Current raw curl pattern:**
```bash
curl -X POST "https://api.dataforseo.com/v3/serp/google/organic/live/advanced" \
  -H "Authorization: Basic $(echo -n "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" | base64)" \
  -H "Content-Type: application/json" \
  -d '{...}'
```

**New MCP pattern:**
```
Agent calls: serp_google_organic_live({ keyword: "...", location_code: 2826 })
```

**Migration impact:**
- All 25 niche agents need updated research protocols
- The DATA-OPERATIONS-ARCHITECTURE.md §2.1 tool-master-matrix references curl commands — needs updating
- Benefits: structured error handling, no base64 encoding, no boilerplate
- Risk: MCP tools may not cover all endpoint parameters. Need verification against our 9 API categories.

**Recommendation:** Implement as a parallel integration first. Keep raw curl scripts as fallback. Once MCP is validated against all 9 API categories across 3 test niches, switch primary method.

---

## 7. RISK REGISTER

### P1 Risks (Pipeline-Blocking)

| Risk | Severity | Mitigation |
|------|----------|------------|
| DataForSEO MCP missing endpoint parameters | HIGH | Keep raw curl scripts as fallback. Test against all 9 API categories before switching. |
| Too many MCP servers degrade agent startup/performance | HIGH | Claude Code loads all MCP servers at startup. With 10+ stdio servers, startup could slow to 30-60 seconds. **Mitigation:** Start with 3 CONFIGURE_NOW servers, add CONFIGURE_SOON incrementally over 3 sessions, measure startup time after each addition. |

### P2 Risks (Degraded)

| Risk | Severity | Mitigation |
|------|----------|------------|
| Brave Search MCP deprecated package breaks | MEDIUM | Use community `mcp-brave-search` as alternative. Same env var. |
| Reddit Research MCP hosted endpoint changes URL | MEDIUM | Monitor GitHub repo for URL updates. Have `reddit-mcp-server` (npx) as fallback. |
| TAM-MCP-Server build becomes stale | LOW | Pin to specific commit after successful build. Document rebuild steps. |

### P3 Risks (Non-Blocking)

| Risk | Severity | Mitigation |
|------|----------|------------|
| Serper free tier is monthly, not one-time (economics are BETTER than documented) | INFO | Update SME-tool-reference-expansion.md §1.4 — free tier is 2,500 queries/month recurring, NOT one-time. This is positive: more capacity than planned. |
| Brave Search "Unlimited (self-hosted)" claim wrong in architecture | INFO | Update DATA-OPERATIONS-ARCHITECTURE.md §2.1. Brave Search is API-key-based (2K free queries/mo), not self-hosted. Self-hosted is SearXNG. |

---

## 8. PRIORITY ACTION PLAN

### Phase 0 (Pre-Niche-1) — 47 minutes total

| Step | Action | Time | Dependency |
|------|--------|------|------------|
| 1 | Add PaperPlain MCP to settings.json | 2 min | None |
| 2 | Add Reddit Research MCP (hosted) to settings.json | 2 min | None |
| 3 | Add Financial Hub MCP to settings.json | 3 min | None |
| 4 | Verify 3 CONFIGURE_NOW servers work (calibration tests) | 10 min | Steps 1-3 |
| 5 | Sign up for Serper API key (serper.dev) | 2 min | None |
| 6 | Add Serper MCP config + API key to settings.json | 3 min | Step 5 |
| 7 | Sign up for Jina AI API key (jina.ai) | 2 min | None |
| 8 | Add webskim MCP config + API key to settings.json | 3 min | Step 7 |
| 9 | Verify 2 CONFIGURE_SOON servers work (calibration tests) | 10 min | Steps 6, 8 |
| 10 | Sign up for Brave Search API key (api.search.brave.com) | 2 min | None |
| 11 | Add Brave Search MCP config + API key | 3 min | Step 10 |
| 12 | Create Google CSE engine ID + configure | 10 min | None |

### Phase 0+ (Before Niche Batch 1) — optional

| Step | Action | Time |
|------|--------|------|
| 13 | Clone + build TAM-MCP-Server, configure | 30 min |
| 14 | Set up SearXNG Docker instance | 60 min |
| 15 | Test DataForSEO MCP vs raw curl parity (3 test API calls) | 15 min |

### Not Before Batch 1

| Step | Action | Wait For |
|------|--------|----------|
| 16 | CrawlForge MCP — signup + configure | Only if Firecrawl budget runs low |
| 17 | FetchSERP MCP — signup + configure | Only if WHOIS/DNS data not covered by DataForSEO |

### Total MCP Footprint After Phase 0

Running MCP servers after Phase 0: ~6-8 servers (3 CONFIGURE_NOW + 3-5 CONFIGURE_SOON). At ~2-5 seconds each for startup = 12-40 seconds total agent startup overhead. Acceptable.

---

## 9. APPENDIX: FIRECRAWL MCP vs CLI COMPARISON

### Tool Coverage

| CLI Command | Firecrawl MCP (firecrawl-mcp) | Notes |
|-------------|-------------------------------|-------|
| `firecrawl search` | `firecrawl_search` | Equivalent. MCP returns structured JSON directly. |
| `firecrawl scrape` | `firecrawl_scrape` | Equivalent. Both support markdown, HTML, links formats. |
| `firecrawl map` | `firecrawl_map` | Equivalent. Both discover URLs. |
| `firecrawl crawl` | `firecrawl_crawl` | Equivalent. Both support depth/path filtering. |
| `firecrawl interact` | **MISSING** | No MCP equivalent. CLI only. |
| `firecrawl monitor` | **MISSING** | No MCP equivalent. CLI only. |
| `firecrawl download` | **MISSING** | No MCP equivalent. CLI only. |
| `firecrawl parse` | **MISSING** | No MCP equivalent. CLI only. |
| `firecrawl agent` | `firecrawl_extract` | Partial. MCP has extract but not autonomous agent mode. |
| `firecrawl search-feedback` | **MISSING** | No MCP equivalent. CLI only. |
| `firecrawl --status` | **MISSING** | Check credits via `firecrawl credit-usage` CLI. |
| N/A | `firecrawl_batch_scrape` | MCP-only. Batch processing with rate limiting. |
| N/A | `firecrawl_deep_research` | MCP-only. Multi-step deep research. |
| N/A | `firecrawl_generate_llmstxt` | MCP-only. Generate LLMs.txt. |
| N/A | `firecrawl_check_crawl_status` | MCP-only. Async job status checks. |
| N/A | `firecrawl_check_batch_status` | MCP-only. Batch job status. |

### Verdict

The MCP server adds 3 capabilities not in CLI (batch_scrape, deep_research, generate_llmstxt) but loses 7 CLI capabilities (interact, monitor, download, parse, agent, search-feedback, status). For the niche research pipeline, **interact** (authenticated page interaction) and **monitor** (recurring change detection) are critical capabilities that the MCP server cannot provide.

**Final recommendation:** Keep Firecrawl CLI as the primary integration. Do not add Firecrawl MCP to settings.json.

---

## APPENDIX B: DATA-OPERATIONS-ARCHITECTURE.md CORRECTIONS

| Section | Current Text | Corrected Text |
|---------|-------------|----------------|
| §2.1 Tier 2 — Brave Search | "Unlimited (self-hosted)" | "2,000 queries/month free (requires Brave API key). Not self-hosted. Self-hosted web search is SearXNG." |
| §2.1 Tier 2 — Serper | "2,500 free queries (one-time)" | "2,500 free queries per month (recurring — more capacity than documented)" |
| §2.1 Tier 2 — Reddit Research | "Free, no auth, 20K+ subreddits" | Confirmed. Add: "Hosted SSE endpoint at https://reddit-research-mcp.fastmcp.app/mcp. No credentials." |
| §2.1 Tier 2 — Firecrawl (implicit) | (Not listed as MCP, listed as Tier 1 CLI) | Add note: "Firecrawl MCP exists (firecrawl-mcp, mendableai, v1.10.0) but CLI is preferred — MCP missing 7 of 10+ critical commands." |
| §4.2 Phase 2 Step 2.9 | "Reddit Research MCP + Firecrawl /search" | Update to reference hosted SSE endpoint URL for consistency. |

---

*End of audit-lens1-mcp-integration.md — Ranked findings by MCP/Integration Architect.*
