# LENS 5: Cost & Efficiency Auditor — Full Audit Report

**Audit Date:** 2026-07-23
**Evaluator:** Cost & Efficiency Auditor Lens
**Scope:** 25-niche data operations architecture
**Toolchain:** Firecrawl (100K credits, 50 concurrent, /search relevance model), DataForSEO ($50 budget, ~83K SERP checks), Context7 MCP, 65+ MCP servers, 20+ free APIs
**Binding Decision:** DataForSEO is PRIMARY for all SERP/keyword/backlink/SEO data. Free SERP tools are fallbacks, not primary.

---

## 1. PER-NICHE BUDGET MODEL

### 1.1 Firecrawl Credits

| Segment | Niches | Per-Niche Budget | Total Credits | Rationale |
|---|---|---|---|---|
| Calibration niche (N1) | 1 | **6,000** | 6,000 | First pass: pipeline construction, pattern discovery, trial-and-error. Expect 30-50% waste on initial crawl boundary definition, URL discovery, and query refinement. |
| Batch 2-4 (N2-N4) | 3 | **4,200** | 12,600 | Early learning curve: 70% of calibration efficiency. Pattern reuse starting but still debugging pipeline. |
| Batch 5-10 (N5-N10) | 6 | **3,800** | 22,800 | Stabilized pipeline: 63% of calibration cost. Clear patterns established, templates hardened. |
| Batch 11-20 (N11-N20) | 10 | **3,600** | 36,000 | Mature pipeline: 60% of calibration cost. Bulk operations, cached cross-niche data, shared domain knowledge. |
| Batch 21-25 (N21-N25) | 5 | **3,400** | 17,000 | Peak efficiency: 57% of calibration cost. Full pattern library, automated quality gates, minimal retries. |
| **Strategic buffer** | — | — | **5,600** | Reserve for deep-dive niches, emergency re-scrapes, and launch-pending validation. Not allocated until needed. |
| **TOTAL** | **25** | **3,720 avg** | **100,000** | 94.4% allocated, 5.6% buffer |

**Variance rules:**
- **Low-complexity niche** (SaaS tool, abundant public data, clear competitor set): budget = base × 0.7
- **High-complexity niche** (enterprise, opaque pricing, regulated): budget = base × 1.3
- **Data-sparse niche** (new category, <5 competitors): budget = base × 0.5 (less to scrape, more to analyze)
- **Competitor-dense niche** (>15 competitors): budget = base × 1.4 (more URLs to cover)

### 1.2 DataForSEO Spend

| Component | Per-Niche Budget | Total | Notes |
|---|---|---|---|
| SERP checks (competitor discovery) | $0.50 | $12.50 | ~830 SERPs at $0.0006 each. 33 SERPs/niche for initial competitor landscape. |
| Keyword research (top competitors) | $0.50 | $12.50 | ~830 keyword queries. Batch 1,000/request = same cost as 1. |
| Backlink profiles (top 5 competitors) | $0.50 | $12.50 | ~830 backlink checks. 33/niche = profile snapshots for 5 competitors. |
| Gap analysis / cross-niche batch | $0.50 | $12.50 | Reserve for overlap detection and cross-niche SERP analysis. |
| **TOTAL** | **$2.00 avg** | **$50.00** | Full budget consumed. No DataForSEO reserve — budget is exactly $50. |

**Variance:** If a niche has >15 competitors, reallocate from low-density niches. Maximum single-niche DataForSEO spend: **$4.00** (2× average).

### 1.3 Cost-per-Insight Targets

| Data Type | Target Cost per Niche | Target Insights | Cost per Insight |
|---|---|---|---|
| Competitor identification | 30 credits + $0.50 | 8-15 competitors | 2-3.75 credits each |
| Competitor pricing scrape | 200 credits | 3-5 pricing anchors | 40-67 credits each |
| Review analysis (20 reviews/competitor) | 80 credits | 100 reviews | 0.8 credits each |
| Keyword landscape | $0.50 DataForSEO | 50 keywords | $0.01 each |
| Backlink profile | $0.50 DataForSEO | 5 competitor profiles | $0.10 each |
| Technology stack | 40 credits | 8-15 tech stacks | 2.7-5 credits each |
| News/PR monitoring | 30 credits | 3-5 key events | 6-10 credits each |

