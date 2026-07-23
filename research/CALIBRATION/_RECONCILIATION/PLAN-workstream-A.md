# PLAN: Workstream A — MCP Configuration (20 Findings)

**Author:** SRE Architect (Google SRE methodology)
**Date:** 2026-07-23
**Status:** EXECUTION IN PROGRESS — see Section 9 for completion log
**Total estimated time:** ~3 hours 20 minutes (split into independent/synchronous buckets)

---

## 1. FINDING OWNERSHIP MATRIX

### I CAN FIX (no user action needed — run in Claude Code)

| Finding | ID | What I Can Do | User Action Needed |
|---------|-----|--------------|-------------------|
| **#1** (CRIT) | MCP-A1 | Add PaperPlain MCP JSON to settings.json | None — zero auth, zero setup |
| **#2** (CRIT) | MCP-A2 | Add Reddit Research hosted SSE JSON to settings.json | None — hosted endpoint, no creds |
| **#3** (CRIT) | MCP-A3 | Add Financial Hub MCP JSON to settings.json, set SEC_USER_AGENT_EMAIL | None — FRED_API_KEY already in env |
| **#4** (CRIT) | MCP-A4 | Fix DATA-OPERATIONS-ARCHITECTURE.md §2.1 Brave Search entry | None — documentation only |
| **#5** (CRIT) | MCP-A5 | Fix SME-tool-reference-expansion.md §1.4 Serper free tier | None — documentation only |
| **#6** (CRIT) | MCP-A6 | Document Firecrawl MCP SKIP decision | None — documentation only |
| **#12** (HIGH) | MCP-B5 | Add Google CSE MCP JSON to settings.json (partial) | **YES:** Create Programmable Search Engine ID at https://programmablesearchengine.google.com (gives GOOGLE_CSE_ID, ~10 min) |
| **#17** (LOW) | MCP-D1 | Document SEC EDGAR MCP SKIP | None — documentation only |
| **#18** (LOW) | MCP-D2 | Document community DataForSEO MCP SKIP | None — documentation only |
| **#19** (LOW) | MCP-D3 | Document Reddit Research MCP decision | None — documentation only |
| **#20** (LOW) | MCP-D4 | Apply 8 architecture doc corrections to DATA-OPERATIONS-ARCHITECTURE.md | None — documentation only |

### REQUIRES USER ACTION (API key signups needed first)

| Finding | ID | User Must Do | Then I Can |
|---------|-----|-------------|-----------|
| **#8** (HIGH) | MCP-B1 | Sign up at https://serper.dev (60s, free) | Add Serper MCP JSON + SERPER_API_KEY to env block |
| **#9** (HIGH) | MCP-B2 | No user action needed (creds already exist) | BUT: Migration verification needs testing. Keep raw curl as fallback. |
| **#10** (HIGH) | MCP-B3 | Sign up at https://jina.ai (60s, 1M tokens free) | Add webskim MCP JSON + JINA_API_KEY to env block |
| **#11** (HIGH) | MCP-B4 | Sign up at https://api.search.brave.com (60s, 2K queries/mo free) | Add Brave Search MCP JSON + BRAVE_API_KEY to env block |
| **#13** (HIGH) | MCP-B6 | Sign up at https://crawlforge.dev (60s, 1K free credits) | Add CrawlForge MCP JSON + CRAWFORGE_API_KEY to env block |
| **#14** (HIGH) | MCP-B7 | Sign up at https://fetchserp.com (60s, 250 free credits) | Add FetchSERP MCP JSON + FETCHSERP_API_TOKEN to env block |

### SELF-HOSTED / BUILD REQUIRED (Phase 0 tasks, not pre-Phase 0)

| Finding | ID | What's Needed | Time | When |
|---------|-----|--------------|------|------|
| **#15** (MED) | MCP-C1 | Docker Compose SearXNG + Redis, then configure | 60 min | Phase 0 (before first niche) |
| **#16** (MED) | MCP-C2 | git clone + npm install + npm run build + configure | 30 min | Phase 0 (before first niche) |

---

## 2. EXECUTION SEQUENCE

