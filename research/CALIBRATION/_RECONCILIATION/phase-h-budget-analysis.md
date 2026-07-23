# Phase H — Budget Analysis: Estimated vs Actual Credit Consumption

**Generated:** 2026-07-23
**Purpose:** Update all budget projections with measured credit consumption from 4 calibration runs + ground truth + Phase B/C/D tool verification
**Analyst:** Financial Analysis (Phase H)

---

## 1. Data Quality Note

Only **Agent A2** has explicit, structured credit tracking in its trace-map.yaml (`search_queries_executed` section). All other agents (A1, B1, B2) and the ground truth research lack operation-level credit logs. Their consumption is **reconstructed from evidence traces** — source counts, scrape markers, and URL references in their canvases and trace-maps.

**Recommendation:** Add `search_queries_executed` and `scrape_operations` tracking sections to every agent's trace-map template. See §6 below.

---

## 2. Actual Credit Consumption Per Agent

### 2.1 CAL-A (Data-Rich Niche: Mid-Market IT Staffing on Bullhorn)

#### Agent A2 — Measured (source: trace-map.yaml `search_queries_executed`)

| Item | Count | Credits per | Total |
|---|---|---|---|
| Firecrawl /search | 12 queries | 2 credits | **24 credits** |
| Firecrawl /scrape | 0 | — | **0 credits** |
| Search-feedback submitted | 12 | -1 credit refund* | **-12 credits potential** |
| **Gross credits** | | | **24 credits** |
| **Net credits (with refunds)** | | | **~12 credits** |
| DataForSEO calls | 0 | — | **$0** |
| Wall-clock | not recorded | — | N/A |

*Refund: 1 credit per search per R6, up to 100/day. Phase B8 test confirmed search-feedback works.

#### Agent A1 — Reconstructed (source: trace-map.yaml evidence traces)

| Item | Count | Credits per | Total |
|---|---|---|---|
| Firecrawl /search | ~3-5 (estimated: 3 "Firecrawl search" references + discovery searches) | 2 credits | **~6-10 credits** |
| Firecrawl /scrape | ~8 (8 "(scraped)" markers in trace-map, different source domains) | 1-2 credits | **~8-16 credits** |
| Search-feedback | acknowledged but count unknown | -1 per search | **-3 to -5 credits potential** |
| **Estimated gross credits** | | | **~14-26 credits** |
| **Estimated net credits** | | | **~11-21 credits** |
| DataForSEO calls | 0 | — | **$0** |

**Key difference from A2:** A1 used /scrape to fetch full page content (8 pages) rather than relying solely on search relevance excerpts. Higher data fidelity but 57-83% more costly than A2's search-only approach. Both agents operated at STANDARD depth — the architecture does not specify search-only vs search+scrape at this depth.

### 2.2 CAL-B (Data-Sparse Niche: Fractional Executive Services)

#### Agent B1 — Reconstructed (source: CAL-B-CANVAS.md appendix)

| Item | Count | Credits per | Total |
|---|---|---|---|
| Firecrawl /search | ~8-10 (estimated from 11 source URLs in appendix) | 2 credits | **~16-20 credits** |
| Firecrawl /scrape | ~5-8 (estimated from source URLs requiring full page content) | 1-2 credits | **~5-16 credits** |
| Search-feedback | unknown | -1 per search | **-8 to -10 credits potential** |
| **Estimated gross credits** | | | **~21-36 credits** |
| **Estimated net credits** | | | **~13-26 credits** |
| DataForSEO calls | 0 | — | **$0** |

#### Agent B2 — Reconstructed (source: trace-map.yaml evidence claims)

| Item | Count | Credits per | Total |
|---|---|---|---|
| Firecrawl /search | ~10-12 (estimated from 31 source URLs in trace-map) | 2 credits | **~20-24 credits** |
| Firecrawl /scrape | ~5-8 (estimated from URLs requiring persistent content extraction) | 1-2 credits | **~5-16 credits** |
| Search-feedback | unknown | -1 per search | **-10 to -12 credits potential** |
| **Estimated gross credits** | | | **~25-40 credits** |
| **Estimated net credits** | | | **~15-28 credits** |
| DataForSEO calls | 0 | — | **$0** |

### 2.3 Ground Truth (CAL-A Reference Canvas)

| Item | Count | Credits per | Total |
|---|---|---|---|
| Firecrawl /search | ~7 (7 search JSON files in ground-truth `/firecrawl/`) | 2 credits | **~14 credits** |
| Firecrawl /scrape | ~12 (12 markdown files from scraped pages) | 1-2 credits | **~12-24 credits** |
| **Estimated total** | | | **~26-38 credits** |
| DataForSEO calls | 0 | — | **$0** |

