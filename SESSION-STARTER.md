# SESSION STARTER: Phase 0 Calibration — 25-Niche Research Program

## AT A GLANCE

**What:** Take the 25-niche evaluation pipeline from *designed* to *operational* — verify every tool, measure actual costs, establish inter-rater reliability, confirm the pipeline runs end-to-end before evaluating any real niche.

**When:** Tools verify in ~45 min. Dual-niche + 4-agent run in ~3-4h. Worst case (re-run needed): spills to second session.

**Verdict after this session:** Either "Pipeline is calibrated, scripts are operational, first 5 niches can execute with measured cost bounds" or "Pipeline is blocked at [specific gate] with documented fix plan."

---

## 1. EXECUTIVE SUMMARY (60 seconds)

**Why Phase 0 exists.** The program has 148 tests passing, 6 operational scripts, 10 tracking files, 6 YAML schemas — and has **never executed**. Every credit estimate (~132/niche), DataForSEO cost ($0.04/niche), and wall-clock projection (20-25 min) is theoretical. Phase 0 replaces estimates with measured data. Without it, the first real niche wastes credits discovering what calibration should have caught.

**What gets delivered.**
- Two calibration niches evaluated by 4 independent agents (A1+A2 on CAL-A, B1+B2 on CAL-B)
- Inter-rater reliability: Cohen's Kappa >= 0.61, ICC >= 0.75 for both niches
- Measured credit consumption per niche (replacing the ~132-credit estimate)
- All 5 operational scripts built, tested, executable (preflight-check, freshness-audit, validate-schema, clean-raw-fetches, generate-quality-dashboard)
- Phase 0 completion gate: 12 items verified green
- Score normalization offsets computed for all 4 agents
- Budget projections updated with actuals

**The two calibration niches.**
- **CAL-A** (data-rich): Mid-Market IT Staffing Agencies on Bullhorn — abundant G2/Capterra reviews, public pricing, existing Gapstars research as cross-reference
- **CAL-B** (data-sparse): B2B Fractional Executive Services for Mid-Market — opaque pricing, thin review corpus, tests agent inference from analogous markets

**Risk cap.** Phase 0 budget: 200 Firecrawl credits max + $0.50 DataForSEO max. If calibration burns more or reveals a tool is broken, halt, document, re-plan. Do NOT proceed to niche 1.

---

## 2. PRE-FLIGHT CHECKLIST (check before executing)

```
PREREQUISITES (all must pass before starting Phase 0)
[ ] FIRECRAWL_API_KEY environment variable resolves to non-empty
[ ] DATAFORSEO_LOGIN environment variable resolves to non-empty
[ ] DATAFORSEO_PASSWORD environment variable resolves to non-empty
[ ] Python 3.10+ available (python3 --version)
[ ] ruamel.yaml installed (pip3 install ruamel.yaml)
[ ] bash 4.0+ available
[ ] Git working tree clean (git status shows no uncommitted changes)
[ ] GitHub access verified (gh auth status)
[ ] All 6 YAML schemas in schemas/ are parseable (see command below)
[ ] All 5 operational scripts in research/_pipelines/ pass bash -n
[ ] 6 parallel Claude Code sessions spawnable (or sequential fallback)
[ ] CALIBRATION-PROTOCOL.md read and understood

SOURCE DOCUMENTS (read the ones marked R before this session)
[ ] R  NICHE-METHODOLOGY.md — the 15-section canvas specification
[ ] R  DATA-OPERATIONS-ARCHITECTURE.md — toolchain, schemas, directory structure
[ ] R  CALIBRATION-PROTOCOL.md — inter-rater reliability, normalization math, ground truth
[ ]    AGENT-CONTEXT-SPEC.md — token budgets, context loading spec
[ ]    RUNBOOK.md — incident response, recovery procedures
[ ] R  PHASE-0-CALIBRATION.md (research/_pipelines/) — stage-by-stage execution commands
[ ] R  references/firecrawl-comprehensive-reference.md — every Firecrawl command, costs, patterns (32 sections)
[ ] R  references/data-sources-reference.md — every other tool (DataForSEO, MCPs, free APIs, use-case matrix)

TRACKING FILES (verify these exist and parse)
[ ] research/_program/LEDGER.yaml — niche ledger
[ ] research/_program/CREDIT_BUDGET.yaml — budget tracking
[ ] research/_program/PIPELINE_CHECKPOINTS.yaml — checkpoint log
[ ] research/_program/CREDENTIALS.yaml — env-var references (gitignored)
[ ] research/_program/TOOL_ERROR_LOG.yaml — tool error registry
[ ] research/_program/FRESHNESS_VIOLATION_LOG.yaml — freshness breach log
[ ] research/_program/QUALITY_METRICS.yaml — quality SLI tracking
[ ] research/_program/SLI_DEFINITIONS.yaml — SLI definitions
[ ] research/_program/DEAD_HOST_REGISTRY.yaml — dead host tracking
[ ] research/_program/TIMEOUT_CONFIG.yaml — timeout configuration
```

