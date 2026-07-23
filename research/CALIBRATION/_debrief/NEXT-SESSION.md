# NEXT SESSION: N-021 Benelux Scale-ups — Niche Evaluation

**Written:** 2026-07-23 (Phase 0 closeout — calibration complete, pipeline operational)

---

## Session Objective

Evaluate **N-021: Benelux Scale-ups (50–500 Employees, VC-Backed)** — the #4 ranked niche, Bob's HIGHEST-access network. Produce a complete 15-section Niche Canvas with evidence trace-map at STANDARD depth.

**Why N-021 first:**
- Bob knows founders personally at dozens of Benelux scale-ups — warmest access of any niche
- HubSpot-native (early-stage) or Salesforce (post-Series B) — both GREEN/YELLOW platforms
- "We just raised EUR 10M and our board wants to see pipeline" — acute, budgeted pain
- Tests the VC-backed scale-up thesis: do post-funding companies buy revenue intelligence?

---

## Context Pack (load in this order, ~5 min)

### 1. Current State (REQUIRED)
- `niche-program/NICHE-REGISTRY.md` — N-021 definition, rationale, access/data assessment
- `niche-program/NICHE-METHODOLOGY.md` — 15-section canvas specification. Note NEW sections:
  - §1.5a: Platform Risk Assessment (BINDING — check API ToS before CRM-native scoring)
  - §1.5b: CRM-Agnostic Delivery (3-tier default architecture)

### 2. Tool Execution (REQUIRED)
- `niche-program/TOOL-EXECUTION-SPEC.md` — 12 binding rules, 11 tasks, error recovery, evidence grading
  - R12: Evidence Grading Quick Reference — FIXES systematic [E]→[H] downgrade
  - R11: Content validation — cookie wall, login wall, bot challenge detection

### 3. Agent Instructions (REQUIRED)
- `niche-program/AGENT-CONTEXT-SPEC.md` — per-phase loading, Phase 1 context budget ~40K tokens

### 4. Calibration Results (REFERENCE)
- `niche-program/research/CALIBRATION/_RECONCILIATION/calibration-summary.yaml` — inter-rater reliability metrics
- `niche-program/research/CALIBRATION/_RECONCILIATION/phase-h-budget-analysis.md` — measured credit consumption
  - STANDARD depth: 12-26 net credits per niche
  - DEEP depth: NOT YET MEASURED (~132 estimated)

### 5. Reference Docs (ONLY IF TOOL-EXECUTION-SPEC.md doesn't cover the use case)
- `niche-program/references/firecrawl-comprehensive-reference.md`
- `niche-program/references/data-sources-reference.md`
- `niche-program/references/SME-tool-reference-expansion.md`

---

## Phase 1: Niche Bounding (~40 min)

**Goal:** Confirm N-021 exists as a viable niche. Find ≥50 searchable companies OR ≥1 analyst report OR data accessibility GREEN.

**Key questions to answer:**
1. How many VC-backed scale-ups (50-500 emp, Series A/B in last 24 months) are in Benelux?
2. Which CRMs do they use? (expected: HubSpot early, Salesforce post-Series B)
3. What's the average tool budget at these companies?
4. Do they have a named RevOps function or is it founder-led?
5. Are there competitors selling revenue intelligence to this segment?

**Tools:** Firecrawl search (R1: search before scrape), Dealroom.co / Crunchbase for funding data, Companies House / OpenRegistry for company verification

**Budget:** ~17 credits (STANDARD depth, Phase 1 only)

---

## Phase 2: Deep Research (~60 min)

**Goal:** Gather competitive intelligence, buyer language, pricing data, and trigger signals.

**Key data to collect:**
- Competitor landscape: who sells pipeline visibility to VC-backed scale-ups?
- Buyer language: Reddit (r/saas, r/startups), LinkedIn posts from scale-up founders
- Pricing benchmarks: what do scale-ups pay for sales/RevOps tools?
- Trigger signals: funding rounds, office expansion, C-suite hires, new market entry

**Context budget:** 45K tokens (reduced from 60K — TOOL-EXECUTION-SPEC.md saves 15K)

---

## Phase 3-4: Commercial Design + Canvas Assembly (~45 min)

**Goal:** Design the complete commercial system and produce the 15-section canvas.

**CRM strategy (from §1.5b):**
- Tier 1 (Dashboard/Email/Slack): DEFAULT for all scale-ups
- Tier 2 (CRM-Native): HubSpot-native available immediately (GREEN platform)
- Tier 3 (CRM-Native Partnership): Salesforce if needed (YELLOW — may need enterprise agreement)

**Pricing (from calibration):**
- Optimal market price: EUR 1,800-2,200/mo
- Gapstars-specific: EUR 2,950/mo (NOT the market price)

---

## Platform Risk Assessment (BINDING — §1.5a)

Before scoring RIOS, check BOTH platforms:
1. **HubSpot API ToS:** Read HubSpot Developer Terms. Expected: GREEN (open API, no AI restrictions, 250K req/day). Verify.
2. **Salesforce API ToS:** Read Salesforce API Terms. Expected: YELLOW (may need enterprise agreement). Verify.

---

## Key Calibration Lessons (do NOT repeat these mistakes)

1. **Evidence grading (R12):** [E] = ANY single source with a URL. One Firecrawl scrape is enough. Do NOT downgrade to [H] because "I only found one source."
2. **Platform risk (R13):** Read the CRM's API fair use policy BEFORE scoring. A1 missed Bullhorn's policy and was off by +1.15 RIOS.
3. **Pricing:** EUR 2,950 is Gapstars-specific. For N-021, find scale-up-specific pricing anchors.
4. **CRM-agnostic first:** Default to Tier 1 delivery. CRM-native is an upsell, not the base product.

---

## MCP Servers Available (6 total)

| Server | Use |
|---|---|
| paperplain | Academic papers (200M+) |
| reddit-research | VOC from r/saas, r/startups |
| financial-hub | SEC EDGAR for any US-public scale-ups |
| dataforseo | SERP, Keywords, Labs API |
| context7 | Official API docs lookup |
| openregistry | Company registry (NL KVK, UK CH, etc.) |

---

## Budget Tracking

- Firecrawl: 100,585 credits available (Phase 0 used ~70-128)
- DataForSEO: ~$50 deposited (~$0.026 used in calibration)
- Per-niche budget (STANDARD): ~17 credits Phase 1 + ~10-20 credits Phase 2 = ~27-37 credits
- Search-feedback: reclaim 1 credit per search (R6 — BINDING)

---

## Success Criteria

After this session, N-021 should have:
- [ ] Complete 15-section canvas with evidence trace-map
- [ ] RIOS score with sub-dimension breakdown
- [ ] Verdict: LAUNCH PENDING / VALIDATE FIRST / NO-GO
- [ ] All claims graded [E/P/H/S] per R12
- [ ] Platform risk assessment for HubSpot and Salesforce
- [ ] CRM delivery tier assignment
- [ ] Credit consumption measured and logged
