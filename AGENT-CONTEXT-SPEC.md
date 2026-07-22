# Agent Context Specification — Per-Phase Loading

**Status:** BINDING. Every niche agent MUST follow this loading specification.

**Principle:** Agents load ONLY what they need for the current phase. No phase loads the full methodology.

**Total methodology document:** ~172K tokens across 4578 lines, NICHE-METHODOLOGY.md + DATA-OPERATIONS-ARCHITECTURE.md combined. A Claude Code session has a 200K token context window. Loading the entire methodology leaves ~14% of the window for research data, intermediate results, and agent deliberation. Agents frequently overflow mid-phase, dropping critical instructions. This specification prevents overflow.

---

## Phase 1: Niche Bounding

**Context budget:** ~40K tokens
**Line budget:** Load only the sections listed below. Do NOT load sections outside this set.

### Load (in this order):

1. **NICHE-METHODOLOGY.md preamble + Part 1 intro** — lines 1-85
   - §1 PREAMBLE: Principles of this methodology
   - TABLE OF CONTENTS reference
   - Part 1 header and opening principles

2. **NICHE-METHODOLOGY.md §3.1 lines 3420-3439 only** — Research Sequence Phase 1 steps

3. **DATA-OPERATIONS-ARCHITECTURE.md §2.2 Tool Selection Decision Tree** — lines 130-163
   - Which tool for which task
   - Primary/fallback/tertiary tool chains

4. **DATA-OPERATIONS-ARCHITECTURE.md §4.1 Phase 1 Pipeline** — lines 359-373 (or the Phase 1 pipeline section)
   - Exact commands for Phase 1
   - Credit budget for Phase 1 (~17 credits)

5. **DATA-OPERATIONS-ARCHITECTURE.md §2.1 Tools Quick Reference** — lines 90-129
   - Tool names, costs, authentication status

### DO NOT LOAD:
- NICHE-METHODOLOGY.md §§2-15 (all canvas sections)
- NICHE-METHODOLOGY.md Part 2 (Research Protocol beyond Phase 1)
- NICHE-METHODOLOGY.md Part 3 (Quality Gates)
- NICHE-METHODOLOGY.md Part 4 (Workflow Integration)
- NICHE-METHODOLOGY.md Part 5 (Cross-Niche Comparability)
- DATA-OPERATIONS-ARCHITECTURE.md §4.2-4.4 (Phase 2-4 pipelines)
- DATA-OPERATIONS-ARCHITECTURE.md §5 (Data Schemas)
- DATA-OPERATIONS-ARCHITECTURE.md §6 (Evidence Engine)
- Any operational scripts (RUNBOOK.md, _pipelines/ files)

### Gate: Before proceeding to Phase 2
- [ ] Verify Phase 1 results confirm niche existence (>=50 searchable companies OR >=1 analyst report OR data accessibility GREEN)
- [ ] If Phase 1 gate fails: flag as HIGH-UNCERTAINTY, proceed to STANDARD depth only
- [ ] If Phase 1 passes: proceed to Phase 2

---

## Phase 2: Deep Research

**Context budget:** ~60K tokens
**Line budget:** Load the sections listed below. This is the highest-context phase.

### Load (in this order):

1. **NICHE-METHODOLOGY.md Part 1 canvas sections (lines 1-1000 approximately)**
   - §1 PREAMBLE + all canvas sections needed for research
   - §2 Buyer & Committee Mapping
   - §3 Pain & Economics
   - §4 Competitive Landscape
   - §5 Ecosystem & Distribution
   - §6 Signals & Triggers

2. **NICHE-METHODOLOGY.md §3.1 Research Sequence Phase 2** — lines 3441-3454

3. **DATA-OPERATIONS-ARCHITECTURE.md §2.3 Tool-to-Task Master Matrix** — lines 165-186

4. **DATA-OPERATIONS-ARCHITECTURE.md §4.2 Phase 2 Pipeline** — lines 374-393

5. **DATA-OPERATIONS-ARCHITECTURE.md §5.1-5.3 Data Schemas** — lines 431-580
   - Competitor profile schema
   - Trigger signal schema
   - Buyer intelligence schema

6. **This document (AGENT-CONTEXT-SPEC.md), Phase 2 section only**

### DO NOT LOAD:
- NICHE-METHODOLOGY.md §§7-15 (commercial design, GTM, scoring)
- NICHE-METHODOLOGY.md Part 3 (Quality Gates)
- NICHE-METHODOLOGY.md Part 4 (Workflow Integration)
- NICHE-METHODOLOGY.md Part 5 (Cross-Niche Comparability)
- DATA-OPERATIONS-ARCHITECTURE.md §4.3-4.4 (Phase 3-4 pipelines)
- DATA-OPERATIONS-ARCHITECTURE.md §6.2-6.4 (grade engine internals)
- RUNBOOK.md