**Quick schema check command:**
```bash
niche_root="/home/weshen83/GTM WORK&PROJECTS/ClarityRevs/niche-program"
for f in "$niche_root/schemas/"*.yaml; do
  python3 -c "from ruamel.yaml import YAML; yaml=YAML(); yaml.load(open('$f')); print(f'OK: $(basename $f)')" 2>&1
done
```

**Quick script check command:**
```bash
for f in "$niche_root/research/_pipelines/preflight-check" \
         "$niche_root/research/_pipelines/freshness-audit" \
         "$niche_root/research/_pipelines/validate-schema" \
         "$niche_root/research/_pipelines/clean-raw-fetches" \
         "$niche_root/research/_pipelines/generate-quality-dashboard" \
         "$niche_root/research/_pipelines/grade-engine"; do
  if [ -x "$f" ]; then echo "EXECUTABLE: $(basename $f)"; else echo "MISSING/NOT EXEC: $(basename $f)"; fi
done
```

---

## 3. PHASED CALIBRATION PROTOCOL WITH TIMEBOXES

### Phase A: Infrastructure & Environment (15 min)

Set the project root, verify Python dependencies, load all 10 tracking files, ensure the directory tree is complete.

```bash
export NICHE_PROGRAM_ROOT="/home/weshen83/GTM WORK&PROJECTS/ClarityRevs/niche-program"
export NICHE_SCRIPT_DIR="$NICHE_PROGRAM_ROOT/research/_pipelines"
cd "$NICHE_PROGRAM_ROOT"

# Verify shared library loads
python3 -c "from lib.pipeline_ops import yaml, load_yaml_safe, write_yaml_atomic, ExitCode; print('pipeline_ops OK')"

# Verify env vars resolve
echo "FIRECRAWL_API_KEY=${FIRECRAWL_API_KEY:0:8}..."
echo "DATAFORSEO_LOGIN=${DATAFORSEO_LOGIN:+SET}"
echo "DATAFORSEO_PASSWORD=${DATAFORSEO_PASSWORD:+SET}"
```

**Gate A:** All env vars resolve, shared library loads, `$NICHE_PROGRAM_ROOT` points to `niche-program/`.

---

### Phase B: Firecrawl Calibration (25 min, ~30 credits)

8 tests covering every Firecrawl capability the pipeline uses.

```bash
# B.1 Credit balance
firecrawl credit-usage
# Expected: balance >= 9,800 (we budget 200 for calibration)

# B.2 Search (primary data source for Phase 1)
firecrawl search "revenue intelligence software 2026" --limit 5
# Expected: 5 results with relevance excerpts

# B.3 JS scrape (competitor reviews, about pages)
firecrawl scrape "https://www.g2.com/products/gong-io/reviews" --wait-for 3000
# Expected: rendered review content. If G2 blocks, document and use Capterra/Reddit fallbacks.

# B.4 Pricing page scrape (competitor pricing intelligence)
firecrawl scrape "https://www.gong.io/pricing/" --wait-for 3000
# Expected: pricing tiers or login-wall detection. If login-walled, document.

# B.5 Crawl (bulk content extraction)
firecrawl crawl "https://docs.dataforseo.com" --include-paths "/v3/" --max-depth 2 --limit 10
# Expected: 10 pages returned

# B.6 Map (URL discovery before crawl)
firecrawl map "https://www.gong.io" --search "pricing"
# Expected: pricing-related URLs. If /map blocked, fall back to /search.

# B.7 Concurrent load test (3 parallel scrapes)
firecrawl scrape "https://www.gong.io/about/" --wait-for 1000 &
firecrawl scrape "https://www.gong.io/product/" --wait-for 1000 &
firecrawl scrape "https://www.gong.io/customers/" --wait-for 1000 &
wait
# Expected: all 3 complete within 90s

# B.8 Search feedback (credit refund test)
firecrawl search "niche research methodology" --limit 3 --submit-feedback
# Expected: first feedback refunds ~1 credit. Verify balance increased.
```