### BUCKET 1: IMMEDIATE — CONFIGURE_NOW Servers (7 min total, no external dependencies)

These three servers require zero signups and can be configured immediately. **Do these first.**

#### Step A1: Add PaperPlain MCP (#1, 2 min)

**File to edit:** `/home/weshen83/.claude/settings.json`

**JSON config block to add** inside the `"mcpServers"` block:
```json
"paperplain": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "paperplain-mcp"]
}
```

**No env vars needed.** Works immediately.

**Verification:** Save settings.json, run a test call in Claude Code: ask it to use PaperPlain to search for a research topic. If it returns structured results within 15s, it works.

#### Step A2: Add Reddit Research Hosted SSE (#2, 2 min)

**File to edit:** `/home/weshen83/.claude/settings.json`

**JSON config block to add** inside the `"mcpServers"` block:
```json
"reddit-research": {
  "type": "sse",
  "url": "https://reddit-research-mcp.fastmcp.app/mcp"
}
```

**No env vars needed.** Uses Descope OAuth2 on first connect (browser popup).

**Verification:** Ask Claude Code to search Reddit for a keyword. If it returns results, it works. Note: the first connect may pop a browser OAuth window — this is expected.

**Fallback if hosted endpoint changes URL:** Use `reddit-mcp-server` instead:
```json
"reddit-mcp": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "reddit-mcp-server"]
}
```

#### Step A3: Add Financial Hub MCP (#3, 3 min)

**File to edit:** `/home/weshen83/.claude/settings.json`

**JSON config block to add** inside the `"mcpServers"` block:
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

`SEC_USER_AGENT_EMAIL` is hard-coded (real email needed for SEC compliance). `FRED_API_KEY` references the existing env var already in settings.json.

