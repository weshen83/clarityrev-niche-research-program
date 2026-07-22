# Lens 6: Quality & Freshness Controller

**Date:** 2026-07-23
**Status:** DESIGN COMPLETE
**Purpose:** Enforce data quality, freshness traceability, and evidence-grade integrity across the 25-niche evaluation data operations pipeline. Every canvas claim must be traceable to verifiable source data with measurable freshness.

**Design principles:**
- Data quality is **measurable**, not subjective. Grades are determined by source data properties, not agent judgment.
- Freshness is **enforced before use**, not audited after. Stale data does not reach canvas generation.
- Every claim has an **audit trail** back to the original fetch. No orphan claims.
- The system is **adversarially testable**: a verifier can independently confirm every grade.

---

## 1. FRESHNESS SLA TABLE

### 1.1 Data Type Classification

Each data type is assigned a `freshness_class` that determines its max age, staleness action, and re-fetch priority.

| # | Data Type | freshness_class | Max Age | Staleness Action | Re-fetch Priority | Rationale |
|---|-----------|----------------|---------|-----------------|-------------------|-----------|
| D-01 | Competitor pricing | PRICING | 90 days | RE_FETCH → DEMOTE | HIGH | Pricing changes quarterly. Stale pricing corrupts band comparisons. |
| D-02 | Competitor features/capabilities | CAPABILITY | 180 days | RE_FETCH → DEMOTE | MEDIUM | Feature sets change at product-launch cadence. |
| D-03 | Customer reviews (G2, Capterra) | REVIEW | 180 days | PASS_FLAG | LOW | Reviews accumulate slowly. Flag staleness but do not block. |
| D-04 | News / intent signals | INTENT | 14 days | RE_FETCH → BLOCK | HIGHEST | Intent signals are time-critical. Beyond 14 days they mislead. |
| D-05 | Job postings / open roles | JOB | 7 days | RE_FETCH → BLOCK | HIGHEST | Jobs close or fill within days. Stale jobs = wrong signal. |
| D-06 | Market sizing / TAM data | MARKET | 180 days | PASS_FLAG | LOW | Market reports change at annual cycle. |
| D-07 | Technographics / tool stack | TECHNO | 180 days | RE_FETCH → PASS_FLAG | LOW | Tech stacks change at renewal cadence. Flag before use. |
| D-08 | Company registry data (KVK, Chamber) | REGISTRY | 90 days | RE_FETCH → DEMOTE | MEDIUM | Registry data changes quarterly. Stale addresses/statuses break outreach. |
| D-09 | SEO / keyword data | SEO | 90 days | RE_FETCH → DEMOTE | MEDIUM | Search volume shifts quarterly. |
| D-10 | LinkedIn profile / role data | PROFILE | 30 days | RE_FETCH → DEMOTE | HIGH | Role changes happen monthly. Stale titles wrong-grade the contact. |
| D-11 | Funding / investment data | FUNDING | 90 days | RE_FETCH → DEMOTE | MEDIUM | Funding rounds are quarterly events. |
| D-12 | Engineering roles / hiring signals | HIRING | 7 days | RE_FETCH → BLOCK | HIGHEST | Mirror of D-05: open roles close fast. |
| D-13 | Website copy / positioning | POSITION | 180 days | PASS_FLAG | LOW | Positioning statements change at rebrand cadence. |
| D-14 | Regulatory / compliance data | REGULATORY | 365 days | RE_FETCH → BLOCK | MEDIUM | Regulation changes are slow but high-stakes if wrong. |
| D-15 | SOC 2 / security certifications | CERT | 365 days | PASS_FLAG | LOW | Certifications last 1-2 years. |

### 1.2 Staleness Actions Defined

| Action | Behavior |
|--------|----------|
| **PASS_FLAG** | Data is usable but annotated with a stale warning. Downstream agents see the warning and may discount the claim. |
| **RE_FETCH** | Automatic re-fetch is triggered. While re-fetch is in progress, the stale data is held (not used in new canvases). If re-fetch succeeds, the new data replaces it. If re-fetch fails, escalate to HUMAN. |
| **DEMOTE** | Data is automatically downgraded one evidence grade level (see Section 2). [E] → [H], [H] → [S]. [S] data beyond SLA is quarantined. |
| **BLOCK** | Data is removed from the active dataset. Canvases that depend on it cannot be generated until fresh data arrives. |