**Record credits used:**
```bash
firecrawl credit-usage
# Note pre and post balance. Calculate: credits_burned = pre_balance - post_balance
```

**Gate B:** B.1 (balance), B.2 (search), B.3 (JS scrape) MUST pass. B.4-B.8 are WARNINGS if they fail — document and proceed. If B.2 or B.3 fail: HALT — account or API issue.

**Cost table (update with actuals):**
| Test | Credits Budgeted | Credits Actual | Delta |
|------|-----------------|----------------|-------|
| B.1 balance check | 0 | | |
| B.2 search (5 results) | 2 | | |
| B.3 JS scrape | 1-2 | | |
| B.4 pricing scrape | 1-2 | | |
| B.5 crawl (10 pages) | 10 | | |
| B.6 map | 1 | | |
| B.7 concurrent (3x) | 6 | | |
| B.8 search + feedback | 2 (1 refunded) | | |
| **Total** | **~24 net** | | |

---

### Phase C: DataForSEO Calibration (10 min, ~$0.01)

```bash
# C.1 SERP check (highest-value function)
curl -s --user "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" \
  -H "Content-Type: application/json" \
  -d '[]' \
  "https://api.dataforseo.com/v3/serp/google/organic/live/advanced" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Status: {d.get(\"status_code\")}, Tasks: {len(d.get(\"tasks\",[]))}')"

# C.2 Keyword volume (market sizing, VOC quantification)
curl -s --user "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" \
  -H "Content-Type: application/json" \
  -d '[]' \
  "https://api.dataforseo.com/v3/keywords/google/search_volume/live" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Status: {d.get(\"status_code\")}')"

# C.3 Labs: competitor domain analysis
curl -s --user "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" \
  -H "Content-Type: application/json" \
  -d '[]' \
  "https://api.dataforseo.com/v3/dataforseo_labs/google/competitors_domain/live" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Status: {d.get(\"status_code\")}')"

# C.4 Domain technographics
curl -s --user "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" \
  -H "Content-Type: application/json" \
  -d '[]' \
  "https://api.dataforseo.com/v3/domain_analytics/technologies/live" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Status: {d.get(\"status_code\")}')"

# C.5 OnPage content parsing (free endpoint)
curl -s "https://api.dataforseo.com/v3/onpage/content_parsing/live" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Status: {d.get(\"status_code\")}')"

# C.6 Check remaining DataForSEO balance
# Visit https://app.dataforseo.com/dashboard or use the billing API endpoint
```

**Gate C:** C.1 (SERP) and C.2 (keyword volume) MUST pass. C.3-C.5 are RECOMMENDED — if they fail, mark as SOURCE_UNAVAILABLE and document. If C.1 or C.2 fail: HALT — account issue.

**Cost table (update with actuals):**
| Test | Cost Budgeted | Cost Actual | Delta |
|------|--------------|-------------|-------|
| C.1 SERP | ~$0.0006 | | |
| C.2 Keywords | ~$0.006 | | |
| C.3 Labs | ~$0.012 | | |
| C.4 Domain tech | ~$0.012 | | |
| C.5 OnPage (free) | $0 | | |
| **Total** | **~$0.03** | | |

---

### Phase D: Free Tool / MCP Verification (15 min, 0 credits)

Test at least 5 fallback tools. The pipeline requires >= 3 to pass.

```bash
# D.1 Reddit Research MCP — query for Buyer VOC signal
# (Invoke via Claude Code MCP or use firecrawl search as fallback)
firecrawl search "site:reddit.com RevOps challenges mid-market 2026" --limit 5
# Expected: >= 3 relevant posts

# D.2 OpenRegistry MCP — Dutch KVK company lookup
# (Invoke via Claude Code MCP)
# Expected: structured company registration data

# D.3 GDELT Project — recent business events
# Query: https://api.gdeltproject.org/api/v2/doc/doc?query=acquisition&mode=ArtList&maxrecords=5
# Expected: >= 5 recent articles

# D.4 EUROSTAT API — NACE sector employment data
# Query: https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/nama_10_a10?format=JSON
# Expected: structured employment data

# D.5 Context7 MCP — API documentation lookup
# (Invoke via Claude Code MCP with query "HubSpot CRM API deals")
# Expected: capability documentation

# D.6 HubSpot API — OAuth connection test
# (If HubSpot credentials configured)
# Expected: contact/deal data or auth error
```