**Gate:** Any data type exceeding 2× its target cost-per-insight without producing proportionally more insights must pause for method review.

---

## 2. THREE-TIER MENU

### 2.1 Data Type: Competitor Discovery & Identification

| Tier | Tools | Cost per Niche | Output | When to Use |
|---|---|---|---|---|
| **FREE** | Context7 MCP (company search), free Crunchbase API (limited), G2 category pages via free scrape | 0 credits | 5-8 competitors | Default for all niches. Enough for the fertility scan. |
| **OPTIMAL** | Firecrawl /search (relevance excerpts, ~10 queries) + DataForSEO SERP checks (2-3 category queries, ~$0.002) | 10 credits + $0.002 | 8-15 competitors, ranked by relevance | Standard pipeline. Adds SERP-based discovery that free tools miss. |
| **PREMIUM** | Firecrawl deep /search (20 queries) + DataForSEO full competitor keyword overlap + backlink intersection | 40 credits + $0.50 | 15-25 competitors, full landscape map | Only for launch-pending niches (final 3-5). Never for the fertility pass. |

**Efficiency rule:** Use FREE for all 25 niches to build the initial competitor list. Only run OPTIMAL for niches that survive the fertility gate (projected: 8-12). Only run PREMIUM for launch-pending niches (projected: 1-3).

### 2.2 Data Type: Competitor Pricing Extraction

