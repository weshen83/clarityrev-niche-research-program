# Workstream B Execution Plan — Agent Instruction Layer

**Findings addressed:** Items #21-40 (AGT-B1 through AGT-L3)
**Status:** IN PROGRESS (TOOL-EXECUTION-SPEC.md created, AGENT-CONTEXT-SPEC.md pending)

---

## 1. Findings Inventory

| # | ID | Severity | Description | Fix Summary | File | Est. Time |
|---|---|---|---|---|---|---|
| 21 | AGT-B1 | CRITICAL | Phase 2 context budget too tight (must-load ~18K tool refs) | Create TOOL-EXECUTION-SPEC.md to replace ref doc loads | TOOL-EXECUTION-SPEC.md (NEW) | 120 min |
| 22 | AGT-B2 | CRITICAL | No tool escalation pattern encoded | Rule #1: search->scrape->map->crawl->interact | TOOL-EXECUTION-SPEC.md R1 | 60 min |
| 23 | AGT-B3 | CRITICAL | JS-rendered pages fail without --wait-for | Rule #5: --wait-for 3000-5000 required | TOOL-EXECUTION-SPEC.md R5 | 15 min |
| 24 | AGT-B4 | BLOCKING | Cache preflight not automated | Cache preflight protocol section | TOOL-EXECUTION-SPEC.md §Cache | 30 min |
| 25 | AGT-B5 | BLOCKING | No prompt injection defense | Rule #8: never paste full scraped content + defense section | TOOL-EXECUTION-SPEC.md R8 + §Prompt | 30 min |
| 26 | AGT-H1 | HIGH | No search-feedback automation | Rule #6 + automation script | TOOL-EXECUTION-SPEC.md R6 + §Feedback | 15 min |
| 27 | AGT-H2 | HIGH | No dead-host registry write logic | Dead-host write protocol + YAML template | TOOL-EXECUTION-SPEC.md §Error | 30 min |
| 28 | AGT-H3 | HIGH | No freshness SLA automation | Cache preflight freshness check (stat --format=%Y + ttl) | TOOL-EXECUTION-SPEC.md §Cache | 30 min |
| 29 | AGT-H4 | HIGH | No error recovery protocol | Error recovery table (5s retry -> fallback -> UNAVAILABLE) | TOOL-EXECUTION-SPEC.md §Error | 30 min |
| 30 | AGT-H5 | HIGH | Session isolation not enforced | Rule #10 + lock file protocol with atomic write | TOOL-EXECUTION-SPEC.md R10 + §Lock | 30 min |
| 31 | AGT-H6 | HIGH | --query ban not enforced | Rule #3: ban --query, use grep instead | TOOL-EXECUTION-SPEC.md R3 | 15 min |
| 32 | AGT-M1 | MEDIUM | No monitoring setup during niche research | Task 8: monitor create for each competitor pricing page | TOOL-EXECUTION-SPEC.md Task 8 | 30 min |
| 33 | AGT-M2 | MEDIUM | No quality threshold for search results | <3 relevant -> retry alt query -> SOURCE_UNAVAILABLE | TOOL-EXECUTION-SPEC.md Task 1 fallback | 15 min |
| 34 | AGT-M3 | MEDIUM | Grade engine I/O protocol undefined | (Deferred to Workstream D — grade engine design) | N/A | — |
| 35 | AGT-M4 | MEDIUM | F-4: DataForSEO when Firecrawl has data | Tool decision surfaced implicitly via task-organized commands; R1 reinforces cheapest-first | TOOL-EXECUTION-SPEC.md R1 + Task structure | 15 min |
| 36 | AGT-M5 | MEDIUM | F-5: /search for registry data | Task 9: OpenRegistry MCP first, search fallback | TOOL-EXECUTION-SPEC.md Task 9 | 10 min |
| 37 | AGT-M6 | MEDIUM | F-8: Missing --only-main-content | Rule #4: REQUIRED for competitor pages | TOOL-EXECUTION-SPEC.md R4 | 10 min |
| 38 | AGT-L1 | LOW | Missing --scrape on Phase 2 /search | Rule #7: Phase 1 no --scrape, Phase 2+ with --scrape | TOOL-EXECUTION-SPEC.md R7 | 10 min |
| 39 | AGT-L2 | LOW | Old Firecrawl flags in training data | All canonical flags encoded in spec; agent uses spec not training | TOOL-EXECUTION-SPEC.md (all commands) | 15 min |
| 40 | AGT-L3 | LOW | Old credit costs in training | Credit budget table with current costs | TOOL-EXECUTION-SPEC.md §Budget | 10 min |