**Gate D:** >= 3 tools MUST pass. If Reddit MCP fails AND Firecrawl public Reddit (D.1) also fails: document as a buyer-language gap for niches where Reddit is a primary VOC source.

---

### Phase E: Ground-Truth Reference Canvas — Wesley Produces 5 Sections for CAL-A (60-90 min)

Wesley produces ground-truth reference for 5 sections of CAL-A (Mid-Market IT Staffing Agencies on Bullhorn):

| Section | Content | Evidence Standard |
|---------|---------|-------------------|
| SS1 — Niche Identity | Definition, boundaries, adjacent niches, scope exclusions | All claims [E] (evidence exists) or [P] (plausible with trace) |
| SS2 — Buyer Persona | Job titles, decision criteria, buying process, triggers | [E] for titles + triggers, [P] for internal process claims |
| SS4 — Competitive Landscape | Direct competitors, indirect substitutes, positioning map | [E] for all competitor URLs and claims |
| SS10 — Pricing Model | Price bands, packaging, willingness-to-pay signals | [E] for published pricing, [P] for inferred bands |
| SS14 — RIOS Score | Complete RIOS scoring with claim-by-claim evidence trace | Per RIOS formula in NICHE-METHODOLOGY.md §6 |

**Blinding rule:** Agents are told a ground truth exists but do NOT know which 5 sections are ground-truthed. This prevents anchoring.

**Self-test:** 48h after producing it, Wesley re-scores CAL-A blind. If his RIOS differs by >0.3, ground truth is revised before agents run.

**Output location:** `research/CALIBRATION/_GROUND-TRUTH/CAL-A-ground-truth.yaml`

---

### Phase F: Dual-Niche Evaluation — 4 Agents (60-90 min wall-clock)

**Agent allocation:**

```
                CAL-A (data-rich)         CAL-B (data-sparse)
Agent pool 1    Agent A1                  (not used)
Agent pool 2    Agent A2                  (not used)
Agent pool 3    (not used)                Agent B1
Agent pool 4    (not used)                Agent B2
```

**Rules:**
- Agents A1 and A2 share NO context with B1 or B2 (non-overlapping pools)
- A1 and A2 work simultaneously with no communication
- B1 and B2 work simultaneously with no communication
- All 4 agents use the identical methodology version (NICHE-METHODOLOGY.md)
- Each produces a complete 15-section canvas with YAML frontmatter and evidence trace-map

**Directory structure:**
```
research/CALIBRATION/
├── N-CAL-AGENT-A1/          ← CAL-A canvas by Agent A1
├── N-CAL-AGENT-A2/          ← CAL-A canvas by Agent A2
├── CAL-B-AGENT-B1/          ← CAL-B canvas by Agent B1
├── CAL-B-AGENT-B2/          ← CAL-B canvas by Agent B2
├── _GROUND-TRUTH/
│   └── CAL-A-ground-truth.yaml
├── _RECONCILIATION/
│   ├── CAL-A-reconciliation.yaml
│   ├── CAL-B-reconciliation.yaml
│   └── calibration-summary.yaml
└── _debrief/
    └── calibration-debrief.md
```

**Pipeline steps for each agent:**
1. Phase 1: Market existence validation (5 searches, prospect discovery, market sizing)
2. Phase 2: Competitive intelligence (competitor identification, feature comparison, pricing)
3. Phase 3: Buyer research (VOC collection, trigger events, decision criteria)
4. Phase 4: Signal detection feasibility (available data sources, tech stack reachability)
5. Phase 5: Commercial design (RIOS scoring, offer framework, workflow spec)
6. Phase 6: Canvas assembly (15 sections, evidence trace-map, quality gates)

---

### Phase G: Calibration Reconciliation (30 min)

```bash
niche_root="/home/weshen83/GTM WORK&PROJECTS/ClarityRevs/niche-program"
cal_dir="$niche_root/research/CALIBRATION"
rec_dir="$cal_dir/_RECONCILIATION"
mkdir -p "$rec_dir"
```

**Step G.1-G.3 — Compute inter-rater reliability for CAL-A:**

Use the grade engine to compare A1 vs A2 on evidence grades (computed via `research/_pipelines/grade-engine`):

