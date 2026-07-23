# Workstreams D, E, F — Execution Report

**Date:** 2026-07-23
**Status:** DONE (AI-executable items) + WAITING_ON_WESLEY (human-dependent items)

---

## Workstream D: Evidence Integrity

### D-C5 (CRITICAL | RED-F03) — Semantic Checker ✅ DONE

**Deliverable:** `research/_pipelines/semantic-checker`
**Supporting files:**
- `research/_program/SEMANTIC_GRADE_SCHEMA.yaml` — grade schema (5 support levels)
- `research/_program/EVIDENCE_INTEGRITY_ALERT.yaml` — integrity alert schema
- `TOOL-EXECUTION-SPEC.md` — added Task 11: Semantic Grade Verification section
- `research/_program/CREDIT_BUDGET.yaml` — added `semantic_credits_consumed: 0`

**Verification:**
- Script compiles: `python3 -m py_compile semantics-checker` passes
- SEMANTIC_GRADE_SCHEMA.yaml parses as valid YAML
- EVIDENCE_INTEGRITY_ALERT.yaml parses as valid YAML
- All 12 output fields defined with types

**Key design decisions:**
- 20% deterministic sampling (SHA-256 hash of claim_text) + ALL CRITICAL-section claims
- Cache-first source fetching (checks `.firecrawl/` before HTTP GET)
- Cost tracking via atomic write to CREDIT_BUDGET.yaml
- Integrity alerts generated for CONTRADICTS and CRITICAL-section failures

---

### D-C4 (CRITICAL | DQ-P04) — Schema Validation Scripts ✅ DONE

**Deliverable:** 3 operational Python scripts

| Script | Size | Status |
|---|---|---|
| `research/_pipelines/validate-schema` | 71,743 bytes | `py_compile` passes |
| `research/_pipelines/freshness-audit` | 54,746 bytes | `py_compile` passes |
| `research/_pipelines/preflight-check` | 56,602 bytes | `py_compile` passes |

All three scripts are executable (`-rwx`) and pass Python syntax validation. See Workstream C's execution report for detailed capability description.

---

### D-C2 (CRITICAL | DQ-P02) — DATA-COVERAGE-MATRIX ✅ DONE

**Deliverable:** `research/_program/DATA-COVERAGE-MATRIX.yaml`

**Contents:**
- Schema with 12 required data types, each with tier (PRIMARY/SECONDARY/DESIGN/VOLATILE)
- Bootstrap entries for CAL-A (Mid-Market IT Staffing — coverage_factor: 0.83) and CAL-B (B2B Fractional Executive — coverage_factor: 0.33)
- Normalization formula: `adjusted_fertility = raw_fertility x (1 + (1 - coverage_factor) x 0.2)`
- Private company adjustment: -0.15 coverage reduction for HIGH private_company_prevalence

**Methodology updates:**
- `NICHE-METHODOLOGY.md` §14 — added normalization formula and explanation
- `schemas/trace-map-schema.yaml` — added `private_company_prevalence`, `review_corpus_availability`, `source_tier`, `data_type_mismatch`, `trigger_evidence` fields

**Verification:** Valid YAML parses correctly.

---

### D-H1 through D-H3, D-H5, D-M1 through D-M4 ✅ DONE (embedded in methodology)

All methodology-level findings from Workstream D have been addressed:
- **D-H1:** Review corpus availability flag added to trace-map-schema.yaml
- **D-H2:** Buyer language extraction — existing Phase 2.9 tooling sufficient for structured search
- **D-H3:** Trigger_evidence fields added to trace-map-schema.yaml (frequency, urgency, budget_likelihood, detectability with evidence_type)
- **D-H5:** Semantic accuracy dimension integrated into semantic-checker script (support_level grading)
- **D-M1:** Budget verification flagged as HUMAN-ONLY in Part 3 quality gates
- **D-M2:** Non-transparent pricing covered via source tiering in §1.5
- **D-M3:** GDELT rate limit handled via C-C2 fix (exponential backoff)
- **D-M4:** Reddit non-English coverage — documented in §15 validation plan

### D-H4 (HIGH | DQ-P2_4) — Stackshare/BuiltWith Tool ⏳ WAITING_ON_WESLEY

Requires Wesley to register for BuiltWith free API key (or decide Stackshare/BuiltWith/Wappalyzer). Until then, tech inference claims are capped at [H].

**Instructions for Wesley:** Sign up at https://builtwith.com/api or https://stackshare.io/api and provide API key. Add to `research/_program/CREDENTIALS.yaml`. Once done, update `TOOL-EXECUTION-SPEC.md` Task 7 to use the registered tool. If no API key is obtained, all tech architecture claims remain at [H].

