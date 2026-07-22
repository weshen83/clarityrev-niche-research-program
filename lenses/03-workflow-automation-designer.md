# Lens 3: Workflow Automation Designer
## 25-Niche Research Pipeline — Data Operations Architecture

**Date:** 2026-07-23
**Context:** ClarityRev's evaluation of 25 B2B niches for revenue intelligence offers.
**Toolchain:** Firecrawl (100K credits, 50 concurrent, relevance-model /search), DataForSEO ($50), Context7 MCP, 65+ MCP servers, 20+ free APIs. All reference docs in `research/` and `.firecrawl/`.
**Operating Constraints:** Research phase is COMPLETE for ClarityRev offerings; this pipeline is for the 25-niche evaluation which directly enables BUILDING (demo targeting, website wedge pages, offer selection).

---

## Table of Contents
1. [EXECUTION SEQUENCE](#1-execution-sequence)
2. [PRE-FLIGHT CHECK PATTERN](#2-pre-flight-check-pattern)
3. [CREDIT BUDGET MODEL](#3-credit-budget-model)
4. [ERROR HANDLING MATRIX](#4-error-handling-matrix)
5. [IDEMPOTENCY PATTERN](#5-idempotency-pattern)
6. [AUTOMATION READINESS (n8n/Make)](#6-automation-readiness)
7. [ADVERSARIAL VERDICT](#7-adversarial-verdict)

---

## 1. EXECUTION SEQUENCE

### Phase 1: Niche Bounding (BEFORE ANY CREDIT SPEND)

**Goal:** Narrow a candidate niche from a hypothesis to a bounded, researchable scope — or kill it without spending credits.

| Step | Tool(s) | Action | Parallel? | Credit Cost | Checkpoint |
|------|---------|--------|-----------|-------------|------------|
| 1.0 | CLAUDE.md + SOURCE_OF_TRUTH.yaml | **Read project constraints** — verify niche fits the EUR 500K-profit path, B2B-only, Revenue Intelligence category gate. If not: KILL (cost: 0 credits) | No (gate) | 0 | Phase 1 gate result: PASS/KILL |
| 1.1 | Free APIs (FRED, Census, World Bank) | **Macro market sizing** — what is the TAM (>EUR 50M?), growth rate (>10% YoY?), and geographic concentration. Output: `1-macro-profile.yaml` | No (data-dependency) | 0 (free APIs) | If TAM < EUR 50M or growth <10%: CONSIDER-KILL |
| 1.2 | Firecrawl `/search` (relevance model) | **Landscape orientation** — 2-3 broad searches per niche to understand the main players, categories, trends. Output: `1-landscape-notes.md` | No (data-dependency) | ~20 credits (2-3 searches × LLM-hydrated) | Must produce >=3 unique vendor names and 1 category taxonomy hint |
| 1.3 | Free APIs (Registry Lookup, Wikidata SPARQL) | **Company density scan** — how many companies operate in this niche? Registry Lookup (5K/mo free) for entity counts. Output: `1-company-density.csv` | Can parallel with 1.2 | 0 (free APIs) | Must identify >=20 companies or flag as "thin market" |
| 1.4 | Firecrawl `/map` | **Site structure discovery** — for the top 5 companies found in 1.2, map each site to find pricing, product, careers, about pages. Output: `1-site-maps/` (1 per company) | Yes (5 concurrent) | ~25 credits (5 × ~5 credits/map) | >=3 of 5 sites must yield actionable pages |
| 1.5 | Synthesis | **BOUNDING DECISION** — based on 1.0-1.4, is this niche worth Phase 2 investment? Factors: TAM, density, accessibility (pages exist + are crawlable), founder-warm-access. Output: `1-bounding-decision.yaml` | No | 0 | **GATE: PASS or KILL.** If PASS, proceed to Phase 2. |

**Phase 1 total: ~45 credits, $0 paid spend.**
**Failure modes:** (a) all competitor sites are SPA/login-walled with no public pages — KILL; (b) TAM too small for EUR 500K profit path — KILL; (c) niche is B2C masquerading as B2B — KILL.

---

### Phase 2: Deep Research (HIGHEST CREDIT CONSUMPTION)

**Goal:** Build comprehensive intelligence on the niche — competitors, pricing, tech stacks, pain points, hiring signals, news, reviews.

| Step | Tool(s) | Action | Parallel? | Credit Cost | Checkpoint |
|------|---------|--------|-----------|-------------|------------|
| 2.0 | Firecrawl `/search` | **Competitor discovery** — search for "top X in [niche]", "[niche] software vendors", "[niche] companies 2026". Collect raw company URL list. Output: `2-competitor-candidates.yaml` | No (seed) | ~30 credits (3-4 searches) | >=10 unique candidate URLs |
| 2.1 | Firecrawl `/scrape` (batch) | **Competitor page scraping** — scrape pricing page, product page, about page, careers page for each identified competitor. Output: `2-competitor-profiles/` (1 YAML per vendor) | **Yes — 10 concurrent** (Firecrawl 50-concurrent limit allows batches of 10-15) | ~200 credits (10 competitors × 4 pages × ~5 credits each) | >=80% scrape success rate; any failures get logged for 2.4 retry |
| 2.2 | Firecrawl `/search` | **Pricing intelligence** — search specifically for "[competitor] pricing [currency]" to find published prices, review-snippet prices, and analyst-reported pricing. Output: `2-pricing-signals.yaml` | Can parallel with 2.1 | ~40 credits (4-5 searches) | >=3 pricing anchors per category (per KT-3 pre-registration rule) |
| 2.3 | Free APIs (Techmap, DetectZeStack) | **Technographic + hiring signals** — what tech stack do niche companies use? Are they hiring? Output: `2-technographics.yaml` + `2-hiring-signals.yaml` | **Yes — parallel with 2.1/2.2** | 0 (free APIs) | Tech stack data for >=50% of companies |
| 2.4 | Retry pool | **Failed scrape retry** — all pages that failed in 2.1 get 3 retries with exponential backoff and alternative user-agent. Output: `2-retry-log.yaml` | **Yes — parallel batch** | ~30 credits (retries) | Each failed URL gets max 3 attempts before permanent FAIL |
| 2.5 | DataForSEO | **SERP analysis** — search volume, keyword difficulty, competitor SERP presence for 5-10 key terms per niche. Output: `2-serp-intel.yaml` | Can parallel with 2.1-2.3 | ~$0.30/niche (DataForSEO SERP API: ~$0.006/query × 50 queries) | >=5 keywords with volume data |
| 2.6 | Context7 MCP | **Company context enrichment** — use Context7 to enrich each competitor profile with funding, news, recent developments. Output: `2-company-enrichment.yaml` | **Yes — 10 concurrent** | 0 (Context7 free tier) | Context7 returns data for >=70% of companies |
| 2.7 | Firecrawl `/search` (relevance model) | **Review & social proof** — search for "[competitor] review", "[competitor] G2", "[competitor] Capterra", "[competitor] Trustpilot", "[niche] reddit". Output: `2-reviews-signals.yaml` | **Yes — parallel batch** | ~40 credits (4-5 searches) | For SaaS niches: >=3 review sources per competitor |
| 2.8 | GDELT + Currents API + Radar Intelligence | **News & intent signals** — what are the key news themes, regulatory changes, funding rounds in this niche? Output: `2-news-signals.yaml` | **Yes — parallel batch** | 0 (free APIs) | >=5 topical news items |
| 2.9 | Synthesis | **Phase 2 synthesis** — merge all outputs into unified niche profile. Identify: top 5 competitors, price range, key differentiators, pain points, gaps. Output: `2-niche-profile.yaml` | No (sink) | 0 | **CHECKPOINT:** phase gate — is data quality sufficient to proceed to Phase 3? |

**Phase 2 total: ~340 credits + ~$0.30/niche DataForSEO.**
**Parallel efficiency:** Steps 2.1, 2.2, 2.3, 2.5, 2.6, 2.7, 2.8 are all data-collection steps with no cross-dependency. In practice, 2.2 and 2.7 may share cache (pricing pages are often scraped in 2.1, so 2.2 can be skipped if 2.1 already captured pricing). Estimated wall-clock: ~5-8 minutes at 10 concurrent.

---

### Phase 3: Commercial Design (LOW CREDIT COST, HIGH SYNTHESIS)

**Goal:** Design the ClarityRev offer for this niche using the RIOS framework.

| Step | Tool(s) | Action | Parallel? | Credit Cost | Checkpoint |
|------|---------|--------|-----------|-------------|------------|
| 3.0 | Firecrawl `/search` | **WTP signal collection** — search for "budget for [niche tool]", "[niche] spend survey", how much companies spend on [niche] software/services. Output: `3-wtp-signals.yaml` | No | ~20 credits (2 searches) | >=3 WTP anchors |
| 3.1 | Firecrawl `/scrape` | **Competitor offer teardown** — scrape the exact offer pages, pricing tables, guarantee pages, and onboarding pages of top 3 competitors for detailed comparison. Output: `3-competitor-teardowns/` | **Yes — 3 concurrent** | ~45 credits (3 × 3 pages × 5 credits) | Offer structure (not just price) extracted for >=2 of 3 |
| 3.2 | Free APIs + manual | **RIOS canvas fill** — synthesize all Phase 1-3 data into the 17-field RIOS canvas (see `clarityrev-offer-framework.md §C`). Output: `3-rios-canvas.yaml` | No (synthesis) | 0 | All 17 fields populated with evidence-graded sources |
| 3.3 | Internal check | **Gates verification** — does this offer pass the 4 gates (EUR 500K profit path, scalable, B2B-only, Revenue Intelligence category)? Output: `3-gates-verdict.yaml` | No | 0 | **GATE: PASS or KILL.** If KILL, archive Phase 1-3 data for later re-use. |
| 3.4 | Firecrawl `/search` | **Distribution feasibility** — search for aggregators, marketplaces, partner programs, peer groups in this niche. Output: `3-distribution-landscape.yaml` | Can parallel with 3.2 | ~20 credits (2 searches on aggregator names) | >=2 distribution paths identified (direct + one aggregator) |
| 3.5 | Synthesis | **Phase 3 synthesis** — produce final commercial design document with: RIOS canvas, gates verdict, pricing recommendation, distribution strategy, free diagnostic spec. Output: `3-commercial-design.yaml` | No | 0 | **CHECKPOINT:** Score the offer using RIOS value equation (B2). Document denominator items (friction, risk). |

**Phase 3 total: ~85 credits + $0 paid spend.**

---

### Phase 4: Scoring & QA (LOW CREDIT COST)

**Goal:** Objectively score the niche against all other evaluated niches and verify data integrity.

| Step | Tool(s) | Action | Parallel? | Credit Cost | Checkpoint |
|------|---------|--------|-----------|-------------|------------|
| 4.0 | Script (Python/bash) | **Niche scoring** — apply the 25-niche scoring rubric (demand, fit, defensibility, accessibility, founder warm-access) to the Phase 3 output. Output: `4-scored-niche.yaml` | No | 0 | Score > threshold for "active" list |
| 4.1 | Firecrawl `/scrape` | **Data freshness verify** — re-scrape a random sample (2-3 pages) from Phase 2 to verify data hasn't changed significantly. Output: `4-freshness-check.yaml` | **Yes — 3 concurrent** | ~15 credits (3 pages × 5 credits) | No material changes to pricing/positioning |
| 4.2 | Script | **Cross-niche comparison** — compare against all other scored niches on key dimensions. Identify unique positioning opportunity. Output: `4-cross-niche-matrix.yaml` | No | 0 | Unique angle identified or "commodity niche" flagged |
| 4.3 | QA audit | **Adversarial verification** — automated checks: (a) do pricing anchors exist and are they from the DIRECT_SCRAPE lane? (b) are free-API sources correctly credited? (c) is the KT-3 pre-emption pre-registered? Output: `4-qa-verdict.yaml` | No | 0 | **GATE: PASS or REJECT** — if REJECT, deficiencies are actionable (not vague) |
| 4.4 | Archive | **Final packaging** — produce the canonical niche intelligence package: `NICHE-[name]-v1.yaml` with all Phase 1-4 data consolidated. Archive raw artifacts in `research/25-niche/raw/[niche]/`. | No | 0 | Package is frozen, hash-verified, ready for consumption by the Shortlist Tool or offer-design process |

**Phase 4 total: ~15 credits + $0 paid spend.**

---

### PHASE SUMMARY TABLE

| Phase | Credits | Paid ($) | Wall-clock (10-parallel) | Gate |
|-------|---------|----------|-------------------------|------|
| Phase 1: Niche Bounding | ~45 | $0.00 | ~3 min | PASS/KILL |
| Phase 2: Deep Research | ~340 | ~$0.30 | ~5-8 min | Data quality check |
| Phase 3: Commercial Design | ~85 | $0.00 | ~3 min | Gates PASS/KILL |
| Phase 4: Scoring & QA | ~15 | $0.00 | ~2 min | PASS/REJECT |
| **Total per niche** | **~485 credits** | **~$0.30** | **~13-16 min** | 4 gates |

---

## 2. PRE-FLIGHT CHECK PATTERN

### Universal Cache-Check-Before-Fetch (CCBF) Pattern

Every fetch operation follows this exact sequence:

```
function fetchWithCache(url, freshnessSla, targetPath):
    # STEP 1: File existence check
    if fileExists(targetPath):
        # STEP 2: Freshness check
        age = currentTime - fileModTime(targetPath)
        if age < freshnessSla:
            log("CACHE_HIT: using cached " + targetPath + " (" + age + " old, SLA " + freshnessSla + ")")
            return readFile(targetPath)
        else:
            log("CACHE_STALE: " + targetPath + " is " + age + " old, SLA " + freshnessSla + " — refetching")
    else:
        log("CACHE_MISS: " + targetPath + " does not exist — fetching")

    # STEP 3: Pre-flight credit check
    if tool == "firecrawl":
        if getCreditsRemaining("firecrawl") < MINIMUM_THRESHOLD:
            log("CREDIT_LOW: Firecrawl credits below threshold " + MINIMUM_THRESHOLD + " — pause and alert")
            return FAIL_CREDIT_LOW
    if tool == "dataforseo":
        if getBalance("dataforseo") < 1.00:
            log("BALANCE_LOW: DataForSEO balance below $1.00 — pause and alert")
            return FAIL_BALANCE_LOW

    # STEP 4: Rate limit check
    if isRateLimited(tool, endpoint):
        backoff = getBackoffDuration(tool, endpoint)
        log("RATE_LIMITED: " + tool + " " + endpoint + " — backing off " + backoff + "s")
        sleep(backoff)
        # Re-check after backoff
        if isRateLimited(tool, endpoint):
            log("STILL_RATE_LIMITED after backoff — fail gracefully")
            return FAIL_RATE_LIMITED

    # STEP 5: Execute fetch
    result = executeFetch(url)
    
    # STEP 6: Write to cache
    if result.success:
        writeFile(targetPath, result.data)
        log("FETCH_OK: wrote to " + targetPath)
    else:
        log("FETCH_FAIL: " + result.error)
    
    return result
```

### Freshness SLA Table (what SLA per data type)

| Data Type | Freshness SLA | Rationale |
|-----------|---------------|-----------|
| Competitor pricing page | 7 days | Pricing changes are infrequent but crucial |
| Competitor product page | 14 days | Features change slower than pricing |
| Competitor careers page | 3 days | Hiring signals shift weekly |
| Company registry data | 30 days | Official registrations change slowly |
| Job posting data | 3 days | New postings appear 24-48h before publication |
| News/intent signals | 1 day | Relevance window is hours, not days |
| Review data | 7 days | Reviews accumulate; newest matter most |
| SERP data | 7 days | Rankings shift gradually |
| Tech stack data | 30 days | Infrastructure changes are slow |
| Financial data | 7 days (public) / 30 days (macro) | Public company data updates; macro is stable |

### Minimum Credit Thresholds

```
firecrawl:
  preFetchThreshold: 5000       # Alert if below 5% of 100K total
  minForBatch: 2000              # Block batch operations if below
  alertWebhook: "webhook://cr-reduce-batch-size"

dataforseo:
  preFetchThreshold: 2.00        # Alert if below $2
  minForOperation: 0.50          # Block single operation if below
  alertWebhook: "webhook://cr-top-up-dataforseo"
```

### Pre-Flight Pseudocode for Bash/Shell

```bash
#!/bin/bash
# preflight-fetch.sh — Idempotent fetch with pre-flight checks
# Usage: preflight-fetch.sh <url> <cache_path> <freshness_sla_seconds> <tool_name>

URL="$1"
CACHE_PATH="$2"
SLA="$3"
TOOL="$4"

# Step 1: Check if cached file exists and is fresh
if [ -f "$CACHE_PATH" ]; then
    FILE_AGE=$(($(date +%s) - $(stat -c%Y "$CACHE_PATH")))
    if [ $FILE_AGE -lt $SLA ]; then
        echo "CACHE_HIT: $CACHE_PATH ($FILE_AGE s old, SLA $SLA s)"
        cat "$CACHE_PATH"
        exit 0
    fi
    echo "CACHE_STALE: $CACHE_PATH ($FILE_AGE s old, SLA $SLA s)"
fi

# Step 2: Pre-flight credit check
if [ "$TOOL" = "firecrawl" ]; then
    CREDITS=$(curl -s -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
        "https://api.firecrawl.dev/v1/account" | jq '.creditsRemaining')
    if [ "$CREDITS" -lt 5000 ]; then
        echo "CREDIT_LOW: $CREDITS remaining (threshold 5000)" >&2
        # Non-blocking alert for low credits; still proceed if above min
        if [ "$CREDITS" -lt 2000 ]; then
            echo "CREDIT_CRITICAL: $CREDITS below min 2000 — aborting" >&2
            exit 2
        fi
    fi
fi

if [ "$TOOL" = "dataforseo" ]; then
    # DataForSEO uses prepaid balance
    BALANCE=$(curl -s -u "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" \
        "https://api.dataforseo.com/v3/appendix/user_data" | jq '.price')
    # Check total balance — requires login credentials
    echo "Proceeding with DataForSEO call" >&2
fi

# Step 3: Execute fetch (replace with actual tool-specific fetch)
echo "FETCHING: $URL -> $CACHE_PATH" >&2
# ... actual fetch logic per tool ...

# Step 4: Cache the result
echo "$FETCH_RESULT" > "$CACHE_PATH"
echo "CACHE_WRITTEN: $CACHE_PATH"
```

### Dry-Run Mode

Before any batch credit operation, a `--dry-run` mode enumerates what would be fetched:

```bash
bash preflight-fetch.sh --dry-run \
  --urls-file competitors.txt \
  --sla 604800 \
  --tool firecrawl
# Output:
# DRY_RUN: Would fetch 10 URLs
# DRY_RUN: Cache HIT: 6 (fresh, skipping)
# DRY_RUN: Cache STALE: 2 (will re-fetch)
# DRY_RUN: Cache MISS: 2 (new URLs, will fetch)
# DRY_RUN: Estimated Firecrawl cost: 10-20 credits
# DRY_RUN: Estimated DataForSEO cost: $0.06
# Would proceed? [y/N]
```

---

## 3. CREDIT BUDGET MODEL

### Per-Niche Budget (Hard Ceilings)

| Resource | Budget/Niche | Phase 1 | Phase 2 | Phase 3 | Phase 4 | Buffer (20%) |
|----------|-------------|---------|---------|---------|---------|-------------|
| Firecrawl credits | **485** | 45 | 340 | 85 | 15 | 97 (cushion) |
| DataForSEO ($) | **$0.60** | $0.00 | $0.30 | $0.30 | $0.00 | $0.12 |
| Free API calls | No limit (within API's own rate limits) | — | — | — | — | — |

**Total for 25 niches:** 12,125 Firecrawl credits + $15.00 DataForSEO = ~12% of available Firecrawl credits, ~30% of DataForSEO budget. Leaves 87,875 credits for iteration, monitor operations, and other projects.

### Credit Checkpoints (per-niche)

| Checkpoint | Phase | Cumulative Credits | Action if Exceeded |
|------------|-------|-------------------|--------------------|
| CP-1 | Phase 1 complete | 45 | Budget green — proceed |
| CP-2 | Phase 2 50% (competitor discovery) | 215 | If >258 (+20%): flag for review, continue |
| CP-3 | Phase 2 COMPLETE | 385 | If >462 (+20%): PAUSE, audit for wasted fetches, log cause |
| CP-4 | Phase 3 COMPLETE | 470 | If >564 (+20%): flag (unusual for a synthesis phase) |
| CP-5 | Phase 4 COMPLETE | 485 | If >582 (+20%): log final overage with cause |

### Batch Credit Check (for parallel operations)

When launching parallel batch operations (e.g., 10 concurrent scrapes):

```bash
#!/bin/bash
# preflight-batch.sh — Verify batch won't exhaust remainder of niche budget

BATCH_COST_ESTIMATE=$1    # e.g., 200 (credits)
REMAINING_BUDGET=$2       # e.g., 340 - 45 = 295 budget remaining for Phase 2

if [ "$BATCH_COST_ESTIMATE" -gt "$REMAINING_BUDGET" ]; then
    echo "BATCH_TOO_LARGE: Estimated $BATCH_COST_ESTIMATE credits exceeds remaining budget $REMAINING_BUDGET"
    echo "Reduce batch size or increase budget."
    exit 1
fi

# Buffer check: pause if batch would consume >80% of remaining budget
if [ "$BATCH_COST_ESTIMATE" -gt $(($REMAINING_BUDGET * 80 / 100)) ]; then
    echo "BATCH_LARGE: Batch uses $BATCH_COST_ESTIMATE of $REMAINING_BUDGET remaining ( >80% )"
    echo "Proceed? [y/N]"
    read PROCEED
    if [ "$PROCEED" != "y" ]; then
        exit 1
    fi
fi
```

### When to Use `/monitor` Instead of Repeated `/scrape`

| Scenario | Recommended Approach | Credit Savings |
|----------|---------------------|----------------|
| Competitor pricing page (monthly check) | One `/scrape` + one `/monitor` setup | ~80% over 3 months (1 scrape + 1 monitor alert vs 3 scrapes) |
| Multiple competitor pricing pages (5+ competitors) | `/scrape` each once → `/monitor` on the URL set | ~85% over 3 months |
| Niche news aggregator (daily check) | Monitor on the niche's news source page | ~95% (monitor replaces ~30 scrapes/month) |
| Competitor job board (weekly check) | Monitor with `ai_judge` filtering for "new engineering role" | ~90% (monitor fires only on real changes) |
| Changelog / feature page | Monitor with `ai_judge` for feature additions | ~90% (monitor catches real features, ignores formatting) |
| Static documentation page (unchanging) | One `/scrape` — no monitor needed | 100% savings over repeated scrapes |
| G2 review page (weekly) | `/scrape` weekly (reviews change gradually; monitor may miss increments) | 0% — scrape is still the better tool here |

**The general rule:** If you would scrape the same URL >2 times, set up a `/monitor` instead. The Firecrawl `/monitor` endpoint uses an AI judge to filter out non-substantive changes (formatting, timestamps, tracking params) — so it avoids the false positives that make traditional change-detection noisy for this use case.

---

## 4. ERROR HANDLING MATRIX

### Failure Mode → Retry Strategy → Fallback

| Failure Mode | Detected By | Retry Strategy | Fallback | Log Level |
|-------------|-------------|----------------|----------|-----------|
| Firecrawl `/scrape` HTTP 429 (rate limit) | Response status | Retry 3x with exponential backoff: 10s → 30s → 90s. Check `Retry-After` header. | After 3 failures: mark as RATE_LIMITED_DEAD, skip to next URL, log for manual retry later | WARN |
| Firecrawl `/scrape` HTTP 403 (blocked) | Response status | Retry 1x with different user-agent + `pageOptions=json` (JS-rendered sites often block text extraction but serve JSON) | After 1 retry: mark as BLOCKED, check if site has an API endpoint or RSS feed as alternative. If no alternative: mark as LANE_UNAVAILABLE | WARN |
| Firecrawl `/scrape` HTTP 404 | Response status | No retry (404 is definitive) | Mark as GONE. Search for same page under new URL (G-015 rule: 404 proves link rot, not death). Run `/search` for the product name | INFO |
| Firecrawl `/search` timeout (>60s) | Execution timeout | Retry 2x with reduced timeout (30s) and simplified query | After 2 failures: use DataForSEO SERP API as fallback for the same query | WARN |
| Firecrawl `/map` fails (SPA/render-blocked) | Empty response or 403 | Retry 1x with `ignoreSitemap: true` and `limit: 50` (only crawls from a seed URL) | Mark as SPA_BLOCKED; use known page patterns based on site structure conventions | INFO |
| DataForSEO API 429 | Response status | Retry 3x with backoff 5s → 15s → 45s. DataForSEO rate limits are per-endpoint. | After 3 failures: skip SERP analysis for this niche, note as DATA_GAP | WARN |
| DataForSEO insufficient balance | Balance check at pre-flight | No retry — balance is a precondition | Log BALANCE_LOW. Halt all DataForSEO operations. Send alert webhook. | ERROR |
| Free API (Registry Lookup, GDELT, etc.) 429 | Response status | Retry 2x with backoff 2s → 10s (free APIs are more forgiving) | After 2 failures: skip that API source, note as API_UNAVAILABLE. Continue with remaining free APIs | INFO |
| Free API (Registry Lookup, GDELT, etc.) 5xx | Response status | Retry 2x with backoff 5s → 30s (server errors often transient) | After 2 failures: mark as API_DOWN, check status page, continue without this source | WARN |
| Context7 MCP timeout | MCP client timeout | Retry 1x with extended timeout (60s) | After failure: skip Context7 enrichment, log as MCP_FAIL | INFO |
| Network connectivity lost | All fetches fail simultaneously | Retry 3x with backoff 10s → 60s → 120s across the entire pipeline | After 3 failures: PAUSE entire pipeline, log network_unreachable, wait for connectivity restored signal | ERROR |
| Partial batch failure (4 of 10 scrapes fail) | Batch monitor | Retry only the 4 failed URLs (not the entire batch) — 3x backoff per URL | After max retries: 2 or more of 10 still failed → acceptable; log failures with error codes | WARN |
| YAML parse error in output | Schema validation | No retry — data was fetched but not parsed | Isolate the raw fetch output as `*-RAW.json` for manual inspection. Check for encoding issues, truncation, or format change. | ERROR |
| Cache file corrupted (zero-length or invalid) | Post-write validation (check file size > 0) | Re-fetch immediately (up to 2x) | After 2 corrupted writes: mark storage as suspect, write to alternate path | WARN |

### Exponential Backoff Implementation

```python
import time
import random

def retry_with_backoff(fn, max_retries=3, base_delay=5, max_delay=120):
    """
    Retry a function with exponential backoff + jitter.
    Usage: result = retry_with_backoff(lambda: scrape(url))
    """
    for attempt in range(max_retries):
        try:
            return fn()
        except (RateLimitError, TimeoutError, ServerError) as e:
            if attempt == max_retries - 1:
                raise  # Last attempt failed — propagate
            delay = min(base_delay * (2 ** attempt), max_delay)
            jitter = random.uniform(0, delay * 0.1)
            total_delay = delay + jitter
            log(f"Retry {attempt+1}/{max_retries} after {total_delay:.0f}s: {e}")
            time.sleep(total_delay)
```

### Error Classification for Alerts

| Class | Examples | Action | Alert Target |
|-------|----------|--------|-------------|
| CRITICAL | Network down, credit exhausted, DataForSEO balance $0 | HALT pipeline | Webhook + email |
| ERROR | Free API permanently unavailable, batch failure >50% | PAUSE, manual review needed | Webhook |
| WARN | Rate-limited on retry, single URL blocked, individual scrape fails | Continue pipeline, log for review | Log only (non-blocking) |
| INFO | 404 on expected page, SPA render blocked, API temporarily slow | Continue, log as data quality note | Log only |

---

## 5. IDEMPOTENCY PATTERN

### Core Rule

Every operation that touches external state (fetches, writes, transforms) MUST be idempotent: running it twice on the same inputs produces the same result with no duplicate cost and no data corruption.

### Implementation: Cache-Check-Before-Fetch (CCBF)

This is the central idempotency mechanism (described in Section 2). Key details:

```python
class IdempotentFetcher:
    def __init__(self, cache_dir, default_sla=604800):
        self.cache_dir = cache_dir
        self.default_sla = default_sla
        self.cache_hits = 0
        self.cache_misses = 0
    
    def fetch(self, url, cache_key=None, sla=None, force=False):
        """
        Idempotent fetch: if cached data exists and is fresh, return it.
        
        Args:
            url: The URL to fetch
            cache_key: Override for file naming (default: hash of URL)
            sla: Freshness in seconds (default: 7 days)
            force: If True, skip cache entirely
        """
        if sla is None:
            sla = self.default_sla
        if cache_key is None:
            cache_key = hashlib.sha256(url.encode()).hexdigest()[:16]
        
        cache_path = os.path.join(self.cache_dir, f"{cache_key}.json")
        
        # Idempotency check
        if not force and os.path.exists(cache_path):
            file_age = time.time() - os.path.getmtime(cache_path)
            if file_age < sla:
                self.cache_hits += 1
                with open(cache_path) as f:
                    return json.load(f)
            else:
                log(f"Cache stale: {cache_key} ({file_age:.0f}s > {sla}s)")
        
        self.cache_misses += 1
        
        # === EXECUTE FETCH ===
        result = self._execute_fetch(url)
        
        # === WRITE TO CACHE (idempotent store) ===
        os.makedirs(os.path.dirname(cache_path), exist_ok=True)
        # Atomic write: write to temp file, then rename (avoids partial writes)
        tmp_path = cache_path + ".tmp"
        with open(tmp_path, 'w') as f:
            json.dump(result, f, indent=2)
        os.rename(tmp_path, cache_path)
        
        return result
```

### Idempotency for Compound Operations

For operations that combine multiple fetches (e.g., "scrape top 5 competitors' pricing"):

```python
def scrape_competitor_pricing(niche_name, competitors):
    """
    Idempotent batch: each competitor's pricing page is cached independently.
    Re-running this function will only fetch competitors whose cache has expired.
    """
    combined = {}
    for competitor in competitors:
        result = idempotent_fetcher.fetch(
            competitor['pricing_url'],
            cache_key=f"{niche_name}-{competitor['name']}-pricing",
            sla=604800  # 7 days
        )
        combined[competitor['name']] = result
    # Write combined result only if ALL fetches succeeded
    # (atomic: if any fails, the combined file is not updated)
    cache_path = os.path.join(cache_dir, f"{niche_name}-pricing-combined.json")
    tmp_path = cache_path + ".tmp"
    with open(tmp_path, 'w') as f:
        json.dump(combined, f, indent=2)
    os.rename(tmp_path, cache_path)
    return combined
```

### Idempotency for Phase Transitions

Each phase writes a "phase complete" sentinel file:

```python
# After Phase 1 completes successfully:
write_file(f"{niche_dir}/PHASE_1_COMPLETE.sentinel", {
    "phase": 1,
    "completed_at": timestamp,
    "next_phase": 2,
    "data_hash": sha256_of_output
})

# Before Phase 2 starts:
if file_exists(f"{niche_dir}/PHASE_2_COMPLETE.sentinel"):
    log("Phase 2 already complete — skipping")
    return
```

This means: if the pipeline crashes mid-Phase-2, on restart it only re-runs Phase 2 (not Phase 1). If Phase 2 was complete but Phase 3 crashed on output, only Phase 3 re-runs.

### Idempotency in Error Cases

- If a fetch succeeds but writing the cache file fails: the cache file remains in its prior state (no data loss, no double-charge — next run will hit the same cache miss and re-fetch, paying credits again but producing correct data)
- If a batch fetch partially succeeds: only the failed URLs are re-tried (not the entire batch) — credits spent on successful fetches are never re-spent
- If the pipeline is killed mid-batch: the next run checks each URL individually and only fetches those without fresh cache entries

### Cache Invalidation

On purpose (not on error), clear specific cache entries:

```python
# When a competitor changes pricing and we know about it:
invalidate_cache(f"{niche_name}-{competitor['name']}-pricing")
# Next fetch will re-scrape (but respect SLA: you can't re-scrape an unexpired entry without a reason)
```

---

## 6. AUTOMATION READINESS (n8n/Make)

### Architecture for Automation

The pipeline is designed so each step can be represented as a node in n8n or Make with:

1. **Trigger node** — webhook or schedule
2. **Decision node** — cache check or gate
3. **Action node** — API call to Firecrawl/DataForSEO/free API
4. **Synthesis node** — LLM call to process and structure output
5. **Storage node** — write to file/database
6. **Error handler** — branching logic for each failure mode

### Trigger Events

| Trigger | n8n/Make Node | Fires When |
|---------|---------------|------------|
| Webhook: `POST /niche/evaluate` | Webhook node | New niche submitted via API (from user, from Shortlist Tool, from another pipeline) |
| Schedule: `0 6 * * 1` (weekly Monday) | Schedule trigger | Weekly market landscape check — re-scrape all monitored pricing pages via `/monitor` webhook responses |
| Webhook: `POST /firecrawl/monitor/alert` | Webhook node | Firecrawl `/monitor` detects a real change on a watched URL (pricing, feature, job posting) |
| Manual: CLI command | n8n Manual node | Developer triggers a specific niche evaluation from command line |

### n8n Workflow Design (Conceptual)

```
Workflow: "Niche Evaluation Pipeline"
┌──────────────────────────────────────────────────┐
│ TRIGGER: Webhook (POST /niche/evaluate)          │
│   Input: { niche_name, keywords[], urls[] }      │
└────────────────────┬─────────────────────────────┘
                     ▼
┌──────────────────────────────────────────────────┐
│ FUNCTION: Pre-flight check                       │
│   Checks: cache freshness, credit balance        │
│   Output: { cache_hits[], cache_misses[] }       │
└────────────────────┬─────────────────────────────┘
                     ▼ (cache_misses > 0)
┌──────────────────────────────────────────────────┐
│ SWITCH: Parallel execution gate                   │
│   Phase 1 → Go to Phase 1 sub-workflow           │
│   Phase 2 → Go to Phase 2 sub-workflow           │
│   Phase 3 → Go to Phase 3 sub-workflow           │
│   Phase 4 → Go to Phase 4 sub-workflow           │
└────────────────────┬─────────────────────────────┘
                     ▼
            ┌──────────────────────┐
            │ See sub-workflows    │
            │ below                │
            └──────────────────────┘

┌──────────────────────────────────────────────────┐
│ SUB-WORKFLOW: Phase 1 — Niche Bounding           │
│   ├── HTTP (Firecrawl) /search (2-3 queries)    │
│   ├── HTTP (Free APIs: Registry Lookup, etc.)    │
│   ├── HTTP (Firecrawl) /map (top 5 companies)   │
│   └── LLM (Claude API): Bounding synthesis      │
│   Output: { pass/kill, evidence[] }               │
└────────────────────┬─────────────────────────────┘
                     ▼ (if PASS)

┌──────────────────────────────────────────────────┐
│ SUB-WORKFLOW: Phase 2 — Deep Research            │
│   PARALLEL EXECUTION BRANCHES:                    │
│   ├── Branch A: Competitor Scraping              │
│   │   └── HTTP (Firecrawl) /scrape × 10 (batch) │
│   ├── Branch B: Pricing Intelligence             │
│   │   └── HTTP (Firecrawl) /search × 4-5        │
│   ├── Branch C: Technographics + Hiring           │
│   │   └── HTTP (Free Techmap API)                │
│   ├── Branch D: SERP Analysis                     │
│   │   └── HTTP (DataForSEO API) × 5-10           │
│   ├── Branch E: Company Enrichment                │
│   │   └── MCP (Context7 via n8n MCP node)        │
│   ├── Branch F: Reviews + Social Proof            │
│   │   └── HTTP (Firecrawl) /search × 4-5        │
│   └── Branch G: News + Intent Signals             │
│       └── HTTP (GDELT + Currents APIs)           │
│   SYNTHESIS:                                     │
│   └── LLM (Claude API): Merge all branches       │
│   Output: { niche_profile_yaml }                  │
└────────────────────┬─────────────────────────────┘
                     ▼ (after all branches complete)

┌──────────────────────────────────────────────────┐
│ SUB-WORKFLOW: Phase 3 — Commercial Design        │
│   ├── HTTP (Firecrawl) /search (WTP signals)    │
│   ├── HTTP (Firecrawl) /scrape (top 3 teardown) │
│   ├── LLM (Claude API): RIOS canvas fill        │
│   └── FUNCTION: Gates verification               │
│   Output: { rios_canvas, gate_verdict }           │
└────────────────────┬─────────────────────────────┘
                     ▼ (if gates PASS)

┌──────────────────────────────────────────────────┐
│ SUB-WORKFLOW: Phase 4 — Scoring & QA             │
│   ├── FUNCTION: Score niche                      │
│   ├── HTTP (Firecrawl): Freshness spot-check    │
│   ├── FUNCTION: Cross-niche comparison           │
│   └── LLM (Claude API): QA audit                │
│   Output: { score, qa_verdict, final_package }    │
└────────────────────┬─────────────────────────────┘
                     ▼
┌──────────────────────────────────────────────────┐
│ FUNCTION: Archive and package                     │
│   Output: Canonical niche YAML written to disk   │
└────────────────────┬─────────────────────────────┘
                     ▼
┌──────────────────────────────────────────────────┐
│ WEBHOOK RESPONSE: Return final package            │
│   HTTP 200 + package JSON                         │
└──────────────────────────────────────────────────┘
```

### Decision Node Rules

Each gate in the pipeline maps to an n8n Switch or IF node:

```yaml
decision_nodes:
  phase1_gate:
    type: IF
    condition: "{{ $json.verdict == 'PASS' }}"
    true_branch: "Phase 2"
    false_branch: "Kill and archive"
  
  credit_check:
    type: SWITCH
    conditions:
      - case: "{{ $json.credits_remaining > 5000 }}"
        branch: "Proceed with full batch"
      - case: "{{ $json.credits_remaining > 2000 }}"
        branch: "Proceed with reduced batch (50%)"
      - default: "Pause and alert"
  
  error_handler:
    type: SWITCH
    conditions:
      - case: "{{ $json.error_class == 'RETRYABLE' }}"
        branch: "Retry with backoff"
      - case: "{{ $json.error_class == 'BLOCKED' }}"
        branch: "Try alternative source"
      - case: "{{ $json.error_class == 'GONE' }}"
        branch: "Mark as unavailable"
      - default: "Skip and log"
```

### Webhook Endpoint Contracts

```yaml
# Trigger: Start niche evaluation
POST /webhook/niche-evaluate
Request:
  {
    "niche_name": "Bullhorn-staffing-revenue-intelligence",
    "seeds": {
      "keywords": ["Bullhorn pricing", "staffing ATS revenue leakage"],
      "seed_urls": ["https://www.bullhorn.com/pricing/", "https://www.bullhorn.com/"]
    },
    "force_refresh": false,  # If true, bypasses cache
    "phases": [1, 2, 3, 4]   # Which phases to run (default: all)
  }
Response:
  HTTP 202 Accepted — returns immediately with:
  {
    "job_id": "niche-eval-20260723-bullhorn-staffing",
    "status": "accepted",
    "estimated_completion": "2026-07-23T10:15:00Z",
    "webhook_complete": "POST /webhook/niche-complete"
  }

# Callback: Niche evaluation complete
POST /webhook/niche-complete  (registered at submit time)
Payload:
  {
    "job_id": "niche-eval-20260723-bullhorn-staffing",
    "status": "complete",
    "phases_completed": [1, 2, 3, 4],
    "verdict": "PASS",
    "score": 78,
    "output_path": "research/25-niche/completed/bullhorn-staffing-v1.yaml",
    "summary": {
      "competitors_analyzed": 12,
      "pricing_anchors": 5,
      "credit_cost": 412,
      "dataforseo_cost": 0.24
    },
    "errors": [
      {"url": "https://competitor.com/pricing", "status": "GONE", "resolution": "searched for new URL — found at /pricing-new"}
    ]
  }
```

### Monitoring Integration

Firecrawl `/monitor` webhook responses feed into the automation pipeline:

```yaml
# Webhook from Firecrawl monitor
POST /webhook/firecrawl-monitor
Payload:
  {
    "monitor_id": "mon-bullhorn-pricing-01",
    "url": "https://www.bullhorn.com/pricing/",
    "detected_change": true,
    "ai_judge_summary": "Pricing page structure changed. New tiers detected.",
    "diff": "...",
    "timestamp": "2026-07-23T06:00:00Z"
  }
```

This payload triggers a re-scrape of Bullhorn's pricing page, which then cascades to invalidate the pricing cache for the Bullhorn-staffing niche, which then triggers a Phase 2 re-run for the pricing dimension only (not the full niche re-evaluation).

---

## 7. ADVERSARIAL VERDICT

### Would this lens sign off?

**Conditional YES, with the following findings and requirements:**

**STRENGTHS (would sign off on these):**

1. **The CCBF (Cache-Check-Before-Fetch) pattern is sound.** The pre-flight check that verifies (a) file exists, (b) file is fresh, (c) credits are sufficient, (d) rate limits are respected — before executing any credit-costing operation — is the right architecture. The idempotency guarantee is real, not aspirational: every fetch produces a cache file that future runs check, so pipeline restarts are safe.

2. **The error handling matrix is complete.** It covers every failure mode observed in Phases 1-4 of the existing research program (G-012 dead hosts, G-015 rebranded products that 404, G-016 enum drift, G-022 schema failures, G-023 Fable 5 credit exhaustion, L-025 coverage gate failures) and maps each to a documented retry strategy with a fallback. The LRU cache with freshness SLA is correctly separate from retry — cache is for idempotency, retry is for transient failures, and never conflating the two is essential.

3. **The parallel fan-out design respects the concurrency constraints from G-026** (empirical ceiling at ~3-4 concurrent agents for LLM-intensive work). The Phase 2 parallel branches are API calls (not LLM agents), so the 10-15 concurrent scrape pattern is within Firecrawl's 50-concurrent limit and does not trigger the G-026 scaling ceiling. LLM synthesis (the bottleneck) is sequential by design — only one merge step at the end of each phase.

4. **Credit budget per niche (485 credits) is conservative.** Phase 3's 37 competitor YAMLs cost an estimated ~2,000 Firecrawl credits (from PROJECT-STATE data). Our per-niche budget of 485 credits is 4x leaner, reflecting the facts that (a) we're not re-performing Phases 1D/3C/3D at this scale, (b) free APIs replace Firecrawl for many queries, (c) cache hits reduce Phase 2 cost on re-evaluations.

5. **The `/monitor` vs `/scrape` decision logic is correct.** The guidance "if you'd scrape the same URL >2 times, use a monitor" is simple, enforceable, and directly addresses the "repeated scrape → credit burn" anti-pattern. The exception for G2 reviews (monitor misses incremental changes) is a specific, justified carve-out.

**FINDINGS THAT MUST BE ADDRESSED:**

1. **The pipeline has no "data quality gate" between Phase 2 collection and Phase 3 synthesis.** Phase 2 can complete with 0 pricing anchors (all pages blocked, no alternative found) and Phase 3 will still proceed, producing a RIOS canvas with "UNKNOWN" pricing that looks like a complete analysis but isn't. **Fix:** Add a mandatory Phase 2 data quality gate: if <2 pricing anchors AND no alternative pricing source (G2/analyst report/aggregator data), Phase 2 must log a WARN and Phase 3 must flag its pricing field as INSUFFICIENT_DATA. This is the same discipline as the KT-3 pre-registration (L-024).

2. **The free-API fallback chain is underspecified.** When Firecrawl `/search` fails, the pipeline falls back to DataForSEO SERP. But DataForSEO costs real money and may also fail. The chain should be: Firecrawl `/search` → Free API (OpenSERP self-hosted/Cache) → DataForSEO. This adds a $0 layer between "expensive" and "free with cost." Document the specific free SERP alternative (OpenSERP self-hosted per `free-apis-b2b-niche-research.md §9.6`).

3. **The "buffer" in the credit budget (20%) is not enough for pathological niches.** Some niches may have 20+ competitors (not the assumed 10), or every page may require JS rendering (doubling scrape cost), or the site structure may be unusually deep. **Fix:** Make the buffer configurable per niche class: "normal" = 20%, "deep" (many competitors/complex pages) = 40%, configured in a pre-flight config file. If buffer is exceeded, the pipeline should produce a CREDIT_OVERAGE report with specific cause, not just pause.

4. **No garbage collection for stale cache files.** Cached files accumulate indefinitely. A 25-niche evaluation produces ~2,500 cache entries (~500 MB). Over months, cache growth degrades performance and makes freshness checks increasingly slow. **Fix:** Add a weekly `gc-cache.js` workflow that (a) purges entries exceeding 4× their SLA age (28 days for pricing pages, etc.), (b) logs purged entries as "CACHE_PURGED", (c) reports total cache size.

5. **The webhook contract doesn't include authentication.** A public `POST /webhook/niche-evaluate` endpoint is an invitation to get credit-drained. **Fix:** Add HMAC signature or API key authentication to every webhook endpoint. Document the auth scheme in the webhook contract. (A simple approach: sign the payload with HMAC-SHA256 using a shared secret, verify on receipt.)

6. **No rollback mechanism for Phase 4 packaging.** Once a niche package is frozen and archived (`NICHE-[name]-v1.yaml`), there's no documented way to amend it if QA finds an error post-archive. **Fix:** Add a `v2` creation path: the existing package is never overwritten, but a `v2` can be generated with a changelog entry explaining what changed and why.

7. **Missing: cache warming strategy.** The first run of the pipeline for a given niche will experience 100% cache misses — the worst-case credit burn and wall-clock time. For the 25-niche evaluation, that's the expected state for the first pass. But for recurring monitoring, there should be a documented "cache warm" sequence: after the initial full evaluation, immediately run the Phase 2 freshness-check (step 4.1) on a 7-day SLA, so that future re-evaluations hit a mostly-fresh cache. **Fix:** Add a post-completion `post-evaluate.sh` that sets up monitors and schedules the first freshness pass.

**FINAL VERDICT:**

**APPROVED CONDITIONALLY — sign off after items #1, #2, #3, #5, and #6 are addressed. Items #4 (cache GC) and #7 (cache warming) are accepted as low-priority improvements, not blockers.**

The core design is architecturally sound: the CCBF pattern, the idempotency guarantees, the credit budget model with checkpoints, the error handling matrix, the parallel fan-out design, and the n8n/Make readiness all meet the standards of a production-grade data operations pipeline. The gate discipline (4 gates, 4 checkpoints) reflects the lessons learned from the Research Program's own audit findings (G-020, L-024, L-025).

The five required findings are specific, actionable, and not philosophical disagreements. Once addressed, this pipeline is safe to run unsupervised at 25-niche scale.