```bash
python3 -c "
import sys; sys.path.insert(0, '$niche_root/research/_pipelines')
from lib.pipeline_ops import yaml

# Load both canvases (conceptual — exact path depends on agent output)
a1 = yaml.safe_load(open('$cal_dir/N-CAL-AGENT-A1/canvas.yaml'))
a2 = yaml.safe_load(open('$cal_dir/N-CAL-AGENT-A2/canvas.yaml'))

# Compare section-level scores
print('=== CAL-A Agent Comparison ===')
for section in ['ss1','ss2','ss3','ss4','ss5','ss6','ss7','ss8','ss9','ss10',
                'ss11','ss12','ss13','ss14','ss15']:
    s1 = a1.get('sections',{}).get(section,{})
    s2 = a2.get('sections',{}).get(section,{})
    if s1 and s2:
        print(f'{section}: A1={s1.get(\"score\")} A2={s2.get(\"score\")} delta={abs(s1.get(\"score\",0)-s2.get(\"score\",0))}')
"
```

**Thresholds:**
| Metric | Target | CAL-A Actual | CAL-B Actual | PASS/FAIL |
|--------|--------|-------------|-------------|-----------|
| Cohen's Kappa (evidence grades) | >= 0.61 | | | |
| ICC(2,1) — RIOS scores | >= 0.75 | | | |
| Ground-truth accuracy (CAL-A only) | >= 80% | | | N/A for CAL-B |
| Grade distribution delta | <= 10pp per grade | | | |
| Verdict match (go/no-go) | exact match | | | |
| Pain quantification | same order of magnitude | | | |
| RIOS composite delta | <= 0.8 agent-to-agent | | | |
| RIOS vs ground truth | <= 0.5 | | | N/A for CAL-B |
| Claim count variance | <= 30% relative | | | |

**Step G.4-G.5 — Same for CAL-B (A1/A2 -> B1/B2):**

Compare B1 and B2 canvases using the same scripts. No ground-truth comparison (CAL-B has no ground truth by design).

**Step G.6 — Measure actual credit consumption:**
```bash
pre_fc=$(cat /tmp/fc_pre_balance 2>/dev/null || echo "UNKNOWN")
post_fc=$(firecrawl credit-usage | grep -oP 'balance: \K\d+' || echo "UNKNOWN")
echo "Firecrawl: pre=$pre_fc post=$post_fc burned=$((pre_fc - post_fc))"
```

**Step G.7 — Identify methodology ambiguities:** Any section where agents diverged by >2 score points triggers a methodology review.

**Step G.8 — Update NICHE-METHODOLOGY.md:** If ambiguities found, amend the methodology and note the change in the document's version history.

**Gate G:** Kappa >= 0.61 AND ICC >= 0.75 for BOTH calibration niches. If either fails: HALT. Fix methodology ambiguity. Re-run calibration on fresh agents. Do NOT proceed to real niches.

---

### Phase H: Budget & Burn Rate Analysis (20 min)

```bash
niche_root="/home/weshen83/GTM WORK&PROJECTS/ClarityRevs/niche-program"
budget_file="$niche_root/research/_program/CREDIT_BUDGET.yaml"
```

**Update CREDIT_BUDGET.yaml with actuals:**

| Metric | Estimated | Actual | Delta | Impact on 25-Niche Projection |
|--------|-----------|--------|-------|-------------------------------|
| Firecrawl per DEEP niche | ~132 credits | ___ | ___ | ___ × 25 × 1.3 = ___ |
| DataForSEO per niche | ~$0.04 | ___ | ___ | ___ × 25 = ___ |
| Wall-clock per niche | ~20-25 min | ___ | ___ | ___ × 25 = ___ |

**Budget escalation trigger:** If calibration burns >300 Firecrawl credits OR >$1.00 DataForSEO: PAUSE for budget review before proceeding to pipeline (50% overrun flag).

---

## 4. VERIFICATION GATES — SUMMARY TABLE