### Gate: Data quality check (BINDING)
- [ ] Target >=3 competitors with pricing anchors. If fewer exist, document with SOURCE_UNAVAILABLE.
- [ ] >=20 reviews across >=3 competitors. If fewer, document search methodology.
- [ ] >=2 independent market sizing sources. If only 1, flag as INSUFFICIENT_DATA.
- [ ] Run deterministic grade engine (separate grading agent, NOT the authoring agent).

---

## Phase 3: Commercial Design

**Context budget:** ~45K tokens
**Line budget:** Load design-relevant sections. This phase is DESIGN, not research.

### Load (in this order):

1. **NICHE-METHODOLOGY.md §7-11** (Customer Journey, Free Services, Paid Services, Recurring Services, Workflow Specs)
   - Each section specifies templates and required fields for commercial design
   - Load only the sections that APPLY per the MECE verification gate

2. **NICHE-METHODOLOGY.md §3.1 Phase 3** — lines 3456-3460

3. **DATA-OPERATIONS-ARCHITECTURE.md §4.3 Phase 3 Pipeline** — lines ~394-410

### DO NOT LOAD:
- NICHE-METHODOLOGY.md §2-6 (research data — already collected in Phase 2)
- NICHE-METHODOLOGY.md §12-15 (evidence stack, GTM, scoring)
- NICHE-METHODOLOGY.md Part 3 (Quality Gates)
- DATA-OPERATIONS-ARCHITECTURE.md §4.1, §4.2, §4.4

### Gate: Before proceeding to Phase 4
- [ ] All APPLIES sections populated with evidence grades
- [ ] MECE verification gate completed
- [ ] Minimum viable journey sequencing respected (Diagnose->Prove first)
- [ ] Design assumptions validated with fresh pricing benchmarks

---

## Phase 4: Scoring, QA & Canvas Authoring

**Context budget:** ~35K tokens
**Line budget:** Minimum context. The research is done, design is done. Load only scoring rubric and quality gates.

### Load (in this order):

1. **NICHE-METHODOLOGY.md §14** (RIOS Score & Diagnosis)
   - The corrected RIOS formula with inverted denominator dimensions
   - Rank-based aggregation specification

2. **NICHE-METHODOLOGY.md Part 3 (Quality Gates)** — lines 3555-3748
   - Section-level gates (4.1)
   - Canvas-level gates (4.2)
   - Agent self-audit checklist (4.3)

3. **NICHE-METHODOLOGY.md §15** (Open Questions & Validation Plan)
   - Evidence grade inventory
   - Open questions framework
   - Decision triggers

4. **DATA-OPERATIONS-ARCHITECTURE.md §6.3** (Evidence Traceability Map)

5. **DATA-OPERATIONS-ARCHITECTURE.md §4.4 Phase 4 Pipeline** — lines ~411-430

### DO NOT LOAD:
- NICHE-METHODOLOGY.md §2-6 (research sections)
- NICHE-METHODOLOGY.md §7-11 (commercial design sections — already finalized)
- NICHE-METHODOLOGY.md §1 PREAMBLE
- DATA-OPERATIONS-ARCHITECTURE.md §4.1-4.3
- RUNBOOK.md

### Gate: Canvas verification
- [ ] Completeness: All 15 sections present and addressed
- [ ] Evidence Integrity: No ungraded claims
- [ ] Coherence: Pain → trigger → Snapshot → paid → recurring logically connected
- [ ] Falsifiability: Canvas can be proven wrong by evidence
- [ ] MECE Boundaries: No overlap with other assessed niches
- [ ] Decision-Readiness: A founder can decide "enter" or "skip"
- [ ] Minimum Viable Sequencing: Build order respected
- [ ] Conversion Model Reconciliation: Journey rates compound to match channel rates within 20%
- [ ] Pricing Consistency: Same price across all sections within 10%

---

## Context Overflow Protocol

The methodology document is ~172K tokens. If loading Phase 2 (60K) plus research data pushes the agent toward capacity limits, follow this protocol.

### Monitoring

The agent MUST check context utilization before loading any new section:
- **If context < 60% of 200K window (<120K tokens):** Safe to load normally
- **If context 60-80% (120K-160K tokens):** Caution zone. Skip optional examples and notes. Load only structural content.
- **If context > 80% (>160K tokens):** OVERFLOW RISK. Execute protocol immediately.

### Overflow Protocol Steps