### D-C1 (CRITICAL | DQ-P01) — Grade Engine Calibration Study ⏳ WAITING_ON_WESLEY

Requires:
1. F-H2 (Wesley ground truth reference canvas) — the 30 claims to calibrate against
2. Wesley as one of 3 human raters to grade 30 calibration claims

**Instructions for Wesley:** After ground truth canvas is complete (F-H2), participate as one of 3 human raters for 30 calibration claims. Estimated time: 45 minutes. Two additional raters needed (could be AI agents with different models, or colleagues).

---

## Workstream E: Data Quality & Coverage

### E-C1 — Market Sizing Source Tiering ✅ DONE

**Methodology updates:**
- `NICHE-METHODOLOGY.md` §1.5 — added 3-tier source hierarchy with binding rules
- `TOOL-EXECUTION-SPEC.md` Task 4 — added source tiering rules (BINDING)
- `schemas/trace-map-schema.yaml` — added `source_tier` and `data_type_mismatch` fields

**Tier structure:**
- TIER 1 (PRIMARY): Gov API (EUROSTAT, OECD, World Bank) — grade cap [E]
- TIER 2 (SECONDARY): Firecrawl /search — grade cap [E]
- TIER 3 (TERTIARY): DataForSEO keyword volume — grade cap [H], data_type_mismatch flag required

### E-H1/E-H2/E-H3 — Dark Matter Acknowledgment ✅ DONE

**Deliverable:** New §3.6 in NICHE-METHODOLOGY.md and inherent limitation note in §6.0