```
PRIMARY TOOL GATES (ALL MUST PASS):
[x] Firecrawl: basic search returns results (B.2)
[x] Firecrawl: JS scrape renders content (B.3)
[x] Firecrawl: credit balance >= 9,800 (B.1)
[x] DataForSEO: SERP endpoint returns results (C.1)
[x] DataForSEO: keyword volume endpoint returns data (C.2)
[x] DataForSEO: balance >= $45 remaining (C.6)

INTER-RATER RELIABILITY GATES (ALL MUST PASS):
[x] CAL-A: Cohen's Kappa >= 0.61
[x] CAL-A: ICC(2,1) >= 0.75
[x] CAL-A: ground-truth accuracy >= 80%
[x] CAL-B: Cohen's Kappa >= 0.61
[x] CAL-B: ICC(2,1) >= 0.75
[x] CAL-B: verdict match (exact)

INFRASTRUCTURE GATES (ALL MUST PASS):
[x] All 10 _program/ tracking files exist and parse
[x] SHARED/ directory with _REGISTRY.yaml + 5 subdirectories
[x] All 6 operational scripts pass syntax + basic execution
[x] Credential pre-flight: all env vars resolve
[x] TOOL_VERSIONS.yaml created with current API versions

FALLBACK TOOL GATES (>= 3 MUST PASS):
[x] Reddit Research MCP or Firecrawl Reddit search
[x] OpenRegistry MCP
[x] GDELT Project
[x] EUROSTAT API
[x] Context7 MCP / HubSpot API
```

---

## 5. FOUNDER-FACING DELIVERABLES

### Moment 1: Gate Passed (Phase B complete, tools verified)

3-sentence Slack to Bob and Adriaan:
> "Calibration underway. All 13 tool tests passed. Firecrawl balance: X credits. DataForSEO: >$45. Ground-truth reference for CAL-A (Staffing on Bullhorn) in progress. Agents will run this afternoon. Expect a calibration debrief by end of day."

No meeting. No deck. This confirms the program is real and on track.

### Moment 2: Calibration Complete (all metrics pass, or fail decision made)

**Deliverable:** 1-page calibration debrief — written to `research/CALIBRATION/_debrief/calibration-debrief.md`

Template:

```markdown
# Calibration Debrief — 2026-07-XX

## Summary
Status: [PASS / CONDITIONAL / BLOCKED]
Tools: [all verified / exceptions noted]
Inter-rater reliability: [ALL PASS / X of 8 passed / FAIL]
Credit burn: XX Firecrawl credits, $X.XX DataForSEO (budget: 200 + $0.50)
Verdict: [PROCEED with pipeline / CONDITIONAL: proceed with caveats / BLOCKED: do not start]

## Tool Verification
| Tool | Status | Notes |
|------|--------|-------|
| Firecrawl search | PASS/FAIL | |
| Firecrawl scrape (JS) | PASS/FAIL | |
| Firecrawl crawl | PASS/FAIL | |
| Firecrawl map | PASS/FAIL | |
| DataForSEO SERP | PASS/FAIL | |
| DataForSEO Keywords | PASS/FAIL | |
| Fallback tools (>=3/5) | PASS/FAIL | Which ones: |
| Concurrent load (3 parallel) | PASS/FAIL | |

## Inter-Rater Reliability
| Metric | CAL-A | CAL-B | Target | Status |
|--------|-------|-------|--------|--------|
| Cohen's Kappa (evidence grades) | 0.XX | 0.XX | >=0.61 | PASS/FAIL |
| ICC (RIOS scores) | 0.XX | 0.XX | >=0.75 | PASS/FAIL |
| Ground-truth accuracy (5 sections) | XX% | N/A | >=80% | PASS/FAIL |
| Verdict match | YES/NO | YES/NO | MUST MATCH | PASS/FAIL |

## Credit Reality Check
| Metric | Estimated | Actual | Delta |
|--------|-----------|--------|-------|
| Firecrawl per DEEP niche | ~132 credits | XXX credits | +/-XX |
| DataForSEO per niche | ~$0.04 | $X.XX | +/-XX |
| Wall-clock per niche | ~20-25 min | XX min | +/-XX |
| 25-niche projection (credits) | ~4,300 | ~X,XXX | +/-X% |

## Score Normalization Factors
| Agent | CAL-A Offset | CAL-B Offset | Composite |
|-------|-------------|-------------|-----------|
| Agent A1 | +0.XX | N/A | +0.XX |
| Agent A2 | -0.XX | N/A | -0.XX |
| Agent B1 | N/A | +0.XX | +0.XX |
| Agent B2 | N/A | -0.XX | -0.XX |

## Go/No-Go Decision
**Decision:** [PROCEED / CONDITIONAL / BLOCKED]
```

**Distribution:** Commit the debrief to repo. Share the commit URL. No PDF. No deck. No meeting unless founders ask.

### What is NOT shared with founders

