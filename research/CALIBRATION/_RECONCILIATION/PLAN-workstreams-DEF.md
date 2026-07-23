# Workstreams D, E, F — Execution Plan

**Program Manager:** McKinsey-style remediation sequencing
**Spec Reference:** `TOOL-LANDSCAPE-FIX-SPEC-COMPLETE.md` Workstream D (§D), Workstream E (§E), Workstream F (§F)
**Date:** 2026-07-23
**Total D+E+F effort:** ~19.5 hours (D: ~11.5h, E: ~1.5h, F: ~6.5h)
**Human-dependent items:** 2 (F-H2: Wesley ground truth; G-C1: Wesley FRED removal)

---

## Executive Dependency Summary

```
WORKSTREAM A (MCP Config) ───┐
WORKSTREAM B (Agent Instr.) ──┤
WORKSTREAM C (Reliability)  ──┤
                              │
                              ▼
                    WORKSTREAM D ═══╗
                    (Evidence Integrity)  ← D-C5 needs B (TOOL-EXECUTION-SPEC grade engine interface)
                                           ← D-C4 needs C (preflight-check + shared infra)
                                           ← D-C1 needs F-H2 (ground truth canvas)
                                           ← D-H4 needs A (MCP or API key for Stackshare)
                              ║
                              ▼
                    WORKSTREAM E ═══╗
                    (Data Quality)     ← E-C1 needs D-C2 (DATA-COVERAGE-MATRIX normalization)
                                           ← E-H3 needs D-C2 (coverage flag integration)
                                           ← All others are standalone methodology docs
                              ║
                              ▼
                    WORKSTREAM F ═══╗
                    (Pipeline Sched.) ← F-C1 needs D-C5 (semantic checker actual cost)
                                           ← F-C4 needs C-H8 (calibration niche actual timings)
                                           ← F-H2 is PREREQUISITE for D-C1, F-C1, F-C4
                                           ← F-M4 needs C-C4 (concurrency lock existence)
                              ║
                              ▼
                        CALIBRATION EXECUTION
                              ║
                              ▼
                    WORKSTREAM G (Security)
                    (Parallel, independent — but G-C1/G-H2 are URGENT DO FIRST)
```

### What MUST complete from A/B/C before D/E/F can start

| Workstream D Dependency | Depends On | Why |
|---|---|---|
| D-C5 Semantic checker | Workstream B (grade engine I/O protocol in TOOL-EXECUTION-SPEC.md) | Agents need defined interface for submitting claims + receiving grades |
| D-C4 Schema validation scripts | Workstream C (preflight-check, shared infra, _program/ infra) | Scripts integrate with preflight-check; need _program/ structure in place |
| D-C1 Calibration study | Workstream F-H2 (ground truth canvas) | Cannot calibrate engine without ground truth reference |
| D-H4 Stackshare tool | Workstream A (MCP config for Stackshare or BuiltWith API) | Needs API key registered in credentials |

| Workstream E Dependency | Depends On | Why |
|---|---|---|
| E-C1 Market sizing guidance | Workstream D-C2 (DATA-COVERAGE-MATRIX.yaml schema) | Methodology references normalization factors |
| E-H3 Private company dark matter | Workstream D-C2 (coverage flag normalization) | Needs coverage flag infrastructure to integrate |

| Workstream F Dependency | Depends On | Why |
|---|---|---|
| F-C1 Realistic budget | Workstream D-C5 (semantic checker actual cost per claim) | Budget must include semantic verification line item |
| F-C4 Per-niche timing | Workstream C-H8 (calibration niche actual timings) | Wall-clock estimates must come from real run |
| F-H2 Ground truth | **HUMAN (Wesley)** — no AI dependency | Wesley produces reference canvas; everything else blocks on this |
| F-M4 Concurrency reduction | Workstream C-C4 (_CONCURRENCY_LOCK.yaml) | Write-transactions need lock infrastructure in place |

---

# WORKSTREAM D: Evidence Integrity (12 findings, ~11.5 hours)

**Files to create:** 7 new files
**Files to edit:** 6 existing files
**AI-executable:** 10 of 12 findings
**Human-required:** 2 (D-C1 calibration study needs Wesley for human raters; D-H4 needs Wesley to register API key)
**Critical path:** F-H2 (ground truth) -> D-C1 (calibration) -> D-C5 (semantic checker)

---

## D-C1 (CRITICAL | DQ-P01) — Grade Engine Calibration Study

**Description:** Grade engine has 16/16 truth-table combos that work mathematically, but has NEVER been calibrated against human judgment. Alignment with actual human evaluators is unknown.

**Fix:** Run calibration study: 3 human raters grade 30 claims from calibration niche. Compare vs deterministic engine. Adjust criteria where disagreement >20%. Target Cohen's Kappa >= 0.61.

