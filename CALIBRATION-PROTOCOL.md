# Calibration Protocol: Execution, Inter-Rater Reliability & Score Normalization

**Status:** BINDING — extends NICHE-METHODOLOGY.md Mechanism 6 with operational detail.
**Version:** 1.0
**Last Updated:** 2026-07-23
**Audience:** Pipeline operator (Wesley), all niche agents

---

## TABLE OF CONTENTS

1. [Purpose & Design Principles](#1-purpose--design-principles)
2. [Calibration Niches & Agent Allocation](#2-calibration-niches--agent-allocation)
3. [Ground-Truth Reference Canvas Requirements](#3-ground-truth-reference-canvas-requirements)
4. [Agent Execution Specification](#4-agent-execution-specification)
5. [Inter-Rater Reliability Metrics & Thresholds](#5-inter-rater-reliability-metrics--thresholds)
6. [Maximum Acceptable Delta Table](#6-maximum-acceptable-delta-table)
7. [Calibration Resolution Protocol](#7-calibration-resolution-protocol)
8. [Score Normalization — Formal Math](#8-score-normalization--formal-math)
9. [The Calibration Paradox](#9-the-calibration-paradox)
10. [Ongoing Calibration Schedule](#10-ongoing-calibration-schedule)
11. [Calibration Completion Gate](#11-calibration-completion-gate)
12. [Computation Procedures](#12-computation-procedures)

---

## 1. Purpose & Design Principles

### 1.1 Why Calibration Is Necessary

Twenty-five independent agents following the same methodology WILL produce incomparable outputs without calibration. Agent A's "Score 4" is not Agent B's "Score 4." Evidence grading, RIOS scoring, and qualitative judgments are all subject to agent non-determinism — the same prompt can produce systematically different outputs across different Claude Code sessions.

Calibration establishes a common measurement system before any niche evaluation begins.

### 1.2 Eight Design Principles

1. **Two-niche, four-agent design.** A single calibration niche with two agents produces exactly one comparison point. Two niches (data-rich + data-sparse) with independent agent pools detect systematic bias that a single-niche calibration cannot.

2. **Human-anchored ground truth.** Five sections of CAL-A are manually produced by Wesley as a reference standard. Agent accuracy is measured against this ground truth, not just agent-to-agent agreement.

3. **Agents blinded to ground-truth sections.** Agents know a ground truth exists but do not know which sections are ground-truthed. This prevents anchoring toward expected outputs.

4. **Non-overlapping agent pools.** CAL-A agents and CAL-B agents are drawn from separate agent sessions with no shared context. This prevents learned-bias sharing across niches.

5. **Deterministic metrics only.** All inter-rater reliability metrics (Cohen's Kappa, ICC, delta tables) are computed by deterministic scripts, not agent self-report. Agents do NOT compute their own calibration scores.

6. **Pass-all gate.** All metrics must pass for both niches before any N-XXX evaluation begins. Partial pass (CAL-A passes but CAL-B fails) triggers targeted methodology amendments.

7. **Dual-curve normalization if needed.** If an agent shows different scoring tendencies on data-rich vs. data-sparse contexts, separate normalization curves are applied — not a single global offset.

8. **Ongoing drift detection.** Calibration decays. Every 5th niche re-tests calibration agreement to detect drift.

---

## 2. Calibration Niches & Agent Allocation

### 2.1 Niche Selection

| Designator | Profile | Niche | Rationale |
|---|---|---|---|
| **CAL-A** | Data-rich, well-understood | Mid-Market IT Staffing Agencies on Bullhorn | Abundant competitors, rich review corpus on G2/Capterra, public pricing available, existing Gapstars research as cross-reference. Tests agent agreement when data is plentiful. |
| **CAL-B** | Data-sparse, blue-ocean | B2B Fractional Executive Services for Mid-Market | Fractional CFO/CTO/CMO placement and management services. Few public competitors (engagement is relationship-driven), thin or absent G2/Capterra review corpus, pricing is opaque (quoted per engagement, not published). Tests agent agreement when data is scarce and inference from analogous markets is required. |

### 2.2 Agent Allocation -- Exactly 4 Agents, Non-Overlapping Pools

```
CAL-A (data-rich):
  Agent A1 -- evaluates CAL-A independently, complete 15-section canvas
  Agent A2 -- evaluates CAL-A independently, complete 15-section canvas

CAL-B (data-sparse):
  Agent B1 -- evaluates CAL-B independently, complete 15-section canvas
  Agent B2 -- evaluates CAL-B independently, complete 15-section canvas
```

**Rules:**
- Agent A1 and Agent A2 share NO context with Agent B1 or Agent B2
- Agent A1 and Agent A2 work simultaneously with no communication
- Agent B1 and Agent B2 work simultaneously with no communication
- All 4 agents use the identical methodology version
- All 4 agents load their context per AGENT-CONTEXT-SPEC.md Phase 0 Calibration Loading Specification
- No agent session is reused across calibration niches

**Agent allocation script** (`research/_pipelines/spawn-calibration-agents.sh`):
```bash
# Spawn 4 independent agent sessions
# CAL-A agents
claude code --context CALIBRATION-PROTOCOL.md --niche CAL-A --agent-id AGENT-A1
claude code --context CALIBRATION-PROTOCOL.md --niche CAL-A --agent-id AGENT-A2
# CAL-B agents
claude code --context CALIBRATION-PROTOCOL.md --niche CAL-B --agent-id AGENT-B1
claude code --context CALIBRATION-PROTOCOL.md --niche CAL-B --agent-id AGENT-B2
```

### 2.3 Directory Structure

```
research/CALIBRATION/
├── N-CAL-AGENT-A1/              ← Agent A1's evaluation
│   ├── 01-company-discovery/
│   ├── 02-competitor-intel/
│   ├── 03-market-sizing/
│   ├── 04-voice-of-customer/
│   ├── 05-signal-feasibility/
│   ├── 06-technographic/
│   ├── 07-buyer-insight/
│   ├── 08-pricing/
│   ├── _canvas/
│   │   ├── NICHE-CANVAS-CAL-A-A1.md
│   │   ├── frontmatter-CAL-A-A1.yaml
│   │   └── evidence/
│   │       └── trace-map-CAL-A-A1.yaml
│   └── _work/
│       └── CHECKPOINT.yaml
├── N-CAL-AGENT-A2/              ← Agent A2's evaluation (mirror)
├── N-CAL-AGENT-B1/              ← Agent B1's evaluation (mirror)
├── N-CAL-AGENT-B2/              ← Agent B2's evaluation (mirror)
├── _GROUND-TRUTH/               ← Wesley's reference
│   ├── ground-truth-CAL-A-sections-1-2-4-10-14.yaml
│   └── ground-truth-CAL-A-canvas-snapshot.md
├── _RECONCILIATION/             ← Inter-rater comparison results
│   ├── CALIBRATION-REPORT-v1.yaml
│   ├── KAPPA-RESULTS.yaml
│   ├── ICC-RESULTS.yaml
│   ├── DELTA-TABLE.yaml
│   └── NORMALIZATION-FACTORS.yaml
└── _RECONCILIATION/ARCHIVE/     ← Previous iteration results (if re-run)
```

---

## 3. Ground-Truth Reference Canvas Requirements

### 3.1 Scope

Wesley manually produces a ground-truth reference for **5 sections of CAL-A**:

| Section | Title | Key Content Requirements |
|---|---|---|
| **Section 1** | Niche Identity & Definition | MECE boundaries, IN/OUT list, 3 edge cases, First-5 Prospect Test, data accessibility gate, structural attractiveness score (Porter's Five Forces), niche existence proof |
| **Section 2** | Buyer & Committee Mapping | Buyer personas (minimum 3 roles per persona), committee map, budget authority, buying process stages, decision velocity estimate |
| **Section 4** | Competitive Landscape | Minimum 5 competitors profiled, pricing tiers extracted, positioning comparison, competitive white space identified |
| **Section 10** | Pricing & Packaging | Core recurring service design, pricing ladder architecture within EUR 1.5-8K bands, expansion triggers and pricing, moat trajectory |
| **Section 14** | RIOS Scoring & Verdict | Gate check (all 4 gates), 8 RIOS dimensions scored with calibration anchors, RIOS score computed, lowest-term diagnosis, niche verdict with confidence grade |

### 3.2 Format

Each ground-truth section follows the identical template as NICHE-METHODOLOGY.md Appendix A. Sections are flagged with a `[GROUND_TRUTH]` marker in the section header:

```markdown
## Section 1: Niche Identity & Definition [GROUND_TRUTH]
```

### 3.3 What Ground Truth Includes

- **Claim-level grading.** Every factual claim in the 5 ground-truth sections carries a `[P]`, `[E]`, `[H]`, or `[S]` grade computed by the deterministic grade engine (DATA-OPERATIONS-ARCHITECTURE.md SS6.2). Wesley does NOT assign grades manually -- the grade engine processes his source URLs.
- **Source URLs for every claim.** Every `[E]` and `[P]` claim has a documented source URL with content hash.
- **RIOS exact score.** The RIOS score is computed via the additive mean formula, not estimated. All 8 dimensions have specific 1-5 scores with written justifications.
- **Scoring calibration anchors used.** Each dimension score cites which part of the calibration anchor table (NICHE-METHODOLOGY.md SS14 preamble) was applied and why.

### 3.4 What Ground Truth Does NOT Include

- **Remaining 10 sections (SS3, 5, 6, 7, 8, 9, 11, 12, 13, 15).** These are NOT ground-truthed. Agents must produce them independently. This is by design: calibration measures agreement on the sections that require the most judgment (scoring, competitive analysis, identity) and leaves discovery-based sections as free-form.
- **CAL-B ground truth.** CAL-B has NO ground truth. Inter-rater reliability on CAL-B is measured through agent-to-agent agreement only (ICC, Kappa, delta table).

### 3.5 Ground Truth Quality Standards

| Criterion | Standard | Verification |
|---|---|---|
| Source diversity | Minimum 3 independent sources per key claim | Manual count by Wesley before publishing |
| Source freshness | All sources within SLA at publishing date | freshness-audit script |
| Evidence grade distribution | At least 40% of claims at `[E]` or higher | Quality dashboard |
| RIOS score reproducibility | Another human following same methodology produces score within +-0.3 | Self-test: Wesley scores CAL-A blind 48 hours later, compares |
| MECE completeness | IN/OUT list covers ALL adjacent niches from NICHE-REGISTRY.md | Manual check against 25-niche list |

### 3.6 Ground Truth Publication

Ground truth is published to `research/CALIBRATION/_GROUND-TRUTH/` before any calibration agent is spawned. The ground-truth YAML file includes a version hash:

```yaml
ground_truth:
  version: "v1.0"
  author: "Wesley"
  created: "2026-07-23"
  content_hash: "sha256:..."
  sections_covered: [1, 2, 4, 10, 14]
  niche: "CAL-A"
  methodology_version: "NICHE-METHODOLOGY.md v1.0"
```

---

## 4. Agent Execution Specification

### 4.1 Context Loading

Each agent loads per AGENT-CONTEXT-SPEC.md SS Phase 0 Calibration Loading Specification (~50K tokens):

1. NICHE-METHODOLOGY.md full preamble (SS1) -- lines 1-85
2. NICHE-METHODOLOGY.md SS3.1 Full Research Sequence -- lines 3420-3470
3. NICHE-METHODOLOGY.md Part 3 Quality Gates -- lines 3555-3748
4. DATA-OPERATIONS-ARCHITECTURE.md SS4.0 Phase 0 Tool Calibration
5. DATA-OPERATIONS-ARCHITECTURE.md SS2.2 Tool Selection Decision Tree
6. AGENT-CONTEXT-SPEC.md full document
7. This document (CALIBRATION-PROTOCOL.md) full document

### 4.2 Ground Truth Awareness Protocol

- Agents are told: "A ground-truth reference exists for 5 sections of CAL-A. Your canvas will be compared against this ground truth. You do NOT know which 5 sections are ground-truthed."
- Agents are NOT shown the ground-truth content.
- Agents are NOT told which specific sections are ground-truthed.
- This prevents anchoring while maintaining honest effort.

### 4.3 Execution Sequence

All 4 agents execute independently:

1. **Phase 0.5: Tool calibration** (re-use Phase 0 results -- do not re-fetch)
2. **Phases 1-4: Full pipeline** per DATA-OPERATIONS-ARCHITECTURE.md SS4.1-4.4
3. **Canvas authoring:** All 15 sections per NICHE-METHODOLOGY.md Appendix A
4. **Evidence traceability:** Complete trace-map.yaml for all `[E]` and `[P]` claims
5. **Self-audit:** Part 3 agent self-audit checklist (mechanism 9 in SS4.3 of methodology)

### 4.4 Data Source Restrictions

**CAL-A (data-rich):**
- Agents MAY use: Firecrawl search/scrape, DataForSEO, G2, Capterra, Reddit Research MCP, OpenRegistry MCP, company websites, public ATS APIs, GDELT, EUROSTAT, OECD
- Agents SHOULD find minimum 5 competitors, 20 reviews across 3+ platforms, 2+ independent market sizing sources

**CAL-B (data-sparse):**
- Agents MAY use: All CAL-A sources PLUX: industry association directories, conference speaker lists, LinkedIn professional services tags (public only, no scraping), fractional executive platform listings, business press, analyst reports from adjacent markets
- If fewer than 5 competitors exist: SOURCE_UNAVAILABLE is VALID (per anti-fabrication rule)
- Inference from analogous markets is PERMITTED but must be flagged with evidence grade `[H]` or lower

### 4.5 Time Budget

| Agent | Phase 1-4 Execution | Max Wall-Clock |
|---|---|---|
| CAL-A agents (A1, A2) | Standard 25-min pipeline + extra analysis | 45 minutes |
| CAL-B agents (B1, B2) | Standard 25-min pipeline + inference time | 50 minutes |

---

## 5. Inter-Rater Reliability Metrics & Thresholds

### 5.1 Metric Taxonomy

Three metric families, each measuring a different aspect of reliability:

| Family | What It Measures | Statistic | Applies To |
|---|---|---|---|
| **Categorical Agreement** | do agents assign the same evidence grade to equivalent claims? | Cohen's Kappa | Evidence grades on both CAL-A and CAL-B |
| **Continuous Score Agreement** | do agents produce numerically similar scores on the same niche? | ICC (Intraclass Correlation Coefficient) | RIOS scores on CAL-A (vs ground truth) and CAL-B (agent-to-agent) |
| **Delta Thresholds** | what specific score differences are acceptable before action is required? | Maximum Acceptable Delta table | All quantitative outputs across both niches |

### 5.2 Metric 1: Cohen's Kappa on Evidence Grades

**What it measures:** Agreement between two agents on the categorical evidence grade (`[P]`, `[E]`, `[H]`, `[S]`) assigned to equivalent claims. Kappa corrects for chance agreement.

**Why Kappa, not simple percentage:** Two agents randomly assigning grades would agree ~30% of the time by chance alone. Kappa removes this inflation.

**Computation:**
1. For each calibration niche, align claims between the two paired agents by claim topic (not claim ID -- agents use different IDs)
2. Build a 4x4 agreement matrix (rows = Agent 1 grade, columns = Agent 2 grade)
3. Compute: `kappa = (observed_agreement - expected_agreement) / (1 - expected_agreement)`

**Threshold:**

| Comparison | Target | Interpretation |
|---|---|---|
| CAL-A: Agent A1 vs Agent A2 | kappa >= 0.61 | Substantial agreement (Landis & Koch) |
| CAL-B: Agent B1 vs Agent B2 | kappa >= 0.61 | Substantial agreement |
| CAL-A vs CAL-B delta | | If CAL-A passes but CAL-B fails, grading criteria are biased toward data-rich contexts. |

### 5.3 Metric 2: Intraclass Correlation Coefficient (ICC) on RIOS Scores

**Model selection:** ICC(2,1) -- two-way random effects, single rater, absolute agreement. This model treats both agents and niches as random effects and measures absolute agreement (not just consistency). ICC(2,1) is the most conservative model and appropriate when:
- Agents are drawn from a population of possible agents (random effects)
- We care about absolute score agreement, not just rank ordering

**Computation for CAL-A (agreement with ground truth):**
- Units of analysis: the 8 RIOS dimensions + composite score (9 data points per agent)
- ICC is computed between Agent A1's scores and ground truth, and Agent A2's scores and ground truth
- Reported as: ICC(A1, GT) and ICC(A2, GT)

**Computation for CAL-B (agent-to-agent agreement):**
- Same 9 data points per agent (8 dimensions + composite)
- ICC is computed between Agent B1's scores and Agent B2's scores

**Threshold:**

| Comparison | Target | Interpretation |
|---|---|---|
| CAL-A: each agent vs ground truth | ICC >= 0.75 | Good agreement -- agent scoring is repeatable relative to human standard |
| CAL-B: Agent B1 vs Agent B2 | ICC >= 0.75 | Good agreement -- agents converge even on data-sparse niche |
| ICC(CAL-A GT) vs ICC(CAL-B) | Delta | If CAL-A passes but CAL-B fails: agents agree when data is abundant but diverge when data is scarce. Systematic bias against data-sparse niches. |

### 5.4 Metric 3: Evidence Grade Distribution

**What it measures:** Do two agents assign roughly the same proportion of `[P]`, `[E]`, `[H]`, and `[S]` grades?

**Computation:**
1. For each agent, compute the percentage of all claims at each grade
2. Compute the absolute difference between the two agents for each grade

**Threshold:**

| Grade | Max Acceptable Difference (pp) |
|---|---|
| `[P]` (Proven) | 10 percentage points |
| `[E]` (Evidenced) | 10 percentage points |
| `[H]` (Hypothesis) | 10 percentage points |
| `[S]` (Speculative) | 10 percentage points |

**Example:** If Agent A1 has 15% `[P]` and Agent A2 has 8% `[P]`, the delta is 7pp -- PASS.

### 5.5 Metric 4: Ground-Truth Section Accuracy

**What it measures:** For the 5 ground-truthed sections of CAL-A, does each agent's output agree with Wesley's reference at the claim level?

**Computation:**
1. Align claims between agent canvas and ground-truth canvas by section and topic
2. For each claim, determine if the agent's claim materially agrees with the ground truth
3. Compute: `accuracy = matching_claims / total_claims_in_ground_truth`

**Threshold:**

| Comparison | Target | Interpretation |
|---|---|---|
| Agent A1 vs GT | >=80% | Agent's interpretation of methodology matches Wesley's |
| Agent A2 vs GT | >=80% | Same for second agent |
| Both agents pass | | Methodology is unambiguous enough for consistent interpretation |
| One agent fails | | Investigate -- is one agent anomalous or is the methodology ambiguous in specific sections? |

### 5.6 Metric 5: Niche Verdict Agreement

**What it measures:** Do paired agents arrive at the same overall verdict for the niche?

**Possible verdicts:** LAUNCH PENDING, VALIDATE FIRST, CONDITIONAL, NO-GO

**Threshold:**

| Comparison | Target |
|---|---|
| CAL-A: Agent A1 vs Agent A2 verdict | Exact match |
| CAL-B: Agent B1 vs Agent B2 verdict | Exact match |

### 5.7 Metric 6: Pain Quantification Agreement

**What it measures:** Do agents estimate similar economic pain values (SS3.2 EUR/year)?

**Threshold:**

| Comparison | Target |
|---|---|
| Both CAL-A agents | Within same order of magnitude (factor <= 10x) |
| Both CAL-B agents | Within same order of magnitude (factor <= 10x) |

---

## 6. Maximum Acceptable Delta Table

### 6.1 Full Delta Specification

Every measurable output from the calibration agents is compared against its paired counterpart (and ground truth for CAL-A). The table below defines the maximum acceptable delta for each metric.

```
================================================================================
| # | Metric | Comparison | Max Delta | Unit | Action If Exceeded |
================================================================================
| 1 | Cohen's Kappa (evidence grades) | A1 vs A2 | >= 0.61 target | kappa value | Amend grading examples |
|   |                                      | B1 vs B2 | (falls below) |               | in Appendix B |
|---|--------------------------------------|-----------|----------------|---------------|----------------------|
| 2 | ICC (RIOS scores vs ground truth) | A1 vs GT | >= 0.75 target | ICC value | Clarify SS14 scoring |
|   |                                      | A2 vs GT | (falls below) |               | anchors |
|---|--------------------------------------|-----------|----------------|---------------|----------------------|
| 3 | ICC (RIOS scores, agent-to-agent) | B1 vs B2 | >= 0.75 target | ICC value | Fix evidence-confidence|
|   |                                      |           | (falls below) |               | flag bias |
|---|--------------------------------------|-----------|----------------|---------------|----------------------|
| 4 | Evidence grade distribution (P/E/H/S) | A1 vs A2 | <= 10 pp per | percentage pts| Clarify grade |
|   |                                      | B1 vs B2 | grade level    |               | definitions |
|---|--------------------------------------|-----------|----------------|---------------|----------------------|
| 5 | Ground-truth section accuracy | A1 vs GT | >= 80% | percentage | Amend specific SS |
|   |                                      | A2 vs GT |                 |               | where disagreement |
|   |                                      |           |                 |               | occurred |
|---|--------------------------------------|-----------|----------------|---------------|----------------------|
| 6 | Niche verdict | A1 vs A2 | Exact match | 4-value enum | Tighten verdict |
|   |                                      | B1 vs B2 |                 |               | criteria in SS14(D) |
|---|--------------------------------------|-----------|----------------|---------------|----------------------|
| 7 | Pain quantification (SS3.2 EUR/yr) | A1 vs A2 | Same order of | factor <=10x | Strengthen SS3.3 |
|   |                                      | B1 vs B2 | magnitude       |               | formula requirements |
|---|--------------------------------------|-----------|----------------|---------------|----------------------|
| 8 | RIOS composite score | A1 vs A2 | <= 0.8 | RIOS points | Check scoring anchors |
|   |                                      | B1 vs B2 |                 |               | or agent competence |
|   |                                      | A1 vs GT | <= 0.5 |               | (tighter for GT) |
|   |                                      | A2 vs GT | <= 0.5 |               | |
|---|--------------------------------------|-----------|----------------|---------------|----------------------|
| 9 | SA (Structural Attractiveness) | A1 vs A2 | <= 2.0 | 1-10 scale | Clarify SA rubric |
|   |                                      | B1 vs B2 |                 |               | in SS6.1 |
|---|--------------------------------------|-----------|----------------|---------------|----------------------|
| 10| WA (Warm Access) | A1 vs A2 | <= 2.0 | 1-10 scale | Clarify WA rubric |
|   |                                      | B1 vs B2 |                 |               | in SS6.1 |
|---|--------------------------------------|-----------|----------------|---------------|----------------------|
| 11| CV (Commercial Viability) | A1 vs A2 | <= 2.0 | 1-10 scale | Clarify CV rubric |
|   |                                      | B1 vs B2 |                 |               | in SS6.1 |
|---|--------------------------------------|-----------|----------------|---------------|----------------------|
| 12| BF (Build Feasibility) | A1 vs A2 | <= 2.0 | 1-10 scale | Clarify BF rubric |
|   |                                      | B1 vs B2 |                 |               | in SS6.1 |
|---|--------------------------------------|-----------|----------------|---------------|----------------------|
| 13| FM (Founder-Market Fit) | A1 vs A2 | <= 2.0 | 1-10 scale | Clarify FM rubric |
|   |                                      | B1 vs B2 |                 |               | in SS6.1 |
|---|--------------------------------------|-----------|----------------|---------------|----------------------|
| 14| Claim count per section | A1 vs A2 | <= 30% | percentage | Check if one agent |
|   |                                      | B1 vs B2 | relative diff   |               | is over- or under- |
|   |                                      |           |                 |               | producing claims |
|---|--------------------------------------|-----------|----------------|---------------|----------------------|
| 15| SERP / keyword metrics | A1 vs A2 | <= 30% relative | percentage | Check DataForSEO |
|   | (total keywords/competitors found) | B1 vs B2 |                 |               | consistency |
--------------------------------------------------------------------------------
```

### 6.2 Delta Computation Script

All deltas are computed by `research/_pipelines/compute-calibration-deltas.sh` (to be created):

```bash
./compute-calibration-deltas.sh \
  --agent-a1 research/CALIBRATION/N-CAL-AGENT-A1 \
  --agent-a2 research/CALIBRATION/N-CAL-AGENT-A2 \
  --agent-b1 research/CALIBRATION/N-CAL-AGENT-B1 \
  --agent-b2 research/CALIBRATION/N-CAL-AGENT-B2 \
  --ground-truth research/CALIBRATION/_GROUND-TRUTH \
  --output research/CALIBRATION/_RECONCILIATION/CALIBRATION-REPORT-v1.yaml
```

Output format:
```yaml
calibration_report:
  iteration: 1
  date: "2026-07-23"
  overall_status: "FAIL"  # PASS | FAIL
  metrics:
    kappa_CAL_A:
      value: 0.72
      target: 0.61
      status: "PASS"
    kappa_CAL_B:
      value: 0.45
      target: 0.61
      status: "FAIL"
    # ... all 15 metrics
  failing_metrics: ["kappa_CAL_B", "evidence_distribution_B"]
  resolution_required: true
```

---

## 7. Calibration Resolution Protocol

### 7.1 Resolution Flow

If any metric fails, follow this structured resolution protocol -- NOT ad-hoc methodology editing.

```
Step 0: DETECT FAILURE
  compute-calibration-deltas.sh outputs FAIL status
  Failing metrics are identified

Step 1: ISOLATE ROOT CAUSE
  ↓
Step 2: AMEND METHODOLOGY
  ↓
Step 3: RE-RUN CALIBRATION
  ↓
Step 4: VERIFY
  ↓
[Loop until all pass, max 3 iterations before Wesley override]
```

### 7.2 Step 1: Isolate Root Cause

For each failing metric, determine the root cause category:

| Failure Pattern | Root Cause Category | Investigation Method |
|---|---|---|
| Both CAL-A and CAL-B fail on Kappa | Global grading ambiguity | Review Appendix B evidence grade examples. Add 5+ examples per grade. |
| CAL-A passes, CAL-B fails on Kappa | Data-sparse grading bias | Add data-sparse-specific grading guidance. Allow `[H]` as default for inference claims. |
| Both CAL-A and CAL-B fail on ICC(RIOS) | Scoring anchor confusion | Review SS14 calibration anchors. Add dimension-level worked examples. |
| CAL-A fails on ICC(GT) but passes ICC(agent) | Agents agree with each other but disagree with human standard | Ground truth may be the outlier. Review Wesley's ground-truth justification. If Wesley's score is defensible, amend methodology to make ground-truth reasoning explicit. |
| One agent fails ground-truth accuracy, other passes | Isolated agent anomaly | Review the failing agent's trace-map and working files. Was the correct methodology version loaded? Did the agent overflow context? |
| Verdict mismatch | Verdict criteria ambiguous | Review SS14(D) verdict definitions. Add decision tree with exactly 4 leaf nodes, each with unambiguous input conditions. |

**Investigation protocol:**
1. All 4 agent canvases are unblinded and shared among the team (Wesley + any agents still available)
2. For each failing metric: agents annotate their canvas at the specific points where they made the judgment that differed from their pair
3. Wesley compares the annotations to identify the methodology section where interpretation diverged
4. Root cause is written to `research/CALIBRATION/_RECONCILIATION/CALIBRATION-REPORT-v1.yaml` under `root_causes:`

### 7.3 Step 2: Amend Methodology

Amendments are targeted to the root cause. Global methodology rewrites are FORBIDDEN during calibration -- they introduce new ambiguity.

**Permitted amendment types:**
1. **Add examples** to Appendix B (evidence grading) -- minimum 5 per grade per amendment round
2. **Add worked calculations** to SS14 scoring anchors -- show exact math for each dimension
3. **Add decision trees** -- replace prose criteria with IF/THEN/ELSE decision logic
4. **Add data-sparse guidance** -- specific instructions for when evidence is thin ("use analogous market inference, flag as `[H]`, and explain the analogy")

**Forbidden amendment types:**
1. **Delete criteria** -- removing requirements to make calibration pass is cheating
2. **Change numerical thresholds** -- Kappa >= 0.61 and ICC >= 0.75 are LOCKED for this program
3. **Add ground truth to more sections** -- the 5 ground-truth sections are fixed; adding more mid-calibration changes the evaluation target

### 7.4 Step 3: Re-Run Calibration

After methodology amendments:
1. Archive the previous iteration's results to `_RECONCILIATION/ARCHIVE/iteration-N/`
2. All 4 agents re-run with the amended methodology
3. Agents are NOT told which metrics failed or what amendments were made (prevents overfitting)
4. If the SAME metric fails in consecutive iterations with different methodology amendments, escalate to Wesley for manual resolution -- the methodology may have reached its inherent ambiguity floor

### 7.5 Step 4: Maximum Iterations

| Iterations | Action |
|---|---|
| 0 (first run) | Normal -- expected to possibly fail on some metrics |
| 1 (first re-run) | Acceptable -- methodology amendments clarify initial ambiguity |
| 2 (second re-run) | Acceptable but concerning -- ambiguity is deep-seated |
| 3+ | STOP. Escalate to Wesley. Pre-register the calibration failure in LEDGER.yaml. If 3 iterations fail, calibration may need to proceed with acknowledged gaps. Document the failing metrics as CONFIDENCE_CAPPED in all subsequent niche evaluations. |

---

## 8. Score Normalization -- Formal Math

### 8.1 What Needs Normalization

| Score Type | Scale | Normalization Required? | Method |
|---|---|---|---|
| RIOS composite score | 1.0-5.0 (continuous) | YES | Per-agent additive offset |
| RIOS dimension scores | 1-5 (ordinal integer) | YES | Per-dimension per-agent offset |
| SA, WA, CV, BF, FM | 1-10 (ordinal) | NO | Rank-based WRS normalizes implicitly |
| Evidence grades | [P]/[E]/[H]/[S] (categorical) | PARTIAL | Grade distribution is tracked but not normalized per-se -- Kappa threshold ensures standards are shared |
| Verdict | 4-value enum | NO | Verdict must match exactly or protocol halts |

### 8.2 RIOS Composite Score Normalization

**Step 1: Compute per-agent RIOS adjustment from calibration.**

Let:
- `GT_RIOS` = Ground-truth RIOS composite score for CAL-A
- `A1_RIOS_CA` = Agent A1's RIOS composite score for CAL-A
- `A2_RIOS_CA` = Agent A2's RIOS composite score for CAL-A
- `B1_RIOS_CB` = Agent B1's RIOS composite score for CAL-B
- `B2_RIOS_CB` = Agent B2's RIOS composite score for CAL-B

Per-agent adjustment for CAL-A agents (A1, A2):
```
adjustment_A1 = A1_RIOS_CA - GT_RIOS
adjustment_A2 = A2_RIOS_CA - GT_RIOS
```

Per-agent adjustment for CAL-B agents (B1, B2):
```
mean_CAL_B = (B1_RIOS_CB + B2_RIOS_CB) / 2
adjustment_B1 = B1_RIOS_CB - mean_CAL_B
adjustment_B2 = B2_RIOS_CB - mean_CAL_B
```

**Step 2: Test for dual-curve requirement.**

If `|adjustment_A1 - adjustment_B1| > 0.5` for the SAME agent, this agent shows materially different bias on data-rich vs data-sparse contexts. Dual-curve normalization is required.

**Step 3: Apply adjustment to subsequent niche scores.**

If NO dual-curve required (single adjustment per agent):
```
calibrated_RIOS = agent_raw_RIOS - adjustment_agent
```

If dual-curve IS required:
```
For data-rich niches (evidence_quality > 50%):
  calibrated_RIOS = agent_raw_RIOS - adjustment_CAL_A_agent

For data-sparse niches (evidence_quality <= 50%):
  calibrated_RIOS = agent_raw_RIOS - adjustment_CAL_B_agent
```

Where `evidence_quality` is defined as the percentage of claims at `[E]` or higher in the niche canvas. The 50% threshold is provisional and can be adjusted based on the distribution of evidence quality across all 25 niches.

**Step 4: Record both raw and calibrated scores.**

In each canvas YAML frontmatter:
```yaml
composite_score: 0.0                     # Calibrated score (post-normalization)
composite_score_raw: 0.0                 # Raw score (pre-normalization)
calibration_applied: true                # True if normalization applied
calibration_method: "single_adjustment"  # "single_adjustment" | "dual_adjustment"
calibration_adjustment: -0.42            # The offset subtracted from raw
calibration_dual: false                  # True if dual-curve normalization used
calibration_as_of: "2026-07-23"          # Date of calibration run
```

### 8.3 RIOS Dimension Score Normalization

Each of the 8 RIOS dimensions (1-5 ordinal) is normalized individually using the same method as the composite:

```
adjustment_dim_d_agent = agent_score_dim_d_CAL_A - ground_truth_dim_d
calibrated_dim_d = agent_raw_dim_d - adjustment_dim_d_agent
```

However, ordinal scores must stay within bounds [1, 5]:
```
calibrated_dim_d = max(1, min(5, round(agent_raw_dim_d - adjustment_dim_d_agent)))
```

### 8.4 Evidence Grade Normalization

Evidence grades are NOT numerically normalized. Instead:
- Grade distribution is tracked per agent (proportion of `[P]`, `[E]`, `[H]`, `[S]`)
- If an agent's grade distribution deviates from the calibration pair's by >10pp on any grade, a grade-distribution correction factor is noted in the agent's profile
- All subsequent niches include a footnote: "Agent [name] shows [+5pp `[P]` bias] relative to calibration baseline -- claims may be graded more leniently than the program standard"

### 8.5 Cross-Niche Score Normalization

The 5 scores (SA, WA, CV, BF, FM) are normalized through rank-based WRS aggregation. Since WRS uses ranks (not raw scores), agent scoring tendency differences cancel out:

- Agent A scores SA=7, WA=6, CV=5, BF=8, FM=6 for N-001
- Agent B scores SA=8, WA=7, CV=6, BF=9, FM=7 for N-002

The ranks within each agent's set are what matters, not the raw scores. As long as each agent's internal scoring is consistent, WRS cancels inter-agent scale differences.

**Caveat:** This works ONLY if agents are consistent within their own scoring system. If Agent A's internal consistency is poor (high variance on similar niches), rank-based normalization breaks down. The ongoing calibration (SS10) detects this.

### 8.6 Worked Example

```
CALIBRATION RESULTS:
  Ground truth (Wesley) CAL-A RIOS: 3.6
  Agent A1 CAL-A RIOS: 3.2
  Agent A2 CAL-A RIOS: 3.9
  Agent B1 CAL-B RIOS: 2.8 (mean CAL-B = 3.0)
  Agent B2 CAL-B RIOS: 3.2

ADJUSTMENTS:
  Agent A1: 3.2 - 3.6 = -0.4 (stricter than GT by 0.4)
  Agent A2: 3.9 - 3.6 = +0.3 (more lenient than GT by 0.3)
  Agent B1: 2.8 - 3.0 = -0.2 (stricter than mean by 0.2)
  Agent B2: 3.2 - 3.0 = +0.2 (more lenient than mean by 0.2)

DUAL-CURVE TEST:
  Agent A1: |(-0.4) - (-0.2)| = 0.2 <= 0.5 => SINGLE adjustment OK
  Agent A2: |(+0.3) - (+0.2)| = 0.1 <= 0.5 => SINGLE adjustment OK
  Agent B1: |(-0.2) - (-0.2)| = 0.0 <= 0.5 => SINGLE adjustment OK  
  Agent B2: |(+0.2) - (+0.2)| = 0.0 <= 0.5 => SINGLE adjustment OK

CONCLUSION: All agents show consistent bias across data-rich and data-sparse
contexts. Single-curve normalization is sufficient.

AGENT PROFILES (for all subsequent evaluations):
  Agent A1: calibrated_RIOS = raw - (-0.4) = raw + 0.4
  Agent A2: calibrated_RIOS = raw - (+0.3) = raw - 0.3
  Agent B1: calibrated_RIOS = raw - (-0.2) = raw + 0.2
  Agent B2: calibrated_RIOS = raw - (+0.2) = raw - 0.2

AGENT A1 SCENARIO (single adjustment):
  Raw RIOS for N-001: 3.1
  Calibrated RIOS: 3.1 - (-0.4) = 3.5
  Recorded in frontmatter:
    composite_score_raw: 3.1
    composite_score: 3.5
    calibration_adjustment: -0.4

DUAL-CURVE COUNTEREXAMPLE (if dual-curve were needed):
  Agent X CAL-A adjustment: -0.6 (stricter on data-rich)
  Agent X CAL-B adjustment: +0.2 (lenient on data-sparse)
  |(-0.6) - (+0.2)| = 0.8 > 0.5 => DUAL CURVE REQUIRED
  
  N-005 (data-rich, evidence_quality 62%):
    Raw: 3.4
    Calibrated: 3.4 - (-0.6) = 4.0
  N-014 (data-sparse, evidence_quality 28%):
    Raw: 3.4
    Calibrated: 3.4 - (+0.2) = 3.2
```

---

## 9. The Calibration Paradox

### 9.1 What the Paradox Is

The calibration protocol relies on a human-produced ground truth to calibrate AI agents. But this creates seven irreducible tensions:

1. **Circular validation.** The human (Wesley) producing the ground truth is the SAME person who wrote the methodology. The ground truth validates the methodology against itself -- a circular argument. If the methodology is ambiguous, Wesley's ground truth reflects his implicit interpretation, which may not be the only valid interpretation.

2. **Partial coverage.** Ground truth covers only 5 of 15 sections. The remaining 10 sections are uncalibrated. Agent agreement on these sections is unknown until the first inter-niche comparison.

3. **Data-sparse ground truth vacuum.** CAL-B has no ground truth. Agent-to-agent agreement is the only validation for data-sparse contexts. If both B1 and B2 agree but are BOTH wrong, the protocol cannot detect this.

4. **Overfitting risk.** Each calibration iteration that passes triggers methodology amendments. Multiple iterations could "train" the methodology to produce specific outputs for CAL-A and CAL-B at the expense of generalizability to the other 25 niches.

5. **Anchoring awareness.** Agents know a ground truth exists even if they don't know which sections. This awareness may cause subtle anchoring -- agents may unconsciously produce "safer" outputs that are less likely to disagree with an unknown ground truth, reducing the very variance the calibration is designed to measure.

6. **Human inconsistency.** Wesley producing the ground truth is a single human with finite time and attention. The ground truth is subject to the same cognitive biases (anchoring, availability, confirmation) that calibration is designed to remove from agents. Wesley's ground-truth RIOS score for CAL-A may differ by +-0.5 from what Wesley himself would produce 48 hours later.

7. **Additive bias assumption.** Score normalization assumes agent bias is additive and constant (Agent A is consistently 0.6 stricter). But AI agent bias may be: (a) non-linear (strict on medium scores but lenient on extremes), (b) context-dependent (different biases in different sections), or (c) random (no stable bias at all).

### 9.2 Mitigations

| Paradox | Mitigation | Effectiveness |
|---|---|---|
| #1 Circular validation | Wesley's ground truth is a reference, not a gold standard. If both agents agree with each other but disagree with Wesley, agents may be right. The resolution protocol (SS7.2) checks this explicitly. | MODERATE |
| #2 Partial coverage | The 5 ground-truthed sections are the 5 that require the MOST judgment (scoring, identity, competitive positioning). The uncalibrated sections are primarily discovery-based (market sizing, signal detection) where objective data constrains variance. | MODERATE |
| #3 Data-sparse vacuum | CAL-B uses agent-to-agent agreement + delta thresholds as validation. While this doesn't detect "both wrong," the thresholds are conservative enough that large shared errors would be improbable across independent agents. | MODERATE |
| #4 Overfitting risk | Max 3 calibration iterations (SS7.5). Each amendment is targeted to the specific failure. Global amendments are forbidden. The pre-registration rule (SS6.1 of methodology) prevents calibrating to the test set. | HIGH |
| #5 Anchoring | Agents are blinded to which sections are ground-truthed. They cannot optimize for ground-truth agreement on specific sections because they don't know which ones will be checked. | HIGH |
| #6 Human inconsistency | Wesley's ground truth is self-tested: he scores CAL-A blind 48 hours later and compares (SS3.5). If his scores differ by >0.3, the ground truth is unreliable and must be revised. | HIGH |
| #7 Non-linear bias | The dual-curve test (SS8.2 Step 2) explicitly tests whether agent bias is context-dependent. If delta exceeds 0.5 between CAL-A and CAL-B adjustments, dual curves are activated. Statistical testing on the first 10 niches can verify whether the additive model holds at scale. | MODERATE |

### 9.3 Accepted Limitations (Non-Blocking)

| Limitation | Rationale |
|---|---|
| Ground truth is a single human's judgment with finite accuracy | Wesley is the domain expert; no alternative expert available for cross-checking. The self-test (SS3.5) quantifies his consistency. |
| Calibration cannot detect every form of agent non-determinism | 4 agents x 2 niches x 15 metrics provides 120+ comparison points. Agents that pass this battery are sufficiently reliable for the program's purpose (portfolio-level decisions, not life-critical systems). |
| The 10 uncalibrated sections are assumed to be discovery-constrained | If later evidence shows high agent variance on uncalibrated sections, the ongoing calibration (SS10) will detect it through drift analysis. |

---

## 10. Ongoing Calibration Schedule

### 10.1 Mini-Calibration Events

After the initial calibration passes, calibration is NOT static. It is re-tested at regular intervals:

```
Event:          Every 5th niche (N-005, N-010, N-015, N-020, N-025)
Type:           Mini-calibration
Scope:          SS14 Part B only (RIOS scores)
Agents:         The agent that completed the 5th niche re-scores both CAL-A and CAL-B
                using SS14 Part B (8 RIOS dimensions + composite)
Duration:       ~10 minutes per re-scoring
```

### 10.2 Drift Detection

After each mini-calibration:

```
Agent_X_CAL_A_re_score = agent X's RIOS for CAL-A at nth checkpoint
Agent_X_CAL_A_original = agent X's original RIOS for CAL-A during calibration

drift_CAL_A = |Agent_X_CAL_A_re_score - Agent_X_CAL_A_original|

If drift_CAL_A > 0.5 OR drift_CAL_B > 0.5:
  -> Flag agent X's last 5 niches for review
  -> Review threshold: verify evidence grades, scoring justifications, and
     trace-map integrity for each flagged niche
  -> If systematic drift confirmed: re-calibrate agent X by:
     a. Run abbreviated calibration (SS14 Part B only on CAL-A and CAL-B)
     b. Compute new adjustment factors
     c. Retroactively re-normalize agent X's last 5 niches with both old
        and new adjustments. If rank position of any niche changes by >= 3
        positions, the agent's evaluation is UNCERTAIN -- mark in LEDGER.yaml.
```

### 10.3 Cohort Re-Calibration

After niche 13 (mid-point), run a full re-calibration:

1. Both CAL-A and CAL-B are re-scored by 2 new agents (C1, C2 -- FRESH agents with no prior calibration context)
2. All 15 metrics from the original calibration are re-computed
3. If any metric fails, investigate: did the methodology drift due to amendments? Did tool changes affect data quality?
4. This serves as a "temporal reliability" check -- are calibration results stable over time?

### 10.4 Final Reliability Check

After all 25 niches are complete:

1. One randomly selected niche from the 25 is re-evaluated by a DIFFERENT agent (new session, no context sharing)
2. The original agent's RIOS scores and evidence grades are compared against the re-evaluation
3. Metrics: Kappa >= 0.41 (moderate agreement -- looser than calibration because the re-evaluation agent has no calibration context) and ICC >= 0.60
4. If these thresholds fail, the entire program's scoring is flagged as `CALIBRATION_DECAYED` in the final LEDGER.yaml, and all 25 niches carry a reliability warning

### 10.5 Calibration Schedule Summary

```
T = 0:     Full calibration (4 agents, 2 niches, 15 metrics)
           GATE: ALL PASS before N-001 begins

T + 5:     Mini-calibration (1 agent re-scores CAL-A + CAL-B, check drift > 0.5)
T + 10:    Mini-calibration
T + 13:    Cohort re-calibration (2 new agents, full 15 metrics)
T + 15:    Mini-calibration
T + 20:    Mini-calibration
T + 25:    Final reliability check (1 random niche, 1 new agent, Kappa + ICC)

Any mini-calibration that detects drift > 0.5:
  -> Flag last 5 niches for review
  -> Re-calibrate the drifting agent
```

---

## 11. Calibration Completion Gate

### 11.1 Gate Conditions

The following MUST be true before any N-XXX evaluation begins:

- [ ] Ground truth published to `research/CALIBRATION/_GROUND-TRUTH/` with version hash
- [ ] All 4 calibration agents completed their canvases (15 sections, complete trace-maps)
- [ ] All 15 metrics in the Maximum Acceptable Delta table PASS for both CAL-A and CAL-B
- [ ] Cohen's Kappa >= 0.61 on evidence grades (both niches)
- [ ] ICC >= 0.75 on RIOS scores (CAL-A vs ground truth, CAL-B agent-to-agent)
- [ ] Ground-truth section accuracy >= 80% (both CAL-A agents)
- [ ] Niche verdict exact match (both pairs)
- [ ] Normalization factors computed and written to `_RECONCILIATION/NORMALIZATION-FACTORS.yaml`
- [ ] Calibration report written to `_RECONCILIATION/CALIBRATION-REPORT-v1.yaml` with status PASS
- [ ] No unresolved calibration paradox items (SS9.2 mitigations documented)

### 11.2 Gate Override

If calibration fails after 3 iterations (SS7.5):
1. Wesley must manually review all 4 agent canvases against the ground truth
2. For each failing metric, determine: is the methodology genuinely ambiguous, or are the agents wrong?
3. If methodology is ambiguous: calibration proceeds with CONFIDENCE_CAPPED status. All subsequent niches carry a footnote: "Calibration did not achieve full convergence on [specific metrics]. Scores for this niche have wider uncertainty than planned."
4. If agents are wrong: replace the failing agent(s), and re-run once. If the replacement agents also fail, proceed with CONFIDENCE_CAPPED.

### 11.3 Gate Logging

Gate pass/fail is logged to `_program/PIPELINE_CHECKPOINTS.yaml`:

```yaml
gates:
  calibration_gate:
    status: "PASS"  # PASS | FAIL | CONFIDENCE_CAPPED
    calibration_iterations: 2
    calibration_date: "2026-07-23"
    failing_metrics: []  # empty on PASS
    normalization_factors:
      AgentA1: -0.42
      AgentA2: 0.31
      AgentB1: -0.18  # Agents B1/B2 only used if dual-curve needed
      AgentB2: 0.15
    calibration_report: "research/CALIBRATION/_RECONCILIATION/CALIBRATION-REPORT-v1.yaml"
```

---

## 12. Computation Procedures

### 12.1 Cohen's Kappa Computation

```python
# compute_kappa.py
# Input: two agent's evidence grade lists (aligned by claim topic)
# Output: kappa statistic

def compute_cohens_kappa(agent1_grades: List[str], agent2_grades: List[str]) -> float:
    """
    Compute Cohen's Kappa for inter-rater agreement on nominal evidence grades.
    
    Grades: [P], [E], [H], [S]
    Kappa = (p_o - p_e) / (1 - p_e)
    
    where p_o = observed agreement proportion
          p_e = expected agreement proportion by chance
    """
    from sklearn.metrics import cohen_kappa_score  # or manual numpy implementation
    
    # Map string grades to integers
    grade_map = {"[P]": 0, "[E]": 1, "[H]": 2, "[S]": 3}
    g1 = [grade_map[g] for g in agent1_grades]
    g2 = [grade_map[g] for g in agent2_grades]
    
    kappa = cohen_kappa_score(g1, g2, weights='linear')
    return kappa
```

### 12.2 ICC(2,1) Computation

```python
# compute_icc.py
# Input: agent scores and ground truth scores across 9 data points (8 dimensions + composite)
# Output: ICC(2,1) value

def compute_icc_2_1(scores_matrix: np.ndarray) -> float:
    """
    Compute ICC(2,1) - two-way random effects, single rater, absolute agreement.
    
    scores_matrix shape: (n_targets, n_raters)
    where n_targets = 9 (8 RIOS dimensions + composite)
          n_raters = 2 for agent-to-agent, or (agent + ground_truth) for GT comparison
    
    ICC(2,1) = (MS_R - MS_E) / (MS_R + (k-1)*MS_E + k*(MS_C - MS_E)/n)
    
    where MS_R = mean square for rows (targets)
          MS_C = mean square for columns (raters)
          MS_E = mean square for error (residual)
          k = number of raters
          n = number of targets
    """
    # Standard ICC(2,1) implementation using ANOVA
    n, k = scores_matrix.shape
    
    # Grand mean
    grand_mean = np.mean(scores_matrix)
    
    # Row means (per target)
    row_means = np.mean(scores_matrix, axis=1)
    
    # Column means (per rater)
    col_means = np.mean(scores_matrix, axis=0)
    
    # Sum of squares
    SS_R = k * np.sum((row_means - grand_mean)**2)
    SS_C = n * np.sum((col_means - grand_mean)**2)
    SS_E = np.sum((scores_matrix - row_means[:, None] - col_means[None, :] + grand_mean)**2)
    
    # Degrees of freedom
    df_R = n - 1
    df_C = k - 1
    df_E = (n - 1) * (k - 1)
    
    # Mean squares
    MS_R = SS_R / df_R
    MS_C = SS_C / df_C
    MS_E = SS_E / df_E
    
    # ICC(2,1)
    icc = (MS_R - MS_E) / (MS_R + (k - 1) * MS_E + k * (MS_C - MS_E) / n)
    
    return icc
```

### 12.3 Grade Distribution Delta

```python
# compute_grade_distribution.py
def compute_grade_delta(agent1_grades: Dict[str, int], agent2_grades: Dict[str, int]) -> Dict[str, float]:
    """
    Compute absolute percentage-point difference in grade distribution.
    
    Input: {grade: count} dictionaries for both agents
    Output: {grade: delta_pp} for each grade level
    """
    total1 = sum(agent1_grades.values())
    total2 = sum(agent2_grades.values())
    
    deltas = {}
    for grade in ["[P]", "[E]", "[H]", "[S]"]:
        pct1 = (agent1_grades.get(grade, 0) / total1) * 100
        pct2 = (agent2_grades.get(grade, 0) / total2) * 100
        deltas[grade] = abs(pct1 - pct2)
    
    return deltas
```

### 12.4 WRS Rank-Based Aggregation (Cross-Niche)

```python
# compute_wrs_ranks.py
def compute_wrs_ranks(niche_scores: Dict[str, Dict[str, float]], weights: Dict[str, float]) -> Dict[str, int]:
    """
    Compute Weighted Rank Score for all niches.
    
    niche_scores: {niche_id: {SA: float, WA: float, CV: float, BF: float, FM: float}}
    weights: {SA: 0.30, WA: 0.25, CV: 0.30, BF: 0.05, FM: 0.15}
    
    Returns: {niche_id: weighted_rank}
    Lower is better.
    """
    dimensions = list(weights.keys())
    
    # Rank each niche on each dimension (rank 1 = highest score)
    ranks = {}
    for niche_id in niche_scores:
        ranks[niche_id] = {}
    
    for dim in dimensions:
        sorted_niches = sorted(niche_scores.keys(), 
                              key=lambda n: niche_scores[n][dim], 
                              reverse=True)
        for rank, niche_id in enumerate(sorted_niches, 1):
            ranks[niche_id][dim] = rank
    
    # Compute WRS
    wrs = {}
    for niche_id in niche_scores:
        wrs[niche_id] = sum(ranks[niche_id][dim] * weights[dim] for dim in dimensions)
    
    # Final ranking
    final_ranks = sorted(wrs.keys(), key=lambda n: wrs[n])
    return {niche: rank for rank, niche in enumerate(final_ranks, 1)}
```

### 12.5 Bootstrap Confidence Intervals

```python
# compute_bootstrap_ci.py
def bootstrap_rank_ci(niche_scores: Dict[str, Dict[str, float]], 
                      weights: Dict[str, float], 
                      iterations: int = 1000, 
                      ci_level: float = 0.90) -> Dict[str, Dict[str, int]]:
    """
    Compute bootstrap confidence intervals for WRS ranks.
    
    Returns: {niche_id: {rank: int, ci_lower: int, ci_upper: int, tied_with: List[str]}}
    """
    import numpy as np
    
    niches = list(niche_scores.keys())
    dimensions = list(weights.keys())
    
    # Store ranks from each iteration
    all_ranks = {niche: [] for niche in niches}
    
    for _ in range(iterations):
        # Bootstrap resample niches (with replacement)
        boot_indices = np.random.choice(len(niches), size=len(niches), replace=True)
        boot_scores = {niches[i]: niche_scores[niches[i]] for i in boot_indices}
        
        # Compute WRS for bootstrap sample
        boot_wrs = compute_wrs_ranks(boot_scores, weights)
        
        # Record ranks
        for niche_id, rank in boot_wrs.items():
            all_ranks[niche_id].append(rank)
    
    # Compute confidence intervals
    results = {}
    for niche_id in niches:
        ranks = sorted(all_ranks[niche_id])
        ci_lower = int(np.percentile(ranks, (1 - ci_level) / 2 * 100))
        ci_upper = int(np.percentile(ranks, (1 + ci_level) / 2 * 100))
        median_rank = int(np.median(ranks))
        
        results[niche_id] = {
            "rank": median_rank,
            "ci_lower": ci_lower,
            "ci_upper": ci_upper
        }
    
    # Determine statistically tied niches
    for niche_id in results:
        tied = []
        for other_id in results:
            if other_id == niche_id:
                continue
            # Overlapping CIs = statistically tied
            if (results[niche_id]["ci_lower"] <= results[other_id]["ci_upper"] and
                results[niche_id]["ci_upper"] >= results[other_id]["ci_lower"]):
                tied.append(other_id)
        results[niche_id]["tied_with"] = tied
    
    return results
```

---

*End of CALIBRATION-PROTOCOL.md v1.0 -- This document extends NICHE-METHODOLOGY.md SS6.3 Mechanism 6. It is BINDING for all calibration activities. No niche evaluation begins until the calibration completion gate (SS11) passes.*