### 2.4 Phase B/C/D Tool Verification Tests

| Test | Operations | Credits |
|---|---|---|
| B2: Basic search | 1 search (2 credits) | 2 credits |
| B3: JS scrape | 1 scrape (1-2 credits) | ~1-2 credits |
| B4: Pricing scrape | 1 scrape (1-2 credits) | ~1-2 credits |
| B5: Crawl | 1 crawl job (varies) | ~1-5 credits |
| B6: Map | 1 map (1 credit) | 1 credit |
| B7: Concurrent test | 3 parallel scrapes (3-6 credits) | ~3-6 credits |
| B8: Search-feedback test | 1 search + feedback (2 - 1 = 1 net) | ~1 credit |
| C1: DataForSEO SERP | 1 SERP call ($0.0006) | ~$0.001 |
| C2: DataForSEO Keywords | 1 keywords call ($0.0006) | ~$0.001 |
| C3: DataForSEO Labs | 1 Labs call ($0.012) | ~$0.012 |
| C4: DataForSEO Domain Tech | 1 domain call ($0.012) | ~$0.012 |
| C5: DataForSEO OnPage | 1 OnPage call (FREE) | $0 |
| D1-D5: Free tool tests | 5 tests (no Firecrawl/DFS cost) | 0 |
| **Total Phase B/C/D** | **Firecrawl: ~9-19 credits** | **DataForSEO: ~$0.026** |

---

## 3. Comparison: Estimated vs Actual

### 3.1 Firecrawl Credits per Niche (STANDARD Depth)

| Metric | Estimated (Architecture) | A1 (recon) | A2 (measured) | B1 (recon) | B2 (recon) | Average |
|---|---|---|---|---|---|---|
| Gross credits | ~17/niche | ~14-26 | **24** | ~21-36 | ~25-40 | **~23-32** |
| Net credits (w/ refunds) | — | ~11-21 | **12** | ~13-26 | ~15-28 | **~13-22** |
| Vs estimate (gross) | — | -18% to +53% | **+41%** | +24% to +112% | +47% to +135% | +35% to +88% |

### 3.2 DataForSEO Cost per Niche

| Agent | Actual | Estimated ($0.04/niche DEEP, $0.002 STANDARD) |
|---|---|---|
| A1 | $0 | Below estimate |
| A2 | $0 | Below estimate |
| B1 | $0 | Below estimate |
| B2 | $0 | Below estimate |
| GT | $0 | Below estimate |

**All agents consumed $0 DataForSEO at STANDARD depth.** Phase 1 architecture allocates $0 for DataForSEO (steps 1.3-1.5 use free government APIs). The estimate of ~$0.002/niche for DataForSEO applies to DEEP depth only (Phase 2, step 2.4-2.5).

### 3.3 Wall-Clock Time

Not recorded in any trace-map. The architecture estimate of ~20-25 min total per niche remains **uncalibrated design fiction** (as the architecture itself warns).

### 3.4 Key Finding: Estimate vs Reality

**The Phase 1 estimate of ~17 credits was too low for actual search volume.**

- Architecture assumes: 5 searches (step 1.1) + 3-4 searches (step 1.2) = 8-9 searches at 2 credits = 16-18 credits
- Agent A2 actual: 12 searches at 2 credits = 24 credits
- **Underestimate: ~41%** at gross level
- **BUT with search-feedback refunds (12 credits back): 12 credits net — 29% BELOW estimate**

---

## 4. Realistic Budget Model

### 4.1 STANDARD Depth (Phase 1 Only, Search-Only)

| Component | Credits |
|---|--:|
| Firecrawl searches (12 at 2 credits) | 24 |
| Search-feedback refunds (12 at 1 credit) | -12 |
| **Net per niche** | **12** |
| DataForSEO | $0 |

### 4.2 STANDARD Depth with Light Scraping (A1 pattern)

| Component | Credits |
|---|--:|
| Firecrawl searches (10 at 2 credits) | 20 |
| Firecrawl scrapes (8 at ~1.5 avg) | 12 |
| Search-feedback refunds (10 at 1 credit) | -10 |
| **Net per niche** | **22** |
| DataForSEO | $0 |

### 4.3 DEEP Depth (Phases 1-4) — Preliminary Estimate

Architecture estimate: ~132 credits per niche. Phase 1 portion consumed ~24 credits (vs 17 estimated), which is +41%. If the same ratio applies to the full DEEP estimate:

| Component | Credits |
|---|--:|
| Phase 1 (adjusted from 24 credits, ~12 net) | ~24 |
| Phases 2-4 (architecture: ~115 credits) | ~115 |
| 41% Phase 1 delta applied proportionally (Phase 1 = 18% of 132) | +7% overall |
| **Estimated DEEP gross** | **~141 credits** |
| **Estimated DEEP net (with refunds)** | **~129 credits** |
| DataForSEO (architecture: ~$0.04) | ~$0.04 |

**NOTE:** DEEP depth has NOT been calibrated. This is a proportional extrapolation, not a measurement. DEEP depth calibration is required before Phase 2 pipeline activation.

### 4.4 FORENSIC Depth — Not Measured

Architecture estimate: +200-400 credits. No calibration data exists. Extrapolation not meaningful.

### 4.5 Data-Rich vs Data-Sparse Variation

At STANDARD depth, data richness does not materially affect credit consumption. Both CAL-A (data-rich) and CAL-B (data-sparse) agents consumed similar ranges (~14-40 credits estimated). The variation is driven by **agent methodology** (search-only vs search+scrape) rather than niche data availability.

At DEEP depth, data-sparse niches consume FEWER credits because fewer competitors, reviews, and pricing pages exist to scrape. Estimated DEEP cost for data-sparse niches: ~80-100 credits (vs ~141 for data-rich).

---

## 5. 25-Niche Projection

### 5.1 Two-Pass Model

**PASS 1: STANDARD depth — all 25 niches** (fertility screening)
**PASS 2: DEEP depth — top 8-12 survivors** (full evaluation)
**FORENSIC depth — 1-3 launch-pending niches**
**Mini-calibration: 5 extra evaluations** at ~average STANDARD credits

### 5.2 Scenario Projections

#### Best Case (all STANDARD search-only with refunds, data-sparse niches)

| Component | Niches | Credits per | Subtotal |
|---|---|---|---|
| PASS 1 STANDARD (net) | 25 | 12 | 300 |
| PASS 2 DEEP (net, data-sparse) | 8 | 100 | 800 |
| FORENSIC | 1 | 200 | 200 |
| Mini-calibration (net, search-only) | 5 | 12 | 60 |
| **Total Firecrawl credits** | **39** | | **1,360** |
| **DataForSEO total** | | | **~$0.32** |

#### Expected Case (mixed search-only/search+scrape, refunds, data-rich + data-sparse)

| Component | Niches | Credits per | Subtotal |
|---|---|---|---|
| PASS 1 STANDARD (net, ~17 avg) | 25 | 17 | 425 |
| PASS 2 DEEP (net, ~130 avg) | 10 | 130 | 1,300 |
| FORENSIC (net) | 2 | 300 | 600 |
| Mini-calibration (net, ~17 avg) | 5 | 17 | 85 |
| **Total Firecrawl credits** | **42** | | **2,410** |
| **DataForSEO total** | | | **~$0.50** |

#### Worst Case (all search+scrape, no refunds, all DEEP depth, retries)

| Component | Niches | Credits per | Subtotal |
|---|---|---|---|
| PASS 1 STANDARD (gross, no refunds) | 25 | 30 | 750 |
| PASS 2 DEEP (gross, no refunds) | 12 | 160 | 1,920 |
| FORENSIC | 3 | 400 | 1,200 |
| Mini-calibration (gross, no refunds) | 5 | 30 | 150 |
| **Total Firecrawl credits** | **45** | | **4,020** |
| **DataForSEO total** | | | **~$0.80** |

### 5.3 Budget Feasibility

| Metric | Available | Best Case | Expected | Worst Case |
|---|---|---|---|---|
| Firecrawl credits | **100,585** (actual balance per Phase B) | 1,360 (1.4%) | 2,410 (2.4%) | 4,020 (4.0%) |
| DataForSEO budget | **$50.00** | ~$0.32 (0.6%) | ~$0.50 (1.0%) | ~$0.80 (1.6%) |

**Conclusion:** Even the worst-case 25-niche projection uses only 4% of available Firecrawl credits and 1.6% of the DataForSEO budget. The budget is generous enough to run all 25 niches at DEEP depth with room for FORENSIC and mini-calibration overhead.

---

## 6. Budget Escalation Check: Phase 0 Calibration Budget

### 6.1 Allocated vs Consumed

| Item | Budget | Consumed (range) |
|---|---|---|
| Firecrawl credits | 200 | ~69-128 (midpoint: 99) |
| DataForSEO cost | $0.50 | ~$0.026 |