**Total findings addressed in Workstream B:** 16 (19 minus 3 cross-referenced to other workstreams)

**Bypassed (assigned to other workstreams):**
- AGT-M3 (Grade engine I/O, #34): Workstream D — grade engine design
- AGT-B6/G-M1 (Prompt injection, #25): Covered by AGT-B5 in this workstream

**Conflicts with other workstreams:**
- AGENT-CONTEXT-SPEC.md: Workstream G (Security) also touches this file (prompt injection defense). Coordinate: my update replaces Phase 2 tool ref loads with TOOL-EXECUTION-SPEC.md. Workstream G adds §31 (Security) loading. Both changes are additive, not conflicting.

---

## 2. Files to Create/Edit

| File | Action | Priority |
|---|---|---|
| `niche-program/TOOL-EXECUTION-SPEC.md` | **CREATE** | P0 — centerpiece |
| `niche-program/AGENT-CONTEXT-SPEC.md` | **UPDATE** — replace tool ref section loads with TOOL-EXECUTION-SPEC.md; add prompt injection defense; add lock file cross-ref; update Phase 2 budget | P0 |
| `niche-program/research/CALIBRATION/_RECONCILIATION/execution-workstream-B.md` | **CREATE** — execution summary | P1 |

---

## 3. Execution Sequence

```
Step 1: CREATE TOOL-EXECUTION-SPEC.md [DONE]
  └── All 10 binding rules (R1-R10)
  └── 10 task sections (Task 1-10)
  └── Credit budget table (Firecrawl + DataForSEO)
  └── Error recovery protocol
  └── Cache preflight protocol
  └── Prompt injection defense
  └── Search-feedback automation script
  └── Dead-host write protocol
  └── Session isolation lock file protocol

Step 2: UPDATE AGENT-CONTEXT-SPEC.md [PENDING]
  └── Section: Replace tool reference loads with TOOL-EXECUTION-SPEC.md
  └── Per-phase: Replace all Firecrawl Ref §§ and Data Sources §§ refs
  └── Update Phase 2 context budget (60K -> ~45K)
  └── Add prompt injection defense: load §Security section Phase 1
  └── Add session isolation: cross-ref to TOOL-EXECUTION-SPEC.md R10
  └── Replace per-load tool instruction: "load TOOL-EXECUTION-SPEC.md instead"

Step 3: CREATE execution-workstream-B.md [PENDING]
  └── Summary of all changes
  └── Verification gate results
  └── What each finding's fix looks like
  └── Remaining items (cross-workstream)
```

---

## 4. Verification Gates

| Gate | Criteria | How to Verify |
|------|----------|--------------|
| B-G1 | TOOL-EXECUTION-SPEC.md exists | File exists at `niche-program/TOOL-EXECUTION-SPEC.md` |
| B-G2 | 10+ binding rules present | `grep -c "BINDING" TOOL-EXECUTION-SPEC.md` >= 1 (frontmatter) + `grep -c "Rule #[0-9]"` >= 10 |
| B-G3 | Every task has non-empty fallback | Each Task section ends with "Fallback:" or "**Fallback:**" |
| B-G4 | All 3 CONFIGURE_NOW MCPs | OpenRegistry, Reddit Research, DataForSEO in command examples |
| B-G5 | Prompt injection defense present | Contains "NEVER paste full scraped content" or equivalent |
| B-G6 | Cache preflight block present | Contains "Cache Preflight Protocol" section |
| B-G7 | Dead-host write logic | Contains DEAD_HOST_REGISTRY.yaml template |
| B-G8 | Session isolation lock file | Contains lock file protocol with atomic write |
| B-G9 | Error recovery protocol | Contains error recovery table with 5s retry -> fallback -> UNAVAILABLE |
| B-G10 | search-feedback rule present | Contains search-feedback automation script |
| B-G11 | AGENT-CONTEXT-SPEC.md updated | Diff shows: tool ref loads replaced, Phase 2 budget updated, prompt injection defense, lock file cross-ref |
| B-G12 | Token budget <5,000 | `wc -w TOOL-EXECUTION-SPEC.md` < 3750 words (~5000 tokens) |

---

## 5. Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| TOOL-EXECUTION-SPEC.md exceeds 5K tokens | LOW | Budget savings negated | Cut examples, keep rules; compact credit table |
| AGENT-CONTEXT-SPEC.md conflicts with Workstream G edits | MEDIUM | Both modify same file | Changes are additive (different sections); coordinate via this plan |
| Fix spec says create at `_pipelines/TOOL-EXECUTION-SPEC.md` but dir doesn't exist | LOW | Path mismatch | Create at niche-program/ root (matches other top-level files) |