- Individual agent canvases (too much detail)
- Raw tool test logs
- Methodology amendments in progress
- Intermediate agent checkpoints

Founders see the synthesis, not the noise.

---

## 6. THE "GOOD ENOUGH" CALL

Wesley has authority to waive conditional gates, but must document the rationale.

**Hard gate (cannot be waived):** Firecrawl AND DataForSEO must both work. If either is broken, pipeline does not start.

| Condition | When to Waive | When NOT to Waive |
|-----------|---------------|-------------------|
| Kappa 0.55-0.60 (target: >=0.61) | CAL-B only + CAL-A passes at >=0.61. Data-sparse niches naturally have lower agreement. Flag as "monitor on first 5 niches." | CAL-A below 0.55. That's the data-rich niche — if agents disagree on abundant data, methodology is broken. |
| ICC 0.70-0.74 (target: >=0.75) | Both niches borderline in same direction — systematic, not random. Score normalization can compensate. | ICC < 0.60. Random disagreement means scores not comparable. |
| Ground-truth accuracy 75-79% (target: >=80%) | Errors concentrated in 1-2 sections. Fix those sections, document remaining uncertainty, proceed. | Errors spread across 4+ sections. Methodology not well-calibrated to Wesley's judgment. |
| Credit burn 1.5-2x estimate | Overrun from specific cause (e.g., rate limiting caused retries). Fix cause, document adjustment factor, proceed. | Overrun is structural (pipeline genuinely costs 250 credits at DEEP depth). Needs budget recalculation and founder-informed scope adjustment. |

**Mandatory ritual before calling calibration complete with any waived metric:**

Write `research/CALIBRATION/_RECONCILIATION/good-enough-rationale.md`:

```yaml
# Good-Enough Rationale — 2026-07-XX
waived_metrics:
  - metric: "<name>"
    actual_value: "<X>"
    target: "<Y>"
    rationale: "<Why this is acceptable. Specific enough that someone reading this 6 months from now understands the judgment call.>"
    monitoring_plan: "<What specific signal will trigger a retrofit if this decision ages poorly?>"
remaining_hard_gates:
  - firecrawl: PASS
  - dataforseo: PASS
calibration_verdict: PROCEED / CONDITIONAL / BLOCKED
```

**Kill switch:** If any waived metric triggers its monitoring plan within the first 5 pipeline niches, calibration is retroactively considered failed. Pipeline pauses. Methodology amended. Full re-calibration before resuming.

---

## 7. FAILURE MODES AND RESPONSES

| # | Failure | Response | Escalation |
|---|---------|----------|------------|
| 1 | Firecrawl API unavailable | HALT. Check status page, account balance, API key. Re-test after fix. | Inform founders |
| 2 | DataForSEO balance exhausted | HALT. Only $50 budgeted. Convert remaining niches to STANDARD-only if pipeline must continue. | Inform founders |
| 3 | Kappa < 0.61 | HALT calibration. Fix methodology sections where agents diverged. Re-run calibration on fresh agents. | Wesley decides |
| 4 | ICC < 0.75 | Same as #3 — continuous metrics too unstable. Investigate RIOS formula ambiguity. | Wesley decides |
| 5 | Scripts fail tests >5x | HALT implementation. Re-examine spec. Trust the 148-test suite. | Wesley decides |
| 6 | Credit burn exceeds 2x estimate | PAUSE. Compute remaining budget at measured burn rate. Decide: reduce depth or top up. | Inform founders |
| 7 | Calibration fails >3x on same metric | Methodology section is fundamentally ambiguous. Escalate to Wesley for structural rewrite. | Wesley must rewrite |
| 8 | Both niches produce contradictory rankings | HALT program. Methodology fundamentally cannot rank consistently. Redesign scoring. | Inform founders |
| 9 | Grade engine assigns [P] to fabricated sources | HALT. Evidence integrity architecture broken. Fix grade engine. Re-test with known fabricated inputs. | Wesley fixes |

---

## 8. AFTER CALIBRATION — NEXT STEPS

### Immediate (same session, if calibration passes)

1. **Update CREDIT_BUDGET.yaml** — replace all `# ESTIMATE` annotations with measured calibration data
2. **Update DATA-OPERATIONS-ARCHITECTURE.md** §§4.1-4.4 — measured per-phase cost data replaces estimates
3. **Update NICHE-METHODOLOGY.md** — clear any ambiguity identified by inter-rater divergence
4. **Update AGENT-CONTEXT-SPEC.md** token budgets — verified against actual Phase 2/3/4 loading
5. **Update PIPELINE_CHECKPOINTS.yaml** — add calibration checkpoint as reference baseline
6. **Update TOOL_VERSIONS.yaml** — capture actual API versions from calibration
7. **Write PROJECT-STATE.md** entry — Phase 0 outcomes, any W or C triggers that fired, adjusted budget projection