### 1.3 `fetched_at` Metadata Standard

Every data file in the pipeline MUST carry a metadata header with the following fields:

```yaml
# === DATA QUALITY METADATA (MANDATORY) ===
_freshness:
  fetched_at: 2026-07-23T14:30:00Z        # ISO 8601 UTC
  fresh_until: 2026-10-21T14:30:00Z        # fetched_at + max_age
  freshness_class: PRICING                  # from table 1.1
  freshness_status: FRESH                   # FRESH | STALE | EXPIRED | VERIFIED_MANUALLY
  staleness_action: RE_FETCH               # from table 1.1
  refetch_count: 0                          # incremented on each re-fetch
  refetch_history:
    - fetched_at: 2026-07-23T14:30:00Z
      trigger: INITIAL
    - fetched_at: 2026-10-21T14:30:00Z
      trigger: SLA_EXPIRY
```

**Enforcement rule:** Any agent or workflow that reads a data file MUST check `freshness_status` before using its contents. If `STALE` or `EXPIRED`, the agent must refuse to use the data and log a freshness violation.

### 1.4 Freshness Check Algorithm (Pseudocode)

```
function check_freshness(file_path):
    metadata = read_metadata(file_path)
    if not metadata.has('_freshness.fetched_at'):
        return FAIL("Missing fetched_at")
    
    age = now() - parse_iso8601(metadata._freshness.fetched_at)
    sla = freshness_sla_table[metadata._freshness.freshness_class].max_age
    
    if age <= sla:
        metadata._freshness.freshness_status = "FRESH"
        return PASS
    elif age <= sla * 2:
        metadata._freshness.freshness_status = "STALE"
        execute_staleness_action(metadata._freshness.staleness_action, file_path)
        return STALE
    else:
        metadata._freshness.freshness_status = "EXPIRED"
        execute_staleness_action("BLOCK", file_path)  # force BLOCK at 2x SLA
        return EXPIRED
```

---

## 2. EVIDENCE GRADE MAPPING

### 2.1 Grade Definitions

The evidence grade `[P/E/H/S]` is attached to a **claim** based on the **data quality of its source(s)**, not by agent judgment. This is a **deterministic mapping**, not a subjective rating.

| Grade | Label | Data Quality Requirements | Source Requirements | Freshness Requirements |
|-------|-------|--------------------------|---------------------|----------------------|
| **[P]** | Proven | All must hold: | ≥2 independent, verified sources | Within SLA (both sources) |
| **[E]** | Evidenced | Must hold: | 1 verified source OR ≥2 partial sources that triangulate the same value | Source within SLA; partials may be within 2× SLA |
| **[H]** | Hypothesis | Must hold: | Logical inference from adjacent data, extrapolation, or data beyond SLA but ≤2× SLA | Adjacent data within SLA; directional validity confirmed |
| **[S]** | Speculative | Falls here if: | No source data exists, claim is best-guess, or source data >2× SLA | Does not apply (grade already reflects staleness) |

### 2.2 The Grade Determination Matrix

The grade is computed by evaluating **four binary criteria** against the source data:

| Criterion | [P] | [E] | [H] | [S] |
|-----------|-----|-----|-----|-----|
| **C1:** ≥2 independent sources | YES | NO | NO | NO |
| **C2:** ≥1 verified source with URL | YES | YES | NO | NO |
| **C3:** Within freshness SLA | YES | YES | NO | NO |
| **C4:** Source URLs documented & accessible | YES | YES | N/A | N/A |

**Resolution rules:**
- If C1 ∧ C2 ∧ C3 ∧ C4 → [P]
- If ¬C1 ∧ C2 ∧ C3 ∧ C4 → [E]
- If ¬C1 ∧ ¬C2 ∧ C3 → [H] (adjacent/inferred)
- If ¬C1 ∧ ¬C2 ∧ ¬C3 → [S]
- If C2 ∧ ¬C3 (data exists but stale): check staleness action:
  - If ≤2× SLA → [H]
  - If >2× SLA → [S]