**Dependencies:**
- MUST have F-H2 complete (Wesley's ground truth reference canvas for calibration niche — defines what "correct" grades should be)
- MUST have calibration niche run (Workstream C-H8 or directly before calibration)
- MUST have 30 claims extracted with source URLs from calibration niche

**Execution Sequence:**
```
Step 1: Extract 30 claims from calibration niche canvas (5 sections × 6 claims each)
Step 2: Prepare claim grading sheet with: claim_text, source_url, evidence_file_hash
Step 3: Run grade engine on all 30 claims → produce engine_grades.json
Step 4: Wesley + 2 raters independently grade same 30 claims → human_grades.csv
Step 5: Compute inter-rater reliability (Fleiss' Kappa) across all 3 humans
         → Target: Fleiss' Kappa >= 0.61
Step 6: Compute engine-vs-consensus agreement per claim
         → Flag claims where engine disagrees with >2 humans
Step 7: Adjust grade criteria where disagreement >20%
         → Typically: source_authority, recency thresholds, source_proximity weights
Step 8: Re-run engine on same 30 claims → verify Kappa >= 0.61
Step 9: Document results in _program/GRADE_ENGINE_CALIBRATION_REPORT.yaml
```

**Human input (Wesley):**
- Act as one of 3 human raters on 30 claims (~45 min)
- Recruit 2 additional raters (could be AI agents with different model, or colleagues)

**AI-executable:**
- Steps 1-2: Extract claims from calibration niche canvas (CLAIMED_FACTS from trace-map, all A-D grade AND NOT_SOURCE_UNAVAILABLE)
- Step 3: Run grade engine → produce engine_grades.json
- Steps 5-8: Compute kappa, flag disagreements, adjust criteria
- Step 9: Write calibration report

**Verification Gate D-G1:** Cohen's Kappa >= 0.61 for all rater pairs. Calibration report on disk.

---

## D-C2 (CRITICAL | DQ-P02) — DATA-COVERAGE-MATRIX Normalization

**Description:** No normalization for data availability across niches. Non-IT niches systematically under-scored because they have less digital exhaust, not because they're worse opportunities.

**Fix:** Implement DATA-COVERAGE-MATRIX.yaml with per-niche data availability scoring. Calculate normalization factor for fertility ranking.

**Dependencies:**
- Must understand the 25-niche list (from NICHE-REGISTRY.md or similar)
- Must understand what data types each section requires (from NICHE-METHODOLOGY.md)

**Execution Sequence:**
```
Step 1: Define schema for DATA-COVERAGE-MATRIX.yaml
        └── per-niche: data_type -> { available: bool, sources: [str], quality: A-E, note: str }
        └── normalization: { raw_score, coverage_factor, adjusted_score }
Step 2: Create _program/DATA-COVERAGE-MATRIX.yaml
        └── Include all 15 canvas sections
        └── For each section: list required data types (market size, competitors, VOC, etc.)
Step 3: Bootstrap with calibration niche (full manual assessment of what's available)
Step 4: Define coverage factor formula:
        └── coverage_factor = available_data_types / total_required_data_types
        └── adjusted_fertility = raw_fertility * (1 + (1 - coverage_factor) * 0.2)
        └── This prevents data-sparse niches from being unfairly penalized
Step 5: Document normalization in NICHE-METHODOLOGY.md §14 (Fertility Scoring)
```

**Human input:** None if methodology already defines required data types per section. If not, Wesley must clarify.

**AI-executable:** Steps 1-5 entirely. Step 3 requires reading calibration niche canvas.

**Verification Gate D-G4:** DATA-COVERAGE-MATRIX.yaml populated for calibration niche with schema ready for all 25.

---

## D-C3 (CRITICAL | DQ-P03) — Fabrication Detection Verifier

**Description:** Independent verifier cannot detect interpretation fabrication. Re-fetching URL + hash comparison only checks "URL exists", not "source supports the claim." A fabricated claim with a real URL passes all 4 binary checks.

**Fix:** Extend verifier: independently extract the specific claim from fetched content. Compare against trace-map's structured data field.

**Dependencies:**
- Must be coordinated with D-C5 (semantic checker) — D-C3 is the verification-layer complement to D-C5's evaluation-layer fix
- trace-map schema must support `extracted_claim_text` and `verifier_claim_text` fields

**Execution Sequence:**
```
Step 1: Extend trace-map schema (trace-map-schema.yaml) to add:
        └── claim_text: str (the exact assertion being made, not just the data value)
        └── verifier_extracted_text: str (populated by verifier — what it found)
        └── verifier_verdict: SUPPORTED | PARTIALLY_SUPPORTED | NOT_SUPPORTED | SOURCE_UNAVAILABLE
        └── verifier_timestamp: datetime
Step 2: Create _pipelines/evidence-verifier (Python script):
        └── For each claim-grade pair in evidence-grades.json:
        └── Read claim_text and source_url from trace-map
        └── Fetch source content (using cached .firecrawl/ data first)
        └── Search for claim_text in fetched content (fuzzy match)
        └── If found → SUPPORTED
        └── If partially found → PARTIALLY_SUPPORTED
        └── If not found → NOT_SUPPORTED → trigger EVIDENCE_INTEGRITY_ALERT
        └── If 404/removed → SOURCE_UNAVAILABLE
Step 3: Define alert threshold: >20% NOT_SUPPORTED → flag canvas for human review
Step 4: Write EVIDENCE_INTEGRITY_ALERT entries to TOOL_ERROR_LOG.yaml
Step 5: Integrate with grade engine post-processing pipeline (post-grade step)
```

**Human input:** None for implementation. If verifier flags >20% NOT_SUPPORTED, that's a human review trigger.

**AI-executable:** Steps 1-5 entirely. The fuzzy matching can use simple string overlap + key-phrase extraction (no LLM needed per claim — this is the cheap counterpart to D-C5's expensive semantic check).

**Verification Gate D-G7:** evidence-verifier script exists. EVIDENCE_INTEGRITY_ALERT protocol documented. TOOL_ERROR_LOG.yaml receives alerts.

---

## D-C4 (CRITICAL | DQ-P04) — Schema Validation Scripts

**Description:** Schema validation scripts (validate-schema.sh, freshness-audit.sh, preflight-check.sh) are DRAFT — not operational. Manual fallbacks will fail under 25-niche concurrency.

**Fix:** Implement all three Python scripts before any niche evaluation.

**Dependencies:**
- Workstream C's preflight-check.sh must exist as a working script (C-C8 already creates this)
- YAML schemas must define what "valid" means (trace-map-schema.yaml, canvas-frontmatter-schema.yaml, etc.)
- Shared test framework must exist (test/ directory in _pipelines/)

**Execution Sequence:**
```
Step 1: AUDIT existing scripts
        └── Check _pipelines/validate-schema — is it executable? Does it parse YAML?
        └── Check _pipelines/preflight-check — does python3 execute it cleanly?
        └── Check _pipelines/freshness-audit — does it run?
Step 2: validate-schema.sh → validate-schema Python rewrite
        └── Must validate: trace-map.yaml, canvas YAML, evidence files against schemas/
        └── Must exit non-zero on ANY validation failure
        └── Must produce machine-readable output (JSON) for pipeline integration
Step 3: freshness-audit.sh → freshness-audit Python rewrite
        └── Must check fresh_until timestamps on all data files
        └── Must flag files within 24h of expiry (WARNING) and expired files (FAIL)
        └── Must support --force flag for emergency override
Step 4: preflight-check.sh → preflight-check Python (if not already done in Workstream C)
        └── Must: check disk space, check Python deps, ping Firecrawl, ping DataForSEO
        └── Must: check CREDIT_BUDGET exists, check _CONCURRENCY_LOCK.yaml exists
        └── Must exit 0 for CONTINUE, 1 for BLOCKED, 2 for WARNING
Step 5: Write test suite for all three scripts
        └── Test valid YAML passes
        └── Test invalid YAML fails with specific error message
        └── Test freshness edge cases (expired, within SLA, missing timestamps)
Step 6: Integrate into pipeline: preflight-check runs FIRST, then freshness-audit, then validate-schema
```

**Human input:** None for implementation. If scripts uncover systemic issues (e.g., ALL existing canvases fail validation), that's a methodology design problem.

**AI-executable:** Steps 1-6 entirely. Python scripts with YAML parsing, timestamp math, API pings.

**Verification Gate D-G6:** `python3 _pipelines/preflight-check --self-check` exits 0. `python3 _pipelines/validate-schema --all` exits 0. Test suite passes.

---

## D-C5 (CRITICAL | RED-F03) — Semantic Checker (Grade Engine Replacement)

**Description:** Grade engine has NO semantic understanding. A fabricated claim with a real URL passes all 4 binary checks. Perverse incentive: fabricating plausible URLs yields HIGHER grades than honest "source unavailable."

**Fix:** Replace grade engine with semantic checker that: (a) extracts claim's core assertion, (b) fetches source content, (c) runs Claude model to assess support level. Cost: ~1 credit/claim. Start with 20% spot-check.

**Dependencies:**
- Workstream B's TOOL-EXECUTION-SPEC.md must define grade engine I/O protocol (AGT-M3 was listed as "deferred to Workstream D")
- Must understand existing grade engine logic (from grade-engine script in _pipelines/)
- Must define what "support level" means: SUPPORTS, PARTIALLY_SUPPORTS, NEUTRAL, CONTRADICTS, UNAVAILABLE

**Execution Sequence:**
```
Step 1: Define semantic grading schema
        └── _program/SEMANTIC_GRADE_SCHEMA.yaml
        └── support_level: SUPPORTS | PARTIALLY_SUPPORTS | NEUTRAL | CONTRADICTS | SOURCE_UNAVAILABLE
        └── confidence: float 0-1 (model's self-reported confidence)
        └── extracted_quote: str (verbatim quote from source supporting the assessment)
        └── rationale: str (why the model assigned this grade)
Step 2: Create _pipelines/semantic-checker (Python + Claude API)
        └── Input: evidence-claims.json (claim text + source URL)
        └── Output: evidence-grades-semantic.json (semantic grades)
        └── Cost control: only check 20% of claims (random sample + all CRITICAL claims)
        └── Prompt: structured, with claim text + source content + grade rubric
Step 3: For the 20% spot-check: compute divergence from deterministic grade engine
        └── If >30% divergence → flag for methodology review
        └── If <10% divergence → deterministic engine is adequate, semantic checker as audit only
Step 4: For NON spot-checked claims: use deterministic grade engine results but note
        └── Mark grade as `grade: B, semantic_verified: false`
Step 5: Integrate into pipeline: post deterministic-grade, run semantic-checker on 20%
        └── Update final grades with semantic_verified flag
Step 6: Document cost tracking: `semantic_credits_consumed` in CREDIT_BUDGET.yaml
```

**Human input:** None for implementation. If divergence >30%, Wesley must review and decide whether to increase sampling rate.

**AI-executable:** Steps 1-6. Step 2 requires Claude API calls — that's ~1 credit/claim × 6 claims per niche × 25 niches × 20% = 30 credits total. Manageable.

**Critical design decision:** The semantic checker prompt MUST include the exact claim text AND the fetched source content. It must NOT be asked "Is this claim supported?" with only the claim — that would be grade-from-memory rather than grade-from-source.

**Verification Gate D-G3 / D-G7:** Semantic checker produces evidence-grades-semantic.json. Spot-check divergence report available. EVIDENCE_INTEGRITY_ALERT triggers on NOT_SUPPORTED.

---

## D-H1 (HIGH | DQ-P2_1) — Review Corpus Availability Flag

**Description:** >=20 reviews from >=2 sources is impossible for 8-10 niches (consulting, fractional exec, manufacturing). The methodology requires this as a minimum.

**Fix:** Add `review_corpus_availability` flag to trace-map.yaml. Demote from "minimum" to "target" for data-sparse niches. Adjust evidence grade ceiling for review-backed claims in those niches.

**Dependencies:** Must coordinate with D-C2 (DATA-COVERAGE-MATRIX) — the coverage flag should be cross-referenced.

**Execution Sequence:**
```
Step 1: Add `review_corpus_availability: SUFFICIENT | LIMITED | NONE` to trace-map-schema.yaml
Step 2: Update NICHE-METHODOLOGY.md §5 (Competitive Landscape):
        └── "For niches with LIMITED or NONE review corpus: demote review count from minimum to target"
        └── "Adjust grade ceiling: review-backed claims capped at [S] (not [P]) for LIMITED niches"
Step 3: Add per-niche flag in trace-map.yaml during canvas creation
```

**AI-executable:** Entirely.

**Verification Gate:** trace-map-schema.yaml has review_corpus_availability field. Methodology updated.

---

## D-H2 (HIGH | DQ-P2_2) — Buyer Language Extraction Pipeline

**Description:** No dedicated tool for buyer language extraction. Currently gathered as byproduct, not dedicated pipeline step.

**Fix:** Add Phase 2.9: Firecrawl /search for verbatim quotes from G2, Reddit, LinkedIn. Require schema-defined output with source URL.

**Dependencies:** None standalone. But buyer-language-schema.yaml already exists at schemas/buyer-language-schema.yaml — leverage that.

**Execution Sequence:**
```
Step 1: Audit existing buyer-language-schema.yaml — does it support quote-level granularity?
        └── If not: extend with: quote_text, source_type (review/forum/social), source_url, speaker_role, sentiment
Step 2: Define Phase 2.9 step in TOOL-EXECUTION-SPEC.md (or reference from there):
        └── Search: "firecrawl search '{niche} buyers say' 'verbatim' '{pain point}' --scrape"
        └── Targets: G2 reviews, Reddit r/{industry}, LinkedIn posts, industry forums
        └── Output: research/N-XXX/buyer-language.json (array of quote objects)
Step 3: Create _pipelines/extract-buyer-language (Python script):
        └── Parse scraped content → extract quote-like patterns
        └── Deduplicate near-identical quotes
        └── Tag by pain point category from methodology
```

**AI-executable:** Steps 1-3 entirely. Step 3 requires NLP pattern matching (regex for quoted text, attribution patterns).

**Verification Gate:** Phase 2.9 produces buyer-language.json with >=5 unique quotes per niche.

---

## D-H3 (HIGH | DQ-P2_3) — Trigger Scoring Empirical Basis

**Description:** Trigger scoring (ACH matrix — Attainability, Clarity, Heat) has no empirical basis. Frequency, Urgency, Budget-Likelihood, Detectability are pure agent judgment.

**Fix:** Require evidence for at least 2 of 4 dimensions per trigger. Detectability must be verified by live API or documentation reference.

**Dependencies:** None standalone. But the trigger framework is in NICHE-METHODOLOGY.md — must update there.

**Execution Sequence:**
```
Step 1: Update NICHE-METHODOLOGY.md §6 (Signal Catalog / Triggers):
        └── "Each trigger MUST cite evidence for ≥2 dimensions"
        └── "Detectability MUST cite a live tool or API — not agent judgment"
        └── Example: "Trigger: CFO gets replaced. Detectability: LinkedIn Sales Navigator 'new title' alert"
Step 2: Add evidence validation to grade engine or evidence-verifier:
        └── For trigger-grade entries: check that detectability claim has tool name + method
Step 3: Update trace-map-schema.yaml to add trigger-specific fields:
        └── trigger_evidence: { frequency, urgency, budget_likelihood, detectability }
        └── Each field: { score: 1-5, evidence: str, evidence_type: DOCUMENTED_CLAIM | LIVE_TOOL }
```

**AI-executable:** Entirely.

**Verification Gate:** Triggers in trace-map have ≥2 evidenced dimensions. Detectability always has live tool reference.

---

## D-H4 (HIGH | DQ-P2_4) — Stackshare/BuiltWith for Tech Architecture

**Description:** Stackshare/tech blog analysis for technical architecture has no assigned tool. Agents guess or skip.

**Fix:** Add Stackshare API or BuiltWith/Wappalyzer for tech inference. Or flag as `[H]` with confidence downgrade.

**Dependencies:** If using BuiltWith: SRE-H07 (register for BuiltWith free API). If using Stackshare: need API key. If using Wappalyzer: needs MCP or API.

**Execution Sequence:**
```
Step 1: DECISION: Stackshare vs BuiltWith vs Wappalyzer vs [H] downgrade
        └── Recommended: BuiltWith (2K/day free, already in pipeline docs) if API key obtained
        └── Fallback: [H] downgrade flag with "tech inference not automated" note
Step 2: If BuiltWith: add API key to CREDENTIALS.yaml, document usage in TOOL-EXECUTION-SPEC.md
        └── "For technical architecture: use BuiltWith API or flag as [H]"
Step 3: Update NICHE-METHODOLOGY.md §8 (Ecosystem):
        └── "Tech inference: [P] only if BuiltWith/Stackshare confirms. No tool → [H]"
Step 4: If no API key: update affected trace-map sections to cap tech claims at [H]
```

**Human input (Wesley):** Register for BuiltWith free API key (or decide Stackshare/BuiltWith/Wappalyzer).

**AI-executable:** Steps 1, 3-4. Step 2 needs API key from human.

**Verification Gate:** Tech inference claims in trace-map have tool-verified [P] or downgraded [H].

---

## D-H5 (HIGH | RED-F15) — Form vs Substance Correction

**Description:** Methodology rewards FORM over SUBSTANCE — well-formatted wrong answers with real URLs score higher than honest sparse canvases.

**Fix:** Add semantic accuracy dimension: verifier independently extracts specific claim from fetched content. If >20% of verified claims unsupported, flag for human review.

**Dependencies:** D-C3 (fabrication detection verifier) and D-C5 (semantic checker) provide the verification infrastructure. D-H5 is the POLICY that uses them.

**Execution Sequence:**
```
Step 1: Define "accuracy dimension" as a grade-dimension modifier:
        └── fertility_score_adjustment = raw_fertility × semantic_accuracy_factor
        └── semantic_accuracy_factor = verified_supported / total_verified
        └── If semantic_accuracy_factor < 0.8 → flag for human review
Step 2: Add to fertility scoring algorithm in GRADE_ENGINE_ALGORITHM.md
Step 3: Add human-review trigger: trace-map field `flagged_for_review: true` when accuracy <0.8
Step 4: Document in methodology §14: "Fertility scores include semantic accuracy penalty"
```

**Dependencies:** D-C3 (evidence-verifier script exists) and D-C5 (semantic checker exists). This is a POLICY finding, not an infrastructure finding — it uses the infrastructure built in D-C3/D-C5.

**AI-executable:** Entirely (steps 1-4, all documentation + scoring logic).

**Verification Gate D-G7:** EVIDENCE_INTEGRITY_ALERT in TOOL_ERROR_LOG.yaml for NOT_SUPPORTED claims.

---

## D-M1 (MEDIUM | DQ-P3_1) — Budget Verification as Human Process

**Description:** Budget verification ($2.3) has no tool support — inherently human process.

**Fix:** Accept. Flag in §15 (Validation Plan) as pre-investment validation step. Cannot be automated.

**Dependencies:** None.

**Execution Sequence:**
```
Step 1: Update NICHE-METHODOLOGY.md §15 (Validation Plan):
        └── "Budget verification: HUMAN-ONLY. No tool automation possible."
        └── "Estimated budget claims remain at grade [E] (Estimate) until pre-investment validation."
        └── Add icon/flag: 🔒 HUMAN_VERIFIED after Wesley confirms budget
```

**AI-executable:** Entirely (documentation update).

**Verification Gate:** Methodology §15 contains budget verification note with human-only flag.

---

## D-M2 (MEDIUM | DQ-P3_2) — Non-Transparent Pricing Fallback

**Description:** Non-transparent pricing for enterprise/consulting has no public pricing fallback.

**Fix:** When public pricing unavailable: use G2 price mentions, job-posting budgets, competitor case studies. Mark as `[E]`.

**Dependencies:** None.

**Execution Sequence:**
```
Step 1: Update NICHE-METHODOLOGY.md §4/§9 (Pricing):
        └── "If no public pricing: try G2 price mentions, job-posting budgets, case studies"
        └── "All derived pricing = [E]. Only official pricing page scrape = [P] or [S]"
Step 2: Add pricing fallback chain to TOOL-EXECUTION-SPEC.md Task 6 (Pricing)
```

**AI-executable:** Entirely.

**Verification Gate:** Methodology has documented pricing fallback chain.

---

## D-M3 (MEDIUM | DQ-P3_3) — GDELT Rate Limit Handling

**Description:** GDELT rate limit unbounded — no queuing or batch strategy for 10-20 queries per niche.

**Fix:** Add rate-limit handling: bundle queries to minimize requests. Add 1s/2s/4s backoff. BigQuery project-level limits apply.

**Dependencies:** None. But coordinate with Workstream C-C2 (GDELT retry logic) which already adds exponential backoff.

**Execution Sequence:**
```
Step 1: Check C-C2 fix (SRE-C02 in Workstream C) — does it already add backoff?
        └── If C-C2 complete: D-M3 is documentation-only (add rate limit doc note)
        └── If C-C2 pending: add queuing + bundling to the GDELT data source protocol
Step 2: Update DATA-OPERATIONS-ARCHITECTURE.md §2.3 (GDELT):
        └── "GDELT BigQuery: bundle 10 queries into 1 query with UNION ALL"
        └── "Per-batch limit: 10 queries per niche. 1s/2s/4s backoff for rate limit errors"
```

**AI-executable:** Entirely.

**Verification Gate:** GDELT section in DATA-OPERATIONS-ARCHITECTURE.md documents bundling + backoff.

---

## D-M4 (MEDIUM | DQ-P3_4) — Reddit Non-English Coverage

**Description:** Reddit Research MCP for non-English subreddits has thin coverage. Dutch-language VOC will be missed.

**Fix:** Supplement with Dutch-language LinkedIn groups, industry forums, CBS StatLine reports. Document English-dominant VOC limitation.

**Dependencies:** None.

**Execution Sequence:**
```
Step 1: Update NICHE-METHODOLOGY.md §2/§5 (VOC sections):
        └── "Reddit coverage is English-dominant. For NL-market niches, supplement with:"
        └── "  - LinkedIn NL groups (via Firecrawl search)"
        └── "  - Dutch industry forums (via Firecrawl search + known URLs)"
        └── "  - CBS StatLine (for NL-market quantitative context)"
Step 2: Add to TOOL-EXECUTION-SPEC.md Task 2 (VOC): language-specific search instructions
```

**AI-executable:** Entirely.

**Verification Gate:** Methodology has Dutch-language VOC supplement strategy. TOOL-EXECUTION-SPEC.md includes language-specific search.

---

### Verification Gate D: Complete Check

| Gate | Pass Criteria | Depends On |
|---|---|---|
| D-G1 | Cohen's Kappa >= 0.61 after calibration | D-C1 + F-H2 |
| D-G2 | Independent mini-calibration protocol (every 5 niches) | D-C5 + D-C3 |
| D-G3 | EVIDENCE_INTEGRITY_ALERT in TOOL_ERROR_LOG.yaml | D-C3 |
| D-G4 | DATA-COVERAGE-MATRIX.yaml populated with normalization | D-C2 |
| D-G5 | Normalization formula in fertility ranking | D-C2 |
| D-G6 | validate-schema.sh, freshness-audit.sh, preflight-check.sh all pass tests | D-C4 |
| D-G7 | Fabrication-detection evidence-verifier operational | D-C3 + D-C5 |

---

# WORKSTREAM E: Data Quality & Coverage (7 unique findings, ~1 hour)

**Files to create:** 1 new (DARK_MATTER_REGISTRY.md or similar)
**Files to edit:** 2-3 existing (NICHE-METHODOLOGY.md, trace-map schema, TOOL-EXECUTION-SPEC.md)
**AI-executable:** 7 of 7 findings entirely
**Human-required:** None
**Critical path:** None standalone — but E-C1 and E-H3 cross-reference D-C2

---

## E-C1 (CRITICAL | DQ-B01) — Market Sizing Ambiguity

**Description:** Market sizing (Section 1) has no guidance on which source combination to use — agents may use search volume as a market size proxy or combine incomparable sources.

**Fix:** Add explicit agent guidance: "Use gov API (EUROSTAT/OECD) as primary, Firecrawl /search as secondary. If gov API unavailable, use two independent Firecrawl searches with different queries."

**Dependencies:** D-C2 (DATA-COVERAGE-MATRIX) establishes the normalization framework this guidance should reference. But the guidance itself can be written standalone.

**Execution Sequence:**
```
Step 1: Update NICHE-METHODOLOGY.md §1 (Market Sizing) — add explicit source tiering:
        └── TIER 1 (PRIMARY): EUROSTAT or OECD API (gov-sourced, highest authority)
        └── TIER 2 (SECONDARY): Firecrawl /search for industry reports, analyst estimates
        └── TIER 3 (TERTIARY, [H] only): DataForSEO keyword search volume as directional proxy
        └── "NEVER combine Tiers 1+3 without DATA_TYPE_MISMATCH flag"
Step 2: Add to TOOL-EXECUTION-SPEC.md Task 1 (Market Sizing):
        └── Exact search queries for market sizing per niche type
Step 3: Update trace-map-schema.yaml for market_size entries:
        └── Add: source_tier: PRIMARY | SECONDARY | TERTIARY
        └── Add: data_type_mismatch: true | false (for Tier 3 proxy usage)
```

**AI-executable:** Steps 1-3 entirely.

**Verification Gate E-G1:** Market sizing has explicit source tiering in methodology. Agent guidance in TOOL-EXECUTION-SPEC.md.

---

## E-H1 (HIGH | DQ-B07) — Trade Show Dark Matter

**Description:** Trade shows have zero digital exhaust — no public API for attendance. Cannot verify trade show activity via automated tools.

**Fix:** Add explicit note in each canvas §15 for affected niches. Most affected: EU Public Sector, Niche Manufacturing, Professional Services.

**Dependencies:** None. Pure documentation.

**Execution Sequence:**
```
Step 1: Update NICHE-METHODOLOGY.md §15 (Validation Plan) — add dark matter section:
        └── "DARK MATTER — Undetectable via Automated Pipeline:"
        └── "  1. Trade show attendance / booth visits"
        └── "  2. In-person meetings and word-of-mouth referrals"
        └── "  3. Private company dynamics (no Crunchbase, no SEC filing)"
        └── "  4. Internal decision-making processes"
        └── "  5. Oral culture industries (traditional trades, family businesses)"
Step 2: Add per-niche dark matter impact template for §15:
        └── "DARK_MATTER_IMPACT: HIGH | MEDIUM | LOW (list affected signal types)"
```

**AI-executable:** Entirely.

**Verification Gate E-G2:** Dark matter section in methodology lists >=5 undetectable signal types.

---

## E-H2 (HIGH | DQ-B08) — In-Person / Word-of-Mouth Dark Matter

**Description:** In-person meetings/word-of-mouth — #1 B2B buying trigger — has no digital signal. Cannot detect "peer recommendation."

**Fix:** Acknowledge as inherent limitation. Trigger system is entirely digital.

**Dependencies:** None. Documentation.

**Execution Sequence:**
```
Step 1: Add to NICHE-METHODOLOGY.md §6 (Signal Catalog):
        └── "INHERENT LIMITATION: Peer recommendation is the #1 B2B buying trigger
              but has zero digital exhaust. Our signal system detects digital triggers
              (job changes, funding, website tech changes, etc.) which correlate with
              but are not equivalent to peer recommendations."
Step 2: Add scoring caveat: "Trigger scores do NOT measure word-of-mouth potential."
```

**AI-executable:** Entirely.

**Verification Gate E-G2 (combined with E-H1):** Dark matter section complete.

---

## E-H3 (HIGH | DQ-B09) — Private Company Dark Matter

**Description:** Private company dynamics — no Crunchbase API, no SEC, no public pricing for consulting/staffing.

**Fix:** Add coverage flag per niche. Most affected: Fractional Executive, Consulting, Agencies, Staffing. Normalize via DQ-P02.

**Dependencies:** D-C2 (DATA-COVERAGE-MATRIX normalization factor) must account for private-company data gaps.

**Execution Sequence:**
```
Step 1: Update DATA-COVERAGE-MATRIX.yaml (from D-C2) to flag private-company data gaps:
        └── Per niche: private_company_prevalence: HIGH | MEDIUM | LOW
        └── Per affected data type: covered_via: PUBLIC_FILING | PRIVATE_REPORT | NOT_AVAILABLE
Step 2: Update NICHE-METHODOLOGY.md §14 (Fertility Scoring):
        └── "Niches with HIGH private_company_prevalence have coverage_factor reduced
              by 0.15 to account for data invisibility. This is NOT a quality penalty —
              it is a measurement limitation flag."
```

**AI-executable:** Entirely.

**Verification Gate E-G3:** DATA-COVERAGE-MATRIX.yaml has private_company_prevalence field. Normalization accounts for data invisibility.

---

## E-M1 (MEDIUM | DQ-B02) — Revenue Leak Benchmark Source Flag

**Description:** Revenue leak benchmark (26%) is single vendor-commissioned source (Clari 2024).

**Fix:** Document as vendor-commissioned in trace-map.yaml. Cross-validate with industry benchmarks.

**Dependencies:** None.

**Execution Sequence:**
```
Step 1: Update trace-map.yaml (canonical references section):
        └── "revenue_leak_26pct: { source: Clari 2024, type: vendor_commissioned,
              confidence: [S], cross_validation: needed, recommended_sources: [... ] }"
Step 2: Add to NICHE-METHODOLOGY.md appendix: list of vendor-commissioned sources with [S] grade
```

**AI-executable:** Entirely.

**Verification Gate E-G4:** Vendor-commissioned sources flagged in trace-map.yaml.

---

## E-M2 (MEDIUM | DQ-B03) — Tech Architecture Inference Tool Gap

**Description:** Technical architecture inference has no tool assigned (duplicate of D-H4).

**Fix:** Same fix as D-H4: Stackshare API or `[H]` downgrade for tech inference claims.

**Dependencies:** Same as D-H4. E-M2 is a cross-reference, not a separate finding.

**Execution Sequence:**
```
Step 1: Cross-reference in this plan: "See D-H4 for implementation."
Step 2: Document in methodology that tech inference with no tool = cap at [H]
```

**AI-executable:** Entirely (documentation cross-reference).

**Verification Gate:** Combined with D-H4 verification.

---

## E-M3 (MEDIUM | DQ-B04) — Ecosystem Section Tool Gap

**Description:** Ecosystem section — no tool can produce aggregator candidates, channel economics, partner activation playbooks.

**Fix:** Accept as design work. Flag economic estimates as `[H]`-`[S]`. Document that Firecrawl /search returns names only.

**Dependencies:** None.

**Execution Sequence:**
```
Step 1: Update NICHE-METHODOLOGY.md §8 (Ecosystem):
        └── "Aggregator, channel, and partner sections are DESIGN work — tool-assisted,
              not tool-automated. Firecrawl /search provides initial name lists.
              Economic estimates (channel economics, partner revenue) = [H] or [S]."
```

**AI-executable:** Entirely.

**Verification Gate:** Ecosystem section limitation documented.

---

## E-M4 (MEDIUM | DQ-B05) — Signal Catalog Limitation

**Description:** Signal catalog — 15-signal requirement has no discovery pipeline. At zero clients, NO signal has HIGH predictiveness confidence.

**Fix:** Accept. First 3 clients are calibration partners. Signal confidence upgrades to `[P]` only after live validation.

**Dependencies:** None.

**Execution Sequence:**
```
Step 1: Update NICHE-METHODOLOGY.md §6 (Signal Catalog):
        └── "SIGNAL CONFIDENCE STAGES:"
        └── "  Stage 0 (pre-launch): All signals [H] — derived from methodology + analogy"
        └── "  Stage 1 (3 clients): Signals observed in live deals → upgrade to [P]"
        └── "  Stage 2 (10+ clients): Statistically validated → upgrade to 95% CI"
Step 2: Add signal catalog versioning: each signal has `stage: 0|1|2` and `clients_validated: int`
```

**AI-executable:** Entirely.

**Verification Gate E-G5:** Signal catalog has staged confidence model. All pre-launch signals at [H].

---

## E-M5 (MEDIUM | DQ-B06) — Customer Journey as Design Section

**Description:** Customer journey — no tool supports journey design. All conversion rates, TTV, breakeven are `[H]`-`[S]`.

**Fix:** Accept as design section. Conversion rates inherit pricing grades (Section 4/9). Document zero-client limitation.

**Dependencies:** None.

**Execution Sequence:**
```
Step 1: Update NICHE-METHODOLOGY.md §13 (Customer Journey):
        └── "This section is DESIGN — journey maps are constructed from methodology,
              not extracted from tools. Conversion rates: inherit grades from Pricing
              section (same evidence basis). TTV and breakeven: mandatory [S] until live data."
```

**AI-executable:** Entirely.

**Verification Gate:** Customer journey section documented as design, not measurement.

---

### Verification Gate E: Complete Check

| Gate | Pass Criteria |
|---|---|
| E-G1 | Market sizing has explicit source tiering guidance |
| E-G2 | Dark matter section in methodology: >=5 undetectable signal types |
| E-G3 | Dark matter flags per niche: canvas §15 contains DATA_DARK_MATTER_HIGH for >=3 UNAVAILABLE/SPARSE niches |
| E-G4 | All vendor-commissioned sources flagged in trace-map.yaml |
| E-G5 | Signal catalog limitation documented: all signals [H] until live client validation |

---

# WORKSTREAM F: Pipeline Scheduling & Budget (10 findings, ~6.5 hours)

**Files to create:** 5-6 new files
**Files to edit:** 6-8 existing files
**AI-executable:** 8 of 10 findings
**Human-required:** 1 critical (F-H2: Wesley produces ground truth reference canvas — 4h)
**Critical path:** F-H2 (ground truth) gates D-C1, F-C1, F-C4. Everything else can proceed in parallel.

---

## F-C1 (CRITICAL | RED-F01) — Realistic Credit Budget

**Description:** 132-credit estimate assumes ideal conditions (zero retries, zero surprises). Realistic: 180-220 cr (80th percentile), 300-400 cr (95th percentile). 4,300 budget supports 14-19 niches, not 25.

**Fix:** Run first REAL niche end-to-end before finalizing ANY budget. Measure on niche with real competitor density, JS pages, retry patterns. Set buffer to 2.0x (not 1.3x). Implement credit runway kill switch.

**Dependencies:**
- F-H2 (Wesley ground truth) — because the first real niche IS the calibration niche, which needs ground truth
- D-C5 (semantic checker cost) — because semantic verification adds ~30 credits across 25 niches
- Workstream C-H8 (actual timing data from calibration run)

**Execution Sequence:**
```
Step 1: RUN CALIBRATION NICHE END-TO-END (after F-H2, D-C1, D-C4, D-C5 are ready)
Step 2: Measure REAL consumption:
        └── Firecrawl credits consumed (search + scrape + crawl + interact)
        └── DataForSEO credits consumed
        └── Semantic checker credits consumed (if D-C5 active)
        └── Wall-clock time
        └── Tool failure rate and retry overhead
Step 3: Update CREDIT_BUDGET.yaml with real data:
        └── firecrawl_per_niche: measured_value × 2.0 buffer
        └── dataforseo_per_niche: measured_value × 2.0 buffer
        └── semantic_per_niche: measured_value × 1.5 buffer
        └── total_budget_25_niches: sum × 25 + 300 (surprise niche reserve)
Step 4: Implement credit runway kill switch:
        └── WARNING at 4,000 credits/hr burn rate
        └── HALT at 8,000 credits/hr burn rate
        └── Document in CREDIT_BUDGET.yaml: warning_threshold, halt_threshold
Step 5: Recompute niche count: budget_realistic / per_niche_realistic
        └── If <25: decide whether to increase budget or reduce niche count
```

**Human input (Wesley):** Decision at Step 5 — increase budget or reduce niche count.

**AI-executable:** Steps 1-4 are execution (running the calibration niche, measuring, updating YAML). Step 5 decision is human.

**Verification Gate F-G1:** CREDIT_BUDGET.yaml has real consumption data from calibration niche. 2.0x buffer applied. Kill switch thresholds set.

---

## F-C2 (CRITICAL | RED-F13) — RIOS Limitations Section

**Description:** RIOS score formula is subjective judgment engineered to look objective — equal weighting, 6-inversion, >3.0 threshold — all arbitrary.

**Fix:** Add "Limitations" section to methodology: "Scores are ordinal opinions, not cardinal truths. Rankings conditional on 24-month-unverifiable assumptions. ALL verdicts carry residual uncertainty."

**Dependencies:** None. Pure documentation.

**Execution Sequence:**
```
Step 1: Update NICHE-METHODOLOGY.md frontmatter — add LIMITATIONS section:
        └── "LIMITATIONS (ALL users MUST read before interpreting scores):"
        └── "1. Scores are ORDINAL, not cardinal. A 4.2 niche is NOT necessarily 'better'
              than a 3.8 niche — the gap has no statistical meaning."
        └── "2. Equal weighting is a DESIGN CHOICE, not an empirical finding."
        └── "3. The >3.0 threshold was set before any data existed. It may change."
        └── "4. Rankings are conditional on assumptions that cannot be verified
              within the program's 24-month timeline."
        └── "5. ALL 'Go / No-Go' verdicts carry residual uncertainty. They are
              investment hypotheses, not predictions."
Step 2: Add to every canvas template: "This canvas is a decision-support instrument,
        not a verified business case. All data grades carry the uncertainty documented
        in the methodology limitations."
```

**AI-executable:** Entirely.

**Verification Gate F-G4:** Limitations section in methodology frontmatter with >=5 limitations.

---

## F-C3 (CRITICAL | RED-F14) — Falsifiability Criteria

**Description:** Pipeline outputs are unfalsifiable for 23+ months — no feedback loop within program timeframe. If a niche fails, no one knows which claim was wrong.

**Fix:** Add falsifiability criteria per canvas: "If niche generates < EUR 50K ARR within 12 months, which specific pipeline claim was wrong?" Forces traceability.

**Dependencies:** None. Design documentation.

**Execution Sequence:**
```
Step 1: Add falsifiability section to canvas template (NICHE-METHODOLOGY.md §16):
        └── "§16 — FALSIFIABILITY CRITERIA"
        └── "If this niche generates < EUR 50K ARR within 12 months of launch,
              the following claims should be investigated as likely wrong:"
        └── "  - Claim 1 (from §3, line): [market size overestimate?]"
        └── "  - Claim 2 (from §6, line): [trigger frequency overestimate?]"
        └── "  - Claim 3 (from §9, line): [WTP overestimate?]"
        └── "  - Claim 4 (from §5, line): [competitor weakness overestimate?]"
Step 2: The falsifiability claims must link back to specific trace-map entries
        └── Each falsifiability entry: `trace_map_id: T-042, section: §3, prediction: "€120M TAM"`
Step 3: Document that falsifiability is completed during canvas finalization, not during research
```

**AI-executable:** Steps 1-3. Step 2 requires linking falsifiability entries to trace-map IDs during canvas finalization.

**Verification Gate F-G7:** Canvas template has §16 Falsifiability Criteria. Each falsifiability entry references trace-map ID.

---

## F-C4 (CRITICAL | SRE-H08) — Actual Per-Niche Wall-Clock Timing

**Description:** Per-niche wall-clock estimates (13-16 min I/O, 20-25 min total) are completely untested — L3 and L6 independently confirmed this.

**Fix:** Run calibration niche. Measure actual timings. Update estimates. Set per-niche hard limit at 45 min.

**Dependencies:** F-H2 (ground truth) — calibration niche must be processed first. Also D-C4 (schema validation scripts) must exist to measure end-to-end.

**Execution Sequence:**
```
Step 1: Run calibration niche through complete pipeline (after all D+E+F infrastructure is ready)
Step 2: Measure: total_wall_clock, io_wait_time, tool_latency, agent_think_time, retry_overhead
Step 3: Update PIPELINE_CHECKPOINTS.yaml:
        └── per_niche_wall_clock_estimated: measured_value
        └── per_niche_hard_limit: max(45, measured_value × 2)
Step 4: Update agent prompts: "Hard limit per niche: N minutes. If exceeded, save partial canvas."
```

**Human input:** None (measurement is automated). But if measured value exceeds 45 min, Wesley must approve the new hard limit.

**AI-executable:** Steps 1-4.

**Verification Gate F-G1 (combined with F-C1):** CREDIT_BUDGET.yaml + PIPELINE_CHECKPOINTS.yaml both updated with real calibration data.

---

## F-H1 (HIGH | RED-F07) — Surprise Niche + Fast-Track

**Description:** 25-niche list too rigid — no surprise mechanism. Methodology rewards data-rich niches.

**Fix:** Add "surprise niche" slot (300 credits reserve). Add "top 5 in 2 weeks" fast-track: run all 25 at STANDARD depth first, surface top 5, then DEEP on those 5.

**Dependencies:** F-C1 (credit budget) must have the 300-credit reserve allocated. The fast-track logic depends on the two-pass pipeline design (F-M1).

**Execution Sequence:**
```
Step 1: Reserve 300 credits in CREDIT_BUDGET.yaml for surprise niche
        └── surprise_niche_reserve: 300, purpose: "unexpected opportunity detected mid-program"
Step 2: Document NICHE-METHODOLOGY.md §16 (Program Design):
        └── "SURPRISE NICHE: One slot reserved. Selection criteria:"
        └── "  - Must be detected mid-program (not in initial 25)"
        └── "  - Must have at least one live trigger within 30 days"
        └── "  - Consumes 300 credits from reserve"
Step 3: Define fast-track selection at Niche #5:
        └── "After 5 niches at STANDARD depth: surface top 3 by fertility score"
        └── "After all 25 at STANDARD depth: surface top 5"
        └── "Top 5 proceed to DEEP depth (500 cr additional / niche)"
```

**AI-executable:** Steps 1-3. Implementation: updates to methodology + CREDIT_BUDGET.yaml.

**Verification Gate F-G5:** Surprise niche slot reserved (300 credits) in CREDIT_BUDGET.yaml.

---

## F-H2 (HIGH | RED-F06) — Ground Truth Production

**Description:** Ground truth does NOT exist — `_GROUND-TRUTH/` directory is EMPTY. Pipeline designed around unimplemented prerequisite.

**Fix:** Wesley produces ground truth reference canvas for 5 sections BEFORE any agent calibration. This is Phase 0 Gate 1.

**Dependencies:** NONE — this is the PREREQUISITE for everything else. Must happen first.

**Human input (Wesley):** FULL — Wesley produces the reference canvas for calibration niche (Mid-Market IT Staffing or similar). 5 sections minimum. This is the anchor against which all grade engine calibration and semantic verifier testing is measured.

**AI-executable:** None of the content production. AI can: format Wesley's output into _GROUND-TRUTH/ files, validate schema compliance, prepare comparison tooling.

**Execution Sequence:**
```
Step 1: Wesley selects calibration niche (Mid-Market IT Staffing recommended — data-rich, familiar)
Step 2: Wesley produces reference canvas for 5 priority sections:
        └── §1: Market Sizing (TAM, SAM, SOM with source URLs)
        └── §3: Competitive Landscape (top 5-8 competitors with positioning)
        └── §6: Signal Catalog (10-15 triggers with detectability evidence)
        └── §9: Pricing & Willingness-to-Pay (pricing bands with sources)
        └── §10: Buyer Persona (3 personas with quotes/evidence)
Step 3: AI formats into _GROUND-TRUTH/ directory:
        └── _GROUND-TRUTH/ground-truth-canvas.yaml (structured YAML with all 5 sections)
        └── _GROUND-TRUTH/ground-truth-trace-map.yaml (trace-map with all claim-source pairs)
        └── _GROUND-TRUTH/ground-truth-evidence-grades.yaml (expected grades — what the engine should output)
Step 4: AI validates: do all claims in ground truth have source URLs? Do evidence grades match expected?
        └── Flag any inconsistencies for Wesley's review before calibration begins
```

**Human input (Wesley):**
- Select calibration niche
- Produce reference canvas for 5 sections (4 hours estimated, could be 6-8)
- Review AI-formatted ground truth files for accuracy

**Verification Gate F-G6:** `_GROUND-TRUTH/` has ground-truth-canvas.yaml, ground-truth-trace-map.yaml, ground-truth-evidence-grades.yaml. All 5 sections populated. Pre-validation passes.

---

## F-M1 (MEDIUM | RED-F08) — Two-Pass Pipeline Design

**Description:** Pipeline produces NO actionable output until all 25 complete — worst case 6 weeks of zero decisions.

**Fix:** Implement "top 5 in 2 weeks" two-pass pipeline: Pass 1 = STANDARD depth on all 25 (425 cr, 2 weeks), Pass 2 = DEEP on top 5 (1,000 cr, 1 week).

**Dependencies:** F-C1 (budget) must allocate credits for two-pass structure. F-H1 (fast-track) uses same logic.

**Execution Sequence:**
```
Step 1: Design two-pass pipeline in NICHE-METHODOLOGY.md §16:
        └── PASS 1 — STANDARD depth (all 25 niches):
        └──   - 15 sections completed at STANDARD depth
        └──   - ~425 credits (17 cr/niche × 25)
        └──   - Target: 2 weeks wall-clock (at 3 concurrent agents)
        └──   - Output: 25 canvases, fertility-ranked list
        └── PASS 2 — DEEP depth (top 5 by fertility score):
        └──   - 15 sections expanded to DEEP depth
        └──   - ~1,000 credits (200 cr/niche × 5)
        └──   - Target: 1 additional week
        └──   - Output: 5 investment-grade canvases with [P] claims
Step 2: Document Stage-Gate at niche #5:
        └── "If no niche in top 5 has fertility > 3.0: STOP. Revisit methodology."
Step 3: Add to TOOL-EXECUTION-SPEC.md: STANDARD vs DEEP depth definitions per section
        └── STANDARD: 1-2 sources per claim, search-only, [S] grade ceiling
        └── DEEP: 3+ sources per claim, crawl+interact, [P] grade achievable
```

**AI-executable:** Steps 1-3 entirely.

**Verification Gate F-G2:** Two-pass pipeline documented in methodology with timeline and credit allocation.

---

## F-M2 (MEDIUM | RED-F10) — Data Staleness Fix

**Description:** First niche's 7-day SLA data (job postings, hiring) stale before pipeline completes (2-4 weeks). Time-sensitive data decays before canvas is finalized.

**Fix:** Collect job/hiring data as final step before canvas finalization, not during initial gathering.

**Dependencies:** Must coordinate with pipeline phase definitions (TOOL-EXECUTION-SPEC.md research phases).

**Execution Sequence:**
```
Step 1: Rephase pipeline: move job/hiring/active-vacancy data collection to LAST step
        └── Phase 1: Stable data (market sizing, competitors, TAM) — doesn't decay
        └── Phase 2: Semi-stable data (pricing, personas, triggers) — weekly refresh acceptable
        └── Phase 3: Volatile data (job postings, active hiring, recent news) — collect LAST
Step 2: Update TOOL-EXECUTION-SPEC.md Phase definitions to reflect Phase 3 ordering
Step 3: Update grade engine: time-sensitive claims get freshness_days = floor(days_since_collection)
        └── freshness_tier = 0-7d: full grade, 8-14d: -1 sub-grade, 15+d: downgrade one full letter
```

**AI-executable:** Steps 1-3 entirely.

**Verification Gate F-G8:** Pipeline phases documented with time-sensitive data as Phase 3 (last). Grade engine applies freshness penalty on stale data.

---

## F-M3 (MEDIUM | RED-F12) — Operator Responsibilities Documentation

**Description:** Pipeline requires human operator for 8+ failure scenarios — each is SPOF on Wesley.

**Fix:** Document all human intervention points in OPERATOR-RESPONSIBILITIES.md with estimated frequency and resolution time.

**Dependencies:** None. Pure documentation. But should be informed by Workstream C (all failure scenarios surfaced there).

**Execution Sequence:**
```
Step 1: Create _program/OPERATOR-RESPONSIBILITIES.md with:
        └── All operator intervention points from across all workstreams:
        └──   1. DataForSEO balance top-up (estimated weekly during heavy pipeline)
        └──   2. CAPTCHA/rate-limit bypass for review platforms (monthly)
        └──   3. Grade engine calibration drift check (every 5 niches)
        └──   4. COMPLIANCE_BLACKLIST.yaml review (quarterly)
        └──   5. FRED API replacement (one-time — G-C1)
        └──   6. Credential rotation (quarterly — G-H3)
        └──   7. Mid-pipeline "top 5" review gate (after niche #5)
        └──   8. Post-incident review (after any pipeline failure)
        └── Per intervention: estimated_frequency, estimated_resolution_time, automation_possible
Step 2: Add automation recommendations: which interventions can be automated in future
        └── "DataForSEO top-up: can be automated with API credit monitoring + alert → auto-top-up"
        └── "Grade engine drift check: partially automated via independent agent mini-calibration"
Step 3: Document escalation path: what if Wesley is unavailable
        └── "If Wesley unreachable >24h: pause pipeline at next natural gate. Do NOT skip operator step."
```

**AI-executable:** Steps 1-3 entirely.

**Verification Gate:** OPERATOR-RESPONSIBILITIES.md exists with all 8+ intervention points documented.

---

## F-M4 (MEDIUM | RED-F02) — Concurrency Reduction (4->3 Agents)

**Description:** Concurrency lock cannot distinguish intent from execution — 9.7% collision per batch at 4 agents. Collisions cause retries, stale data, and YAML corruption.

**Fix:** Reduce from 4 to 3 concurrent agents (collision drops to ~3%). Implement write-transactions for shared files.

**Dependencies:** Workstream C-C4 (create _CONCURRENCY_LOCK.yaml) — the lock file must exist before agents can use it. Also C-C6 (dead-host registry write logic) must be in place.

**Execution Sequence:**
```
Step 1: Update AGENT-CONTEXT-SPEC.md:
        └── "Max concurrent niche agents: 3" (changed from 4)
        └── "Write-transactions: ALL shared file writes use atomic tmp+mv pattern"
Step 2: Implement write-transaction pattern in lock protocol:
        └── Read: shared → no lock needed
        └── Write: temp file → mv → acquire write lease → move to shared → release lease
        └── Per-agent log files: research/N-XXX/_agent-log.jsonl (JSON Lines, append-only)
Step 3: Update TOOL-EXECUTION-SPEC.md lock file protocol:
        └── agent_count: max 3
        └── transaction_type: read | write | read-write
        └── write_lease_duration: 30s max (if exceeded, allow break)
Step 4: Reduce shared file contention: split YAML files per-niche where possible
        └── CREDIT_BUDGET.yaml gains per-niche sub-keys instead of single flat list
        └── DEAD_HOST_REGISTRY.yaml unchanged (single file, write-transaction protected)
```

**AI-executable:** Steps 1-4 entirely.

**Verification Gate F-G3:** AGENT-CONTEXT-SPEC.md says "Max 3 concurrent niche agents." Write-transaction pattern documented.

---

### Verification Gate F: Complete Check

| Gate | Pass Criteria | Depends On |
|---|---|---|
| F-G1 | CREDIT_BUDGET.yaml updated with real calibration data + 2.0x buffer | F-C1 + F-C4 |
| F-G2 | Two-pass pipeline documented: STANDARD + DEEP with timeline | F-M1 |
| F-G3 | Concurrency limit changed to 3: AGENT-CONTEXT-SPEC.md | F-M4 |
| F-G4 | Limitations section in methodology: >=5 limitations | F-C2 |
| F-G5 | Surprise niche slot reserved: 300 credits in CREDIT_BUDGET.yaml | F-H1 |
| F-G6 | Ground truth exists: _GROUND-TRUTH/ has reference canvas | F-H2 (WESLEY) |
| F-G7 | Falsifiability criteria documented in canvas template | F-C3 |
| F-G8 | Job/hiring data collection moved to pre-finalization step | F-M2 |

---

# MASTER SEQUENCE: Workstreams A through G

## Sequence Rules

1. **Everything blocks on G-C1 and G-H2** — FRED ToS violation is active, credentials leak in .bashrc is active. These are done first regardless of everything else.
2. **F-H2 (Wesley ground truth)** is the single longest critical-path item (4h human) — it gates D-C1, F-C1, F-C4. Wesley should START this day 1, while AI works on everything else.
3. **A+B+C have no hard ordering between them** but A (MCP config) enables some B+C exercises. Run A first, then B+C in parallel.
4. **D+E+F are sequential by dependency** but D contains most of the heavy lifting (~11.5h of ~19.5h).
5. **G (Security)** runs in parallel throughout — its implementation doesn't block pipeline but its decisions (FRED, creds, ToS) affect methodology.

## The Master Sequence

```
WEEK 1           MON              TUE              WED              THU              FRI
                ┌─────────────────────────────────────────────────────────────────────────┐
A (MCP Config)  ████████████████████──────────────────────────────────────────────────────  ┐
B (Agent Inst.) ─█████████████████████████████████████████────────────────────────────────  │ PARALLEL
C (Reliability) ─████████████████████████████████████████████████████████████████████████  ┘
                                                                                          
D (Evidence)    ───────────────────────────────────────███████████████████████████████───  ┐ sequential
E (Data Qual)   ──────────────────────────────────────────────────██████████████████────  ┘ after B+C
F (Pipeline)    ─────████──────████████████████████──────────────────────────────────────  ┐ F-H2 starts
                ──────────────────────────────────────────████████████████████████████───  │ day 1, gates D
G (Security)    █████████████████████████████████████████████████████████████████████████  parallel

WEEK 2           MON              TUE              WED              THU              FRI
                ┌─────────────────────────────────────────────────────────────────────────┐
G (remaining)   ─███████████████████──────────────────────────────────────────────────────
D (finish)      ████████████████████████████████──────────────────────────────────────────
E (finish)      ████████████████──────────────────────────────────────────────────────────
F (finish)      ██████████████████████████████████████████────────────────────────────────
CALIBRATION     ──────────────────────────────────────────────────████████████████████████
```

## Detailed Merge Sequence

### DAY 1: Foundation (G-C1, G-H2 start, F-H2 start)

**Sequential (must be day 1):**
```
G-C1: REMOVE FRED_API_KEY ⚠️ ACTIVE TOS VIOLATION [WESLEY — 15 min]
G-H2: Move creds from .bashrc to settings.json [WESLEY — 10 min]
```
**Wesley starts (long pole, 4h):**
```
F-H2: Produce ground truth reference canvas for 5 sections [WESLEY — 4h]
```
**AI works in parallel with Wesley:**
```
A-C1..A-C3: CONFIGURE_NOW MCP servers (PaperPlain, Reddit, Financial Hub)
A-C4..A-C6: Documentation corrections
G-H3: Add credential rotation tracking to CREDENTIALS.yaml
G-H4: Read G2/Capterra ToS → COMPLIANCE_BLACKLIST.yaml [WESLEY needed]
```
**End day 1:** FRED removed, creds secure, 3 MCPs configured, ground truth ~50% done.

### DAY 2-3: Workstreams A+B+C (parallel)

**A (MCP Config completion — ~2h remaining):**
```
A-H1..A-H7: Configure Serper, Brave, Google CSE, CrawlForge, FetchSERP, DataForSEO MCP migration
A-M1: SearXNG Docker deployment (60 min)
A-M2: TAM-MCP-Server build (30 min)
A-L1..A-L4: Low-priority decisions + doc corrections
VERIFICATION GATE A
```

**B (Agent Instruction Layer — ~7h):**
```
B-C1/B-C2: TOOL-EXECUTION-SPEC.md creation [DONE per file check — 10 binding rules, 360 lines]
B-C3..B-C6: Escalation pattern, --wait-for, cache preflight, prompt injection
B-H1..B-H6: search-feedback, dead-host, freshness, error recovery, session isolation, --query ban
B-M1..B-M6: Monitoring setup, quality threshold, grade engine I/O, tool decision tree, registry, --only-main-content
B-L1..B-L3: Phase distinction, canonical flags, credit costs
UPDATE AGENT-CONTEXT-SPEC.md (tool ref load replacement, prompt injection, lock file cross-ref)
VERIFICATION GATE B
```

**C (Reliability & Concurrency — ~8h):**
```
Wave 1: TIMEOUT_CONFIG.yaml restructure (connect/read/total)
Wave 2: SLI_DEFINITIONS.yaml corrections
Wave 3: RUNBOOK.md fixes
Wave 4: DATA-OPERATIONS-ARCHITECTURE.md rate limit corrections (8 fixes)
Wave 5: Preflight-check operational readiness (GATE functions, disk space, deps)
Wave 6: Create missing infra files (_CONCURRENCY_LOCK, MCP_SCHEDULE, TOOL_VERSIONS, _postmortems/)
Wave 7: Freshness audit ETag fix
Wave 8: GDELT retry + hiring signal fallback
Wave 9: Remaining HIGH items
VERIFICATION GATE C
```

### DAY 4-5: Workstreams D+E (sequential, D first)

**D (Evidence Integrity — ~11.5h):**
```
Step 1: D-C4 Schema validation scripts (2h) — MUST be first, gates pipeline readiness
Step 2: D-C2 DATA-COVERAGE-MATRIX (45 min) — needed by E findings
Step 3: D-C3 Fabrication detection verifier (1h) — needed by D-H5
Step 4: D-C5 Semantic checker (4h) — MOST IMPACTFUL single fix, longest
Step 5: D-H1..D-H4 High items (75 min) — methodology updates
Step 6: D-H5 Form vs substance correction (2h) — uses D-C3/D-C5 infrastructure
Step 7: D-M1..D-M4 Medium items (50 min) — documentation
VERIFICATION GATE D (partial: D-G1 and D-G2 need ground truth + calibration run)
```

**E (Data Quality — ~1h, can run during D Step 6-7):**
```
E-C1: Market sizing guidance (10 min)
E-H1..E-H3: Dark matter acknowledgment (30 min)
E-M1..E-M5: Medium items (25 min)
VERIFICATION GATE E
```

### DAY 5-6: Workstreams F (Pipeline Scheduling)

**F (Pipeline Scheduling — ~6.5h):**
```
Pre-Step: F-H2 Ground truth MUST be complete (from Day 1, Wesley)
Step 1: F-C2 RIOS limitations (30 min) — standalone
Step 2: F-C3 Falsifiability criteria (1h) — standalone
Step 3: F-H1 Surprise niche + fast-track (1h) — standalone
Step 4: F-M1 Two-pass pipeline (1h) — standalone
Step 5: F-M2 Data staleness fix (30 min) — standalone
Step 6: F-M3 Operator responsibilities (30 min) — standalone
Step 7: F-M4 Concurrency reduction (2h) — needs C-C4 in place
Step 8: F-C1 + F-C4 Realistic budget + timings (2h combined)
         ⚠️ These require calibration niche RUN — after ALL other infrastructure is deployed
VERIFICATION GATE F (partial: F-G1 and F-G8 need calibration run)
```

### DAY 7-8: Calibration Execution & G Remaining

**Calibration Execution (after ALL infrastructure fixes deployed):**
```
STEP 1: Run preflight-check — must PASS before any niche
STEP 2: Validate ground truth exists (F-H2)
STEP 3: Run CAL-A (Mid-Market IT Staffing) at STANDARD depth
         - Measure: credit consumption, wall-clock, tool failure rate
         - Output: reference canvas for 5 sections
STEP 4: Calibrate grade engine (D-C1) — 3 human raters vs engine on 30 claims
         - Target: Cohen's Kappa >= 0.61
STEP 5: Run CAL-A at DEEP depth — verify Phase 2 context budget
STEP 6: Run CAL-B (B2B Fractional Executive) — test data-sparse niche
STEP 7: Update ALL budget estimates based on real consumption
STEP 8: Pass/fail gate: any CRITICAL bug? → Do NOT proceed to main pipeline
```

**G (Security — remaining, parallel throughout):**
```
G-H1: Verify Reddit MCP ToS
G-C1 (done day 1)
G-H2 (done day 1)
G-H3 (done day 1)
G-H4: G2/Capterra ToS compliance + COMPLIANCE_BLACKLIST.yaml
G-M1: Prompt injection defense (already in B-C6)
G-M2: Run clean-raw-fetches
G-M3: Search transcripts for credential leaks
G-M4: Data disposal lifecycle documentation
G-M5: YouTube API quota tracking
G-L1..G-L3: Brandfetch attribution, UK Companies House, incident response
VERIFICATION GATE G
```

## Executable Now (AI Only, No Human Needed)

These can be done immediately without waiting for Wesley:

| Finding | Workstream | Est. Time |
|---|---|---|
| B-C1..B-C6 | B | 4h |
| B-H1..B-H6 | B | 2.5h |
| B-M1..B-M6 | B | 2h |
| C-C1 (timeout fix) | C | 5 min |
| C-C4 (concurrency lock) | C | 30 min |
| C-C6 (dead-host write) | C | 25 min |
| C-C8 (preflight-check) | C | 45 min |
| C-H1..C-H16 | C | 2.5h |
| C-M1..C-M15 | C | 2h |
| C-L1..C-L8 | C | 1h |
| D-C2 (DATA-COVERAGE-MATRIX) | D | 45 min |
| D-C3 (verifier) | D | 1h |
| D-C4 (validation scripts) | D | 2h |
| D-C5 (semantic checker) | D | 4h |
| D-H1..D-H4 | D | 75 min |
| D-H5 (form vs substance) | D | 2h |
| D-M1..D-M4 | D | 50 min |
| E-C1 (market sizing) | E | 10 min |
| E-H1..E-H3 (dark matter) | E | 30 min |
| E-M1..E-M5 | E | 25 min |
| F-C2 (RIOS limitations) | F | 30 min |
| F-C3 (falsifiability) | F | 1h |
| F-H1 (surprise niche) | F | 1h |
| F-M1 (two-pass) | F | 1h |
| F-M2 (staleness) | F | 30 min |
| F-M3 (operator resp.) | F | 30 min |
| F-M4 (concurrency reduce) | F | 2h |

**Subtotal AI-executable now:** ~27 hours of work (can be parallelized across agents)

## Waiting for Wesley (Human Required)

| Finding | Workstream | Human Time | Why |
|---|---|---|---|
| F-H2 Ground truth canvas | F | 4h minimum | Wesley must produce reference canvas for 5 sections |
| D-C1 Calibration study | D | 45 min + 2 raters | Wesley participates as 1 of 3 human raters for 30 claims |
| G-C1 FRED API key removal | G | 15 min | Needs Wesley to remove from settings.json + .bashrc |
| G-H2 Credential consolidation | G | 10 min | Needs Wesley to move env vars to settings.json |
| G-H4 G2/Capterra ToS | G | 45 min | Wesley reads ToS, makes compliance decision |
| G-M3 Transcript search | G | 15 min | Wesley reviews transcript redaction decisions |
| F-C1 Budget decision | F | 5 min | If budget supports <25 niches: increase or reduce? |

**Total human time:** ~6 hours (most of which is the ground truth canvas)

## Risk Register for D+E+F Execution

| Risk | Probability | Impact | Mitigation |
|---|---|---|---|
| D-C5 semantic checker costs exceed estimate | MEDIUM | Budget overrun | Start with 20% spot-check; measure actual cost; adjust sampling rate |
| D-C4 schema validation scripts uncover systemic issues in existing canvases | HIGH | Pipeline delay | Accept as expected — the scripts' purpose IS to find issues. Fix methodology, not retroactive fixes. |
| E dark matter documentation reveals pipeline fundamentally blind for >50% of niches | MEDIUM | Methodology overhaul | Already known for consulting/fractional. Design pipeline around it: lower fertility scores expected for those niches. |
| F-C1 first real niche consumes >400 credits | MEDIUM | Budget supports <14 niches | 2.0x buffer already set. If exceeded: accept lower niche count or increase budget. |
| F-H2 ground truth takes >6 hours from Wesley | HIGH | Delays D-C1, F-C1, F-C4 | Prioritize 5 sections minimum. Remaining sections filled during calibration. |
| F-M4 concurrency reduction insufficient (3 agents still collide) | LOW | Write corruption | Implement write-transactions atomically; if collisions persist at 3 agents, reduce to 2. |
| D-C3 verifier flags >50% of claims as NOT_SUPPORTED (pipeline quality concerns) | HIGH | Pipeline credibility crisis | Investigate root cause: is it poor claim drafting, poor source selection, or verifier algorithm too strict? |
