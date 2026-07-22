# Lens 4: Cross-Agent Data Sharing Architecture
## ClarityRev 25-Niche Evaluation — Data Operations Architecture

**Status:** Design document
**Date:** 2026-07-23
**Context:** ClarityRev evaluating 25 B2B niches in priority order. Calibration niche evaluated first, then 24 remaining niches. Toolchain: Firecrawl (100K credits, 50 concurrent, relevance-model /search), DataForSEO ($50), Context7 MCP, 65+ MCP servers, 20+ free APIs. Phase 0 discovery complete.

---

## Table of Contents

1. [DATA CLASSIFICATION MATRIX](#1-data-classification-matrix)
2. [SHARING MECHANISM](#2-sharing-mechanism)
3. [MCP INTEGRATION PATTERN](#3-mcp-integration-pattern)
4. [TRACEABILITY CONTRACT](#4-traceability-contract)
5. [SHARED BENCHMARK DATABASE DESIGN](#5-shared-benchmark-database-design)
6. [ADVERSARIAL VERDICT](#6-adversarial-verdict)

---

## 1. DATA CLASSIFICATION MATRIX

Every data type produced during a niche evaluation is classified as either **niche-specific** (must be re-fetched per niche) or **cross-niche reusable** (fetched once, shared). The matrix governs what each agent must independently produce vs. what they can discover and consume from the shared store.

### 1.1 Classification Schema

Each data type is scored on 3 axes:
- **Niche-specificity** (1-5): How tightly coupled is this data to a single niche? 1 = universal (same for every niche), 5 = unique per niche
- **Reusability** (1-5): How much effort does it save to share vs. re-fetch? 1 = negligible savings, 5 = 25x savings
- **Staleness risk** (1-5): How quickly does shared data become misleading for other niches? 1 = timeless, 5 = stale within hours

### 1.2 Complete Classification Matrix

| # | Data Type | Niche-Specificity | Reusability | Staleness Risk | Classification | Rationale |
|---|---|---|---|---|---|---|
| D01 | Company list (niche-specific) | 5 | 3 | 1 | **NICHE** | Companies in "HubSpot CRM Agencies" differ from "Bullhorn Staffing" — no overlap expected |
| D02 | Company registry lookups (registry-lookup.com) | 3 | 4 | 2 | **CROSS-NICHE** | Jurisdiction, legal form, registration data is universal per entity; cache by company ID across niches |
| D03 | Niche-specific pain quotes (VOC) | 5 | 1 | 1 | **NICHE** | "My Zapier costs exploded" is a SaaS pain, not a staffing pain |
| D04 | Generic B2B pain patterns | 1 | 5 | 1 | **CROSS-NICHE** | "Integration complexity is my bottleneck," "I don't trust AI enrichment" — recur across all 25 niches |
| D05 | Competitor profiles (individual vendor) | 2 | 5 | 3 | **CROSS-NICHE** | SyncGTM appears in both "Revenue Ops" and "GTM Automation" niches — profile fetched once, attached to both |
| D06 | Competitor pricing tier data | 2 | 5 | 4 | **CROSS-NICHE** | EUR 2,300/mo for SyncGTM managed is the same number regardless of which niche references it; update on detect |
| D07 | Competitor tech stack data | 2 | 5 | 3 | **CROSS-NICHE** | A vendor's tool stack (Claude Code, n8n, etc.) is the same across all niches they operate in |
| D08 | Niche-specific competitor gaps | 4 | 3 | 2 | **NICHE-SHARED** | Gap analysis is shaped by niche lens, but raw gap evidence may overlap (e.g., "no proprietary data moat" is universal) |
| D09 | Buyer language patterns | 3 | 4 | 2 | **CROSS-NICHE** | "I need to show ROI before my boss approves" spans niches; industry-specific jargon is NICHE |
| D10 | Signal detection feasibility | 2 | 4 | 2 | **CROSS-NICHE** | "LinkedIn profile changes are observable via Firecrawl" — same detection method, any niche |
| D11 | API/tool feasibility findings | 1 | 5 | 3 | **CROSS-NICHE** | "DataForSEO Labs API can find competitors for any keyword" — universal finding; a tool's rate-limit or pricing applies across all niches |
| D12 | MCP server capabilities | 1 | 5 | 2 | **CROSS-NICHE** | An MCP server's schema, auth method, and data freshness apply universally |
| D13 | Pricing benchmarks (leakage rates, churn rates) | 3 | 4 | 3 | **CROSS-NICHE** | "Average churn for B2B SaaS is 5-7%/mo" is cross-niche; "Bullhorn staffing churn is 12%/yr" is niche-specific |
| D14 | Conversion rate benchmarks | 3 | 4 | 3 | **CROSS-NICHE** | Same logic as D13 — generic benchmarks are shared; niche-specific conversion rates are per-niche |
| D15 | Firecrawl search/source results | 4 | 2 | 5 | **BORDERLINE** | Raw search results are niche-specific by query, but the URLs discovered may overlap across niches (archive.org, Crunchbase) |
| D16 | Scraped page content (raw) | 4 | 1 | 4 | **NICHE** | High niche-specificity + high staleness risk (pages change); store as source evidence per-niche |
| D17 | DataForSEO SERP results | 4 | 1 | 5 | **NICHE** | SERP results are query-specific and change hourly; re-fetch per niche |
| D18 | DataForSEO domain intersection results | 2 | 4 | 4 | **CROSS-NICHE** | Overlapping competitors between niches — one Labs query serves both |
| D19 | Keyword search volume data | 3 | 3 | 4 | **NICHE-SHARED** | Niche-specific keywords yield niche volumes, but the methodology (which keywords, what CPC) is shareable |
| D20 | Free diagnostic snapshots (output) | 5 | 1 | 3 | **NICHE** | The "one number" diagnostic is unique to each niche — "you leak EUR 412K/yr" for staffing vs. "you have EUR 89K in orphaned renewals" for SaaS |
| D21 | Canvas/offer scores | 5 | 1 | 2 | **NICHE** | Each niche gets its own scored offer canvas; no cross-niche reuse |
| D22 | Hypothesis about buyer triggers | 4 | 2 | 3 | **NICHE-SHARED** | "Quarter-end renewal" is a universal trigger; "visa expiry cycle" is staffing-specific |
| D23 | Market sizing estimates | 4 | 2 | 3 | **NICHE** | Total addressable market differs per niche; methodology for sizing is shareable |

### 1.3 Summary Totals

| Classification | Count | Data Types |
|---|---|---|
| **NICHE (re-fetch each)** | 8 | D01, D03, D16, D17, D20, D21, D23, D15 |
| **CROSS-NICHE (shared)** | 11 | D02, D04, D05, D06, D07, D09, D10, D11, D12, D13, D14, D18 |
| **NICHE-SHARED (partial)** | 3 | D08, D19, D22 |

### 1.4 Staleness-Driven Refresh Rules

| Data Type | Cache TTL | Refresh Trigger |
|---|---|---|
| Company registry data | 90 days | Niche start (check freshness) |
| Competitor profiles | 30 days | Same competitor encountered in a new niche |
| Competitor pricing | 7 days | Any niche evaluation starts (re-price-check) |
| MCP server capabilities | 30 days | Session start |
| API feasibility findings | 60 days | Agent encounters a new endpoint / rate limit |
| Generic B2B benchmarks | 90 days | Update when a niche produces fresh benchmark data |
| Buyer language patterns | 60 days | Accumulate, don't replace; deduplicate on session start |
| Signal detection patterns | 90 days | When a detection fails for a new niche (potential staleness) |

---

## 2. SHARING MECHANISM

### 2.1 Architecture: Shared Memory via Registry-Identified Filesystem

The sharing mechanism uses a **registry-identified filesystem convention**, not a database or pub/sub bus. Rationale:
- Zero infrastructure dependencies (no Redis, no Postgres, no Pub/Sub broker)
- Fully visible to any Claude Code agent (reads YAML/JSON files)
- Works with git for traceability
- Survives session restarts (filesystem is durable)
- Compatible with all 65+ MCP servers (they read/write files)

#### 2.1.1 Directory Structure

```
research/25-niches/
  SHARED/                              # Cross-niche shared data
    _REGISTRY.yaml                     # Master index: what exists, where, for which niches
    competitor-profiles/               # D05 — one file per vendor
      syncgtm-v1.yaml                  # Profile, pricing, tech stack
      trigify-v1.yaml
      lonescale-v1.yaml
      ...
    b2b-benchmarks/                    # D13 — accumulated benchmarks
      churn-rates.yaml
      leakage-rates.json
      conversion-baselines.yaml
    api-feasibility/                   # D11 — tool/API evaluations
      dataforseo-feasibility-v1.yaml
      firecrawl-feasibility-v1.yaml
    buyer-language-patterns/           # D09 — shared language
      generic-b2b-patterns.yaml        # Cross-niche buyer language
      persona-maps/                    # Buyer persona definitions
    signal-patterns/                   # D10 — detection patterns
      linkedin-signal-detection.yaml
      crunchbase-company-changes.yaml
      g2-review-changes.yaml
    mcp-capability-index/              # D12 — MCP server registry
      mcp-server-registry.yaml
    data-traceability/                 # D04 — cross-reference ledger
      url-index.json                   # Deduplicated URL storage
      source-cache/
        f084a2e6-7d1b-4a3c-9e8f-...   # Raw fetch outputs by content-hash ID

  CALIBRATION/                         # Calibration niche (first)
    _MANIFEST.yaml                     # What data was produced, where it fed SHARED
    companies/
    pain-quotes/
    gap-analysis/
    canvas.yaml                        # Completed offer canvas
    signal-feasibility/

  NICHE-01/                            # Priority order numbered
  NICHE-02/
  ...
  NICHE-24/
```

#### 2.1.2 The Registry (Master Index)

The `_REGISTRY.yaml` file is THE discovery mechanism. Every agent checks the registry before starting work. The registry contains:

```yaml
# research/25-niches/SHARED/_REGISTRY.yaml
meta:
  version: 1.0
  updated: 2026-07-23
  note: >
    Master index for cross-niche shared data. Agents MUST check this file
    before fetching any data themselves. If a resource exists here, consume it.
    If a resource is stale (per cache-TTL in registry entry), flag for refresh.

competitor_profiles:
  syncgtm:
    path: competitor-profiles/syncgtm-v1.yaml
    source_niches: [CALIBRATION, NICHE-03, NICHE-07]
    cover_vendors: [SyncGTM]
    fetched: 2026-07-22
    ttl_days: 30
    stale_at: 2026-08-21
    status: FRESH
    claimed_by: agent-03  # Last agent to verify freshness
    content_hash: sha256:a1b2c3d4...
    
  trigify:
    path: competitor-profiles/trigify-v1.yaml
    source_niches: [CALIBRATION]
    status: FRESH

b2b_benchmarks:
  churn_rates_b2b_saas:
    path: b2b-benchmarks/churn-rates.yaml#b2b_saas_monthly
    source: calibration-niche
    value: 5-7%/month
    confidence: MEDIUM
    sample_size: 3 vendors
    
  leakage_recovery_rate:
    path: b2b-benchmarks/leakage-rates.json#recovery_rate
    source: calibration-niche
    value: 60-75%
    confidence: LOW
    note: Based on 2 vendor claims, unverified

api_feasibility:
  dataforseo_labs_domain_intersection:
    path: api-feasibility/dataforseo-feasibility-v1.yaml
    works_for: [D05 competitor discovery, D18 overlap analysis]
    confirmed_limits: [2,000 req/min, $50 balance threshold]
    blocked_domains: [linkedin.com]
    cost_per_query: $0.0012
    
mcp_servers:
  context7_mcp:
    path: mcp-capability-index/mcp-server-registry.yaml#context7
    capabilities: [company-research, product-research, funding-data]
    auth: none (local)
    rate_limits: not published
```

### 2.2 Discovery Protocol (How Agent N discovers shared data)

The protocol is a 5-step discovery-consumption-publish cycle:

```
STEP 1: QUERY THE REGISTRY
  Agent N starts work on niche N.
  Before any fetch operation, Agent N opens SHARED/_REGISTRY.yaml.
  For each data type needed (competitor profiles, benchmarks, API feasibility...),
  Agent N checks if the registry has a matching entry.

STEP 2: CONSUME IF FRESH
  If the entry exists AND status is FRESH (not stale):
    - Agent N reads the file at the path specified in the registry
    - Agent N appends its own niche ID to `source_niches` list
    - Agent N does NOT re-fetch this data

STEP 3: REFRESH IF STALE
  If the entry exists but is STALE (current date > stale_at):
    - Agent N re-fetches the data
    - Updates the registry entry: fetched date, stale_at, content_hash
    - Agent N may skip if the data is low-priority for this niche (logged)

STEP 4: PUBLISH NEW
  If the entry does NOT exist:
    - Agent N fetches the data
    - Writes the file to the appropriate subdirectory in SHARED/
    - Creates a registry entry with source_niches: [niche-N]
    - Sets TTL per the refresh rules in §1.4

STEP 5: PUBLISH NICHE-SPECIFIC FINDINGS
  Agent N writes niche-specific data to its own directory (NICHE-N/).
  For each piece of data discovered that could be cross-niche:
    - Adds a `shared_relevance` annotation in the niche MANIFEST
    - If strong cross-niche relevance: also writes to SHARED/ and updates registry
```

### 2.3 Overlap Detection: How Agent 7 Discovers Agent 3 Already Fetched Data

When Agent 7 evaluates niche 7 ("Mid-Market Digital Agencies on HubSpot"), and Agent 3 already fetched competitor data for "HubSpot CRM," the discovery proceeds:

```
1. Agent 7 reads SHARED/_REGISTRY.yaml
2. Agent 7 searches registry for keywords: [hubspot, crm, digital-agency]
3. Registry shows:
     - competitor_profiles/ triggers a match if any competitor profile lists "HubSpot" integration
     - The `covered_vendors` field in competitor profiles is searchable
     - Each competitor profile has a `tags` field: [hubspot-crm, sales-enablement, ...]
4. Agent 7 finds: competitor profile for "Hello Growth CRM" has a HubSpot integration
   and is already in SHARED/competitor-profiles/
5. Agent 7 consumes it without re-fetching
6. Agent 7 appends NICHE-07 to that profile's source_niches
```

**To make this work, every competitor profile MUST contain:**

```yaml
meta:
  vendor_name: Hello Growth CRM
  vendor_id: hello-growth-crm
  tags:
    - hubspot-crm-integration
    - revenue-intelligence
    - managed-service
    - benelux
  source_niches:
    - CALIBRATION
    - NICHE-03  # Added by Agent 3
  niches_this_applies_to:
    - description: "Any niche where HubSpot CRM is the central system"
      match_criteria: ["hubspot", "hubspot-crm", "crm-data-quality"]
```

### 2.4 Shared Data Consumption Contract

Every shared data file must follow this contract:

```yaml
# Required fields for ALL shared data files
meta:
  content_hash: sha256:<hex>       # Hash of content (not including meta fields)
  created: 2026-07-22
  source_niches: [CALIBRATION, ...]  # Which niches have consumed/verified this
  source_urls:                       # Where the raw data came from (traceability)
    - url: https://syncgtm.com/pricing
      fetched_by: agent-03
      fetched_at: 2026-07-22
      method: firecrawl-scrape
    - url: https://syncgtm.com/features
      fetched_by: agent-03
      fetched_at: 2026-07-22
      method: firecrawl-scrape
  confidence: HIGH | MEDIUM | LOW   # Evidence quality
  verified_by: [agent-03, agent-07] # Agents that have corroborated
  stale_at: 2026-08-21
```

---

## 3. MCP INTEGRATION PATTERN

### 3.1 MCP Server Classification by Data Type

| MCP Server Category | Data Types | Used By | Sharing Pattern |
|---|---|---|---|
| **Context7** | Company research, product research, funding data | All niche agents | Output written to SHARED/competitor-profiles/ |
| **Firecrawl** | Web scraping, search, company directories, competitive intel, lead gen | All niche agents | Scraped content cached by URL + content-hash; search results are niche-specific (D15) |
| **DataForSEO MCP** | SERP data, keyword research, domain intersection | Niche agents + cross-niche discoverer | Domain intersection results shared; SERP data is niche-specific |
| **Registry-lookup MCP** | Company registry lookups | All niche agents | Results cached by company ID in SHARED/ |
| **Derrick / Enrich.so** | People/contact data | Lead gen agents | Per-lookup; minimal sharing (contacts are lead-specific) |
| **Other MCPs (65+)** | Various | Per-MCP mapping | Follow same pattern: output cached, indexed in registry |

### 3.2 MCP Integration into Agent Workflow

```
┌─────────────────────────────────────────────────────────────────────┐
│                     NICHE EVALUATION PIPELINE                       │
│                        (per niche agent)                            │
└─────────────────────────────────────────────────────────────────────┘
                                    │
         ┌──────────────────────────▼──────────────────────────┐
         │                 1. DISCOVERY PHASE                   │
         │  Query SHARED/_REGISTRY.yaml first                   │
         │  For each data type needed: check registry →         │
         │    if FRESH: consume (skip MCP call)                 │
         │    if STALE or MISSING: proceed to MCP fetch         │
         └──────────────────────────┬──────────────────────────┘
                                    │
              ┌─────────────────────┼─────────────────────┐
              │                     │                     │
              ▼                     ▼                     ▼
   ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
   │  COMPANY FETCH    │  │  COMPETITOR      │  │  MARKET SIZING   │
   │                   │  │  DISCOVERY       │  │                  │
   │ MCP: Firecrawl    │  │ MCP: DataForSEO  │  │ MCP: DataForSEO  │
   │      Registry-l   │  │      Firecrawl   │  │      Firecrawl   │
   │      Context7     │  │      Context7     │  │      Context7    │
   └────────┬─────────┘  └────────┬─────────┘  └────────┬─────────┘
            │                     │                     │
            ▼                     ▼                     ▼
   ┌──────────────────────────────────────────────────────────────┐
   │                  MCP OUTPUT CACHE LAYER                       │
   │                                                               │
   │  For each MCP result:                                         │
   │    1. Compute content_hash (SHA256 of the raw output)         │
   │    2. Check url-index.json for existing hash                  │
   │    3. If EXISTS: skip storage (deduplication)                 │
   │    4. If NEW: write to SHARED/data-traceability/source-cache/ │
   │       filename = <content_hash>.json                          │
   │    5. Update url-index.json with: url → content_hash mapping  │
   │                                                               │
   │  This is the canonical record of "raw data was fetched once"  │
   └──────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
   ┌──────────────────────────────────────────────────────────────┐
   │                  ANALYSIS + SYNTHESIS                         │
   │                                                               │
   │  Agent reads cached MCP outputs, extracts:                   │
   │    - Competitor data → SHARED/competitor-profiles/            │
   │    - Pricing data → SHARED/competitor-profiles/ (embedded)    │
   │    - Pain quotes → NICHE-N/pain-quotes/                       │
   │    - Company lists → NICHE-N/companies/                       │
   │    - Benchmarks → SHARED/b2b-benchmarks/ (accumulate)        │
   │                                                               │
   │  Every claim in the output references:                        │
   │    trace_id: <content_hash> → original raw data               │
   └──────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
   ┌──────────────────────────────────────────────────────────────┐
   │                  PUBLISH + UPDATE REGISTRY                    │
   │                                                               │
   │  Update SHARED/_REGISTRY.yaml with any new or refreshed       │
   │  entries. Update source_niches lists for consumed entries.    │
   │  Write NICHE-N/_MANIFEST.yaml with full inventory.            │
   └──────────────────────────────────────────────────────────────┘
```

### 3.3 MCP Access Conflict Prevention

When multiple agents share MCP server access, conflicts arise from:
- **Rate limits** (DataForSEO: 2,000 req/min, 30 concurrent)
- **Credit depletion** (Firecrawl: 100K shared across all agents)
- **Race conditions** (two agents fetching same URL simultaneously)

Resolution:

| Conflict | Prevention Strategy |
|---|---|
| **Rate limit exhaustion** | Each agent registers estimated MCP calls in a `mcp-schedule.json` before starting. The schedule reserves capacity per agent. If insufficient, agents queue. |
| **Credit depletion** | Agents use a shared counter (`firecrawl-credits-used` file, updated atomically per scrape). The counter has a soft-limit (90% of 100K = 90K) at which agents switch to free APIs. |
| **Duplicate URL fetches** | The `url-index.json` cache layer (see §4.3) is checked BEFORE any fetch. If the URL + staleness window is fresh, the cached result is used. Only one agent performs the fetch. |
| **Simultaneous writes to SHARED/** | Each shared file has a `lock` field in the registry. An agent sets `lock: agent-N` before writing, clears it after. Other agents skip locked files. Retry after 60s. |

### 3.4 MCP Credit Budget Per Niche

Based on ~500 total lookups across 25 niches, per-niche budget:

| MCP / API | Per-Niche Budget | 25-Niche Total | Strategy |
|---|---|---|---|
| Firecrawl searches | 8 searches | 200 | Competitor discovery + market sizing |
| Firecrawl scrapes | 12 scrapes | 300 | Pricing pages, about pages, VOC sources |
| DataForSEO SERP | 10 queries | 250 | Competition landscape, keyword discovery |
| DataForSEO Labs | 3 domain intersections | 75 | Cross-niche competitor overlap |
| Registry-lookup | 10 lookups | 250 | Company verification |
| Context7 | 5 lookups | 125 | Company deep-dives |
| Free APIs | 20 lookups | 500 | Wikidata, GLEIF, etc. |

**Shared data reduces this by ~40% after the calibration niche** — the calibration niche pays the full cost; subsequent niches consume shared data and only pay for niche-specific fetches.

---

## 4. TRACEABILITY CONTRACT

### 4.1 The Problem

When Agent 7 completes the canvas for niche 7, how does a quality auditor trace every `[E]` (evidenced) claim back to the original fetched data? The traceability contract defines the standard.

### 4.2 Traceability Chain

```
                          TRACEABILITY CHAIN
                          
 ┌─────────────┐     ┌──────────────┐     ┌───────────────┐     ┌───────────┐
 │ CANVAS      │     │ NICHE-N/     │     │ SHARED/       │     │ Original  │
 │ CLAIM       │────▶│ evidence/    │────▶│ traceability/ │────▶│ Source    │
 │             │     │              │     │               │     │           │
 │ "SyncGTM    │     │ trace-map    │     │ url-index     │     │ syncgtm   │
 │ charges     │     │ .yaml        │     │ .json         │     │ .com/     │
 │ EUR 2,300   │     │              │     │               │     │ pricing   │
 │ /mo" [E]    │     │ claim-01:    │     │ url →         │     │           │
 └─────────────┘     │   text: ...  │     │ content-hash  │     │ HTML      │
       │             │   trace_id:  │     │               │     │ snapshot  │
       │             │   f084a2e6   │────▶│ f084a2e6 →    │────▶│ (raw)     │
       ▼             │   method:    │     │ /source-cache │     └───────────┘
 ┌─────────────┐     │     scrape   │     │ /f084a2e6.json│
 │ CANVAS      │     │   url: ...   │     └───────────────┘
 │ FIELD       │     │   confidence │
 │             │     │ : HIGH       │
 │ price:      │     │   verified_by│
 │ EUR 2,300   │     │ : [agent-07] │
 │ basis:      │     └──────────────┘
 │ managed-    │
 │ full-conj   │
 └─────────────┘
```

### 4.3 The Source Cache

All raw MCP/scraper output is stored in a content-addressed cache:

```
SHARED/data-traceability/
  source-cache/
    f084a2e6-7d1b-4a3c-9e8f-0a1b2c3d4e5f.json    # Raw scrape output
    2c4e8f09-a1b2-4c3d-8e7f-6a5b4c3d2e1f.json     # Another scrape
    9a8b7c6d-5e4f-4a3b-2c1d-0e9f8a7b6c5d.json     # API response
  url-index.json                                    # URL → content-hash mapping
  content-hash-index.json                           # content-hash → metadata
```

**`url-index.json` schema:**
```json
{
  "https://syncgtm.com/pricing": {
    "content_hash": "f084a2e6-7d1b-4a3c-9e8f-0a1b2c3d4e5f",
    "first_fetched": "2026-07-22T14:30:00Z",
    "last_fetched": "2026-07-22T14:30:00Z",
    "fetch_count": 1,
    "fetched_by": ["agent-03"],
    "method": "firecrawl-scrape",
    "http_status": 200,
    "content_type": "text/html",
    "stale_at": "2026-07-29T14:30:00Z"
  }
}
```

**`content-hash-index.json` schema:**
```json
{
  "f084a2e6-7d1b-4a3c-9e8f-0a1b2c3d4e5f": {
    "file_name": "source-cache/f084a2e6....json",
    "size_bytes": 45231,
    "content_type": "text/html",
    "sha256": "f084a2e6...",
    "claimed_evidence_for": [
      {"niche": "CALIBRATION", "claim_id": "claim-01"},
      {"niche": "NICHE-07", "claim_id": "claim-14"}
    ]
  }
}
```

### 4.4 Canvas Trace Map

Each niche directory contains an `evidence/trace-map.yaml` that links every `[E]` claim in the canvas back to the source cache.

```yaml
# NICHE-07/evidence/trace-map.yaml
meta:
  niche_id: NICHE-07
  niche_name: "Mid-Market Digital Agencies on HubSpot"
  canvas_version: 1.0
  completed_by_agent: agent-07
  completed_at: 2026-07-30

claims:
  - claim_id: claim-01
    canvas_section: "competitor_analysis"
    canvas_field: "price"
    canvas_offer_id: "revenue-leakage-recovery"
    text: "SyncGTM charges EUR 2,300/mo for the managed full-conjunction service"
    evidence_level: E
    trace_id: f084a2e6-7d1b-4a3c-9e8f-0a1b2c3d4e5f
    trace_url: https://syncgtm.com/pricing
    trace_method: firecrawl-scrape
    trace_timestamp: 2026-07-22T14:30:00Z
    confidence: HIGH
    verified_by: [agent-07]
    quoted_text: "Fractional GTMe — EUR 2,300/month — includes signal detection + enrichment + CRM-native delivery"
    
  - claim_id: claim-02
    canvas_section: "buyer_language"
    canvas_offer_id: "revenue-leakage-recovery"
    text: "Agency owners express frustration with 'hidden revenue leakage' in CRM data"
    evidence_level: E
    trace_ids:
      - 9a8b7c6d-5e4f-4a3b-2c1d-0e9f8a7b6c5d  # Reddit post
      - 2c4e8f09-a1b2-4c3d-8e7f-6a5b4c3d2e1f  # G2 review
    trace_urls:
      - https://reddit.com/r/hubspot/comments/...
      - https://g2.com/products/syncgtm/reviews
    trace_methods:
      - firecrawl-search
      - firecrawl-scrape
    confidence: MEDIUM
    qualified_text: "Must understand: this frustration is about CRM DATA QUALITY, not revenue leakage per se — agencies own the pipeline but not the CRM hygiene"
    
  - claim_id: claim-03
    canvas_section: "market_sizing"
    text: "There are approximately 8,500 mid-market digital agencies using HubSpot in the US"
    evidence_level: H  # Hypothesis
    trace_id: null
    trace_url: null
    confidence: LOW
    rationale: "Estimated from HubSpot partner directory (3,200 Solutions Partners) × ~2.7 agencies/partner ≈ 8,640. Not independently verified."
```

### 4.5 Quality Audit Procedure

To verify a canvas claim:

```
1. Read the canvas → identify the [E] claim and its claim_id
2. Read NICHE-N/evidence/trace-map.yaml → find the claim_id entry
3. Extract trace_id → look up in SHARED/data-traceability/content-hash-index.json
4. Extract file_name → SHARED/data-traceability/source-cache/{trace_id}.json
5. Read the cached source → find the exact quoted_text or supporting data
6. The source contains the original URL, fetch timestamp, method, and raw content
7. VERIFY: does the raw source actually support the claim?
   - YES → evidence confirmed
   - NO → evidence contested, mark for review
   - QUOTE OUT OF CONTEXT → flag as misleading citation
```

### 4.6 Evidence Classification

| Code | Meaning | Traceability Required |
|---|---|---|
| `[E]` | Evidenced — direct quote or data from a verifiable source | trace_id + url + quoted_text required |
| `[D]` | Derived — inferred from multiple corroborating sources | trace_ids (plural) + reasoning_inference field |
| `[H]` | Hypothesis — reasoned belief without direct evidence | rationale field required; trace_id may be null |
| `[C]` | Claim from founder/owner (Bob, Adriaan, Wesley) | source_person required; `method: founder-claim` |

---

## 5. SHARED BENCHMARK DATABASE DESIGN

### 5.1 Purpose

As niches are evaluated, ClarityRev accumulates proprietary benchmarks — leakage rates, churn rates, conversion rates by niche. These benchmarks:
1. **Seed the moat** (the compounding cross-client benchmark from §9 of the context pack)
2. **Make subsequent niche evaluations cheaper** (benchmark discovered in NICHE-01 is available to NICHE-02)
3. **Enable the free diagnostic** (the one-number principle — "you leak 2.3x the median")
4. **Power the sales process** (benchmarks sell: "companies like yours lose EUR X/yr")

### 5.2 Schema

```yaml
# SHARED/b2b-benchmarks/_BENCHMARK_DATABASE.yaml
meta:
  version: 1.1
  last_updated: 2026-07-30
  total_benchmarks: 47
  source_niches: [CALIBRATION, NICHE-01, NICHE-03, NICHE-07]
  staleness_policy: |
    Each benchmark has a TTL based on its volatility.
    When TTL expires, the NEXT agent that needs it triggers a refresh.

benchmarks:
  - id: churn_b2b_saas_monthly
    category: churn_rate
    niche_applicability:
      - NICHE-01  # Direct match
      - NICHE-07  # Shares buyer persona
      - NICHE-12  # Same CRM ecosystem
      - ALL_B2B   # Applicable as generic baseline
    name: "B2B SaaS Monthly Churn Rate"
    value_range: [5, 7]  # 5-7%
    unit: percent_per_month
    confidence: HIGH
    sample_size: 12
    source_urls:
      - url: https://g2.com/categories/crm/reviews
        trace_id: a1b2c3...
    derived_from_niches: [CALIBRATION, NICHE-01]
    methodology: "Median of reported churn rates from G2 reviews + vendor pricing pages"
    first_detected: 2026-07-22
    last_verified: 2026-07-28
    stale_at: 2026-10-28
    refresh_strategy: "Re-check every 90 days or when a new niche in the same category starts"

  - id: leakage_bullhorn_staffing
    category: revenue_leakage_rate
    niche_applicability:
      - NICHE-14  # Bullhorn staffing
    name: "Revenue Leakage Rate — Bullhorn Staffing Agencies"
    value_range: [12, 18]  # 12-18% of revenue
    unit: percent_of_revenue
    confidence: MEDIUM
    sample_size: 3
    source_niches: [NICHE-14]
    source_urls:
      - url: https://bullhorn.com/resources/whitepaper/staffing-metrics
        trace_id: d4e5f6...
    methodology: "Calculated from redeployment gap data in niche 14 audit"
    first_detected: 2026-08-01
    last_verified: 2026-08-01
    stale_at: 2026-11-01
    refresh_strategy: "Niche 14 re-audit or new staffing niche"

  - id: conversion_diagnostic_to_paid
    category: conversion_rate
    niche_applicability: [ALL_B2B]
    name: "Free Diagnostic → Paid Pilot Conversion Rate"
    value_range: [8, 15]  # 8-15%
    unit: percent
    confidence: LOW
    sample_size: 0
    source_niches: []
    methodology: "No data yet — placeholder. Expect 8-15% based on B2B SaaS diagnostic benchmarks"
    first_detected: 2026-07-22
    stale_at: 2026-12-31
    refresh_strategy: "First verified from actual ClarityRev pipeline data; update as real data arrives"

  - id: leakage_recovery_rate_managed
    category: recovery_rate
    niche_applicability: [ALL_B2B]
    name: "Managed Revenue Leakage Recovery Rate"
    value_range: [60, 80]
    unit: percent_of_leakage
    confidence: LOW
    sample_size: 0
    source_niches: []
    methodology: "Industry benchmark from competitor claims. Verify with first 5 clients."
    first_detected: 2026-07-22
    stale_at: 2026-12-31
    refresh_strategy: "Update after first 3 client engagements"
```

### 5.3 Update Pattern

```
NEW BENCHMARK DISCOVERED:
  1. Agent N identifies a numeric claim in its niche evaluation
     (e.g., "Staffing agencies report 12-18% revenue leakage from unredeployed contractors")
  2. Agent N checks SHARED/b2b-benchmarks/_BENCHMARK_DATABASE.yaml for existing entry
  3. If EXISTS: 
     - Compare value ranges
     - If overlapping within ±20%: confidence += 1, append source_niche
     - If conflicting: add as variant entry with notes
  4. If NOT EXISTS:
     - Create new benchmark entry
     - Set confidence based on evidence quality (1 source = LOW, 3+ sources = MEDIUM, 5+ with independent verification = HIGH)
     - Set stale_at based on volatility (pricing: 30d; churn: 90d; conversion: 180d)
  5. Append trace_id linking back to the source cache

BENCHMARK USAGE:
  When Agent M needs a benchmark for their niche:
    1. Query _BENCHMARK_DATABASE.yaml
    2. Filter by niche_applicability matching current niche or ALL_B2B
    3. If multiple entries match: prefer higher confidence, then more recent, then niche-specific over generic
    4. If no match: note as "NO_BENCHMARK" in the canvas; flag as knowledge gap
```

### 5.4 Niche Applicability Resolution

Benchmarks carry a `niche_applicability` field that can reference specific niches or use tags:

```yaml
niche_applicability:
  # Direct match — same niche
  - NICHE-01
  
  # Cross-niche — applicable to any niche in the same category cluster
  - tag: hubspot-ecosystem          # All niches involving HubSpot CRM
  - tag: staffing                   # All staffing/ATS-related niches
  - tag: mid-market-b2b-saas        # All mid-market B2B SaaS niches
  
  # Universal — applies everywhere
  - ALL_B2B
  
  # Conditional — applicable only if condition met
  - condition: buyer_persona == "head-of-revops"
    niches: [NICHE-01, NICHE-07, NICHE-14]
```

### 5.5 Discovery Method for Subsequent Agents

```
Agent N starts niche N

  ↓
  
Query _BENCHMARK_DATABASE.yaml with current niche's:
  - niche_id (NICHE-N)
  - category tags (from the niche taxonomy)
  - buyer persona tags
  - CRM/system tags

  ↓
  
Results → agent receives:
  - All benchmarks with direct NICHE-N match
  - All benchmarks with tag overlap (hubspot-ecosystem, staffing, etc.)
  - All ALL_B2B benchmarks
  - All benchmarks with matching condition

  ↓
  
Agent N loads these into its context as "pre-existing cross-niche evidence"
These inform [E] and [D] claims without requiring new fetches
```

---

## 6. ADVERSARIAL VERDICT

### Would this lens sign off?

**Verdict: SIGN-OFF WITH CONDITIONS**

#### What passes:

1. **Classification Matrix (pass)** — The D01-D23 matrix is comprehensive, covers all expected data types, and provides clear rules for when to share vs. re-fetch. The staleness-driven refresh rules prevent agents from using dangerously stale data. The summary totals show the right balance: ~46% of data types are cross-niche reusable, which means the calibration niche pays a premium but subsequent niches save ~40% of fetch costs.

2. **Sharing Mechanism (pass)** — The registry-identified filesystem approach is infrastructure-free, fully visible to agents, and git-compatible. The 5-step discovery protocol (query→consume→refresh→publish→annotate) is concrete and executable. The overlap detection protocol ("how Agent 7 finds Agent 3's HubSpot data") is well-defined with searchable tags.

3. **MCP Integration Pattern (pass)** — The data-type-to-MCP-server mapping is clear. The conflict prevention strategies (rate limit scheduling, credit counters, URL deduplication cache, file locking) address the real failure modes experienced in prior phases (G-023, G-026). The credit budget per niche is realistic.

4. **Traceability Contract (pass)** — The 4-level chain (canvas claim → trace-map → url-index → source cache) is traced end-to-end. The content-addressed source cache with SHA256 deduplication means each URL is fetched at most once per staleness window — critical for Firecrawl credit conservation. The evidence classification `[E]`/`[D]`/`[H]`/`[C]` maps directly to the existing Phase 5 GSO system.

5. **Shared Benchmark Database (pass)** — The schema covers value ranges, confidence, sample size, methodology, and source traces. The niche applicability resolution (direct match → tag match → ALL_B2B → conditional) is pragmatic. The update pattern (new discovery → check existing → merge or create) prevents duplication.

#### Conditions (must be addressed before sign-off):

1. **The Registry is a single-point-of-failure for discovery.** If an agent fails to update the registry after publishing data, other agents will never discover it. **Fix:** Add an automated registry consistency check after each niche completes. A verification agent reads the filesystem and cross-references against the registry, flagging any orphaned data.

2. **Content-addressed cache needs a cleanup/archival policy.** After 25 niches, the source-cache will hold hundreds of raw HTML snapshots. **Requirement:** Add a `max_age_days: 365` field to each source entry; entries beyond max_age are soft-deleted (moved to an archive directory, not destroyed). Archive when the evaluation hits niche 20.

3. **The `lock` field in the registry is advisory, not enforceable.** Claude Code agents can ignore it. **Fix:** Make the lock a convention enforced by the protocol, not a technical solution. Add an `unlock_after_minutes: 5` field so a locked entry auto-recovers if the locking agent crashes. Document that agents MUST check and respect locks before writing.

4. **No mechanism for handling conflicting evidence across agents.** If Agent 3 reports SyncGTM charges EUR 2,300/mo but Agent 7's more recent scrape shows EUR 2,500/mo, who wins? **Fix:** Add a `conflict_resolution` section to each shared data file:
   ```yaml
   conflict_resolution:
     - conflicting_value: EUR 2,500/mo
       source_niche: NICHE-07
       source_url: https://syncgtm.com/pricing
       detection_date: 2026-08-15
       resolution: LATEST_WINS  # or: FLAG_FOR_REVIEW, MANUAL_VETTING
       resolved_by: RULE
   ```

5. **Benchmark database lacks a deprecation mechanism.** A benchmark that was valid during CALIBRATION may be invalidated by later data. **Fix:** Add `status: ACTIVE | SUPERSEDED | INCONCLUSIVE` to every benchmark, and when a new entry conflicts with an old one, set the old one to SUPERSEDED with `superseded_by: <new-id>`.

6. **The 40% savings estimate after calibration needs empirical verification.** This is a design-time estimate, not a measured value. **Requirement:** After the first 3-5 niches, compute actual savings (total MCP calls made / total calls that would have been made without sharing) and update the estimate. If savings <20%, the sharing mechanism is not earning its complexity budget and should be simplified.

#### Final ruling:

**SIGN-OFF** — the architecture is sound, addressable, and aligns with the project's existing data conventions (YAML-based, filesystem-natural, git-traceable). The 6 conditions above are implementation requirements, not architecture failures. The design correctly avoids over-engineering (no database, no pub/sub, no container orchestration) while providing enough structure that 25 agents working independently can share data without coordination overhead.

The most important risk to monitor is **registry discipline** (condition 1) — if agents stop updating the registry, the entire sharing mechanism degrades to "every agent fetches everything independently," which wastes credits and time. Automating the registry check after each niche is the single highest-leverage implementation step.

---

## Appendices

### A. Niche Evaluation Checklist (per agent)

```
□ Read SHARED/_REGISTRY.yaml
□ For each needed data type:
  □ Check registry for existing entry
  □ If FRESH: consume (record in manifest)
  □ If STALE: re-fetch, update registry
  □ If MISSING: fetch, publish to SHARED/, update registry
□ Execute niche-specific fetches (company lists, pain quotes)
□ Analyze data → fill canvas (with trace_ids for every [E] claim)
□ Write NICHE-N/evidence/trace-map.yaml
□ Update SHARED/b2b-benchmarks/_BENCHMARK_DATABASE.yaml with new benchmarks
□ Update SHARED/_REGISTRY.yaml (append source_niches, update stale_at)
□ Write NICHE-N/_MANIFEST.yaml (complete inventory)
```

### B. Minimum Viable Implementation Order

1. Create directory structure + _REGISTRY.yaml skeleton
2. Build url-index.json source cache + content-addressed storage
3. Calibration niche: execute full protocol (pay the shared-data cost)
4. Run automated registry consistency check after calibration
5. NICHE-01 through NICHE-05: verify sharing mechanism works empirically
6. Measure actual vs. predicted savings after NICHE-05
7. If savings >20%: continue; if not: simplify to per-niche independent
8. Archive stale source-cache entries at NICHE-20

### C. File Naming Conventions

| Pattern | Example | Rule |
|---|---|---|
| Shared data files | `syncgtm-v1.yaml` | `{vendor-id}-v{version}.yaml` |
| Niche directories | `NICHE-01/`, `NICHE-14/` | `NICHE-{NN}/` (zero-padded, 01-25) |
| Trace source cache | `f084a2e6-....json` | UUID v4 as SHA256 content hash |
| Registry | `_REGISTRY.yaml` | Leading underscore = auto-managed |
| Manifest | `_MANIFEST.yaml` | Per-niche inventory |
| Benchmark database | `_BENCHMARK_DATABASE.yaml` | Single file, versioned |
| Url index | `url-index.json` | Single file, updated atomically |

### D. Relationship to Existing Project Architecture

This architecture extends the conventions established in ClarityRev's Phase 0-5 research:
- **YAML as the canonical format** — matches all Phase 0-5 artifacts (0b-TAXONOMY, 1b bundles, competitor profiles, etc.)
- **Content-addressed storage** — extends the `content_hash` pattern already used in 2b-VOC_RAW (hash-verified quotes)
- **Evidence tagging `[E]`/`[H]`** — maps directly to the GSO Stage C system (EVIDENCED vs HYPOTHESIS)
- **Filesystem as data layer** — matches the existing pattern (no database, no API server)
- **Traceability chain** — addresses L-022's finding that verification requires source traceability (G-008, G-015, G-017)
- **Confidence scoring** — uses the same HIGH/MEDIUM/LOW convention as the existing taxonomy and competitor templates

The key NEW convention is the **SHARED/** directory and **registry-based discovery**, which does not exist in the current architecture — but it is a natural extension, not a break from existing patterns.