### 2.3 Source Verification Rules for Grade Assignment

A **verified source** means:
1. The URL resolves (HTTP 200 or 2xx/3xx) at time of fetch
2. The fetch was performed by an approved tool (Firecrawl, DataForSEO, Context7 MCP, or manual with timestamped screenshot)
3. The fetched content is stored and checksummed
4. The URL, fetch date, tool, and checksum are recorded in the source metadata

A **partial source** means:
- The source provides directional confirmation but not precise data (e.g., "pricing starts at EUR 200" on a comparison page vs. "EUR 199/mo" on the vendor's own page)
- Two partial sources that converge on the same value can triangulate to [E]

### 2.4 What Determines the Grade (NOT the Agent)

**Binding rule:** No agent may assign a grade by its own judgment. The grade is computed by the Grade Assignment Engine (GAE) which reads the source metadata and applies the matrix above.

If an agent writes "Claim: EUR 299/mo [E]" in a canvas, the GAE must verify:
- Is there a source data file claiming EUR 299?
- Does that file have a verified URL?
- Is the file within SLA?
- Does the source URL actually resolve to a page that states EUR 299?

If any check fails, the GAE **automatically corrects the grade** (or rejects the claim).

---

## 3. AUDIT TRAIL FORMAT

### 3.1 Standard Audit Trail Schema

Every claim in a canvas carries a `_audit` block that traces back to the source:

```yaml
# === CANVAS CLAIM ===
claim:
  id: C-042
  text: "Competitor X charges EUR 299/mo for its Pro plan"
  evidence_grade: P                      # assigned by GAE, not agent
  _audit:
    sources:
      - source_file: "research/niche-003/competitors/compA-pricing.yaml"
        url: "https://competitor.com/pricing"
        fetch_date: 2026-07-22
        tool: "firecrawl-scrape"
        checksum: "sha256:a1b2c3d4e5f6..."
        freshness: 1 day
        sla: 90 days
        status: PASS
        verified: true
      - source_file: "research/niche-003/competitors/compA-g2.yaml"
        url: "https://www.g2.com/products/competitor-a/reviews"
        fetch_date: 2026-07-22
        tool: "firecrawl-scrape"
        checksum: "sha256:6f5e4d3c2b1a..."
        freshness: 1 day
        sla: 180 days
        status: PASS
        verified: true
    grade_computation:
      criteria: { C1: true, C2: true, C3: true, C4: true }
      resolution: "C1 ∧ C2 ∧ C3 ∧ C4 → [P]"
      computed_at: 2026-07-23T10:00:00Z
      computed_by: "GAE-v1"
```

### 3.2 Inline Format (for Canvases without YAML)

For prose canvases or markdown documents, the format is:

```
[Claim: "Competitor X charges EUR 299/mo for its Pro plan"]
  [P] → Source: research/niche-003/competitors/compA-pricing.yaml
       → URL: https://competitor.com/pricing (fetched 2026-07-22, Firecrawl)
       → Freshness: 1 day / SLA 90 days → PASS
       → Checksum: sha256:a1b2c3d4e5f6... → MATCHES original
  [P] → Source: research/niche-003/competitors/compA-g2.yaml
       → URL: https://www.g2.com/products/competitor-a/reviews (fetched 2026-07-22, Firecrawl)
       → Freshness: 1 day / SLA 180 days → PASS
       → Grade: C1+C2+C3+C4 → [P]
```

### 3.3 Traceability Chain Diagram

```
Canvas Claim
  ↑ (references)
Source Data File (YAML/JSON with _freshness metadata)
  ↑ (references)
Original URL + Fetch Date + Tool
  ↑ (verifies)
HTTP 200 + Checksum + Content Match
```

**Integrity invariant:** Every link in the chain can be independently verified. An auditor can:
1. Take the claim from the canvas
2. Open the source data file
3. Re-fetch the original URL
4. Compare checksums to confirm the content hasn't drifted
5. Confirm the freshness status

### 3.4 Orphan Claim Detection

Any claim in a canvas that lacks a `_audit` block (or fails to resolve to a source data file) is flagged as **ORPHAN** and automatically assigned [S] grade. Orphan claims with [P] or [E] labels are **rejected** by the GAE.

---

## 4. VALIDATION CHECKS

### 4.1 Corpus Validation (e.g., "20-Review Corpus")

When a deliverable claims "20 reviews analyzed," the validation procedure is:

| # | Check | Method | Pass/Fail |
|---|-------|--------|-----------|
| VC-01 | Count entries | `len(reviews_in_json)` must equal 20 | If <20 → FAIL |
| VC-02 | Unique source URLs | Every review must have a `source_url` field with a non-empty string | If any missing → FAIL |
| VC-03 | URL accessibility | Re-fetch each `source_url`: must return HTTP 2xx | If >2 dead URLs → FAIL; 1-2 dead → FLAG |
| VC-04 | Content match | For each review, verify the fetched page contains the review text | If >2 mismatches → FAIL; 1-2 mismatch → FLAG |
| VC-05 | Date recency | Each review's `review_date` (or fetch_date) must be within REVIEW SLA (180 days) | If >3 stale → FAIL |
| VC-06 | Human verification | Spot-check 10% (2/20) manually: is the review real, from a real person, on the claimed platform? | If any fake → FAIL |
| VC-07 | Deduplication | Are any two reviews identical? (hash comparison) | If any duplicate → FAIL |

**Verdict logic:**
- All 7 pass → CORPUS_VERIFIED
- 0-2 VC failures (non-blocking) → CORPUS_ACCEPTED_WITH_FLAGS
- 3+ VC failures OR VC-06 or VC-07 fail → CORPUS_REJECTED

### 4.2 General Validation Checks (All Data Types)

| Check | Applies To | Method |
|-------|-----------|--------|
| **Schema conformance** | All data files | File must match its schema YAML/JSON. Validated by `validate-schema.js` |
| **Freshness metadata presence** | All data files | `_freshness.fetched_at` must exist and be parseable ISO 8601 |
| **Source URL format** | All fetched data | URL must start with `https://` and resolve to a known domain |
| **Checksum integrity** | All fetched data | `sha256(content) == stored checksum` — confirms file not corrupted |
| **Cross-source consistency** | Claims with [P] grade | Two sources must agree within 10% of the claimed value. If they diverge >10%, investigate. |
| **Language match** | All Dutch-market data | Content language should match expected locale (NL for NL-market data) |

### 4.3 Automated Validation Runbook

Executed by `validate-data-ops.js` (or equivalent):

```bash
# Validate all data files in a niche directory
validate-data-ops \
  --dir research/niche-003/ \
  --check schema,freshness,urls,checksums \
  --output validation-report-niche-003.json

# Validate a specific corpus file
validate-data-ops \
  --file research/niche-003/reviews/review-corpus.json \
  --check corpus-count=20 \
  --spot-check 10% \
  --output corpus-validation-report.json
```

---

## 5. STALENESS AUDIT PROCEDURE

### 5.1 Pre-Finalization Staleness Audit

**Trigger:** Before any canvas is marked COMPLETE (i.e., before it leaves the authoring stage and enters delivery/use).

**Procedure:**

```
PHASE 1: COLLECT
  - Resolve all _audit.source_file references in the canvas
  - Build a list of all unique source data files
  - Record: file path, freshness_class, fetched_at, current age

PHASE 2: EVALUATE
  - For each source file:
    - If FRESH (age <= SLA): PASS
    - If STALE (SLA < age <= 2*SLA): FLAG
    - If EXPIRED (age > 2*SLA): FAIL
  - Compute: stale_ratio = flagged_count / total_sources

PHASE 3: DECIDE
  - If stale_ratio == 0: CANVAS_PASSES
  - If stale_ratio <= 0.10 (<=10%): CANVAS_PASSES_WITH_WARNING
    - Canvas is marked COMPLETE but audit log records staleness warning
  - If stale_ratio > 0.10 (>10%): CANVAS_BLOCKED
    - Canvas cannot be marked complete
    - Stale sources listed in the block report
    - Re-fetch triggered for each stale source (with correct staleness_action)
```

### 5.2 Staleness Report Format

```yaml
staleness_audit:
  canvas_id: "niche-003-canvas-v1"
  audited_at: 2026-07-23T10:00:00Z
  total_sources: 24
  fresh: 20
  flagged: 3
  failed: 1
  stale_ratio: 0.167  # 16.7% > 10% → BLOCKED
  blocked: true
  blocked_reason: "stale_ratio 0.167 exceeds threshold 0.10"
  flagged_sources:
    - file: "research/niche-003/competitors/compB-pricing.yaml"
      freshness_class: PRICING
      age: 95 days
      sla: 90 days
      action: RE_FETCH
    - file: "research/niche-003/intent/signals.yaml"
      freshness_class: INTENT
      age: 18 days
      sla: 14 days
      action: BLOCK  # >2x handled as BLOCK per 2x rule
    - file: "research/niche-003/registry/company-data.yaml"
      freshness_class: REGISTRY
      age: 112 days
      sla: 90 days
      action: RE_FETCH
  failed_sources:
    - file: "research/niche-003/jobs/open-roles.yaml"
      freshness_class: JOB
      age: 21 days
      sla: 7 days
      action: BLOCK
```

### 5.3 Alerting

When a staleness audit blocks a canvas, an alert MUST be sent:

- **Channel:** Session log (with owner flag `[FRESHNESS-AUDIT]`)
- **Format:**
  ```
  [FRESHNESS-AUDIT] BLOCKED: niche-003-canvas-v1
  Reason: 4/24 sources stale (16.7%)
  Blocked by: LENS-6 / Quality & Freshness Controller
  Blocked sources:
    - compB-pricing.yaml (95d/90d) → RE_FETCH
    - signals.yaml (18d/14d) → BLOCK
    - company-data.yaml (112d/90d) → RE_FETCH
    - open-roles.yaml (21d/7d) → BLOCK
  Action required: Re-fetch blocked sources before marking canvas complete.
  ```

### 5.4 Pre-Flight Check (before beginning a canvas)

Before the first agent writes a claim, run a **pre-flight freshness check**:
- Check every source data file the canvas expects to reference
- If any are STALE or EXPIRED, trigger re-fetch BEFORE authoring begins
- Canvas authoring may not start until all required sources are FRESH

This prevents the workflow of "write with stale data, audit, block, re-fetch, rewrite."

---

## 6. ADVERSARIAL VERDICT

### 6.1 Would Lens 6 sign off on this system?

**Short answer: CONDITIONAL PASS — 7 gaps must close before production sign-off.**

The design is sound at the architectural level:
- Freshness SLA table is complete with defined actions per data type
- Evidence grade mapping is deterministic and removes agent judgment
- Audit trail format provides end-to-end traceability
- Validation checks are specific and automated
- Staleness audit has clear thresholds and blocking criteria

**However, an adversarial read finds the following gaps:**

### 6.2 Gap 1: No cryptographic binding between source fetch and claim

**What it says:** The audit trail records checksums but nothing prevents a post-hoc edit. If a source data file is modified after its `fetched_at`, the stored checksum can be recomputed against the new content, and there is no mechanism to detect this.

**Severity:** MAJOR

**Fix:** Store the source file's checksum in an **immutable append-only audit log** (a simple JSON Lines file: `_audit/log.jsonl`), NOT in the file itself. When a file is fetched, write `{file, checksum, fetched_at}` to the log. When validating, recompute and compare against the log entry, not the file header. A mismatch proves post-fetch tampering.

### 6.3 Gap 2: The 10% staleness threshold is arbitrary

**What it says:** Why 10%? A canvas with 2 stale out of 20 sources is 10%. A canvas with 2 stale out of 25 is 8%. The same data quality concern passes or fails depending on the total number of sources. Worse: a canvas with 1 stale SOURCE but that source provides 40% of the claims would pass the 10% test while being 40% stale by claim weight.

**Severity:** MEDIUM

**Fix:** Add a **claim-weighted staleness ratio**: `stale_claims / total_claims`. A canvas blocks if EITHER:
- Source-level staleness > 10%, OR
- Claim-weighted staleness > 10%

Both thresholds are configurable per canvas type.

### 6.4 Gap 3: No "verified stale" detection for linked pages that changed since fetch

**What it says:** The current design checks `now - fetched_at < SLA`. But a page can change 5 minutes after being fetched — the "freshness" passes because the file is 1 day old, yet the content is already wrong. The Gapstars v5 audit found exactly this: Eye Security's vacancy count was 10 at fetch time (stored correctly), but 28 on the live page — and our freshness check passed because the file was 1 hour old.

**Severity:** HIGH (this was an active bug in the Gapstars demo — see G-015/L-027 family)

**Fix:** Add **retroactive freshness verification** for claim-critical data:
1. Before canvas finalization, re-fetch ALL source URLs for [P] and [E] graded claims
2. Recompute the checksum of the fetched content
3. If the checksum changed: flag the claim as CONTENT_CHANGED
4. For numeric claims (pricing, counts), re-extract the value and compare
5. If the value changed, the claim must be updated or downgraded to [H]

This is expensive (2x fetches) but necessary for any deliverable going to a client. For internal canvases, the standard SLA check suffices.

### 6.5 Gap 4: Source independence is self-attested

**What it says:** The [P] grade requires "≥2 independent sources." But "independent" is not mechanically verified. Two URLs from the same affiliate program or the same press release both count as "independent" under the current definitions. The G2 review and the vendor's own pricing page are genuinely independent. Two blogs quoting the vendor's press release are not.

**Severity:** MEDIUM

**Fix:** Add a `source_independence` field to the audit trail:
```yaml
source_independence:
  - domain1: "competitor.com"
  - domain2: "g2.com"
  verdict: INDEPENDENT  # INDEPENDENT | SAME_ORIGIN | SAME_NEWS_CYCLE | UNKNOWN
  verified_by: "manual check of domain ownership + content comparison"
```
For automated checks: compare domain registrant data; if both sources publish under the same parent company or affiliate network, flag for manual review.

### 6.6 Gap 5: No mechanism for source URL death detection between fetches

**What it says:** A source URL can die (404) between the SLA check and the canvas delivery. The current design detects this only at fetch time or at the pre-finalization audit. If a canvas is used repeatedly (e.g., a weekly report), a URL that dies mid-week renders claims unverifiable.

**Severity:** LOW (for one-shot canvases) / MEDIUM (for recurring canvases)

**Fix:** For recurring canvases, implement a **pre-delivery URL health check**:
1. Re-fetch every source URL for [P] and [E] claims
2. If any URL returns 4xx/5xx: flag the claim as SOURCE_DEGRADED, downgrade one grade
3. If >20% of URLs are dead: BLOCK delivery

### 6.7 Gap 6: No checksum for the claim-to-source mapping itself

**What it says:** The audit trail format records which source files a claim uses. But nothing prevents a bad actor (or a buggy agent) from silently rewiring a claim to a different source file while keeping the same `claim_id`. The claim text still references "EUR 299," but the source file now points to a different competitor.

**Severity:** MEDIUM

**Fix:** When a canvas is finalized, compute a **binding hash** of the entire claim-to-source mapping:
```
binding_hash = sha256(
    sorted(claim_id + "→" + source_file + "→" + url for each claim)
)
```
Store this hash alongside the canvas. Before any subsequent use, recompute and compare. If the hash changed, the mapping was altered.

### 6.8 Gap 7: No staleness rollback procedure

**What it says:** When a canvas is BLOCKED due to staleness, the procedure says "re-fetch and retry." But what happens to the partially-completed canvas? If 3 of 24 sources are stale and the other 21 are fine, do we throw away the 21 and restart? Do we patch in-place?

**Severity:** LOW

**Fix:** Implement a **partial staleness recovery** workflow:
1. Re-fetch only the stale sources
2. Update only the affected claims in the canvas (claims that directly depend on those sources)
3. Re-verify the affected claims' evidence grades
4. Re-run the staleness audit
5. If the audit passes with the updated+re-verified claims, mark the canvas complete

This avoids throwing away 21 good sources because 3 went stale.

### 6.9 Overall Verdict

| Criterion | Verdict | Notes |
|-----------|---------|-------|
| Design completeness | PASS | All 6 deliverables specified with implementable detail |
| Deterministic grading | PASS | Grade matrix removes agent judgment; GAE enforces |
| Audit trail coverage | PASS | End-to-end traceability chain specified |
| Gap severity | CONDITIONAL | 7 gaps found; 1 HIGH, 2 MEDIUM, 1 MAJOR, 3 LOW |
| Production readiness | CONDITIONAL | Acceptable as DESIGN but must fix Gaps 1, 3, 4, 6 before production |

**Sign-off condition:** Gap 3 (retroactive freshness for [P]/[E] claims) and Gap 6 (binding hash for claim-to-source mapping) must be resolved before any canvas is delivered to a client. Gap 1 (immutable audit log) should be resolved before the pipeline processes its first data file. Gaps 2, 5, 7 can be resolved during implementation.

If all 7 gaps are addressed: **FULL PASS**.
If only Gaps 1, 3, 6 are addressed: **CONDITIONAL PASS** (acceptable for internal canvases; not for client deliveries).
If no gaps addressed: **REJECT** — the system currently cannot prove a claim's source integrity at the standard the lens requires.

---

## APPENDIX A: Source Verification Standard (Complete)

Every fetched URL MUST record:

```yaml
source_verification:
  url: "https://competitor.com/pricing"
  fetch_date: 2026-07-22T14:30:00Z
  http_status: 200
  tool: "firecrawl-scrape"
  tool_version: "v1.2.3"
  checksum: "sha256:a1b2c3d4e5f67890abcdef1234567890abcdef1234567890abcdef1234567890"
  checksum_algorithm: "sha256"
  fetch_duration_ms: 2340
  redirect_chain:
    - url: "https://competitor.com/pricing"
      status: 301
    - url: "https://www.competitor.com/pricing"
      status: 200
  content_type: "text/html; charset=utf-8"
  content_length: 45230
  notes: "Redirect from non-www to www. Final page rendered includes JS-loaded pricing table."
```

## APPENDIX B: Tool-Specific Freshness Metadata Additions

| Tool | Additional Metadata |
|------|-------------------|
| Firecrawl scrape | `firecrawl_credits_used`, `firecrawl_mode` (scrape/crawl/search) |
| DataForSEO | `dataforseo_task_id`, `dataforseo_api_endpoint`, `dataforseo_credits_used` |
| Context7 MCP | `context7_query`, `context7_source_count` |
| Manual fetch | `fetched_by` (person name), `method` (browser screenshot / curl / extension), `screenshot_path` |

## APPENDIX C: Default `_freshness` Block (Copy-Paste Template)

```yaml
# Copy this block into every new data file
_freshness:
  fetched_at: null              # ISO 8601 — SET ON CREATION
  fresh_until: null             # auto-computed
  freshness_class: UNASSIGNED   # from table 1.1
  freshness_status: FRESH       # FRESH | STALE | EXPIRED
  staleness_action: RE_FETCH    # from table 1.1
  refetch_count: 0
  refetch_history:
    - fetched_at: null
      trigger: INITIAL
  source_verification:
    url: null
    http_status: null
    tool: null
    checksum: null
    checksum_algorithm: "sha256"
```

## APPENDIX D: Grade Assignment Engine (GAE) Interface Specification

```python
# Pseudocode for the Grade Assignment Engine

class GradeAssignmentEngine:
    def assign_grade(self, claim: Claim, sources: List[SourceFile]) -> GradeResult:
        c1 = len(sources) >= 2
        c3 = all(s.freshness_status == "FRESH" for s in sources)
        c2 = all(s.source_verification.http_status == 200 for s in sources)
        c4 = all(s.source_verification.url is not None for s in sources)
        
        # Independence check (Gap 4 mitigation)
        domains = set(s.source_verification.url_domain for s in sources)
        independent = len(domains) >= 2 and not self._same_owner(domains)
        
        if c1 and c2 and c3 and c4 and independent:
            return GradeResult.GRADE_P
        elif c2 and c3 and c4:
            return GradeResult.GRADE_E
        elif c2 and not c3:
            # Stale data
            max_age = max(s.age_days for s in sources)
            if max_age <= sla_lookup(s.freshness_class) * 2:
                return GradeResult.GRADE_H
            else:
                return GradeResult.GRADE_S
        else:
            return GradeResult.GRADE_S
```
