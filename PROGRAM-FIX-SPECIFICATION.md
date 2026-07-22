# Niche Research Program — Fix Specification

**Status:** BINDING — Execute exactly as specified. Deviations require pre-registered waivers.
**Source:** 17-lens holistic program audit (21 agents, 2.9M tokens, ~45 findings)
**Target:** Every P0, P1, P2, and P3 finding from the audit synthesis, organized into 6 workstreams.
**Standard:** Each workstream is designed to be executed by a team of world-class SMEs from the best consultancies, decacorns, FAANG companies, universities, and research institutes — each using the best-fitting frameworks, methodologies, best practices, and mental models for their specific domain.

---

## TABLE OF CONTENTS

1. [Fix Architecture](#1-fix-architecture)
2. [Workstream A: Scoring & Mathematical Validity](#2-workstream-a-scoring--mathematical-validity)
3. [Workstream B: Evidence Integrity & Anti-Fabrication](#3-workstream-b-evidence-integrity--anti-fabrication)
4. [Workstream C: Methodology & Agent Executability](#4-workstream-c-methodology--agent-executability)
5. [Workstream D: Infrastructure & Concurrent Operations](#5-workstream-d-infrastructure--concurrent-operations)
6. [Workstream E: Strategy, Portfolio & Financial Validity](#6-workstream-e-strategy-portfolio--financial-validity)
7. [Workstream F: Execution Readiness & GTM Translation](#7-workstream-f-execution-readiness--gtm-translation)
8. [Execution Sequence & Dependencies](#8-execution-sequence--dependencies)
9. [Verification Gates](#9-verification-gates)

---

## 1. Fix Architecture

### 1.1 Workstream Overview

| Workstream | P0 | P1 | P2 | P3 | Est. Hours | Expert Team |
|---|---|---|---|---|---|---|
| A: Scoring & Mathematical Validity | 2 | 0 | 1 | 1 | 6 hrs | Psychometrician + Decision Scientist + Statistician |
| B: Evidence Integrity & Anti-Fabrication | 2 | 3 | 1 | 1 | 14 hrs | Research Methodologist + Data Quality Engineer + AI Alignment Researcher |
| C: Methodology & Agent Executability | 2 | 2 | 0 | 2 | 10 hrs | Technical Writer + AI Prompt Engineer + UX Designer for Agents |
| D: Infrastructure & Concurrent Operations | 2 | 3 | 2 | 1 | 14 hrs | SRE + Distributed Systems Engineer + Platform Engineer |
| E: Strategy, Portfolio & Financial Validity | 0 | 2 | 4 | 2 | 10 hrs | Strategy Consultant + Financial Analyst + Portfolio Theorist |
| F: Execution Readiness & GTM Translation | 0 | 1 | 2 | 3 | 16 hrs | Fractional CTO + GTM Strategist + Web Developer + Copywriter |
| **Total** | **8** | **11** | **10** | **10** | **~70 hrs** | **18 experts across 6 teams** |

### 1.2 Dependency Graph

```
Workstream A (Scoring) ─────────────────────────────────────────────────┐
    ↓                                                                    │
Workstream B (Evidence) ──→ Workstream C (Methodology) ──→ Verification Gate
    ↓                                                                    │
Workstream D (Infrastructure) ───────────────────────────────────────────┘
    
Workstream E (Strategy) ──→ Workstream F (Execution) ──→ Final Gate
```

- **A must complete first** — all other workstreams depend on the corrected scoring formulas
- **B → C** — methodology changes depend on evidence integrity fixes
- **D can run in parallel with A+B+C** — infrastructure fixes are independent
- **E → F** — execution planning depends on strategy decisions
- **E+F can run in parallel with A+B+C+D** — different files, different concerns

### 1.3 Fix Identification Convention

Every fix is labeled `{Workstream}-{Priority}-{Number}`. Example: `A-P0-1` = Workstream A, Priority 0, Fix #1. This maps to the audit synthesis findings: `A-P0-1 = F1 (RIOS denominator inversion)`, `A-P0-2 = F2 (ordinal-to-interval violation)`, etc.

---

## 2. Workstream A: Scoring & Mathematical Validity

### Expert Team

| Role | Background | Responsibility |
|---|---|---|
| **Lead Psychometrician** | Educational Testing Service (ETS) / College Board — designs and validates scoring rubrics for high-stakes assessments used by millions | Validates that the RIOS framework and composite score produce meaningful, defensible rankings. Applies Item Response Theory and inter-rater reliability frameworks. |
| **Decision Scientist** | Stanford Decision Analysis / McKinsey Decision Quality — applies multi-criteria decision analysis (MCDA) to executive-level strategic choices | Ensures the scoring system produces decision-quality output. Applies sensitivity analysis, value of information analysis, and decision tree modeling. |
| **Statistician** | FDA Biostatistics / ASA — validates measurement scales for regulatory submission | Validates that ordinal-to-interval conversion is mathematically sound. Computes confidence intervals, rank uncertainty, and statistical power. |

### Frameworks & Methodologies

- **Item Response Theory (IRT)** — for validating that the 1-10 scoring anchors discriminate between niches of different quality
- **Multi-Attribute Utility Theory (MAUT)** — for constructing a mathematically valid composite from sub-scores
- **Analytic Hierarchy Process (AHP)** — for deriving weights from pairwise comparisons rather than intuition
- **Bootstrap Resampling** — for computing confidence intervals around niche ranks without distributional assumptions
- **Morris Method for Global Sensitivity Analysis** — for determining which weights actually drive ranking changes

### Fixes

#### A-P0-1: Fix RIOS Denominator Inversion (F1)

**Audit finding:** The formula `(QO × PL × SF) / (TTV × OF × PR)` divides by TTV, OF, and PR. A niche with the BEST time-to-value (score 5) gets DIVIDED BY 5, producing a LOWER RIOS score than a niche with the WORST time-to-value (score 1, divided by 1). The formula systematically ranks slow, high-friction, risky niches ABOVE fast, low-friction, safe ones.

**Target file:** `NICHE-METHODOLOGY.md` §14 Part B (RIOS Scoring)

**Corrected specification:**

Replace the multiplicative ratio formula with an additive mean formula. Invert the three denominator dimensions so that, like all other dimensions, HIGHER = BETTER.

```yaml
# §14 Part B — RIOS Scoring Formula (CORRECTED)

# Step 1: Invert denominator dimensions
# Original 1-5 scale where 1=worst, 5=best for ALL dimensions:
TTV_prime = 6 - TTV   # Time-to-Value: 5(fastest)→1, 1(slowest)→5  → higher=better
OF_prime  = 6 - OF    # Organizational Friction: 5(lowest)→1, 1(highest)→5 → higher=better
PR_prime  = 6 - PR    # Perceived Risk: 5(lowest)→1, 1(highest)→5 → higher=better

# Step 2: Compute RIOS as arithmetic mean of all 8 dimensions
RIOS = mean(QO, PL, SF, TTV_prime, OF_prime, PR_prime, D, C)

# Where:
#   QO = Quantified Outcome (1-5, higher=better)
#   PL = Proven Likelihood (1-5, higher=better)
#   SF = Strategic Fit (1-5, higher=better)
#   TTV_prime = Inverted Time-to-Value (1-5, higher=better)
#   OF_prime  = Inverted Organizational Friction (1-5, higher=better)
#   PR_prime  = Inverted Perceived Risk (1-5, higher=better)
#   D  = Defensibility (1-5, higher=better)
#   C  = Capacity to Deliver (1-5, higher=better)

# Range: 1.0 (worst possible) to 5.0 (best possible)
# All 8 dimensions contribute equally. Additive form eliminates inversion pathology.
```

**Verification:** Take the calibration niche. Score it once with the OLD formula and once with the CORRECTED formula. If any dimension's contribution changes direction (a high TTV niche drops in rank), the fix is working. The corrected formula should rank fast-to-build, low-friction, low-risk niches HIGHER than slow, high-friction, high-risk niches — all else equal.

---

#### A-P0-2: Fix Ordinal-to-Interval Scale Violation (F2)

**Audit finding:** The composite score treats 1-10 ordinal scores as interval data. The distance between anchors (8-10, 5-7, 3-4, 1-2) is not equal. Weighted linear combination (`SA×0.3 + WA×0.25 + CV×0.35 + BF×0.1`) is mathematically invalid for ordinal data. Ranking differences of 0.2-0.5 composite points are noise.

**Target files:**
- `NICHE-METHODOLOGY.md` §6.1 (Standardized Scoring Rubric)
- `NICHE-METHODOLOGY.md` §14 (Scoring)
- `schemas/canvas-frontmatter-schema.yaml` (composite_score field)

**Corrected specification:**

Replace the weighted linear combination of ordinal scores with **rank-based aggregation**. This is the standard approach in non-parametric statistics for combining ordinal rankings.

```yaml
# §6.1 — Composite Score (CORRECTED)

# Step 1: Score each niche on all 4 dimensions (unchanged)
#   SA = Structural Attractiveness (1-10)
#   WA = Warm Access (1-10)
#   CV = Commercial Viability (1-10)
#   BF = Build Feasibility (1-10)

# Step 2: After ALL 25 niches are evaluated, rank them on each dimension
#   Rank_SA(niche)  = position of niche when sorted by SA (1 = best, 25 = worst)
#   Rank_WA(niche)  = position of niche when sorted by WA
#   Rank_CV(niche)  = position of niche when sorted by CV
#   Rank_BF(niche)  = position of niche when sorted by BF

# Step 3: Compute Weighted Rank Sum
#   WRS = Rank_SA × 0.30 + Rank_WA × 0.25 + Rank_CV × 0.35 + Rank_BF × 0.10

# Step 4: Sort niches by WRS (LOWER = BETTER)
#   Rank 1 = lowest WRS = highest priority niche

# Properties:
#   - Mathematically valid for ordinal data (ranks are interval-scale)
#   - Preserves the intended weight structure
#   - Eliminates false precision (no decimal scores implying unearned accuracy)
#   - Ties are handled by mean rank (standard in non-parametric statistics)
#   - Sensitivity: rank changes of 1-2 positions are meaningful; 5+ positions are robust

# Uncertainty reporting:
#   For each niche, report the 90% bootstrap confidence interval of its rank.
#   If niche #3's CI is [1, 7] and niche #4's CI is [2, 8], they are effectively tied.
```

**Verification:** Take 5 scored niches. Compute the OLD composite (weighted linear). Compute the NEW composite (rank-based). Do the top 2 niches agree? If they disagree, the ordinal violation was material. The rank-based method is the correct answer.

---

#### A-P2-1: Add Bootstrap Confidence Intervals to Rankings

**Target file:** `NICHE-METHODOLOGY.md` §6.1, new subsection "Ranking Uncertainty"

**Specification:** After all 25 niches are ranked, run 1,000 bootstrap iterations (resample niches with replacement, re-rank, record ranks). For each niche, report the 90% confidence interval of its rank. Niches with overlapping CIs are flagged as "STATISTICALLY TIED" in the comparison dashboard.

---

#### A-P3-1: Implement Automated Weight Sensitivity Analysis

**Target file:** New script `research/_pipelines/weight-sensitivity`

**Specification:** A script that perturbs each weight by ±0.05, ±0.10, ±0.15 and reports which niches change rank. Output: a sensitivity matrix showing "Niche #3 and #4 swap at WA weight = 0.30" or "Top 3 stable across all perturbations."

---

## 3. Workstream B: Evidence Integrity & Anti-Fabrication

### Expert Team

| Role | Background | Responsibility |
|---|---|---|
| **Lead Research Methodologist** | Stanford GSB / NSF research methodology review board — audits evidence standards for federally funded research programs | Designs the traceability chain from canvas claim → raw HTTP response. Validates that the evidence grading system meaningfully distinguishes reliable from unreliable claims. |
| **Data Quality Engineer** | Google Data Engineering / FDA data integrity guidelines — builds data quality frameworks for petabyte-scale pipelines | Implements deterministic grade engine, content-independence checks, and schema validation. Ensures the evidence pipeline cannot be gamed. |
| **AI Alignment Researcher** | Anthropic / DeepMind alignment team — specializes in detecting and preventing reward hacking, specification gaming, and perverse incentives in LLM-based systems | Audits every scoring rule for perverse incentives. Ensures the agent's optimization landscape rewards honesty, not fabrication. Designs anti-gaming countermeasures. |

### Frameworks & Methodologies

- **Cohen's Kappa & Fleiss' Kappa** — for measuring inter-rater reliability of evidence grades between agents
- **Content-Origination Tracing** — for detecting when two "independent" sources share a common origin
- **Incentive Landscape Modeling** — for mapping the agent's optimization surface and finding reward-hacking paths
- **Adversarial Prompt Engineering** — for designing prompts that are robust against agent gaming
- **Reproducibility Criteria (NASEM 2019)** — the National Academies' standards for reproducible research

### Fixes

#### B-P0-1: Fix Completion Mandate → Fabrication Incentive (F3)

**Audit finding:** "Every section must be filled" combined with mandatory quantity thresholds (≥5 prospects, ≥3 competitors, ≥10 triggers) creates a structural incentive to fabricate. Honest agents who write SOURCE_UNAVAILABLE fail the completeness gate. Dishonest agents who fabricate pass all gates and rank higher.

**Target file:** `NICHE-METHODOLOGY.md` Part 2 (Research Protocol), Part 3 (Quality Gates), and every section with a quantity threshold

**Corrected specification:**

```markdown
## PRINCIPLE: Address, Don't Fabricate (BINDING)

Every section of the Niche Canvas must be ADDRESSED — not necessarily filled. If data is unavailable after a documented exhaustive search, write:

> **SOURCE_UNAVAILABLE** — [What was sought] could not be obtained after [N] attempts across [tools used]. Last attempt: [date]. [Brief explanation of why data is unavailable for this niche].

SOURCE_UNAVAILABLE is a VALID and COMPLETE response. It satisfies the completeness gate. It does NOT penalize the niche's score. It IS flagged in the evidence quality report so founders know this data point is missing.

## ANTI-FABRICATION RULE (BINDING)

Quantity thresholds (≥5 prospects, ≥3 competitors, ≥10 triggers) are TARGETS, not GATES. If only 2 competitors exist in a niche, writing SOURCE_UNAVAILABLE for the 3rd is CORRECT. Fabricating a 3rd competitor to hit the threshold is a PROGRAM-INTEGRITY VIOLATION.

Every quantity threshold in this document is hereby amended:
- OLD: "≥5 prospects required" → NEW: "Target: 5 prospects. If fewer exist, document all that do and mark the remainder SOURCE_UNAVAILABLE."
- OLD: "≥3 competitors with pricing anchors" → NEW: "Target: 3 competitors with pricing anchors. If the niche has fewer, document all competitors and explain why (e.g., 'niche is dominated by 2 players')."
- OLD: "≥10 trigger events" → NEW: "Target: 10 trigger events. Rank all discovered triggers by frequency × urgency. If fewer than 10 discovered, document the search methodology."
```

**Verification:** During calibration, deliberately select a niche with sparse public data (≤2 competitors, ≤3 trigger event types). If either agent fabricates data, the anti-fabrication rule has failed and the prompt needs hardening.

---

#### B-P0-2: Create Evidence Trace-Map Schema (F4a)

**Audit finding:** The trace-map that links canvas claims to source data has no formal schema. Agents write whatever they want. Schema violations are undetected. The traceability chain is aspirational, not enforced.

**Target files:**
- NEW: `schemas/trace-map-schema.yaml`
- `NICHE-METHODOLOGY.md` §6.2 and Appendix (evidence trace-map specification)

**Corrected specification:**

```yaml
# schemas/trace-map-schema.yaml — BINDING schema for evidence/trace-map.yaml

schema:
  name: "Evidence Trace-Map Schema"
  version: "1.0"
  source: "NICHE-METHODOLOGY.md §6.2, DATA-OPERATIONS-ARCHITECTURE.md §6.3"

fields:
  - field: niche_id
    type: string
    required: true
    pattern: "^(N-\\d{3}|CAL-[AB])$"
    description: "Niche identifier this trace-map belongs to"

  - field: generated_by
    type: string
    required: true
    description: "Agent identifier that authored this trace-map"

  - field: generated_at
    type: string (ISO 8601)
    required: true
    description: "Timestamp when trace-map was generated"

  - field: methodology_version
    type: string
    required: true
    description: "Git commit hash of NICHE-METHODOLOGY.md used"

  - field: claims
    type: list
    required: true
    min_items: 1
    item_schema:
      - field: claim_id
        type: string
        required: true
        pattern: "^[A-Z]-\\d{3}-§\\d+(\\.\\d+)*-claim-\\d+$"
        description: "Unique claim identifier, e.g., N-001-§3.2-claim-003"

      - field: claim_text
        type: string
        required: true
        description: "The exact text of the claim as it appears in the canvas"

      - field: canvas_section
        type: string
        required: true
        description: "Which section of the canvas this claim appears in (e.g., §3.2)"

      - field: evidence_grade
        type: string
        required: true
        enum: ["[P]", "[E]", "[H]", "[S]"]
        description: "Evidence grade assigned by the DETERMINISTIC grade engine (§6.2)"

      - field: grade_criteria
        type: dict
        required: true
        children:
          - field: c1_independent_sources
            type: boolean
            required: true
          - field: c2_verified_source
            type: boolean
            required: true
          - field: c3_within_sla
            type: boolean
            required: true
          - field: c4_source_urls
            type: boolean
            required: true

      - field: sources
        type: list
        required: true
        min_items: 1
        item_schema:
          - field: source_file
            type: string
            required: true
            description: "Path to structured data file (relative to niche-program/research/)"

          - field: source_field
            type: string
            required: true
            description: "Dotted path to the specific field in the source file"

          - field: source_url
            type: string (URL)
            required: true
            description: "Original URL from which data was fetched"

          - field: originating_source
            type: string
            required: false
            description: "For [P] claims: the root source both URLs trace back to. If two URLs cite the same underlying study/survey/report, they are NOT independent and this field MUST be populated."

          - field: fetch_date
            type: string (ISO 8601)
            required: true

          - field: fetch_tool
            type: string
            required: true
            enum: ["firecrawl_search", "firecrawl_scrape", "dataforseo", "openregistry_mcp", "reddit_research_mcp", "context7_mcp", "gdelt_api", "eurostat_api", "oecd_api", "public_ats_api", "manual"]

          - field: content_hash
            type: string
            required: true
            pattern: "^sha256:[a-f0-9]{64}$"
            description: "SHA-256 hash of the fetched content"

          - field: freshness_status
            type: string
            required: true
            enum: ["FRESH", "STALE", "EXPIRED"]

          - field: fresh_until
            type: string (ISO 8601)
            required: true

      - field: cross_source_agreement_pct
        type: float
        required: false
        description: "For [P] claims with numerical values: percentage agreement between sources. Required if evidence_grade is [P] and claim contains a numerical value."

  - field: independent_verification
    type: dict
    required: false
    description: "Populated by the independent verifier agent (Mechanism 7)"
    children:
      - field: verifier_agent
        type: string
        required: true
      - field: verification_date
        type: string (ISO 8601)
        required: true
      - field: urls_checked
        type: integer
        required: true
      - field: hashes_match
        type: integer
        required: true
      - field: hashes_mismatch
        type: integer
        required: true
      - field: claim_support_verified
        type: integer
        required: true
        description: "Number of checked URLs where the fetched content semantically supports the claim"
      - field: claim_support_failed
        type: integer
        required: true
        description: "Number of checked URLs where the fetched content does NOT support the claim"
      - field: verdict
        type: string
        required: true
        enum: ["PASS", "FLAGGED"]
```

**Verification:** During calibration, validate the calibration niche's trace-map against this schema using `validate-schema trace-map <file>`. Schema violations must be caught before the canvas enters scoring.

---

#### B-P1-1: Remove Agent Self-Grading (F4b)

**Audit finding:** The agent that authors the claims also assigns their evidence grades. The "deterministic grade engine" is invoked by the same agent that controls its inputs. An agent can fabricate a claim, cite it to a real URL, input C1=YES, C2=YES, C3=YES, C4=YES, and receive [P] — all within its own execution context. No independent process verifies the inputs.

**Target files:**
- NEW: `research/_pipelines/grade-engine` (standalone Python script)
- `DATA-OPERATIONS-ARCHITECTURE.md` §6.2

**Corrected specification:**

```python
#!/usr/bin/env python3
"""
grade-engine — Deterministic evidence grade assignment.

Stripe API Design: this is a standalone, stateless function that takes
claim+source data and returns a grade. It is invoked by a SEPARATE agent
from the one that authored the claims. The authoring agent writes the
trace-map; the grading agent reads it and assigns grades.

This separation ensures the agent cannot self-grade its own fabrications.
"""

# Grade assignment is a PURE FUNCTION of four binary criteria.
# No agent judgment. No "interpretation." No LLM call.
# If inputs are valid → output is deterministic (see truth table, Appendix C).

def assign_grade(c1: bool, c2: bool, c3: bool, c4: bool) -> str:
    """
    Deterministic evidence grade assignment.
    
    Priority-ordered, first-match-wins. See DATA-OPERATIONS-ARCHITECTURE.md §6.2
    and Appendix C for the complete 16-combination truth table.
    """
    if c1 and c2 and c3 and c4:    return "[P]"   # Priority 1
    if not c1 and c2 and c3 and c4: return "[E]"   # Priority 2
    if not c2:                       return "[H]"   # Priority 3
    if not c3:                       return "[H]"   # Priority 4 (demoted)
    if not c4:                       return "[S]"   # Priority 5
    return "[S]"  # DEFAULT
```

**Integration:** After the canvas agent writes the trace-map, a SEPARATE grading agent runs `grade-engine` against the trace-map. The grading agent cannot modify trace-map content — it only reads and assigns grades. The assigned grades are written to `trace-map.yaml` fields `evidence_grade` and `grade_criteria`.

---

#### B-P1-2: Add Content-Origination Independence Check (F4c)

**Target files:**
- `research/_pipelines/grade-engine` (extend)
- `schemas/trace-map-schema.yaml` (originating_source field — already in B-P0-2)

**Specification:** When a claim has 2+ sources and would qualify for [P], the grade engine checks the `originating_source` field. If both source URLs trace back to the same originating source (same survey, same report, same press release, same underlying study), they are NOT independent. The grade is capped at [E] with annotation "MULTI_SOURCE_SAME_ORIGIN."

Detection method: Compare the `originating_source` fields. If both are populated and match (case-insensitive, fuzzy match for minor formatting differences), flag as non-independent. If one or both are empty, flag for human review — the agent failed to document the originating source.

---

#### B-P1-3: Add Claim-Level Inter-Rater Reliability to Calibration (F4e)

**Target file:** `NICHE-METHODOLOGY.md` §6.3 (Mechanism 6: Calibration Protocol)

**Specification:** Extend the calibration protocol to test evidence grade agreement. After two agents independently evaluate the calibration niche, compute Cohen's Kappa on the evidence grades assigned to the same claims. Target: κ ≥ 0.61 (substantial agreement). If κ < 0.61, the evidence grading criteria are too ambiguous — add more examples to the grade engine's documentation and re-calibrate.

---

#### B-P2-1: Implement Evidence Half-Life Decay

**Target file:** `research/_pipelines/grade-engine` (extend)

**Specification:** Evidence grades auto-decay over time. A claim graded [P] in July 2026 is not equally trustworthy in January 2027. The world changes — competitors change pricing, markets shift, regulations update.

```python
EVIDENCE_HALF_LIFE = {
    "[P]": 180,  # 6 months — proven claims decay to [E] after 180 days
    "[E]": 120,  # 4 months — evidenced claims decay to [H] after 120 days
    "[H]": 60,   # 2 months — hypotheses decay to [S] after 60 days
    "[S]": 30,   # 1 month — speculative claims are flagged for re-evaluation
}
```

The grade engine checks `now - claim_date` against the half-life. If exceeded, the grade auto-downgrades. The downgrade is logged in trace-map with `grade_decay_applied: true` and `original_grade: "[P]"`.

---

#### B-P3-1: Add Random-Sampling Verification Schedule

**Target file:** `NICHE-METHODOLOGY.md` §6.3 (new Mechanism 9)

**Specification:** In addition to the every-5th-niche independent verification (Mechanism 7), add random-spot-check verification. After each niche, roll a 20% chance of triggering verification. If triggered, 10% of source URLs are re-fetched and content-hash-compared. This prevents agents from learning the verification schedule and gaming it (only fabricating on non-verification niches).

---

## 4. Workstream C: Methodology & Agent Executability

### Expert Team

| Role | Background | Responsibility |
|---|---|---|
| **Lead Technical Writer** | Stripe API Documentation / Google developer docs — writes specifications that engineers implement correctly on first read | Rewrites ambiguous instructions as explicit, testable commands. Eliminates "should" → "must." Adds decision trees for every agent choice point. |
| **AI Prompt Engineer** | Anthropic / Google DeepMind — designs prompts for autonomous agent systems where ambiguity causes production incidents | Audits every agent-facing instruction for executability. Adds context window management. Designs the per-phase loading specification. |
| **UX Designer for AI Agents** | Microsoft Copilot UX / LangChain agent UX — designs the experience of being an AI agent executing a task | Models the agent's "cognitive journey" through the methodology. Identifies confusion points, decision fatigue moments, and shortcut opportunities. |

### Frameworks & Methodologies

- **Controlled Natural Language (CNL)** — for writing instructions that are unambiguous to both humans and LLMs
- **Decision Tree Design** — for replacing "use your judgment" with explicit if-then logic
- **Context Budget Modeling** — for ensuring the agent never exceeds its working memory
- **GOMS Model (Goals, Operators, Methods, Selection)** — for modeling agent task execution at the keystroke level
- **Instruction Drift Measurement** — for quantifying how agent behavior changes across repeated iterations

### Fixes

#### C-P0-1: Add Context Window Management (F5)

**Audit finding:** No per-phase context budget. Combined methodology + architecture is ~172K tokens in a 200K window. Agents overflow mid-phase, dropping critical instructions. Consecutive niches contaminate each other's context.

**Target files:**
- NEW: `niche-program/AGENT-CONTEXT-SPEC.md`
- `NICHE-METHODOLOGY.md` Part 2 (Research Protocol)
- `DATA-OPERATIONS-ARCHITECTURE.md` §4

**Corrected specification:**

Create `AGENT-CONTEXT-SPEC.md` — the binding per-phase context loading specification:

```markdown
# Agent Context Specification — Per-Phase Loading

**Status:** BINDING. Every niche agent MUST follow this loading specification.
**Principle:** Agents load ONLY what they need for the current phase. No phase loads the full methodology.

## Phase 1: Niche Bounding
**Context budget:** ~40K tokens
**Load:**
1. NICHE-METHODOLOGY.md §1 (Niche Identity & Strategic Rationale) — lines 74-185
2. NICHE-METHODOLOGY.md §3.1 Research Sequence Phase 1 — lines 3397-3421
3. DATA-OPERATIONS-ARCHITECTURE.md §2.2 Tool Selection Decision Tree — lines 130-163
4. DATA-OPERATIONS-ARCHITECTURE.md §4.1 Phase 1 Pipeline — lines 359-373
5. AGENT-CONTEXT-SPEC.md (this file, Phase 1 section only)
**DO NOT LOAD:** §2-15 of methodology, §4.2-4.4 of architecture, any operational scripts

## Phase 2: Deep Research
**Context budget:** ~60K tokens
**Load:**
1. NICHE-METHODOLOGY.md §§2-6 (Buyer, Pain, Competitive, Ecosystem, Signals) — lines 186-1000
2. NICHE-METHODOLOGY.md §3.1 Research Sequence Phase 2 — lines 3411-3417
3. DATA-OPERATIONS-ARCHITECTURE.md §4.2 Phase 2 Pipeline — lines 374-393
4. DATA-OPERATIONS-ARCHITECTURE.md §2.3 Tool-to-Task Master Matrix — lines 165-186
5. DATA-OPERATIONS-ARCHITECTURE.md §5.1-5.3 Data Schemas — lines 431-580
6. AGENT-CONTEXT-SPEC.md (this file, Phase 2 section only)
**DO NOT LOAD:** §§7-15 of methodology, §4.3-4.4 of architecture, RUNBOOK.md

[... continue for Phases 3 and 4 ...]

## Context Overflow Protocol

If at any point the agent's context approaches 80% capacity (160K/200K tokens):
1. CHECKPOINT: Write current state to N-XXX/_work/CHECKPOINT.yaml
2. FLUSH: Clear all non-essential context
3. RECOVER: Reload from CHECKPOINT.yaml and continue from last completed step
4. LOG: Record overflow event in PIPELINE_CHECKPOINTS.yaml

## Session Isolation Rule (BINDING)

Each niche evaluation MUST use a FRESH agent session. No session reuse across niches.
A session that evaluated N-003 must not be used for N-007.
Shared data is accessed through the filesystem (SHARED/ registry), not through session memory.
```

---

#### C-P0-2: Fix Bob Time Budget (F8)

**Audit finding:** Methodology references 40 hrs/week for Bob. Reality: ~20 hrs/week. Every downstream capacity calculation, GTM timeline, and founder capacity allocation is off by 2×.

**Target file:** `NICHE-METHODOLOGY.md` — global find-and-replace

**Corrected specification:** Every reference to founder time commitment must reflect reality:
- "40 hrs/week" → "20 hrs/week" (Bob's actual availability)
- All capacity calculations using founder time must be re-derived at 20 hrs/week
- Section 7.4 (Offer Economics Summary) must recalculate founder capacity allocation
- Section 10.5 (Land-and-Expand Trajectory) timelines must double (what took 3 months at 40 hrs takes 6 months at 20 hrs)

---

#### C-P1-1: Rewrite "Should" → "Must" (Ambiguity Elimination)

**Audit finding (Lens 2a):** 83 instances of "should," "consider," "may," "ideally," "suggest," "could," "might," or "optionally" in NICHE-METHODOLOGY.md alone. An AI agent cannot distinguish between "should" (advisory) and "must" (mandatory). Every "should" is an ambiguity that produces non-deterministic behavior across 25 agents.

**Target file:** `NICHE-METHODOLOGY.md` — global audit of 83 ambiguous terms

**Corrected specification:**

For every instance of ambiguous language:
- "should" → "must" (if the instruction is mandatory) or "may" (if it's truly optional, with explicit conditions)
- "consider X" → "evaluate X against criteria Y. If Y ≥ threshold, do Z. Otherwise, skip and document reason."
- "ideally" → DELETE (the methodology describes what's required, not what would be nice)
- "suggest" → DELETE (same reason)
- "could" → replace with explicit decision rule
- "might" → DELETE or replace with probability estimate
- "optionally" → "Optional. If skipped, document reason in §15 Open Questions."

Example transformation:
- BEFORE: "Search for competitor pricing. Consider checking G2 reviews if available."
- AFTER: "Search for competitor pricing using Firecrawl /scrape on competitor pricing pages (DATA-OPERATIONS-ARCHITECTURE.md §2.3, Row 2). Then search G2 for reviews using Firecrawl /search '[competitor] reviews G2.' If G2 review page is login-walled, skip and document in §4.7 Competitive Intelligence Limitations."

---

#### C-P1-2: Add Agent Decision Trees for Every Choice Point

**Target file:** NEW: `niche-program/AGENT-DECISION-TREE.md`

**Specification:** Every point in the methodology where an agent must make a choice must have an explicit decision tree. Example:

```markdown
## Decision Point: Phase 1 → Phase 2 Transition

IF Phase 1 confirms niche existence (≥50 searchable companies, ≥1 analyst report, data accessibility GREEN):
    → PROCEED to DEEP depth (Phase 2)
ELSE IF Phase 1 partially confirms (≥25 companies, zero analyst reports, data accessibility YELLOW):
    → PROCEED to STANDARD depth (Phase 1 only, no Phase 2-4)
    → Flag as HIGH-UNCERTAINTY in LEDGER.yaml
    → Do NOT proceed to DEEP without explicit Wesley approval
ELSE IF Phase 1 fails (<25 companies, data accessibility RED):
    → HALT evaluation
    → Flag as INCONCLUSIVE in LEDGER.yaml
    → Credit budget: ~17 credits consumed (Phase 1 only)
```

Every decision point in the 4-phase pipeline must have an equivalent tree.

---

#### C-P3-1: Implement NLP Drift Detection

**Target file:** NEW: `research/_pipelines/drift-detector`

**Specification:** After every 5 niches, compare the most recent canvas against the calibration niche canvas. Compute cosine similarity of section embeddings. If similarity drops below 0.7 (indicating the agent is writing qualitatively different content), flag for human review. This detects methodology drift before it contaminates 20 niches.

#### C-P3-2: Add Anti-Fragility Dashboard

**Target file:** Extend `research/_pipelines/generate-quality-dashboard`

**Specification:** Add an "Antifragility Score" section to the dashboard. Metrics: SHARED/ registry growth rate (entries per niche), credit-per-niche trend (should decrease as cache hits increase), evidence quality trend (should improve as benchmarks accumulate), calibration re-score drift (should be stable). If any metric DEGRADES across niches, the program is fragile, not antifragile.

---

## 5. Workstream D: Infrastructure & Concurrent Operations

### Expert Team

| Role | Background | Responsibility |
|---|---|---|
| **Lead SRE** | Google SRE / NASA JPL — designs production systems where failure is not an option | Hardens the operational scripts for concurrent 4-agent execution. Designs the file-level locking protocol. Models credit exhaustion. |
| **Distributed Systems Engineer** | Amazon DynamoDB / Google Spanner — designs shared-state protocols for eventually-consistent systems | Designs the SHARED/ registry protocol. Ensures dedup correctness under concurrent access. Models race conditions. |
| **Platform Engineer** | Stripe / Shopify — builds internal platforms that 100+ engineers use daily | Ensures the scripts, schemas, and registries form a cohesive platform. Designs the developer experience for niche agents. |

### Frameworks & Methodologies

- **Jepsen-style Concurrency Testing** — for finding race conditions in shared-state protocols
- **Capacity Planning Under Uncertainty** — for modeling credit consumption with confidence intervals
- **Defense in Depth** — for ensuring no single failure cascades into total pipeline failure
- **Immutable Infrastructure** — for ensuring agents cannot corrupt shared state
- **Chaos Engineering (Netflix Simian Army)** — for injecting failures to verify resilience

### Fixes

#### D-P0-1: Fix Credit Budget (F10)

**Audit finding:** Architecture assumes 100K Firecrawl credits. Reality: ~10K. Every budget calculation, gate threshold, and depth model is off by 10×. The 25-niche DEEP program is unaffordable as designed.

**Target file:** `DATA-OPERATIONS-ARCHITECTURE.md` §1.2, §4.5, §8.1

**Corrected specification:**

```yaml
# §1.2 Key Numbers (CORRECTED)
| Firecrawl credits available | ~10,000 (verify exact balance with `firecrawl credit-usage`) |
| Firecrawl per niche (STANDARD) | ~17 credits |
| Firecrawl per niche (DEEP) | ~132 credits (estimated — MEASURE on calibration niche) |
| Max DEEP niches at 10K budget | ~50 (allows 25 DEEP + 25 STANDARD with buffer) |
| Conservative budget for 25 niches | 25 × 132 × 1.3 (30% buffer) = ~4,300 credits |
| Phase 0 calibration budget | 200 credits (one-time) |

# §4.5 Pre-Spend Credit Gates (CORRECTED)
| GATE-1→2 | Firecrawl remaining ≥ 2,000 credits | (was 5,000 — adjusted for 10K budget) |

# §8.1 Three-Depth Execution Model (CORRECTED)
# All credit numbers verified against actual balance.
# Calibration niche will produce MEASURED consumption to replace estimates.
```

---

#### D-P0-2: Fix Dead-Host Registry (F11)

**Audit finding:** `DEAD_HOST_REGISTRY.yaml` contains `firecrawl.dev` as a blocked host — a leftover from script testing. This blocks the PRIMARY tool for all niches.

**Target file:** `research/_program/DEAD_HOST_REGISTRY.yaml`

**Corrected specification:** Remove the test entry. The registry should be empty at program start, populated only by genuine dead-host detections during pipeline execution. Add a validation check: "DEAD_HOST_REGISTRY.yaml must never contain entries for primary tool base URLs (firecrawl.dev, api.dataforseo.com). If a primary tool appears dead, escalate to Wesley — do NOT auto-block."

---

#### D-P1-1: Implement SHARED/ Registry + Dedup Protocol (F12)

**Audit finding:** SHARED/_REGISTRY.yaml and dedup-manifest.yaml are specified in the architecture but don't exist on disk. The bootstrap protocol for the first 5 niches is undocumented. Cross-niche data sharing is theoretical.

**Target files:**
- NEW: `research/SHARED/_REGISTRY.yaml` (initialized with empty index)
- NEW: `research/_pipelines/dedup-manifest.yaml` (initialized)
- `DATA-OPERATIONS-ARCHITECTURE.md` §7.1-7.3

**Corrected specification:**

Create `SHARED/_REGISTRY.yaml`:
```yaml
# SHARED/_REGISTRY.yaml — Master index of all cross-niche shared data
# Read by every niche agent BEFORE fetching any data (§7.2 Discovery Protocol)
# Updated by every niche agent AFTER completing evaluation
last_updated: "2026-07-23"
entries:
  competitors: {}
    # Example entry:
    # syncgtm:
    #   profile_file: "SHARED/competitors/syncgtm-v1.yaml"
    #   first_profiled_by: "N-003"
    #   fetch_date: "2026-07-23"
    #   fresh_until: "2026-10-21"
    #   niches_relevant: ["N-003", "N-007"]
  benchmarks: {}
  triggers: {}
  regulatory: {}
  buyer_language: {}
```

Create `_pipelines/dedup-manifest.yaml`:
```yaml
# dedup-manifest.yaml — Tracks which niche first profiled each cross-niche entity
# Prevents duplicate credit spend on the same competitor across niches (§7.3)
entries: {}
  # Example:
  # syncgtm: {first_profiled_by: "N-003", profile_file: "SHARED/competitors/syncgtm-v1.yaml"}
```

**Bootstrap protocol (first 5 niches):** For niches 1-5, the SHARED registry will be sparse. Bootstrap fetches count against the initiating niche's budget. CREDIT_BUDGET.yaml tracks a `cross_niche_bootstrap_credits` field. After niche 5, ≥60% of common cross-niche data should exist in SHARED/. If not, escalate — niches may not be sharing data correctly.

---

#### D-P1-2: Implement File-Level Locking Protocol (F13)

**Audit finding:** CREDIT_BUDGET.yaml, CACHE_MANIFEST.yaml, TOOL_ERROR_LOG.yaml, and all SHARED/ files are accessed by 4 concurrent agents with no locking. Read-modify-write races produce lost updates, duplicate entries, and corrupted YAML.

**Target file:** NEW: `research/_pipelines/lib/file_lock.py`

**Corrected specification:**

```python
"""
file_lock.py — Advisory file locking for concurrent agent access.

Google SRE pattern: lock before mutate. Wait with backoff. Break stale locks.

Usage:
    with FileLock(path_to_shared_file, timeout_seconds=30):
        data = load_yaml_safe(path)
        data["new_entry"] = ...
        write_yaml_atomic(data, path)
"""

import time
import os
from pathlib import Path

class FileLock:
    def __init__(self, file_path: Path, timeout_seconds: int = 30):
        self.lock_path = file_path.parent / f".{file_path.name}.lock"
        self.timeout = timeout_seconds
    
    def __enter__(self):
        waited = 0
        while waited < self.timeout:
            try:
                # Create lock file atomically (O_EXCL fails if exists)
                fd = os.open(str(self.lock_path), os.O_CREAT | os.O_EXCL | os.O_WRONLY)
                os.write(fd, f"locked_by=niche_agent\ntimestamp={time.time()}".encode())
                os.close(fd)
                return self
            except FileExistsError:
                # Check if lock is stale (>5 minutes old)
                if self._is_stale():
                    self._break_lock()
                    continue
                time.sleep(1)
                waited += 1
        raise TimeoutError(f"Could not acquire lock on {self.lock_path} within {self.timeout}s")
    
    def __exit__(self, *args):
        if self.lock_path.exists():
            self.lock_path.unlink()
    
    def _is_stale(self) -> bool:
        try:
            mtime = self.lock_path.stat().st_mtime
            return (time.time() - mtime) > 300  # 5 minutes
        except OSError:
            return True
    
    def _break_lock(self):
        self.lock_path.unlink(missing_ok=True)
```

**Integration:** Every script that writes to CREDIT_BUDGET.yaml, CACHE_MANIFEST.yaml, TOOL_ERROR_LOG.yaml, DEAD_HOST_REGISTRY.yaml, or any SHARED/ file MUST use FileLock. Scripts that only read these files do not need a lock (the atomic write pattern ensures readers never see partial writes — they see either the old file or the new file, never a half-written one).

---

#### D-P1-3: Add Non-Firecrawl Fallback Validation (F18/P2-8)

**Target files:** `DATA-OPERATIONS-ARCHITECTURE.md` §2.2 (Decision Tree), §4.0 (Phase 0)

**Specification:** If Firecrawl is unavailable during calibration or niche evaluation, the agent must have a documented, tested fallback for every data type. Test DataForSEO OnPage API (free content parsing) and Jina AI MCP (reader mode) as fallbacks for pricing pages and review extraction. Document success rates in Phase 0 calibration.

---

#### D-P2-1: Implement GameDay Automated Test Suite (P3-1)

**Target file:** NEW: `research/_pipelines/test/test_gameday.sh`

**Specification:** An automated chaos test that:
1. Corrupts CREDIT_BUDGET.yaml mid-execution
2. Adds firecrawl.dev to DEAD_HOST_REGISTRY.yaml
3. Creates a CACHE_MANIFEST.yaml with orphaned entries
4. Writes invalid YAML to TOOL_ERROR_LOG.yaml
5. Fills .firecrawl/ directory to 95% disk
6. Runs all 5 operational scripts
7. Verifies: scripts detect corruption, produce correct exit codes, log errors, and do NOT crash

---

#### D-P2-2: Create Infrastructure Inventory

**Target file:** NEW: `niche-program/INFRASTRUCTURE-INVENTORY.md`

**Specification:** Document every existing ClarityRev asset that niche agents should reference: existing competitor audits, VOC corpus, Gapstars demo learnings, Bullhorn API knowledge, Clay enrichment templates, existing CRM connectors. Without this, agents evaluate niches in a vacuum, unaware of existing ClarityRev knowledge.

#### D-P3-1: Add SBOM Generator for Toolchain

**Target file:** NEW: `research/_pipelines/generate-sbom`

**Specification:** A script that generates a Software Bill of Materials for the entire toolchain: every MCP server with version, every free API with rate limit, every Python dependency with license. Run before calibration and after every toolchain change.

---

## 6. Workstream E: Strategy, Portfolio & Financial Validity

### Expert Team

| Role | Background | Responsibility |
|---|---|---|
| **Lead Strategy Consultant** | McKinsey / BCG — advises Fortune 500 companies on market entry strategy | Validates that the program's strategic framework produces decision-quality recommendations. Ensures the "no-go" path exists. Models competitive response. |
| **Financial Analyst** | Goldman Sachs / Berkshire Hathaway — builds financial models that withstand board scrutiny | Validates the EUR 500K gate math. Builds CAC/LTV sensitivity models. Ensures unit economics close for a bootstrapped startup. |
| **Portfolio Theorist** | Bridgewater / Yale Endowment — applies modern portfolio theory to strategic decisions under uncertainty | Designs the portfolio analysis framework. Ensures niche selection considers covariance, not just individual merit. |

### Frameworks & Methodologies

- **Modern Portfolio Theory (Markowitz)** — for optimizing the niche portfolio for risk-adjusted return, not just individual niche quality
- **Real Options Valuation** — for valuing the optionality created by entering one niche (expansion paths, adjacency plays)
- **Scenario Planning (Shell Method)** — for stress-testing niche recommendations under multiple future states
- **Jobs-to-be-Done Theory (Christensen)** — for validating that the canvas captures the real "job" buyers are hiring for
- **Five Forces (Porter)** — for modeling competitive intensity and barriers to entry sustainability

### Fixes

#### E-P1-1: Remove Data-Rich Niche Penalty (F6)

**Audit finding:** Niches with more public data produce more [P]/[E] claims and score higher. Data-poor niches (genuine blue-ocean opportunities) produce more [H]/[S] claims and are penalized with half-weight scoring. The program systematically recommends crowded red oceans over innovative whitespace.

**Target file:** `NICHE-METHODOLOGY.md` §6.3 (Mechanism 2: Evidence Grade Audit)

**Corrected specification:**

```markdown
# Mechanism 2: Evidence Confidence Flag (CORRECTED)

OLD (REMOVED): "If >50% are [H] or [S], the canvas must be flagged as HIGH-UNCERTAINTY
and scored at half weight in comparisons."

NEW: "Every canvas reports an EVIDENCE CONFIDENCE FLAG:
- HIGH CONFIDENCE: ≥66% [P]+[E] claims
- MODERATE CONFIDENCE: 33-66% [P]+[E] claims
- LOW CONFIDENCE: <33% [P]+[E] claims

The evidence confidence flag is REPORTED ALONGSIDE the composite score. It does NOT
affect the composite score ranking. The founders see:
  'Niche #3 ranks 1st (composite) with MODERATE confidence — the data is thinner
   than Niche #7 which ranks 2nd with HIGH confidence.'

Decision rule: If two niches are within the ranking uncertainty band (A-P2-1 bootstrap CI),
the niche with HIGHER evidence confidence is recommended. If a niche ranks #1 with LOW
confidence, the founders are explicitly warned: 'This is the highest-scoring niche but
the evidence for this score is thin. Validate with primary research before committing.'"
```

---

#### E-P1-2: Fix EUR 500K Gate Math (F15)

**Audit finding:** The EUR 500K gate uses gross profit as a proxy for net profit, omitting fixed costs (tools, infrastructure, Wesley's time). The formula `clients × price × margin` does not account for the cost of the tools and infrastructure needed to deliver the service.

**Target file:** `NICHE-METHODOLOGY.md` §14, §7.4

**Corrected specification:**

```markdown
# EUR 500K Net Profit Gate (CORRECTED)

Net Annual Profit = (Clients × ARPU × 12) × Gross Margin − Annual Fixed Costs

Where:
  ARPU = Average Revenue Per User (monthly)
  Gross Margin = (Revenue − Variable Costs) / Revenue
    Variable costs include: Firecrawl credits, DataForSEO credits, Clay enrichment,
    Claude API tokens, CRM subscription per client
  Annual Fixed Costs = Sum of:
    Core tools & infra: EUR 6,000/yr (Firecrawl, DataForSEO, hosting, domains)
    Wesley fractional CTO: EUR 24,000/yr (opportunity cost of time)
    Bob/Adriaan: EUR 0 (founders, no salary until profitability)
    Buffer: 20% of subtotal

Gate: Net Annual Profit ≥ EUR 500,000 at 50 clients within 24 months.
If the model requires >50 clients or >24 months, flag as EXTENDED-TIMELINE.
If the model requires >100 clients, flag as REQUIRES-VC-SCALE (infeasible for bootstrapped).
```

---

#### E-P2-1: Add Portfolio Analysis Framework (F14)

**Target file:** NEW section in `NICHE-METHODOLOGY.md` §15 or new Part 6

**Specification:** After all 25 niches are evaluated, run portfolio analysis:

1. **Correlation Matrix:** For each pair of top-10 niches, score overlap on: CRM system dependency, buyer persona, signal types, competitor set, regulatory environment. High overlap = high correlation = poor diversification.

2. **Concentration Score:** What percentage of the top-3 niches share the same CRM dependency? If >66%, a single CRM API deprecation kills the entire strategy.

3. **Adjacency Value:** For each niche, what other niches become EASIER to enter after establishing a foothold here? (Shared competitor intelligence, shared buyer language, shared signal detection, shared brand authority.)

4. **Sequencing Recommendation:** Given the portfolio analysis, what's the recommended ENTRY SEQUENCE? Niche A first (largest TAM, establishes brand), then Niche B (adjacent, reuses signals), then Niche C (aspirational, requires authority from A+B).

---

#### E-P2-2: Add Competitive Defensibility to Scoring (P2-2)

**Target file:** `NICHE-METHODOLOGY.md` §6.1, §14

**Specification:** Add a 5th scoring dimension to the composite:

```markdown
#### Score 5: Competitive Defensibility (1-10)
Based on: barriers to entry, incumbent response speed, white space half-life, switching costs, network effects, data moat potential
- 8-10: High barriers, slow incumbent response, white space sustainable >24 months
- 5-7: Moderate barriers, incumbents respond in 12-24 months, white space lasts 12 months
- 3-4: Low barriers, incumbents respond in 6-12 months, white space lasts 6 months
- 1-2: No barriers, incumbents respond immediately, white space is already closing

Weight: 0.10 (reducing Commercial Viability from 0.35 → 0.30, Build Feasibility from 0.10 → 0.05)
New composite: SA×0.30 + WA×0.25 + CV×0.30 + BF×0.05 + CD×0.10
```

---

#### E-P2-3: Add Time-to-Cash Dimension (P2-3)

**Target file:** `NICHE-METHODOLOGY.md` §6.1

**Specification:** A niche that takes 12 months to generate first revenue is fundamentally different from one that generates revenue in 2 months. Add a 6th dimension.

#### E-P2-4: Model Competitive Response Timing (F17/P2)

**Target file:** `NICHE-METHODOLOGY.md` §4 (Competitive Landscape)

**Specification:** For each top-5 niche, estimate: how long after ClarityRev's entry before the #1 incumbent launches a competing feature? How long before they drop prices? How long before they publish a "vs ClarityRev" comparison page? This is the "white space half-life" — the window during which ClarityRev can establish before competitive response begins.

---

#### E-P3-1: Create Portfolio Execution Dashboard

**Target file:** Extend `research/_pipelines/generate-quality-dashboard`

**Specification:** A dashboard view showing the top-10 niches as a portfolio: correlation heatmap, concentration score, sequencing recommendation, and risk-adjusted return (composite score ÷ portfolio correlation).

#### E-P3-2: Implement Weight Sensitivity Analysis Automation

See A-P3-1.

---

## 7. Workstream F: Execution Readiness & GTM Translation

### Expert Team

| Role | Background | Responsibility |
|---|---|---|
| **Lead Fractional CTO** | Multiple B2B SaaS startups, $0→$10M ARR — has built and shipped with 3-person teams | Validates that the program's recommendations are BUILDABLE by a 3-person team. Designs the "day 1 after selection" execution plan. |
| **GTM Strategist** | B2B SaaS from $0→$50M ARR — has taken multiple products from zero to first 100 customers | Validates that the canvas output is ACTIONABLE for outbound sales. Designs the "first 10 conversations" playbook. |
| **Web Developer (CRO-focused)** | Webflow / conversion optimization — builds B2B websites that convert at 3%+ | Translates canvas output into a complete website specification. Validates that buyer language, pain architecture, and competitive positioning are copy-ready. |
| **Conversion Copywriter** | B2B SaaS copywriting — writes hero text, value props, and landing pages that convert | Audits the canvas's buyer language output for copy readiness. Flags gaps between "what buyers say in reviews" and "what copy needs to convert." |

### Frameworks & Methodologies

- **Conversion-Centered Design (CCD)** — for structuring website pages around conversion goals, not content inventory
- **Voice-of-Customer Copywriting** — for translating verbatim buyer language into conversion copy
- **Jobs-to-be-Done (for copy)** — for structuring copy around the progress buyers are trying to make
- **The "First 10 Conversations" Framework** — for designing outbound sequences that work before you have case studies
- **SPA (Single-Page Application) Architecture** — for building fast, conversion-optimized B2B websites

### Fixes

#### F-P1-1: Fix Calibration Protocol (F17)

**Audit finding:** The calibration protocol evaluates ONE niche shared by two agents. This establishes inter-rater reliability on a SINGLE data point. It cannot detect systematic bias (agents might agree on the calibration niche but diverge systematically on different types of niches).

**Target file:** `NICHE-METHODOLOGY.md` §6.3 (Mechanism 6)

**Corrected specification:**

```markdown
# Mechanism 6: Calibration Protocol (CORRECTED)

OLD: Calibrate on ONE niche with TWO agents.
NEW: Calibrate on TWO niches with TWO agents each.

Niche CAL-A: "Mid-Market IT Staffing Agencies on Bullhorn" (data-rich, well-understood)
Niche CAL-B: [A data-sparse niche TBD — blue-ocean opportunity with minimal public data]

Why two calibration niches:
- CAL-A tests agent agreement on a DATA-RICH niche (many competitors, many reviews)
- CAL-B tests agent agreement on a DATA-SPARSE niche (few competitors, thin public data)
- If agents agree on CAL-A but diverge on CAL-B, the methodology produces different
  results for different niche types — evidence grading criteria need refinement.

ADDITIONALLY: Establish a GROUND-TRUTH REFERENCE for CAL-A.
Before agents evaluate CAL-A, Wesley manually produces a "reference canvas" for
5 sections (§1, §2, §4, §10, §14). This ground truth is the standard against
which agent accuracy is measured. Agents must agree with the ground truth (not
just with each other).

INTER-RATER RELIABILITY:
- Compute Cohen's Kappa on evidence grades (target: κ ≥ 0.61)
- Compute Intraclass Correlation Coefficient (ICC) on RIOS scores (target: ICC ≥ 0.75)
- If either metric fails: methodology amendment → re-calibrate → repeat until passing
```

---

#### F-P2-1: Create Buyer-Language Schema (P2-1)

**Target file:** NEW: `schemas/buyer-language-schema.yaml`

**Specification:** A structured schema for buyer language extracts that distinguishes between:

```yaml
# Buyer language fields
- field: verbatim_quote
  description: "Exact text from review/Reddit/interview — no paraphrasing"
- field: source_url
  description: "URL where this quote was found"
- field: reviewer_role
  description: "Job title of the person who wrote this (e.g., VP Sales, CRO)"
- field: pain_classification
  enum: [EXPRESSED_PAIN, LATENT_PAIN, ASPIRATIONAL_GOAL, COMPLIANCE_REQUIREMENT]
  description: "What type of buyer motivation does this quote represent?"
- field: emotional_charge
  enum: [FRUSTRATED, ANXIOUS, HOPEFUL, SKEPTICAL, URGENT, RESIGNED]
  description: "The emotional state behind the words — drives copy tone"
- field: copy_ready
  type: boolean
  description: "Can this quote be used directly as website copy? If false, what's missing?"
- field: headline_candidate
  type: boolean
  description: "Is this quote strong enough to be a hero headline?"
- field: competitor_mentioned
  type: string
  description: "Which competitor is the buyer evaluating? (for 'vs Competitor X' pages)"
- field: trigger_event
  type: string
  description: "What event caused the buyer to start looking? (for trigger-based landing pages)"
```

---

#### F-P2-2: Create Complete Website Copy Specification (P2-5)

**Target file:** NEW: `niche-program/WEBSITE-COPY-SPEC.md`

**Specification:** For the selected niche, produce a complete copy document covering:

1. **Hero Section:** Headline (from buyer language), subheadline (from pain architecture), CTA (from free diagnostic snapshot)
2. **"The Problem" Section:** Quantified pain in buyer's own words, cost of inaction, "what happens if you do nothing"
3. **"How It Works" Section:** The signal detection → enrichment → delivery pipeline, explained in buyer language
4. **"vs Competitor X" Pages:** One page per top-3 competitor, using their own reviews against them
5. **Pricing Page:** Pricing ladder with value justification per tier, guarantee structure, "who is this for" per tier
6. **Social Proof Section:** Placeholder structure for case studies (populated after first 3 clients)
7. **Lead Magnet Landing Page:** The diagnostic snapshot — what it is, what it reveals, how to get it
8. **Blog Content Calendar:** 12 topics derived from trigger events and buyer questions

Each section specifies: the copy direction, the verbatim buyer language to use, the emotional tone, and the conversion goal.

---

#### F-P2-3: Map Canvas to Schema.org Structured Data (P2-6)

**Target file:** NEW: `niche-program/SEO-STRUCTURED-DATA-SPEC.md`

**Specification:** Map every page type to Schema.org types for SEO:
- Homepage → `Organization` + `WebSite`
- "How It Works" → `HowTo`
- Pricing → `Product` with `Offer` items
- Blog → `BlogPosting` with `author` and `datePublished`
- Lead Magnet → `WebApplication` with `potentialAction`

---

#### F-P3-1: Add Founder-Market Fit to Scoring (F9/P1-9)

**Target file:** `NICHE-METHODOLOGY.md` §6.1, §1

**Specification:** Add "Founder-Market Fit" as a scored dimension:

```markdown
#### Score 5 (or 6): Founder-Market Fit (1-10)
Based on: Bob's network relevance, Adriaan's data ops fit, Wesley's build capability, 
founder energy/enthusiasm for this niche, credibility with this buyer persona
- 8-10: Bob knows 10+ potential buyers personally, founders are excited, credible to buyers
- 5-7: Bob knows 3-9 buyers, founders are interested, somewhat credible
- 3-4: Bob knows 0-2 buyers, founders are neutral, credibility is a stretch
- 1-2: No network, no energy, no credibility — why are we even evaluating this?

Weight proposals:
- Option A: 0.15 (reducing CV 0.35→0.30, BF 0.10→0.05)
- Option B: 0.10 (reducing CV 0.35→0.30, WA 0.25→0.20)
Decision: Defer to A-P0-2 weight sensitivity analysis to determine optimal weight.
```

---

#### F-P3-2: Create "Day 1 After Selection" Execution Plan Template

**Target file:** NEW section in `NICHE-METHODOLOGY.md` §15 or Part 6

**Specification:** The program currently ends at "here's your ranked list of niches." Add a "Day 1 After Selection" section that answers:

1. **What gets built first?** The minimum viable signal engine, one CRM connector, and the diagnostic snapshot — in that order.
2. **Who builds what?** Wesley: signal engine + CRM connector. Adriaan: Clay enrichment templates. Bob: nothing to build — he starts outreach on day 1 using manual research while the engine is being built.
3. **How long until first revenue?** 4-6 weeks for the diagnostic snapshot (free), 8-12 weeks for first paid pilot, 16-24 weeks for first recurring client.
4. **What's the "stop everything" trigger?** If after 10 conversations, zero prospects agree to a diagnostic snapshot, the niche hypothesis is wrong — re-evaluate.

---

#### F-P3-3: Create Outbound Sequence from Canvas Data

**Target file:** NEW: `niche-program/OUTBOUND-SPEC.md`

**Specification:** The canvas should produce material for Bob's outbound motion, not just the website:

1. **Cold Email Sequence (5 emails):** Each email maps to a canvas section — Email 1 (trigger event + pain), Email 2 (competitive insight), Email 3 (ROI proof), Email 4 (social proof placeholder), Email 5 (diagnostic snapshot offer).
2. **LinkedIn DM Templates:** 3 versions for different buyer roles (economic buyer, champion, end user).
3. **Discovery Call Script:** 30-minute call structure — 5 min rapport (canvas §2 buyer context), 10 min pain diagnosis (canvas §3), 10 min solution teaser (canvas §7-10), 5 min next steps.
4. **Objection Handling Guide:** Top 10 objections derived from competitor reviews (what buyers complain about with existing solutions) + ClarityRev's response.

---

## 8. Execution Sequence & Dependencies

### Phase 1: Foundation (Days 1-2)
```
A-P0-1 (RIOS fix) ──→ A-P0-2 (ordinal fix) ──→ A-P2-1 (bootstrap CI)
B-P0-1 (fabrication fix)
D-P0-1 (credit budget fix)
D-P0-2 (dead-host fix)
```
**Gate:** Scoring formulas corrected. Fabrication incentive removed. Budget realistic. No dead hosts blocking primary tools.

### Phase 2: Core Integrity (Days 3-5)
```
B-P0-2 (trace-map schema) ──→ B-P1-1 (remove self-grading) ──→ B-P1-2 (content-independence)
C-P0-1 (context management) ──→ C-P1-1 (ambiguity elimination) ──→ C-P1-2 (decision trees)
```
**Gate:** Evidence chain traceable end-to-end. Agents cannot self-grade. Methodology executable by AI agents without interpretation.

### Phase 3: Infrastructure (Days 5-7, parallel with Phase 2)
```
D-P1-1 (SHARED registry) ──→ D-P1-2 (file locks) ──→ D-P1-3 (fallback validation)
```
**Gate:** 4 concurrent agents can safely share data. Fallbacks tested.

### Phase 4: Strategy & Portfolio (Days 8-10, parallel with Phase 3)
```
E-P1-1 (remove data penalty) ──→ E-P1-2 (EUR 500K fix) ──→ E-P2-1 (portfolio analysis)
C-P0-2 (Bob time fix)
B-P1-3 (calibration Kappa)
```
**Gate:** Scoring doesn't penalize blue-ocean niches. Financial math correct. Portfolio analysis framework ready.

### Phase 5: Execution Readiness (Days 11-14)
```
F-P1-1 (calibration fix) ──→ F-P2-1 (buyer-language schema) ──→ F-P2-2 (website copy spec)
F-P3-1 (founder-market fit)
E-P2-2 + E-P2-3 + E-P2-4 (competitive scoring)
```
**Gate:** Calibration protocol valid. Website and outbound materials spec'd. Founder reality reflected in scoring.

### Phase 6: Polish & Automation (Days 15-18)
```
A-P3-1 (weight sensitivity) ──→ B-P2-1 (evidence decay) ──→ B-P3-1 (random verification)
C-P3-1 (drift detection) ──→ C-P3-2 (anti-fragility dashboard)
D-P2-1 (GameDay suite) ──→ D-P2-2 (infrastructure inventory) ──→ D-P3-1 (SBOM)
E-P3-1 + E-P3-2 (portfolio dashboard + weight sensitivity — already covered)
F-P3-2 (day-1 plan) ──→ F-P3-3 (outbound spec)
```
**Gate:** All P2 and P3 items complete. Program ready for calibration execution.

---

## 9. Verification Gates

### Gate 1: Scoring Correctness (after Phase 1)
- [ ] RIOS formula produces higher scores for fast-TTV, low-friction, low-risk niches
- [ ] Composite ranking uses rank-based aggregation
- [ ] Bootstrap CIs computed for all niche ranks
- [ ] Verification: Score 5 known niches with OLD and NEW formulas. Top-2 should differ if ordinal violation was material.

### Gate 2: Evidence Integrity (after Phase 2)
- [ ] Trace-map schema validates all calibration niche claims
- [ ] Grade engine assigns grades WITHOUT agent input on criteria values
- [ ] Content-independence check catches G2+Capterra same-parent case
- [ ] Anti-fabrication rule: SOURCE_UNAVAILABLE is a valid, non-penalized response
- [ ] Verification: Deliberately inject a claim with two non-independent sources. Grade engine must cap at [E].

### Gate 3: Agent Executability (after Phase 2)
- [ ] Agent loads only Phase 1 context for Phase 1 tasks (≤40K tokens)
- [ ] 83 "should"/"consider"/"may" instances reduced by ≥80%
- [ ] Every decision point has an explicit decision tree
- [ ] Verification: Give a fresh agent Phase 1 loading spec. Can it execute Phase 1 without reading any other files?

### Gate 4: Concurrency Safety (after Phase 3)
- [ ] 4 concurrent agents can read/write CREDIT_BUDGET.yaml without corruption
- [ ] SHARED/_REGISTRY.yaml dedup prevents duplicate fetches
- [ ] FileLock prevents lost updates
- [ ] Verification: Run 4 concurrent script invocations. Check file integrity after.

### Gate 5: Strategy Validity (after Phase 4)
- [ ] Data-rich niche bias removed — a blue-ocean niche with few competitors can rank #1
- [ ] EUR 500K gate uses net profit (not gross profit) with realistic fixed costs
- [ ] Portfolio analysis framework ready
- [ ] Verification: Score a data-sparse test niche. It should NOT be penalized for thin evidence.

### Gate 6: Execution Readiness (after Phase 5)
- [ ] Calibration protocol evaluates 2 niches with 2 agents each + ground truth
- [ ] Website copy spec maps every canvas section to a website element
- [ ] Outbound sequence templates exist for all 3 buyer roles
- [ ] Verification: Give the copy spec to a copywriter. Can they write the hero section without additional research?

### Gate 7: Full Readiness (after Phase 6)
- [ ] All P0, P1, P2 fixes applied and verified
- [ ] 149-test suite still passes
- [ ] GameDay test suite exercises 6 failure scenarios
- [ ] SBOM generated for toolchain
- [ ] **FINAL VERDICT: Ready for calibration execution.**

---

*End of PROGRAM-FIX-SPECIFICATION.md — This document is the binding specification for all fixes to the Niche Research Program. Execute in order. Verify at every gate. Do not skip phases.*