### Commit to GitHub

```bash
cd "/home/weshen83/GTM WORK&PROJECTS/ClarityRevs"
git add niche-program/research/CALIBRATION/
git add niche-program/research/_program/CREDIT_BUDGET.yaml
git add niche-program/research/_program/LEDGER.yaml
git add niche-program/research/_program/PIPELINE_CHECKPOINTS.yaml
git add niche-program/research/_program/TOOL_VERSIONS.yaml
git add niche-program/DATA-OPERATIONS-ARCHITECTURE.md
git add niche-program/NICHE-METHODOLOGY.md
git commit -m "feat(calibration): Phase 0 complete — CAL-A + CAL-B evaluated

- Tools verified: [all PASS / noted failures waived]
- CAL-A inter-rater: K=0.XX, ICC=0.XX, ground-truth=XX%
- CAL-B inter-rater: K=0.XX, ICC=0.XX
- Credit burn: XX credits (budget: 200), DataForSEO: \$X.XX (budget: \$0.50)
- Methodology amendments: [none / brief summary]
- Verdict: [PROCEED / CONDITIONAL / BLOCKED]"
```

**Do NOT commit:** Individual tool test logs, error traces, intermediate agent checkpoints (auto-cleaned from `_work/`).

### Next Session Target

N-001 Mid-Market B2B SaaS Revenue Operations — Phase 1 Niche Bounding. At this point, the first real niche has:
- Measured cost bounds (no more estimates)
- Verified tools (no more theory)
- Operational quality scripts (no more stubs)
- Calibrated evaluation process (agents produce comparable outputs)

The program is no longer theoretical — it runs.

---

## APPENDIX: COMMAND CHEAT SHEET

```bash
# === ENVIRONMENT ===
export NICHE_PROGRAM_ROOT="/home/weshen83/GTM WORK&PROJECTS/ClarityRevs/niche-program"
export NICHE_SCRIPT_DIR="$NICHE_PROGRAM_ROOT/research/_pipelines"
cd "$NICHE_PROGRAM_ROOT"

# === VERIFY ===
python3 -c "from lib.pipeline_ops import yaml, load_yaml_safe, write_yaml_atomic, ExitCode; print('pipeline_ops OK')"
echo "FIRECRAWL_API_KEY=${FIRECRAWL_API_KEY:0:8}..."
echo "DATAFORSEO_LOGIN=${DATAFORSEO_LOGIN:+SET}"
echo "DATAFORSEO_PASSWORD=${DATAFORSEO_PASSWORD:+SET}"

# === FIRECRAWL ===
firecrawl credit-usage
firecrawl search "revenue intelligence software 2026" --limit 5
firecrawl scrape "https://www.g2.com/products/gong-io/reviews" --wait-for 3000
firecrawl scrape "https://www.gong.io/pricing/" --wait-for 3000
firecrawl crawl "https://docs.dataforseo.com" --include-paths "/v3/" --max-depth 2 --limit 10
firecrawl map "https://www.gong.io" --search "pricing"

# === DATAFORSEO ===
curl -s --user "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" \
  -H "Content-Type: application/json" \
  -d '[]' \
  "https://api.dataforseo.com/v3/serp/google/organic/live/advanced" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Status: {d.get(\"status_code\")}, Tasks: {len(d.get(\"tasks\",[]))}')"

# === CREDITS ===
firecrawl credit-usage

# === CALIBRATION DIRECTORIES ===
mkdir -p research/CALIBRATION/{_GROUND-TRUTH,_RECONCILIATION,_debrief,N-CAL-AGENT-A1,N-CAL-AGENT-A2,CAL-B-AGENT-B1,CAL-B-AGENT-B2}

# === LEDGER ===
python3 -c "
from ruamel.yaml import YAML
yaml=YAML()
data = {'niches': {'CAL-A': {'type': 'calibration', 'status': 'in_progress'}, 'CAL-B': {'type': 'calibration', 'status': 'in_progress'}}}
yaml.dump(data, open('research/_program/LEDGER.yaml','w'))
"
```