| Tier | Tools | Cost per Niche | Output | When to Use |
|---|---|---|---|---|
| **FREE** | MCP servers (Crunchbase, G2), manual URL checks via free Firecrawl scrape (3 URLs/niche) | 6-12 credits | Price ranges, tier names (if published) | Preliminary fertility scan. Establishes price band. |
| **OPTIMAL** | Firecrawl /map (1 credit to discover URLs) then targeted /scrape on pricing pages (3-5 URLs) + DataForSEO SERP check for pricing-page discovery | 5-20 credits + $0.002 | 3-5 pricing anchors per competitor. Managed vs. self-serve identified. | Standard pipeline. The `map` before `crawl` pattern saves 80% of credits vs blind crawling. |
| **PREMIUM** | Full Firecrawl crawl of competitor site (pricing/*, features/*) + DataForSEO price-history if available + manual browser interaction via /interact for login-walled pricing | 150-500 credits + $1.00 | Full pricing page inventory, feature-tier mapping | Launch-pending only. NOT for fertility pass. |

**KT-3 gate:** OPTIMAL tier is sufficient for KT-3 (competitor pre-emption check). The pre-registration shows the key variable is monthly-recurring managed-service pricing — one direct scrape of the pricing page per competitor is sufficient. PREMIUM would not change the KT-3 outcome.

### 2.3 Data Type: Review & Social Proof Analysis

| Tier | Tools | Cost per Niche | Output | When to Use |
|---|---|---|---|---|
| **FREE** | G2 category pages via free scrape, Context7 reviews, Trustpilot via free API | 0-10 credits | 10-20 reviews per competitor | All niches. 10 reviews gives 80% of sentiment signal. |
| **OPTIMAL** | Firecrawl /search for "X reviews G2", "X review Capterra" (2 queries) + targeted scrapes of top review pages (2-3 per competitor) | 20 credits | 20-50 reviews per competitor, star distribution, common praise/complaint themes | Niches that survive fertility gate. 20 reviews = 95% saturation of sentiment themes. |
| **PREMIUM** | Firecrawl /monitor on top competitors' review pages (ongoing change detection) + full review history scrape (paginated) | 60 credits + ongoing monitoring credits | Complete review history, temporal sentiment trends, response patterns | Launch-pending only. Monitoring is set once and fires on change — 1 credit per detection event. |

**Diminishing returns anchor:** After 20 reviews per competitor, marginal new insight drops below 5%. The first 10 reviews capture ~80% of sentiment themes. Do not scrape beyond 50 reviews per competitor — the 51st review is overwhelmingly likely to repeat a theme already captured.

### 2.4 Data Type: Keyword & SEO Research

| Tier | Tools | Cost per Niche | Output | When to Use |
|---|---|---|---|---|
| **FREE** | Context7 MCP for organic search data (limited), Google Trends (free), Ahrefs free webmaster tools | 0 credits | Top 10 keywords per category | Preliminary scan only. |
| **OPTIMAL** | DataForSEO keyword batch (1,000 keywords/request = 1 API call) + DataForSEO SERP check for top 5 competitors' ranking keywords | $0.50 | Top 50 keywords per competitor, search volume ranges, estimated traffic share | Standard pipeline. This is the PRIMARY method — DataForSEO is the designated tool for this data type. |
| **PREMIUM** | DataForSEO full keyword gap analysis (up to 5 competitors simultaneously) + DataForSEO historical keyword data + competitive density metrics | $1.00-$2.00 | Full keyword landscape, gap opportunities, seasonal trends, CPC data | Launch-pending niches only. The keyword gap output directly feeds offer positioning. |

**Efficiency rule:** Top 50 keywords per competitor captures ~80% of organic traffic. Keyword gap analysis (comparing multiple competitors) can be batched — run once for all launch-pending niches together to share the cost.

### 2.5 Data Type: Backlink Profile Analysis

| Tier | Tools | Cost per Niche | Output | When to Use |
|---|---|---|---|---|
| **FREE** | MozBar (free), OpenLinkProfiler (free, limited), Context7 domain data | 0 credits | Domain authority range, rough link count | Preliminary scan. Gives "is this a link-competitive category?" signal. |
| **OPTIMAL** | DataForSEO backlinks API for top 3 competitors per niche | $0.30 | Backlink count, domain authority, top referring domains | Fertility gate survivors. 3 competitors is the minimum for backlink benchmarking. |
| **PREMIUM** | DataForSEO full backlink profile (all discovered competitors) + anchor text distribution + referring domains by category | $1.00-$3.00 | Complete backlink landscape, gap analysis, link-building opportunities | Launch-pending only. Not needed for fertility pass — backlinks don't predict offer viability. |

**Justification for skipping in most niches:** Backlink data has the weakest correlation with offer viability of any data type in this toolkit. A competitor can rank #1 with 0 backlinks (product-led growth, brand search) or have millions of links and zero revenue (content farms). Only run backlink analysis for launch-pending niches where SEO positioning is part of the GTM strategy.

### 2.6 Data Type: Technology Stack Detection

| Tier | Tools | Cost per Niche | Output | When to Use |
|---|---|---|---|---|
| **FREE** | Wappalyzer (browser extension, manual), BuiltWith free tier, Context7 MCP (limited tech data) | 0 credits | 3-5 tech signals per competitor | All niches. Free tier covers CRM, analytics, hosting basics — enough for fertility. |
| **OPTIMAL** | Firecrawl /scrape of competitor homepage + builtwith.com lookup (1 scrape each) | 4-6 credits | 8-15 tech signals, CRM/AI tool identification | Niches that survive fertility gate. Essential for "does this competitor use the tools we'd integrate with?" assessment. |
| **PREMIUM** | Firecrawl full crawl of competitor site (all pages for embedded scripts/tags) + DataForSEO for tech-related keyword queries | 100-200 credits | Complete tech stack including CDNs, marketing automation, session recording, A/B testing | Only if technology partnership/integration is part of the offer (rare). |

### 2.7 Data Type: Job Posting & Hiring Signals

| Tier | Tools | Cost per Niche | Output | When to Use |
|---|---|---|---|---|
| **FREE** | Indeed/Glassdoor free search (manual or Context7), LinkedIn free (limited, TOS risk) | 0 credits | Open roles per competitor, role types | Fertility pass. "Are they hiring sales/GTM roles?" is a growth signal. |
| **OPTIMAL** | Firecrawl /search for "[competitor] careers" + targeted scrape of careers page (1 per competitor) | 10 credits | Open roles, growth stage indicators, tech stack signals from job descriptions | Fertility gate survivors. 1 scrape per competitor captures hiring trajectory. |
| **PREMIUM** | DataForSEO for job-related SERP checks + Firecrawl /monitor on careers pages (weekly change detection) | 10 credits + monitoring | Hiring velocity trends, role-type evolution, team size inference | Launch-pending niches — want to confirm market growth velocity before committing. |

---

## 3. DIMINISHING RETURNS THRESHOLDS

### 3.1 By Data Type

| Data Type | Minimum Viable | Sweet Spot | Hard Stop | Evidence Basis |
|---|---|---|---|---|
| Competitors per niche | 3 | 5 | 10 | 3 gives price triangulation. 5 gives strategic clusters. Beyond 10, additional competitors are long-tail — they move ranking order but not category-level conclusions (G-006 validated). |
| Reviews per competitor | 10 | 20 | 50 | VOC experience (Phase 2): 447 quotes across 10 lanes. First 10 reviews capture 80% of sentiment themes. 20 reaches 95%. After 50, every additional 10 reviews adds <2% new themes. |
| Pricing anchors per category | 3 | 5 | 8 | KT-3 pre-registration: 3 anchors is the binding minimum. 5 gives statistical confidence. Beyond 8, the price band stabilizes within ±5%, and the additional data changes no output. |
| Keywords per competitor | 20 | 50 | 100 | Long-tail SEO: top 20 keywords = ~50% of traffic. Top 50 = ~80%. Top 100 = ~90%. The 50th-to-100th keywords capture declining-volume terms that are unlikely to change category-level opportunity assessment. |
| SERP pages per query | 1 (top 10) | 3 (top 30) | 5 (top 50) | G2/Capterra/Crunchbase: first page captures dominant players. Page 3+ is marginal — these are low-visibility competitors unlikely to be market-relevant. |
| DataForSEO keyword batch size | 200 | 1,000 | 1,000 (API limit) | Cost is per-request, not per-keyword. Always batch to 1,000. But the 900th keyword adds negligible insight — the limit is analytical, not financial. |
| Tech stack signals per competitor | 3 | 8 | 15 | 3 gives CRM/hosting/analytics. 8 gives marketing stack. Beyond 15, you're detecting CDNs and tag managers that don't affect competitive positioning. |
| VOC quotes per niche | 5 | 15 | 30 | Phase 2 methodology: new themes saturate around 15 quotes per niche. At 30, additional quotes are near-duplicates. |

### 3.2 For the 25-Niche Pipeline Specifically

| Resource | Diminishing Point | Explanation |
|---|---|---|
| Niche parallelism | 4 concurrent | G-026: background-agent connection instability scales with concurrency. Beyond 4 concurrent niches, wall-clock savings diminish and failure rates increase. Sequential batches of 4. |
| Cross-niche data reuse | Niche 11+ | By niche 11, the pipeline is mature. Every additional niche benefits from shared patterns but the marginal efficiency gain diminishes. The learning curve savings model (Section 4) quantifies this. |
| Fertility gate accuracy | After first pass through 25 niches | The fertility gate (rank niches by potential) requires only OPTIMAL-tier data. Running PREMIUM-tier on all 25 would cost ~3× the credits for <10% change in ranking — the ranking order stabilizes at OPTIMAL. Only re-score with PREMIUM for launch-pending candidates. |

### 3.3 The 80/20 Rule Applied to the Full Pipeline

| Phase | Effort Share | Insight Capture | Verdict |
|---|---|---|---|
| 25-niche fertility pass (FREE tier) | 10% of budget | 70% of insight | **MANDATORY** — ranks all niches, identifies top contenders |
| Top 8-12 deep-dive (OPTIMAL tier) | 30% of budget | 20% of insight | **MANDATORY** — validates ranking, builds competitive profiles |
| Top 3-5 launch validation (PREMIUM tier) | 50% of budget | 8% of insight | **DISCRETIONARY** — only if a specific niche is selected for go-to-market |
| Buffer & rework | 10% of budget | 2% of insight | **INSURANCE** — emergency re-scrapes, catch-up on missed data |

**The 90% trap warning:** The last 10% of insight costs 60% of the budget. The biggest efficiency risk is running PREMIUM-tier on 10+ niches instead of 3-5. The fertility gate is specifically designed to prevent this: it identifies which niches survive to the next tier. Any workflow that bypasses or softens the fertility gate is a budget risk.

---

## 4. LEARNING CURVE SAVINGS MODEL

### 4.1 Firecrawl Credit Burn by Niche Number

```
Niche 1  (calibration): 6,000 credits  — 100% baseline
Niche 2:                 4,500 credits  — 75% of calibration (+triaging pipeline)
Niche 3:                 4,200 credits  — 70%
Niche 4:                 3,900 credits  — 65%
Niche 5:                 3,800 credits  — 63%
Niche 6:                 3,800 credits  — 63%
          (plateau: template reuse)
Niche 10:                3,600 credits  — 60%
Niche 15:                3,600 credits  — 60%
Niche 20:                3,400 credits  — 57%
Niche 25:                3,400 credits  — 57%
```

**TOTAL: 97,200 credits** (allowing 2,800 buffer for cross-niche lookups and re-scrapes)

### 4.2 Where the Savings Come From

| Source | Calibration Niche | Niche 10 | Niche 25 | Savings Mechanism |
|---|---|---|---|---|
| URL discovery | 500 credits (trial-and-error domain guessing) | 50 credits (known sources per category type) | 30 credits (pattern library) | Cross-niche URL registry: once we know Crunchbase/G2/Capterra patterns for SaaS, we reuse them. 10× reduction by niche 10. |
| Query refinement | 800 credits (iterating search queries) | 200 credits (query templates hardened) | 100 credits (automated parameterization) | Template library of effective queries per data type. 8× reduction. |
| Crawl boundary definition | 1,500 credits (over-crawling, fixing depth) | 500 credits (known site structures) | 300 credits (site structure library) | Each niche's competitors share site structures (pricing at /pricing, careers at /careers). Library of 50+ patterns covers 90% of cases by niche 10. |
| Error recovery | 1,200 credits (retries, debugging) | 300 credits (known workarounds) | 150 credits (automated fallbacks) | G-012, G-015, G-016, G-020 all had Firecrawl-specific learnings. Once cataloged, these errors are handled prophylactically. |
| Output validation | 1,000 credits (re-scraping to verify) | 300 credits (spot-check only) | 100 credits (automated validation) | Confidence in pipeline output grows with repetition. Calibration requires 3× verification; mature pipeline runs verification inline. |

### 4.3 Efficiency Multiplier

| Metric | Calibration Niche | Niche 25 | Improvement |
|---|---|---|---|
| Credits per insight | 120 | 68 | 1.76× more efficient |
| Wall-clock time | ~4 hours | ~1.5 hours | 2.7× faster |
| Human attention required | High (debugging) | Low (monitoring) | 5× reduction in oversight |
| DataForSEO cost per useful SERP | $0.06 | $0.01 | 6× more efficient (no wasted queries) |

### 4.4 What Does NOT Improve with Learning

- **Firecrawl base cost per scrape:** Stays at 1 credit. Pattern reuse reduces the NUMBER of scrapes, not their unit cost.
- **DataForSEO $50 hard cap:** Does not change. The savings are in query targeting, not lower prices.
- **Concurrent niche limit:** Stays at 4 (G-026). The scaling ceiling is connection stability, not pipeline maturity.
- **Binding kill-gate thresholds:** Pre-registered. Pipeline maturity does not relax KT-1/KT-3/KT-4 criteria.

---

## 5. RUNAWAY BURN DETECTION

### 5.1 Kill Switch Matrix

| Trigger | Threshold | Action | Alert Channel |
|---|---|---|---|
| Single niche Firecrawl credits | >6,000 (100% of calibration budget) | **PAUSE** the niche pipeline. Log what has been consumed and what remains uncollected. Do NOT resume until a human reviews whether the excess was justified. | Session interrupt + OS file flag |
| Single niche Firecrawl credits | >9,000 (150% of calibration budget) | **HALT** — kill all active scrapes for this niche. Archive what data was collected. This niche is over-budget and must be re-scoped before continuing. | Hard stop. Requires explicit confirmation. |
| Single niche DataForSEO spend | >$4.00 (2× average) | **PAUSE** DataForSEO queries for this niche. Review query pattern for waste (duplicate SERP checks, excessive keyword batches). | Session alert |
| Single niche DataForSEO spend | >$5.00 (2.5× average) | **HALT** — no further DataForSEO queries for this niche. The remaining $1+ over the 2× threshold requires justification before additional spend. | Hard stop. |
| Consecutive API failures (any tool) | 5 consecutive failures on the same endpoint | **STOP** the failing operation. Investigate: is the endpoint down? Is the authentication expired? Is rate-limiting active? Do not retry until root cause is identified (see failed approaches F-007, G-012). | Immediate alert |
| Aggregate Firecrawl burn rate | >4,000 credits/hour sustained for 2+ hours | **PAUSE** all pipelines. This burn rate suggests runaway parallelism or an infinite-loop crawl. Review active workstreams. | Rate alarm |
| Aggregate DataForSEO burn rate | >$5/hour sustained | **HALT** all DataForSEO operations. $5/hour would exhaust the entire budget in 10 hours. Most likely cause: unbatched keyword queries or excessive SERP checks. | Hard stop |
| Cross-niche duplicate data fetch | Same URL scraped 3+ times across different niches | **ALERT** — data reuse failure. The pipeline should cache all scrapes by URL. 3+ duplicates indicate the cross-niche cache is not being consulted. Investigate cache integrity. | Session warning |
| No useful data after N attempts | 5 fetches to a data source return empty/null/non-informative content | **STOP** fetching from this source for this niche. Mark as LANE_UNAVAILABLE with reason. Do not retry at higher depth (see G-012 — some sources are permanently dead to automated fetchers). | Session alert |

### 5.2 Automated Guard Implementation

Each kill switch should be implemented as a runtime check in the pipeline orchestration layer:

```yaml
kill_switches:
  per_niche_firecrawl_credit_cap:
    warning: 6000
    halt: 9000
    scope: niche
    action: "pause_or_halt"
    log_to: "runaway_niches.md"

  per_niche_dataforseo_spend_cap:
    warning: 4.00   # dollars
    halt: 5.00
    scope: niche
    action: "pause_or_halt"

  consecutive_failure_limit:
    threshold: 5
    scope: endpoint_per_niche
    action: "stop_and_investigate"
    log_to: "failed_endpoints.md"

  aggregate_burn_rate_firecrawl:
    warning: 4000  # credits/hour
    duration_minutes: 120
    action: "pause_all"

  aggregate_burn_rate_dataforseo:
    warning: 5.00  # dollars/hour
    duration_minutes: 60
    action: "halt_all"
```

### 5.3 What Runaway Burn Looks Like in Practice

Based on Phase 0-3 experience (PROJECT-STATE.md, KNOWLEDGE-BASE.md), the most likely runaway scenarios:

1. **Over-crawling competitor sites** — Firecrawl crawl with no depth limit on a 10,000-page site. Cost: 10,000+ credits before manual stop. **Fix:** always use `map` before `crawl` (G-020 adjacent). Map costs 1 credit and returns all URLs. Then scrape only the relevant subset.

2. **Repeated failures on dead hosts** — G-012: `eetimes.com` (hangs), `tracxn.com` (504), `linkedin.com` (999), `glassdoor.com` (403). Each retry costs credits. **Fix:** maintain a `DEAD_HOSTS` registry. After 2 consecutive failures, add the host to the registry and skip all future fetches for this session. Only re-test at session restart.

3. **DataForSEO unbatched query pattern** — Sending 50 individual keyword queries instead of batching 1,000 in one request. Costs 50× the price. **Fix:** always buffer keyword queries to a batch queue. Submit when the queue reaches 200 entries or a 5-minute timer expires.

4. **Fertility gate bypass** — Running PREMIUM-tier on all 25 niches because "we might miss something." **Fix:** binding pipeline gate — each niche must have a fertility score before it can advance beyond FREE tier. Hard-coded in the orchestration script.

---

## 6. ADVERSARIAL VERDICT

### 6.1 Would This Lens Sign Off?

**Conditional sign-off — APPROVED with CONDITIONS.**

The budget model is sound. The three-tier menu correctly prioritizes free sources and defines clear escalation paths. The diminishing returns thresholds are grounded in empirical data from Phase 0-3 (VOC saturation curves, competitor audit coverage, pricing anchor stability). The learning curve savings model is appropriately conservative (57% of calibration cost at niche 25, not 30%). The kill switches cover the failure modes observed in Phase 0-3 (G-012, G-020, G-026, F-007).

### 6.2 Conditions

**CONDITION 1 — The fertility gate must be binding, not advisory.** If the pipeline allows niches to advance to OPTIMAL or PREMIUM tier without a fertility score, the entire budget model collapses. The learning curve savings assume that only 8-12 niches reach OPTIMAL and only 3-5 reach PREMIUM. If all 25 get PREMIUM treatment, the budget is 3-5× overspent.

**CONDITION 2 — DataForSEO queries must be batched by design.** The $50 budget goes exactly to $0 if queried efficiently. But 50 individual SERP checks (instead of 1 batch of 1,000) would cost the same as 50 batched — the issue is that individual queries are harder to track and more likely to be duplicate. Implement a query deduplication layer: before any DataForSEO call, check if the same query was already made for another niche (cross-niche keyword overlap detection).

**CONDITION 3 — The dead-host registry must be shared across niches, not per-niche.** G-012 identified 4 permanently dead hosts for automated fetchers. If each of 25 niches independently discovers linkedin.com is TOS-blocked, that's 25 wasted attempts. A shared, persistent registry avoids this.

**CONDITION 4 — No Firecrawl crawl without a prior `map`.** This single rule would have saved 50% of the waste in Phase 3's competitor site scraping. It costs 1 credit to discover all URLs, then 1 credit per relevant page. Crawling blindly costs 1 credit per irrelevant page too. Enforce at the pipeline level, not as guidance.

**CONDITION 5 — The strategic buffer (5,600 credits) may only be touched with documented justification.** This is the insurance fund. It should remain untouched through at least the first 10 niches. If it's consumed before niche 10, the budget model was wrong and the pipeline needs recalibration, not a bigger buffer.

**CONDITION 6 — Re-scrapes of the same URL must auto-detect and cache-hit.** The single most common waste pattern observed: fetching the same URL twice because two niches share a competitor, or because a verification pass re-fetches already-collected data. Implement a URL-content hash cache at the pipeline level. If a URL has been scraped in the last 7 days and the content hash matches, reuse the cached data at 0 credit cost.

### 6.3 Risk Table

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Fertility gate bypassed, all 25 niches get PREMIUM | Low (pipeline architecture prevents it) | **CRITICAL** — 3-5× budget overrun, DataForSEO exhausted by niche 8 | Code-level gate: niche score must be computed before tier escalation. Not configurable. |
| DataForSEO $50 exhausted before niche 15 | Medium (if batching fails) | **HIGH** — loss of primary SEO tool for remaining 10 niches | Implement batch queue + dedup layer. Fallback: free SERP tools for remaining niches (reduced quality). |
| Runaway crawl of large competitor site (10K+ pages) | Medium (one misconfigured crawl per session) | **HIGH** — 10,000+ credits lost in minutes | `map`-before-`crawl` rule enforced at pipeline level. Depth limit default: 3 pages. |
| Cross-niche URL cache not consulted | Medium (cache-busting failure mode) | **MEDIUM** — 10-20% credit waste on duplicate scrapes | Cache check before every scrape. Log cache-hit rate as a dashboard metric. |
| MCP server rate limits trigger retry loops | High (65+ MCP servers, unknown rate limits) | **LOW** (each failure costs only 1-2 credits, but blocks pipeline) | Implement exponential backoff with jitter. Kill switch at 5 consecutive failures. |
| Over-collection of VOC/pain-point data beyond 30 quotes per niche | Medium (the 80/20 trap) | **LOW** (only 30-60 credits wasted per niche) | Hard stop at 30 quotes per niche. Additional quotes must be explicitly requested. |

### 6.4 Final Assessment

**Verdict: APPROVED, subject to 6 conditions above.**

This architecture is the most cost-efficient design possible given the toolchain constraints. The key innovations that earn sign-off:

1. **Three-tier escalation** prevents the most common budget failure (running maximum depth on everything).
2. **`map`-before-`crawl`** is the single highest-ROI efficiency practice in the Firecrawl ecosystem — saving 10×+ on competitor site data collection.
3. **DataForSEO batching** within the $50 budget is tight but viable, and the fallback to free SERP tools is documented, not an afterthought.
4. **Learning curve savings** are modeled conservatively, and the strategic buffer absorbs the real learning curve risk (the calibration niche might need more than 6,000 credits).

The single non-negotiable failure mode is the fertility gate being bypassed. If that happens, every other efficiency measure is moot — the pipeline will consume 3-5× its budget without producing 3-5× the insight. The architecture should hard-code this gate at the orchestration layer, not trust it to process compliance.

**Signed:** Cost & Efficiency Auditor Lens
**Date:** 2026-07-23