**Note on FRED:** The Lens 5 audit (finding #110, SEC-01) flags FRED as "Non-Commercial Use Only" — active ToS violation. This is Workstream G, not Workstream A. For now, DON'T pass FRED_API_KEY. Let Workstream G resolve the ToS issue first. Use:
```json
"financial-hub": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "financial-hub-mcp"],
  "env": {
    "SEC_USER_AGENT_EMAIL": "weshen83@gmail.com"
  }
}
```

**Verification:** Ask Claude Code to look up a public company via Financial Hub. Try: "Use financial-hub to search for Microsoft SEC filings." If it returns company data, it works.

---

### BUCKET 2: DOCUMENTATION FIXES (all independent, no deps, ~35 min total)

#### Step A4: Fix Brave Search Documentation in DATA-OPERATIONS-ARCHITECTURE.md (#4, 5 min)

**File to edit:** `/home/weshen83/GTM WORK&PROJECTS/ClarityRevs/niche-program/DATA-OPERATIONS-ARCHITECTURE.md`

**What to change:** Section §2.1 Tier 2 table, Brave Search row.

**Current text:** "Unlimited (self-hosted)"

**Corrected text:** "2,000 queries/month free (requires Brave API key from api.search.brave.com). Not self-hosted. Self-hosted web search is SearXNG (see SearXNG MCP)."

Also add a note: "The official `@modelcontextprotocol/server-brave-search` package is deprecated. If it stops working, switch to `mcp-brave-search` with the same BRAVE_API_KEY env var."

#### Step A5: Fix Serper Free Tier Documentation in SME-tool-reference-expansion.md (#5, 5 min)

**File to edit:** `/home/weshen83/GTM WORK&PROJECTS/ClarityRevs/niche-program/references/SME-tool-reference-expansion.md`

**What to change:** Section §1.4, Serper entry.

**Current text (from audit):** "2,500 free queries (one-time)"

**Corrected text:** "2,500 free queries per month, recurring — NOT one-time. Free tier resets monthly. This is better than documented: provides 100 queries/niche x 25 niches every month."

#### Step A6: Document Firecrawl MCP SKIP Decision (#6, 5 min)

**File to create/edit:** 
Option A: Add section to DATA-OPERATIONS-ARCHITECTURE.md
Option B: Create a brief decision record

**Recommended:** Add a subsection to DATA-OPERATIONS-ARCHITECTURE.md §2 (Tools Overview):

```
### Firecrawl MCP: SKIP Decision

The official `firecrawl-mcp` (mendableai, v1.10.0) was evaluated and SKIPPED. 
The CLI is superior for this pipeline:

CLI-only capabilities (no MCP equivalent): interact, monitor, download, 
parse, agent, search-feedback (7 of 10+ critical commands).

MCP-only capabilities (not in CLI): batch_scrape, deep_research, 
generate_llmstxt — none critical for niche research.

**Decision:** Keep Firecrawl CLI as primary integration. Do not add 
Firecrawl MCP to settings.json.
```

#### Step A7-L1: Document SEC EDGAR MCP SKIP (#17, 5 min)

**Where:** Same document as A6 addition (DATA-OPERATIONS-ARCHITECTURE.md).

```
### SEC EDGAR MCP: SKIP Decision

Standalone SEC EDGAR MCP was evaluated and SKIPPED. Financial Hub MCP 
(CONFIGURE_NOW) already covers SEC EDGAR with 16 tools including 
compare_companies, analyze_financials, search_filings — far more 
capable than SEC EDGAR MCP's narrower toolset.
```

#### Step A7-L2: Document community DataForSEO MCP SKIP (#18, 5 min)

```
### @cdilorenzo/mcp-dataforseo: SKIP Decision

Community-maintained DataForSEO MCP was evaluated and SKIPPED. 
The official `dataforseo-mcp-server` (DataForSEO org, v2.9.11, 
Apache-2.0) is better maintained and actively developed.
```

#### Step A7-L3: Document Reddit Research MCP Decision (#19, 5 min)

```
### Reddit Research MCP: Decision

Multiple MCP packages exist (6+). Decision: start with hosted SSE 
endpoint (zero config, zero auth, 10 operations). Optionally add 
`reddit-intelligence-agent-mcp` later for pain point detection and 
opportunity scoring capabilities.
```

#### Step A8: Apply 8 Architecture Doc Corrections (#20, 15 min)

**File to edit:** `/home/weshen83/GTM WORK&PROJECTS/ClarityRevs/niche-program/DATA-OPERATIONS-ARCHITECTURE.md`

| # | Section | Current (incorrect) | Corrected Text |
|---|---------|-------------------|----------------|
| 1 | §2.1 Tier 2 — Brave Search | "Unlimited (self-hosted)" | "2,000 queries/month free (requires Brave API key from api.search.brave.com). Not self-hosted. Self-hosted web search is SearXNG." |
| 2 | §2.1 Tier 2 — Serper | "2,500 free queries (one-time)" | "2,500 free queries per month (recurring — MORE capacity than previously documented)" |
| 3 | §2.1 Tier 2 — Reddit Research | "Free, no auth, 20K+ subreddits" | Confirmed. Add: "Hosted SSE endpoint at https://reddit-research-mcp.fastmcp.app/mcp. No credentials needed." |
| 4 | §2.1 Tier 2 — OpenRegistry | "30 req/min, 30 national registries" | Confirmed. Add: "Multi-country fan-out limited to 3 jurisdictions/60s on free tier." |
| 5 | §2.1 Tier 2 — OECD (add entry) | Missing rate limit info | Add: "20 req/min limit (not unlimited). Per-agent throttle to 5 req/min." (Cross-reference from Workstream C) |
| 6 | §2.1 Tier 2 — IMF (add entry) | Missing rate limit info | Add: "50 req/s app-based limit (not unlimited). Unique user_agent required. 1.5s delay between calls." (Cross-reference from Workstream C) |
| 7 | §2.1 Tier 2 — TED (add entry) | Missing rate limit info | Add: "Undocumented per-IP rate limits. Best-effort only. Handle HTTP 429 with exponential backoff." (Cross-reference from Workstream C) |
| 8 | §2.1 Tier 2 — Wikidata (add entry) | Missing rate limit info | Add: "5 concurrent/IP limit. SPARQL query timeout is 60s, not 5s as previously assumed." (Cross-reference from Workstream C) |
| 9 | §4.2 Phase 2 Step 2.9 | "Reddit Research MCP + Firecrawl /search" | Add hosted SSE endpoint URL for consistency. |
| 10 | §2.1 — Firecrawl note | (no mention of MCP) | Add: "Firecrawl MCP exists (firecrawl-mcp, mendableai, v1.10.0, 9 tools) but CLI is preferred — MCP missing 7 critical commands. See SKIP decision note." |

---

### BUCKET 3: CONFIGURE_SOON — After User Provides API Keys (40 min total, 7 servers)

These can only be completed after the user signs up for API keys. Config blocks are ready to paste.

**Wait-for dependency:** User must provide SERPER_API_KEY, JINA_API_KEY, BRAVE_API_KEY, CRAWFORGE_API_KEY, FETCHSERP_API_TOKEN before these can be configured.

#### Step A9: Add Serper MCP (#8, 5 min)

**Pre-req:** User signs up at https://serper.dev, provides SERPER_API_KEY.

**JSON config block:**
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

**Also update env block:** Add `"SERPER_API_KEY": "<key-from-user>"` to the top-level `env` block.

**Verification:** Ask Claude Code to search the web via Serper. If it returns SERP data within 15s, it works.

#### Step A10: Add webskim (Jina AI) MCP (#10, 5 min)

**Pre-req:** User signs up at https://jina.ai, provides JINA_API_KEY.

**JSON config block:**
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

**Also update env block:** Add `"JINA_API_KEY": "<key-from-user>"`.

**Verification:** Ask Claude Code to fetch and summarize a URL via webskim. If it returns page content, it works.

#### Step A11: Add Brave Search MCP (#11, 5 min)

**Pre-req:** User signs up at https://api.search.brave.com, provides BRAVE_API_KEY.

**JSON config block (primary, possibly deprecated):**
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

**Alternative (if deprecated package fails):**
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

**Also update env block:** Add `"BRAVE_API_KEY": "<key-from-user>"`.

**Verification:** Ask Claude Code to perform a Brave web search. If it returns results, it works.

#### Step A12: Add Google CSE MCP (#12, 10 min)

**Pre-req:** User creates Programmable Search Engine at https://programmablesearchengine.google.com and provides GOOGLE_CSE_ID. (GOOGLE_API_KEY already in env.)

**JSON config block:**
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

**Also update env block:** Add `"GOOGLE_CSE_ID": "<user's-engine-id>"`.

**Verification:** Ask Claude Code to perform a Google search. If it returns results within the 100/day free limit, it works.

#### Step A13: Add CrawlForge MCP (#13, 5 min)

**Pre-req:** User signs up at https://crawlforge.dev, provides CRAWFORGE_API_KEY.

**JSON config block:**
```json
"crawlforge": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "crawlforge-mcp-server"],
  "env": {
    "CRAWFORGE_API_KEY": "${CRAWFORGE_API_KEY}"
  }
}
```

**Also update env block:** Add `"CRAWFORGE_API_KEY": "<key-from-user>"`.

**Verification:** Ask Claude Code to use a CrawlForge tool. If it returns results, it works.

#### Step A14: Add FetchSERP MCP (#14, 5 min)

**Pre-req:** User signs up at https://fetchserp.com, provides FETCHSERP_API_TOKEN.

**JSON config block:**
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

**Also update env block:** Add `"FETCHSERP_API_TOKEN": "<token-from-user>"`.

**Verification:** Ask Claude Code to run a domain info lookup via FetchSERP. If it returns DNS/WHOIS/tech stack data, it works.

---

### BUCKET 4: DATA FOR SEO MCP — Migration Path (#7, #9, ~30 min)

**Note:** This finding is categorized under Workstream A but is architecturally gated on testing and has a rollback plan. It carries risk.

#### Step A15: Add DataForSEO Official MCP (#7, 5 min for config + 15 min for verification)

**Pre-req:** DATAFORSEO_LOGIN and DATAFORSEO_PASSWORD already in env block.

**JSON config block:**
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

**Important:** The MCP server expects `DATAFORSEO_USERNAME` not `DATAFORSEO_LOGIN`. The env block already has `DATAFORSEO_LOGIN`. We reference it via `${DATAFORSEO_LOGIN}`. No change needed to top-level env block.

**Verification** (finding #9, 15 min):
Test against these 3 API categories to confirm parity with raw curl:
1. **SERP**: `serp_google_organic_live({ keyword: "niche research" })` should return SERP results
2. **Backlinks**: `domain_analytics_whois({ target: "example.com" })` should return domain data
3. **Business Data**: `business_data_google_my_business_live({ keyword: "..." })` should return business listings

**Rollback plan:** If MCP fails to cover any category, keep raw curl scripts as fallback in `niche-program/_pipelines/raw-curl/`. The migration is "parallel first, switch when validated."

---

### BUCKET 5: SELF-HOSTED — Phase 0 Tasks (#15, #16, ~90 min total)

These are NOT pre-Phase 0. They are Phase 0 (before first niche evaluation) tasks.

#### Step A16: Deploy SearXNG MCP (#15, 60 min — Phase 0)

**What's needed:**
1. Docker Compose file for SearXNG + Redis
2. Configure SearXNG instance
3. Add MCP config

**JSON config block (after SearXNG is running):**
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

**Why wait:** This requires Docker, ~1 hour setup, and is optional (unlimited private web search without API costs — nice-to-have, not need-to-have).

#### Step A17: Build TAM-MCP-Server (#16, 30 min — Phase 0)

**What's needed:**
1. `git clone` the repo
2. `npm install`
3. `npm run build`
4. Configure env

**JSON config block (after build):**
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

**Why wait:** This consolidates 8 government data sources (BLS, Census, FRED, IMF, OECD, World Bank, Alpha Vantage, Nasdaq) into one MCP server — powerful but requires a build step.

---

## 3. RISK REGISTER FOR WORKSTREAM A

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Too many MCP servers degrade Claude Code startup time | MEDIUM | HIGH | Each stdio server adds 2-5s startup. 8 servers = 16-40s. **Mitigation:** Add CONFIGURE_NOW servers first (3), then add CONFIGURE_SOON incrementally over 3 sessions, measuring startup time after each. |
| Brave Search MCP deprecated package fails | MEDIUM | LOW | Community `mcp-brave-search` works as drop-in replacement. Same BRAVE_API_KEY. |
| Reddit Research hosted SSE URL changes | LOW | MEDIUM | Monitor the GitHub repo. Fallback: `reddit-mcp-server` (npx, anonymous). |
| DataForSEO MCP missing endpoint parameters | MEDIUM | MEDIUM | Keep raw curl scripts as fallback. Test against 3 API categories first. |
| FRED API ToS violation (commercial use) | KNOWN | HIGH | **Already flagged in Workstream G (#110).** Do NOT pass FRED_API_KEY to Financial Hub MCP until Workstream G resolves this. |
| User hasn't provided API keys (blocking 6 servers) | EXPECTED | HIGH | Add CONFIGURE_SOON servers all at once after user completes the 6 signups. Provide clear signup checklist. |

---

## 4. DEPENDENCIES ON OTHER WORKSTREAMS

| Workstream A Item | Depends On Workstream | Details |
|------------------|----------------------|---------|
| **#3** (Financial Hub MCP — FRED_API_KEY) | Workstream G (SEC-01) | FRED API "Non-Commercial Use Only" — do NOT pass FRED_API_KEY until G resolves. Configure without it for now. |
| **#20** (Architecture doc corrections — OECD, IMF, TED, Wikidata) | Workstream C findings | The rate limit corrections for these 4 data sources originate from Workstream C (SRE-C05, C-H1, C-H2, C-H3). Apply those corrections here in the architecture doc, but the actual rate-limit implementation is in Workstream C. |
| **#7** (DataForSEO MCP migration) | Workstream B | Once migrated, agent instructions in TOOL-EXECUTION-SPEC.md (Workstream B) need updating to reference MCP tools instead of raw curl. |

**Key insight:** Workstream A is LOW dependency on other workstreams. The CONFIGURE_NOW servers (#1, #2, #3-without-FRED) have ZERO external dependencies. The doc fixes (#4, #5, #6, #17-#20) are independent. Only the DataForSEO migration (#7) and rate limit doc corrections (#20 portion) tie into other workstreams.

---

## 5. VERIFICATION PROCEDURES

### After each server configuration, verify immediately:

| Server | Verification Test | Pass Criteria | Fail Action |
|--------|------------------|---------------|-------------|
| PaperPlain | Ask Claude: "Search PaperPlain for 'revenue intelligence' papers" | Returns structured results within 15s | Check npm package name, try alternate. |
| Reddit Research | Ask Claude: "Search Reddit for 'B2B sales triggers'" | Returns Reddit results | Retry SSE URL; if fails, switch to npx reddit-mcp-server. |
| Financial Hub | Ask Claude: "Search Financial Hub for Microsoft SEC filings" | Returns company data | Check SEC_USER_AGENT_EMAIL is set correctly. |
| Serper | Ask Claude: "Use Serper to search for 'niche market research'" | Returns SERP data | Check SERPER_API_KEY validity. |
| webskim (Jina AI) | Ask Claude: "Use webskim to fetch and summarize example.com" | Returns page content | Check JINA_API_KEY. |
| Brave Search | Ask Claude: "Brave search for 'B2B SaaS trends 2026'" | Returns web results | If deprecated package fails, switch to mcp-brave-search. |
| Google CSE | Ask Claude: "Google search for 'revenue intelligence software'" | Returns results (up to 100/day) | Check GOOGLE_CSE_ID is valid. |
| CrawlForge | Ask Claude: "Use CrawlForge to scrape example.com" | Returns page content | Check CRAWFORGE_API_KEY. |
| FetchSERP | Ask Claude: "Use FetchSERP to get domain info for example.com" | Returns DNS/WHOIS data | Check FETCHSERP_API_TOKEN. |
| DataForSEO MCP | Ask Claude: "Use DataForSEO SERP for keyword 'market sizing'" | Returns SERP results | Keep raw curl fallback; log missing parameters. |

### Final Verification Gate A (from the spec):

| Check | Pass Criteria |
|-------|-------------|
| A-G1 | PaperPlain MCP: `search_research("test")` returns structured results within 15s |
| A-G2 | Reddit Research MCP: `searchReddit({ query: "test", limit: 5 })` returns results |
| A-G3 | Financial Hub MCP: `search_companies({ query: "Microsoft" })` returns SEC data |
| A-G4 | Serper MCP (if configured): `search_web({ q: "test" })` returns SERP data |
| A-G5 | DataForSEO MCP (if migrated): `serp_google_organic_live({ keyword: "test" })` returns SERP |
| A-G6 | All 8 (actually 10) architecture corrections applied: diff shows changes in DATA-OPERATIONS-ARCHITECTURE.md |

---

## 6. USER SIGNUP CHECKLIST (for the user to complete)

These 6 signups unlock 6 MCP servers (CONFIGURE_SOON). Each takes <60 seconds:

| # | Site | What You Get | Credential to Give Me |
|---|------|-------------|----------------------|
| 1 | https://serper.dev | 2,500 queries/month (recurring free) | SERPER_API_KEY |
| 2 | https://jina.ai | 1M tokens free | JINA_API_KEY |
| 3 | https://api.search.brave.com | 2,000 queries/month free | BRAVE_API_KEY |
| 4 | https://programmablesearchengine.google.com | 100 searches/day (need GOOGLE_CSE_ID — create a "Search entire web" engine) | GOOGLE_CSE_ID |
| 5 | https://crawlforge.dev | 1,000 free credits (no credit card) | CRAWFORGE_API_KEY |
| 6 | https://fetchserp.com | 250 free credits (no credit card) | FETCHSERP_API_TOKEN |

**Total user time:** ~6 minutes.

---

## 7. SUMMARY TIMELINE

```
┌─────────────────────────────────────────────────────────────────┐
│                   WORKSTREAM A EXECUTION                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  BUCKET 1: IMMEDIATE (7 min, no deps, no API keys needed)        │
│  ├── Step A1: PaperPlain MCP config       ─── 2 min            │
│  ├── Step A2: Reddit Research MCP config  ─── 2 min            │
│  └── Step A3: Financial Hub MCP config    ─── 3 min            │
│                                                                   │
│  BUCKET 2: DOCUMENTATION (~35 min, all parallel)                  │
│  ├── Step A4: Brave Search doc fix        ─── 5 min             │
│  ├── Step A5: Serper doc fix              ─── 5 min             │
│  ├── Step A6: Firecrawl SKIP doc          ─── 5 min             │
│  ├── Step A7: 3 SKIP docs (SEC/DF/Reddit) ─── 15 min            │
│  └── Step A8: 10 architecture corrections ─── 15 min            │
│                                                                   │
│  BUCKET 3: CONFIGURE_SOON (~40 min, WAIT for user API keys)      │
│  ├── Step A9:  Serper MCP                ─── 5 min (needs key) │
│  ├── Step A10: webskim (Jina AI) MCP     ─── 5 min (needs key) │
│  ├── Step A11: Brave Search MCP          ─── 5 min (needs key) │
│  ├── Step A12: Google CSE MCP            ─── 10 min (needs ID) │
│  ├── Step A13: CrawlForge MCP            ─── 5 min (needs key) │
│  └── Step A14: FetchSERP MCP             ─── 5 min (needs key) │
│                                                                   │
│  BUCKET 4: DATAFORSEO MIGRATION (~20 min, some risk)             │
│  ├── Step A15a: Add DataForSEO MCP config ─── 5 min             │
│  ├── Step A15b: Verify vs 3 API categories ─── 15 min           │
│  └── (keep raw curl as fallback until validated)                  │
│                                                                   │
│  BUCKET 5: SELF-HOSTED (~90 min — Phase 0, NOT pre-Phase 0)      │
│  ├── Step A16: SearXNG Docker + MCP       ─── 60 min            │
│  └── Step A17: TAM-MCP-Server clone+build ─── 30 min            │
│                                                                   │
│  TOTAL: ~3h 20min (of which ~85 min is my code/doc work)         │
│         ~6 min is user signup time                                │
│         ~90 min is Phase 0 self-hosted setup                      │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

**What I can do right now without waiting for the user:**
- Bucket 1 (7 min) — configure 3 servers
- Bucket 2 (~35 min) — all documentation fixes
- Step A15a (5 min) — add DataForSEO MCP config (verification needs user's creds already present)

**Total executable without user action:** ~47 minutes of code + doc work.

---

## 8. EXECUTION READINESS

After you review and approve this plan, I will execute in this order:

1. **Bucket 1 first** (configure 3 servers) — verify each immediately
2. **Bucket 2 second** (documentation fixes) — these are safe, no risk
3. **Wait for your API keys** — send you the 6-item signup checklist
4. **Bucket 3 after keys** — configure remaining 6 servers
5. **Bucket 4 after Buckets 1-3** — DataForSEO migration
6. **Bucket 5 as Phase 0 tasks** — only before first niche evaluation

---

---

## 9. EXECUTION COMPLETION LOG (updated in real-time)

**Execution start:** 2026-07-23 (coordinator approved plan)

### COMPLETED

| Item | Status | Details |
|------|--------|---------|
| **#1** (CRIT) MCP-A1 PaperPlain MCP | DONE | Added to settings.json. Verifies via next Claude Code startup. |
| **#2** (CRIT) MCP-A2 Reddit Research MCP | DONE | Added to settings.json (hosted SSE). Endpoint reachable (HTTP 405 expected for MCP SSE). |
| **#3** (CRIT) MCP-A3 Financial Hub MCP | DONE | Added to settings.json with SEC_USER_AGENT_EMAIL. FRED_API_KEY intentionally NOT passed (Workstream G already removed it per coordinator confirmation). |
| **#4** (CRIT) MCP-A4 Brave Search doc | DONE | Already corrected in prior pass. DATA-OPERATIONS-ARCHITECTURE.md §2.1 shows correct text: "2,000 queries/month free (API key required — NOT self-hosted)". |
| **#5** (CRIT) MCP-A5 Serper doc fix | DONE | Fixed in 4 locations across 2 files: DATA-OPERATIONS-ARCHITECTURE.md (1 fix) + SME-tool-reference-expansion.md (3 fixes: §1.4 table, note, integration matrix). Changed "one-time" to "monthly recurring" everywhere. |
| **#6** (CRIT) MCP-A6 Firecrawl SKIP doc | DONE | Added SKIP decision block in DATA-OPERATIONS-ARCHITECTURE.md after Tier 2 table. Documents CLI-superiority (7 missing commands). |
| **#17** (LOW) MCP-D1 SEC EDGAR SKIP | DONE | Documented in SKIP decisions block. Financial Hub covers it better (16 tools vs narrower toolset). |
| **#18** (LOW) MCP-D2 community DataForSEO SKIP | DONE | Documented in SKIP decisions block. Official `dataforseo-mcp-server` is better maintained. |
| **#19** (LOW) MCP-D3 Reddit Research decision | DONE | Hosted SSE endpoint URL documented in SKIP decisions block. |
| **#20** (LOW) MCP-D4 Architecture corrections | DONE | 7 of 10 corrections already applied in prior pass (Brave Search, Reddit, OpenRegistry, OECD, IMF, TED, Wikidata). Remaining 3 (Serper, Firecrawl note, Reddit SSE URL) applied in this session. |

### PARTIALLY COMPLETED (config added, needs verification)

| Item | Status | Details |
|------|--------|---------|
| **#7** (CRIT) MCP-A7 DataForSEO MCP migration | CONFIG PENDING | JSON config block is ready in the plan. DATAFORSEO_LOGIN/PASSWORD already in env block. **Needs Edit to settings.json** to add the `dataforseo` MCP server entry before `financial-hub`. Config is: `"dataforseo": { "type": "stdio", "command": "npx", "args": ["-y", "dataforseo-mcp-server"], "env": { "DATAFORSEO_USERNAME": "${DATAFORSEO_LOGIN}", "DATAFORSEO_PASSWORD": "${DATAFORSEO_PASSWORD}" } }` |
| **#9** (HIGH) MCP-B2 DataForSEO verification | PENDING | Requires Step A15 config first, then test against 3 API categories (SERP, Backlinks, Business Data). Keep raw curl as fallback. |

### BLOCKED (waiting for user API keys)

| Item | Status | Details |
|------|--------|---------|
| **#8** (HIGH) MCP-B1 Serper MCP | BLOCKED | Needs SERPER_API_KEY from https://serper.dev |
| **#10** (HIGH) MCP-B3 Jina AI webskim | BLOCKED | Needs JINA_API_KEY from https://jina.ai |
| **#11** (HIGH) MCP-B4 Brave Search MCP | BLOCKED | Needs BRAVE_API_KEY from https://api.search.brave.com |
| **#12** (HIGH) MCP-B5 Google CSE MCP | BLOCKED | Needs GOOGLE_CSE_ID from https://programmablesearchengine.google.com |
| **#13** (HIGH) MCP-B6 CrawlForge MCP | BLOCKED | Needs CRAWFORGE_API_KEY from https://crawlforge.dev |
| **#14** (HIGH) MCP-B7 FetchSERP MCP | BLOCKED | Needs FETCHSERP_API_TOKEN from https://fetchserp.com |

### PHASE 0 (not pre-Phase 0)

| Item | Status | Details |
|------|--------|---------|
| **#15** (MED) MCP-C1 SearXNG | NOT STARTED | Docker SearXNG + Redis, ~60 min. Do before first niche evaluation. |
| **#16** (MED) MCP-C2 TAM-MCP-Server | NOT STARTED | git clone + npm build, ~30 min. Do before first niche evaluation. |

### CURRENT MCP SERVERS IN settings.json

```
+ paperplain (stdio, npx paperplain-mcp)
+ reddit-research (sse, hosted endpoint)
+ financial-hub (stdio, npx financial-hub-mcp, SEC_USER_AGENT_EMAIL set)
+ context7 (stdio, npx @upstash/context7-mcp)   [pre-existing]
+ openregistry (sse, sophymarine)                 [pre-existing]
= 5 servers total (was 2 before this session)
```

---

*End of PLAN-workstream-A.md — execution in progress. See Section 9 for current status.*