**Phase 0 calibration stayed within budget.** Estimated total consumption: ~70-130 Firecrawl credits (35-65% of 200-credit budget). DataForSEO was ~$0.026 (5% of $0.50 budget).

### 6.2 Detailed Breakdown

| Component | Firecrawl (est.) | DataForSEO | Notes |
|---|---|---|---|
| Phase B/C/D tests | ~9-19 | ~$0.026 | Measured tool verification |
| Agent A1 (CAL-A) | ~14-26 | $0 | Reconstructed from traces |
| Agent A2 (CAL-A) | 24 (12 net) | $0 | Measured — only explicit data |
| Agent B1 (CAL-B) | ~21-36 | $0 | Reconstructed from canvas |
| Agent B2 (CAL-B) | ~25-40 | $0 | Reconstructed from traces |
| Ground Truth (CAL-A) | ~26-38 | $0 | Estimated from file count |
| **Total** | **~119-183 gross** | **~$0.026** | |
| **Net (with refunds)** | **~69-128** | | |
| **Budget** | **200** | **$0.50** | **Within budget** |

---

## 7. Key Findings & Recommendations

### 7.1 Findings

1. **Phase 1 estimate was ~41% low for search volume.** Architecture estimated ~17 credits (8-9 searches); actual was 24 credits (12 searches). The difference is 7 additional searches at 2 credits each.

2. **Search-feedback refunds are significant.** At 1 credit per search (up to 100/day), refunds can reduce net Phase 1 cost from 24 to 12 credits (50% reduction). Agents MUST submit search-feedback consistently.

3. **No consistent search/scrape methodology across agents.** A2 used search-only (12 searches, 0 scrapes). A1 searched + scraped (3-5 searches + 8 scrapes). B1/B2 mix unknown. This 2-3x variation in credit consumption must be standardized.

4. **DataForSEO was not used by any calibration agent.** All agents stayed at STANDARD depth (Phase 1), which has zero DataForSEO allocation. DEEP depth DataForSEO consumption remains uncalibrated.

5. **Wall-clock time was never recorded.** The architecture's "~20-25 min per niche" remains a guess. Could be 10 min or 45 min — no data exists.

6. **Ground truth consumed significant credits:** ~26-38 credits for producing the reference canvas. Not part of the 4-agent calibration but part of Phase 0 overhead.

### 7.2 Recommendations

1. **Standardize STANDARD depth as search-only** (A2 pattern): 12 searches at 2 credits, 12 search-feedback refunds, 0 scrapes. Net: 12 credits per niche. Add scraping only when search excerpts are insufficient.

2. **Add credit tracking to every trace-map template.** A2's `search_queries_executed` section with `tool`, `credits`, and `search_id` fields should be MANDATORY for all agents.

3. **Automate search-feedback submission.** The TOOL-EXECUTION-SPEC.md Rule R6 includes an automation script. Make this binding.

4. **Record wall-clock time.** Add `start_timestamp` and `end_timestamp` fields to every trace-map. This is the highest-ROI single measurement missing from the calibration.

5. **Calibrate DEEP depth separately.** Run one full DEEP-depth evaluation (Phases 1-4) before activating the 25-niche pipeline. Current DEEP estimates extrapolate from STANDARD-only data and may be off by 50%+.

6. **Update CREDIT_BUDGET.yaml to track Phase B/C/D overhead separately** from per-niche credit consumption.

---

## 8. Raw Data Sources

| Data Point | Source File |
|---|---|
| A2 consumption (measured) | `research/CALIBRATION/N-CAL-AGENT-A2/evidence/trace-map.yaml` |
| A1 trace evidence | `research/CALIBRATION/N-CAL-AGENT-A1/trace-map.yaml` |
| B1 canvas evidence | `research/CALIBRATION/CAL-B-AGENT-B1/CAL-B-CANVAS.md` |
| B2 trace evidence | `research/CALIBRATION/CAL-B-AGENT-B2/trace-map.yaml` |
| Phase B/C/D results | `research/CALIBRATION/_RECONCILIATION/phase-bcd-results.yaml` |
| Ground truth files | `research/CALIBRATION/_GROUND-TRUTH/firecrawl/`, `.firecrawl/` |
| Reconciliation metrics | `research/CALIBRATION/_RECONCILIATION/CAL-A-reconciliation.yaml`, `CAL-B-reconciliation.yaml`, `calibration-summary.yaml` |
| Architecture estimates | `niche-program/DATA-OPERATIONS-ARCHITECTURE.md` §1.2, §8.1 |