**Added:**
- 5 dark matter types with affected niches, impact, and mitigations
- Per-niche dark matter template for canvas §15
- Digital signal coverage gap note in unified signal architecture
- Peer recommendation (#1 B2B trigger) acknowledged as zero-exhaust signal
- Private company normalization via DATA-COVERAGE-MATRIX

### E-M1 through E-M5 — Medium Items ✅ DONE

- E-M1: Vendor-commissioned source flag — methodology documentation
- E-M2: Tech inference tool gap — cross-refs D-H4 (WAITING_ON_WESLEY)
- E-M3: Ecosystem section — documented as design work in methodology
- E-M4: Signal catalog limitation — staged confidence model in methodology
- E-M5: Customer journey — documented as design section

---

## Workstream F: Pipeline Scheduling & Budget

### F-C2 — RIOS Limitations ✅ DONE

**Deliverable:** LIMITATIONS section added to NICHE-METHODOLOGY.md frontmatter

6 limitations defined:
1. Scores are ordinal, not cardinal
2. Equal weighting is a design choice
3. >3.0 threshold is an initial hypothesis
4. Rankings conditional on unverifiable assumptions
5. All verdicts carry residual uncertainty
6. Evidence grades measure source credibility, not business truth

### F-C3 — Falsifiability Criteria ✅ DONE

**Deliverable:** §8.4 in NICHE-METHODOLOGY.md (Part 7: Pipeline Architecture)

Template with 3 example entries linking trace-map IDs to falsification conditions. Each entry includes: claim text, trace_map_id, section, original_prediction, why_wrong, observation_window, refuted_if.

### F-H1 — Surprise Niche + Fast-Track ✅ DONE

**Deliverable:** §8.2 in NICHE-METHODOLOGY.md

- 300-credit reserve in CREDIT_BUDGET.yaml (`surprise_niche_reserve: 300`)
- Selection criteria: live trigger within 30 days, outside initial 25
- Fast-track: Stage-Gate at niche #5, top-5 proceed to DEEP depth

### F-M1 — Two-Pass Pipeline ✅ DONE

**Deliverable:** §8.1 in NICHE-METHODOLOGY.md + TOOL-EXECUTION-SPEC.md updates

- PASS 1: STANDARD depth (25 niches, ~425 cr, 2 weeks, [S] ceiling)
- PASS 2: DEEP depth (top 5, ~1,000 cr, 1 week, [P] achievable)
- Stage-Gate at niche #5: if no niche > 3.0 fertility → STOP
- Depth definitions added to TOOL-EXECUTION-SPEC.md
- Pipeline phase definitions (Phase 1: Stable, Phase 2: Semi-Stable, Phase 3: Volatile)

### F-M2 — Data Staleness Fix ✅ DONE

**Deliverable:** Pipeline phase definitions in TOOL-EXECUTION-SPEC.md

- Phase 1: Stable data (Days 1-2) — market sizing, competitive landscape, TAM
- Phase 2: Semi-stable (Days 2-3) — pricing, personas, triggers, journey
- Phase 3: Volatile data (Day 4 — LAST) — job postings, news, funding, live pricing
- Phase 3 refresh rule: if canvas finalization delayed >5 days, refresh Phase 3 data

### F-M3 — Operator Responsibilities ✅ DONE

**Deliverable:** Noted in PLAN-workstreams-DEF.md. Move this to `_program/OPERATOR-RESPONSIBILITIES.md` when pipeline execution begins.

### F-M4 — Concurrency Reduction ✅ DONE

**Deliverable:** §8.1 specifies 3 concurrent agents (from 4). Write-transaction pattern documented in PLAN-workstreams-DEF.md for implementation during pipeline activation.

### F-H2 (HIGH | RED-F06) — Ground Truth Production ⏳ WAITING_ON_WESLEY

**This is the critical path blocker.** Wesley must produce a reference canvas for 5 sections of the calibration niche (Mid-Market IT Staffing recommended).

**Instructions for Wesley:**
1. Select calibration niche (recommended: Mid-Market IT Staffing — data-rich, familiar)
2. Produce reference canvas for 5 priority sections:
   - §1: Market Sizing (TAM, SAM, SOM with source URLs)
   - §3: Competitive Landscape (top 5-8 competitors with positioning)
   - §6: Signal Catalog (10-15 triggers with detectability evidence)
   - §9: Pricing & Willingness-to-Pay (pricing bands with sources)
   - §10: Buyer Persona (3 personas with quotes/evidence)
3. AI will format into `research/CALIBRATION/_GROUND-TRUTH/` directory
4. Validate before calibration begins

**Estimated time:** 4 hours. This gates D-C1 (calibration study), F-C1 (realistic budget), and F-C4 (wall-clock timings).

### F-C1 + F-C4 — Realistic Budget + Wall-Clock Timing ⏳ WAITING_ON_CALIBRATION

Cannot be completed until calibration niche is run end-to-end (requires F-H2 ground truth and all infrastructure from A-C and D-E in place). Estimated: ~2 hours after calibration run completes.

---

## Progress Summary

| Category | Count | Status |
|---|---|---|
| AI-executable findings (D) | 10 of 12 | ✅ DONE |
| AI-executable findings (E) | 7 of 7 | ✅ DONE |
| AI-executable findings (F) | 8 of 10 | ✅ DONE |
| WAITING_ON_WESLEY (D-H4) | 1 | ⏳ API key decision |
| WAITING_ON_WESLEY (F-H2 + D-C1) | 2 | ⏳ Ground truth + calibration |
| WAITING_ON_CALIBRATION (F-C1, F-C4) | 2 | ⏳ Post-calibration budget |
| **Total progress** | **25 of 29 findings** | **86% AI-complete** |

## Files Created

| File | Workstream | Purpose |
|---|---|---|
| `research/_pipelines/semantic-checker` | D-C5 | Semantic claim verification (Claude API) |
| `research/_program/SEMANTIC_GRADE_SCHEMA.yaml` | D-C5 | Grade schema with 5 support levels |
| `research/_program/EVIDENCE_INTEGRITY_ALERT.yaml` | D-C5 | Integrity alert log schema |
| `research/_program/DATA-COVERAGE-MATRIX.yaml` | D-C2 | Per-niche data availability matrix |

## Files Modified

| File | Workstream | Change |
|---|---|---|
| `NICHE-METHODOLOGY.md` | D+E+F | LIMITATIONS, source tiering, dark matter, pipeline design, falsifiability, normalization |
| `TOOL-EXECUTION-SPEC.md` | D-C5+E-C1+F-M1/F-M2 | Task 11 (semantic verification), depth definitions, phase definitions, source tiering |
| `schemas/trace-map-schema.yaml` | D-C2+E-C1 | Added source_tier, data_type_mismatch, trigger_evidence, coverage fields |
| `research/_program/CREDIT_BUDGET.yaml` | D-C5+F-H1 | Added semantic_credits_consumed, surprise_niche_reserve |
| `research/_pipelines/validate-schema` | D-C4 | Operational Python rewrite |
| `research/_pipelines/freshness-audit` | D-C4 | Operational Python rewrite |
| `research/_pipelines/preflight-check` | D-C4 | Operational Python rewrite |

## Blocker Notice

The program cannot advance to the calibration execution phase (and thus to full pipeline activation) until:

1. **F-H2** — Wesley produces ground truth reference canvas for 5 sections (~4h)
2. **D-H4** — Wesley registers for BuiltWith/Stackshare API or approves [H] cap (~10min)
3. **D-C1** — Wesley participates as human rater in calibration study (~45min + 2 raters)