**Step 1: CHECKPOINT** (takes effect when context > 80% capacity)
```
Write current state to: niche-program/research/N-XXX/_work/CHECKPOINT.yaml

Format:
  checkpoint_id: "UUID v4"
  phase: "Phase [1/2/3/4]"
  completed_steps: ["step1", "step2", ...]
  last_completed_step: "exact name of last completed step"
  intermediate_results: {}
    # Key data collected so far (market size, competitor list, etc.)
  pending_steps: ["step3", "step4", ...]
  timestamp: "ISO 8601"
```

**Step 2: FLUSH**
Clear all non-essential context:
1. Remove any cached research data that is already written to disk
2. Remove any intermediate calculations that are already saved to CHECKPOINT.yaml
3. Keep only: AGENT-CONTEXT-SPEC.md current section, active pipeline instructions, CHECKPOINT summary

**Step 3: RECOVER**
1. Reload from CHECKPOINT.yaml
2. Re-read only the methodology sections needed for the NEXT uncompleted step
3. Continue execution from `last_completed_step`

**Step 4: LOG**
```
Append to: niche-program/research/_program/PIPELINE_CHECKPOINTS.yaml

checkpoints:
  - niche_id: "N-XXX"
    checkpoint_id: "UUID v4"
    phase: "Phase [1/2/3/4]"
    reason: "OVERFLOW_80PCT"
    tokens_used: ~165000
    steps_completed: N
    steps_remaining: M
    timestamp: "ISO 8601"
```

### Overflow Prevention During Load

When loading Phase 2 specifically (highest risk, ~60K tokens):
1. Load sections SEQUENTIALLY, not all at once
2. After loading each section, write any immediately actionable instructions to a local buffer
3. Remove section from context once its data is collected and written to disk
4. If context reaches 75% before all Phase 2 sections are loaded, trigger CHECKPOINT and continue with remaining sections in a fresh load

---

## Session Isolation Rule (BINDING)

1. **Each niche evaluation MUST use a FRESH agent session.** No session reuse across niches.
2. A session that evaluated N-003 must not be used for N-007.
3. Shared data is accessed through the filesystem (SHARED/ registry), not through session memory.
4. Cross-niche deduplication uses `_pipelines/dedup-manifest.yaml` — check BEFORE fetching any data.
5. A session that overflowed and checkpointed MUST NOT resume in a session that also contains another niche's context.

### Rationale
Consecutive niches in the same session contaminate each other's context. Buyer language from N-003 leaks into N-007's research. Competitor analysis for N-003 influences N-007's objectivity. Session isolation prevents this contamination.

### Exception
The calibration protocol (Mechanism 6) uses two agents evaluating the SAME two niches. This is the ONLY case where session-to-niche mapping permits reuse — both agents evaluate the same niches for inter-rater reliability.

---

## Phase 0 Calibration Loading Specification

**Context budget:** ~50K tokens
**Load:**
1. NICHE-METHODOLOGY.md full preamble (§1) — lines 1-85
2. NICHE-METHODOLOGY.md §3.1 Full Research Sequence — lines 3420-3470
3. NICHE-METHODOLOGY.md Part 3 Quality Gates — lines 3555-3748
4. DATA-OPERATIONS-ARCHITECTURE.md §4.0 Phase 0 Tool Calibration
5. DATA-OPERATIONS-ARCHITECTURE.md §2.2 Tool Selection Decision Tree
6. This document (AGENT-CONTEXT-SPEC.md) full document
7. CAL-A reference canvas (Wesley-produced ground truth for 5 sections)

### Calibration-specific rules:
- Two agents evaluate CAL-A and CAL-B independently
- Do NOT share context between the two calibration agents
- Inter-rater reliability check (Cohen's Kappa) happens AFTER both agents complete their independent evaluations
- Verification: compute Kappa >= 0.61 and ICC >= 0.75

---

## Context Budget Enforcement

| Phase | Token Budget | Sections Loaded | Risk Level |
|---|---|---|---|
| Phase 1: Niche Bounding | ~40K | Preamble + Phase 1 steps only | LOW |
| Phase 2: Deep Research | ~60K | Canvas §§2-6 + Phase 2 pipeline | HIGH — most overflow-prone |
| Phase 3: Commercial Design | ~45K | Canvas §§7-11 + Phase 3 pipeline | MEDIUM |
| Phase 4: Scoring & QA | ~35K | §14-15 + Part 3 Quality Gates | LOW |
| Phase 0 Calibration | ~50K | Full preamble + research sequence + gates | MEDIUM |

**Enforcement:** If context exceeds 80% at any point, the OVERFLOW PROTOCOL is MANDATORY (not advisory). The agent MUST checkpoint, flush, and recover. A checkpointed-but-not-recovered agent MUST NOT continue — it is operating on incomplete context.
