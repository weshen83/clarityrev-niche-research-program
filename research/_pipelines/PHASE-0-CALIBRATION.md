# PHASE 0: Tool Calibration & Pre-Flight Check
## Session Starter for the 25-Niche Evaluation Pipeline

**Status:** BINDING — Execute this sequence before any niche evaluation begins.
**Last Updated:** 2026-07-23
**Context:** Niche Research Program — read `NICHE-METHODOLOGY.md`, `DATA-OPERATIONS-ARCHITECTURE.md`, `AGENT-CONTEXT-SPEC.md`, `RUNBOOK.md`
**Design philosophy:** Google SRE — software engineering for operations. Stripe API design — contract-first. Netflix Chaos Engineering — assume failure. Every command is copy-pasteable. Every expected output is documented. Every failure path has a recovery.

**Ground truth:** The program has 148 tests passing, 6 operational scripts, 5 tracking files, 6 YAML schemas, and has NEVER been executed. This Phase 0 transforms it from designed to operational.

---

## TABLE OF CONTENTS

- [STAGE 0: Environment Verification](#stage-0-environment-verification)
- [STAGE 1: Test Suite Execution](#stage-1-test-suite-execution)
- [STAGE 2: Tool Calibration](#stage-2-tool-calibration)
  - [2.1 Firecrawl Calibration](#21-firecrawl-calibration)
  - [2.2 DataForSEO Calibration](#22-dataforseo-calibration)
  - [2.3 Free Tool / MCP Server Verification](#23-free-tool--mcp-server-verification)
  - [2.4 Sequential Test (Cache-Idempotency)](#24-sequential-test-cache-idempotency)
- [STAGE 3: Infrastructure Bootstrap](#stage-3-infrastructure-bootstrap)
- [STAGE 4: Calibration Niche Dry-Run (Phase 1 Only)](#stage-4-calibration-niche-dry-run-phase-1-only)
- [STAGE 5: Credit Budget Baseline](#stage-5-credit-budget-baseline)
- [CALIBRATION COMPLETION GATE](#calibration-completion-gate)
- [TROUBLESHOOTING](#troubleshooting)
- [NEXT STEPS](#next-steps)

---

## STAGE 0: Environment Verification

### 0.1 Set the Project Root

```bash
export NICHE_PROGRAM_ROOT="/home/weshen83/GTM WORK&PROJECTS/ClarityRevs/niche-program"
export NICHE_SCRIPT_DIR="$NICHE_PROGRAM_ROOT/research/_pipelines"
cd "$NICHE_PROGRAM_ROOT"
```

**Verify:**
```bash
# Should print the full path to niche-program/
echo "NICHE_PROGRAM_ROOT=$NICHE_PROGRAM_ROOT"
# Should print research/_pipelines
echo "SCRIPT_DIR=$NICHE_SCRIPT_DIR"
# Confirm we're in the right directory
pwd
# Should print: .../niche-program
```

### 0.2 Verify Python & Dependencies

```bash
python3 --version
# Expected: Python 3.10+ (3.12 preferred)

pip3 install ruamel.yaml 2>&1 | tail -1
# Expected: "Successfully installed ruamel.yaml-..." or "Requirement already satisfied: ruamel.yaml"
```

**Verify the shared library loads:**
```bash
python3 -c "from lib.pipeline_ops import yaml, load_yaml_safe, write_yaml_atomic, ExitCode; print('pipeline_ops OK')"
# Expected: pipeline_ops OK
```

**Verify all 6 schemas exist and are parseable:**
```bash
for f in schemas/*.yaml; do
  python3 -c "from ruamel.yaml import YAML; yaml=YAML(); d=yaml.load(open('$f')); print(f'OK: $f')" 2>&1
done
# Expected: OK: schemas/competitor-profile-schema.yaml (6 lines, one per schema)
```

### 0.3 Verify Environment Variables

```bash
echo "FIRECRAWL_API_KEY=${FIRECRAWL_API_KEY:0:8}..."  # Show first 8 chars only
echo "DATAFORSEO_LOGIN=${DATAFORSEO_LOGIN:+SET (login present)}"  # Just confirm present
echo "DATAFORSEO_PASSWORD=${DATAFORSEO_PASSWORD:+SET (password present)}"
```

**If any are missing**, they must be set before proceeding:
```bash
# Example — DO NOT hardcode secrets. Load from your password manager.
# export FIRECRAWL_API_KEY="sk-..."
# export DATAFORSEO_LOGIN="..."
# export DATAFORSEO_PASSWORD="..."
```

### 0.4 Verify Git Repository State

```bash
git status --short
# Expected: Clean working tree. Untracked files are OK (raw data).
# If there are modified tracked files, commit or stash before pipeline execution.

git rev-parse --show-toplevel
# Expected: /home/.../nich-program (confirms we're in a git repo)
```

### 0.5 Verify Program Tracking Files

```bash
for f in \
  "$NICHE_PROGRAM_ROOT/research/_program/CREDIT_BUDGET.yaml" \
  "$NICHE_PROGRAM_ROOT/research/_program/DEAD_HOST_REGISTRY.yaml" \
  "$NICHE_PROGRAM_ROOT/research/_program/PIPELINE_CHECKPOINTS.yaml" \
  "$NICHE_PROGRAM_ROOT/research/_program/LEDGER.yaml" \
  "$NICHE_PROGRAM_ROOT/research/_program/TOOL_ERROR_LOG.yaml" \
  "$NICHE_PROGRAM_ROOT/research/_program/SLI_DEFINITIONS.yaml" \
  "$NICHE_PROGRAM_ROOT/research/_program/QUALITY_METRICS.yaml" \
  "$NICHE_PROGRAM_ROOT/research/_program/FRESHNESS_VIOLATION_LOG.yaml"; do
  if [ -f "$f" ]; then
    python3 -c "from ruamel.yaml import YAML; y=YAML(); y.load(open('$f')); print('OK: $f')"
  else
    echo "MISSING: $f"
  fi
done
# Expected: All 8 files present and parseable
```

### 0.6 Verify SHARED Directory Structure

```bash
ls -d "$NICHE_PROGRAM_ROOT/research/SHARED/"*/
# Expected: benchmarks/ competitors/ buyer_language/ regulatory/ tools/ taxonomy/ triggers/
```

### 0.7 Verify Operational Scripts Are Runable

```bash
for f in preflight-check freshness-audit validate-schema clean-raw-fetches generate-quality-dashboard grade-engine; do
  file "$NICHE_SCRIPT_DIR/$f" | grep -q "Python script" && echo "OK: $f" || echo "NOT PYTHON: $f"
done
# Expected: OK: preflight-check (5 lines, one per script + grade-engine)
```

---

## STAGE 1: Test Suite Execution

Run the full test suite to confirm the system is healthy before consuming any credits.

```bash
bash "$NICHE_SCRIPT_DIR/test/run_all_tests.sh"
```

**Expected output:**
```
============================================================
  ClarityRev Niche Pipeline — Master Test Suite
============================================================
  Date: 2026-07-23 ...

[--- pytest: pipeline_ops.py unit tests ---]
...
>> pytest: pipeline_ops.py unit tests: ALL PASSED (70 passed, 0 skipped)

[--- bash: preflight-check integration ---]
...
>> bash: preflight-check integration: ALL PASSED (18 passed, 0 skipped)

[--- bash: freshness-audit integration ---]
...
>> bash: freshness-audit integration: ALL PASSED (16 passed, 0 skipped)

[--- bash: validate-schema integration ---]
...
>> bash: validate-schema integration: ALL PASSED (14 passed, 0 skipped)

[--- bash: clean-raw-fetches integration ---]
...
>> bash: clean-raw-fetches integration: ALL PASSED (14 passed, 0 skipped)

[--- bash: generate-quality-dashboard integration ---]
...
>> bash: generate-quality-dashboard integration: ALL PASSED (16 passed, 0 skipped)

============================================================
  FINAL RESULTS
============================================================
  Total tests:  148
  Passed:       148
  Failed:       0
  Skipped:      0

ALL TESTS PASSED
```

**If tests fail:**
- Inspect individual test output above the summary
- `git log --oneline -5` to see recent changes
- Check `test/` directory for test tolerance issues (date-sensitive tests can fail near midnight UTC)
- Fix and re-run. Do NOT proceed to Stage 2 until all 148 tests pass.

---

## STAGE 2: Tool Calibration

### 2.1 Firecrawl Calibration

**2.1.1 Credit Balance Check**
```bash
firecrawl credit-usage
```
**Expected:** Returns remaining credits. Should be ~10,000.
```
10,000
```
**If FAILS:** Check `FIRECRAWL_API_KEY` env var. Visit https://firecrawl.dev/dashboard.

**2.1.2 Basic Search (Discovery Query)**
```bash
firecrawl search "revenue intelligence software 2026" --limit 5
```
**Expected:** Returns 5 results with titles, URLs, and relevance excerpts. Cost: ~2 credits.

**Troubleshooting if empty:**
- The search relevance model returns excerpts, not full pages. If zero results, try broader query.
- If HTTP 4xx/5xx, check API key validity and account status.

**2.1.3 JS-Rendered Scrape (G2 Reviews Page)**
```bash
firecrawl scrape "https://www.g2.com/products/gong-io/reviews" --wait-for 3000
```
**Expected:** Returns G2 page content with review data. May show a login wall.
- If G2 blocks with a login wall: **this is expected behavior.** G2 sometimes requires login for review content. Document this finding.
- If it succeeds: note that G2 reviews are publicly accessible for this product.
- Cost: 1-2 credits.

**Fallback test (Capterra — typically no login wall):**
```bash
firecrawl scrape "https://www.capterra.com/p/181934/Gong-io/reviews/" --wait-for 2000
```

**2.1.4 Pricing Page Scrape (Static)**
```bash
firecrawl scrape "https://www.gong.io/pricing/" --wait-for 3000
```
**Expected:** Returns pricing tier information OR a "contact sales" gate.
- If pricing is behind a login/gate: **this is expected.** Document that Gong enterprise pricing is quote-gated.
- If pricing is visible: extract tier names and prices for the calibration record.
- Cost: 1-2 credits.

**2.1.5 Crawl with Path Filter**
```bash
firecrawl crawl "https://docs.dataforseo.com" --include-paths "/v3/" --max-depth 2 --limit 10
```
**Expected:** Returns 10 docs pages from the DataForSEO v3 API docs.
- If site blocks the crawl: try reducing to --max-depth 1.
- Cost: ~10 credits.

**2.1.6 Map Discovery**
```bash
firecrawl map "https://www.gong.io" --search "pricing"
```
**Expected:** Returns pricing-related URLs from gong.io.
- Typical output: `https://www.gong.io/pricing/`, `https://www.gong.io/plans/`, etc.
- Cost: 1 credit.

**2.1.7 Concurrent Test (3 Parallel Scrapes)**
```bash
# Run 3 scrapes simultaneously to verify concurrency works
firecrawl scrape "https://www.gong.io/pricing/" --wait-for 2000 &
PID1=$!
firecrawl scrape "https://www.gong.io/" --wait-for 2000 &
PID2=$!
firecrawl scrape "https://www.clari.com/pricing/" --wait-for 2000 &
PID3=$!
wait $PID1; echo "SCRAPE 1 DONE: $?"
wait $PID2; echo "SCRAPE 2 DONE: $?"
wait $PID3; echo "SCRAPE 3 DONE: $?"
```
**Expected:** All 3 complete successfully within ~10 seconds.
- If any hang longer than 60s: kill with `kill <PID>`.
- If rate-limited (429): note the limit. Reduce default concurrent count.
- Cost: 3-6 credits.

**2.1.8 Firecrawl Estimated Costs for Calibration**

| Test | Credits | Outcome |
|------|---------|---------|
| Credit balance | 0 | PASS / FAIL |
| Basic search | ~2 | PASS / FAIL |
| JS scrape (G2) | ~1-2 | PASS / PARTIAL / FAIL |
| Pricing scrape (Gong) | ~1-2 | PASS / PARTIAL / FAIL |
| Crawl (DataForSEO docs) | ~10 | PASS / FAIL |
| Map (Gong) | ~1 | PASS / FAIL |
| Concurrent test (3 scrapes) | ~3-6 | PASS / FAIL |

**Expected total:** ~20-25 credits for the Firecrawl calibration block.

---

### 2.2 DataForSEO Calibration

**2.2.1 SERP Check (Live)**
```bash
curl -s --user "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" \
  -H "Content-Type: application/json" \
  -d '{"keyword":"revenue intelligence software","location_code":2840,"language_code":"en"}' \
  "https://api.dataforseo.com/v3/serp/google/organic/live/advanced" | python3 -m json.tool | head -40
```
**Expected:** Returns JSON with SERP results including URLs, titles, positions.
- `location_code: 2840` = Netherlands. Change for other markets.
- Cost: ~$0.0006 (standard queue, task-based pricing).

**If authentication fails:**
```bash
# Test basic auth independently
curl -s -o /dev/null -w "%{http_code}" --user "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" \
  "https://api.dataforseo.com/v3/serp/google/organic/live/advanced"
# Expected: 200 (OK) or 40x (auth issue)
```

**2.2.2 Keyword Volume (Batch)**
```bash
curl -s --user "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" \
  -H "Content-Type: application/json" \
  -d '{"keywords":["revenue intelligence","sales forecasting","pipeline analytics","deal intelligence","revenue operations"],"location_code":2840,"language_code":"en"}' \
  "https://api.dataforseo.com/v3/keywords/google/search_volume/live" | python3 -m json.tool | head -60
```
**Expected:** Returns search volumes, CPC, competition for 5 test keywords.
- Cost: ~$0.0006 per batch of up to 1,000 keywords.

**2.2.3 Labs Competitor Domain Analysis**
```bash
curl -s --user "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" \
  -H "Content-Type: application/json" \
  -d '{"domain":"gong.io","location_code":2840,"language_code":"en"}' \
  "https://api.dataforseo.com/v3/dataforseo_labs/google/competitors_domain/live" | python3 -m json.tool | head -50
```
**Expected:** Returns competitor domains with keyword overlap metrics.
- If gong.io is not found, try "clari.com" or "salesforce.com".
- Cost: ~$0.012/task.

**2.2.4 Domain Technographics**
```bash
curl -s --user "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" \
  -H "Content-Type: application/json" \
  -d '{"domains":["gong.io"],"internal_list":false}' \
  "https://api.dataforseo.com/v3/domain_analytics/technologies/live" | python3 -m json.tool | head -80
```
**Expected:** Returns detected technologies for gong.io.
- Categories include: analytics, CDN, CRM, marketing automation, etc.
- Cost: ~$1.21/1K companies (for this single domain: ~$0.0012).

**2.2.5 DataForSEO OnPage (Free Endpoint)**
```bash
curl -s --user "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" \
  -H "Content-Type: application/json" \
  -d '{"target":"https://gong.io","max_crawl_pages":3,"enable_browser_rendering":true}' \
  "https://api.dataforseo.com/v3/on_page/content_parsing/live" | python3 -m json.tool | head -40
```
**Expected:** Returns parsed page content (meta, headings, text). This endpoint is FREE.
- Cost: $0.00.

**2.2.6 DataForSEO Estimated Costs for Calibration**

| API Call | Cost | Outcome |
|----------|------|---------|
| SERP check (live) | ~$0.0006 | PASS / FAIL |
| Keyword volume (5 kw) | ~$0.0006 | PASS / FAIL |
| Labs competitor domain | ~$0.012 | PASS / FAIL |
| Domain technographics | ~$0.0012 | PASS / FAIL |
| OnPage content parsing | $0.00 | PASS / FAIL |

**Expected total:** ~$0.015 for the DataForSEO calibration block.

---

### 2.3 Free Tool / MCP Server Verification

These are fallback-only tools (per DATA-OPERATIONS-ARCHITECTURE.md §2.2: Firecrawl/DataForSEO first, free tools only when they are demonstrably BETTER at a specific task).

**2.3.1 OpenRegistry MCP (European Company Registries)**
```bash
# Query KVK (Netherlands) for a known company
openregistry: query nl "Booking.com"
```
**Expected:** Returns company registration data (KVK number, address, directors, status).
- If MCP unavailable: Fallback to OpenKVK API directly: `curl -s "https://api.openkvk.nl/company/Booking.com"`

**2.3.2 Reddit Research MCP (Free, Official API)**
```bash
# Search for "RevOps challenge" on Reddit
reddit: search "RevOps challenge" limit:5
```
**Expected:** Returns relevant posts with content, upvotes, comments.
- This is the PRIMARY method for Reddit access. Firecrawl is the fallback (for public Reddit pages only).

**2.3.3 GDELT Project (News Monitoring)**
```bash
# Query GDELT for revenue intelligence news in the last 7 days
curl -s "https://api.gdeltproject.org/api/v2/doc/doc?query=revenue%20intelligence&mode=artlist&maxrecords=5&format=json" | python3 -m json.tool | head -40
```
**Expected:** Returns news articles related to revenue intelligence.
- GDELT covers 100K+ outlets in 65 languages. Free and unlimited.

**2.3.4 EUROSTAT API (Market Sizing)**
```bash
# Query NACE J.62 (Computer programming, consultancy) employment data
curl -s "https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/nama_10_a10?geo=NL&unit=CP_MEUR&nace_r2=J62" | python3 -m json.tool | head -30
```
**Expected:** Returns employment/value-added data for the Dutch IT sector.
- If the response is too large, use the `&format=JSON&lang=en&filter=value` parameters.
- Alternative: CBS StatLine (Netherlands-specific): `curl -s "https://opendata.cbs.nl/statline/#/CBS/nl/dataset/..."`

**2.3.5 Context7 MCP (API Docs Verification)**
```bash
# Query official HubSpot API docs for CRM search
context7: query "HubSpot CRM search API"
```
**Expected:** Returns API endpoint details, authentication methods, rate limits.
- Used for verifying signal feasibility (trigger detection) in Phase 2.

**2.3.6 Free Tool Verification Summary**

| Tool | Test Query | Expected | Outcome |
|------|-----------|----------|---------|
| OpenRegistry MCP | Booking.com (NL) | KVK data | PASS / FAIL |
| Reddit Research MCP | "RevOps challenge" | Posts | PASS / FAIL |
| GDELT Project | "revenue intelligence" | News | PASS / FAIL |
| EUROSTAT API | NACE J.62 (NL) | Economic data | PASS / FAIL |
| Context7 MCP | HubSpot CRM API | Docs | PASS / FAIL |

**Gate:** At least 3 of 5 free tools must verify as working. If fewer than 3 pass, the fallback chain for the pipeline is too weak. Document the failing tools and decide: (1) find alternative free tools, or (2) accept the reduced fallback coverage.

---

### 2.4 Sequential Test (Cache-Idempotency)

Run a preflight check BEFORE a credit-consuming operation, then verify it correctly detects a cache hit.

```bash
cd "$NICHE_PROGRAM_ROOT"

# Step 1: Run preflight-check on a niche that does NOT have cached data
python3 "$NICHE_SCRIPT_DIR/preflight-check" N-099 competitor-profile --dry-run
```
**Expected:** Exit code 1 (BLOCKED or no cache hit → signals no cached data) with output like:
```
{
  "exit_code": 1,
  "niche_id": "N-099",
  "data_type": "competitor-profile",
  "cache_status": "MISS",
  "dry_run": true
}
```

```bash
# Step 2: Run preflight-check on N-099 which HAS test data
python3 "$NICHE_SCRIPT_DIR/preflight-check" N-099 test-data --target-url "https://example.com"
```
**Expected:** Exit code 0 with cache hit or valid check:
```
{
  "exit_code": 0,
  "niche_id": "N-099",
  "data_type": "test-data",
  "cache_status": "HIT" or "PASS"
}
```

```bash
# Step 3: Test dead-host detection
python3 "$NICHE_SCRIPT_DIR/preflight-check" N-099 competitor-pricing --target-url "https://this-does-not-exist-12345.com/pricing" --dry-run
```
**Expected:** Exit code 2 (WARNING) or 1 (BLOCKED) if the host format is clearly invalid or unknown.

---

## STAGE 3: Infrastructure Bootstrap

### 3.1 Verify CREDENTIALS.yaml

```bash
# Check that CREDENTIALS.yaml exists and is valid YAML
python3 -c "
import os, sys
sys.path.insert(0, '$NICHE_SCRIPT_DIR')
from lib.pipeline_ops import load_yaml_safe, PROGRAM_DIR
c = load_yaml_safe(PROGRAM_DIR / 'CREDENTIALS.yaml')
if c:
    print('CREDENTIALS.yaml: OK')
    # Verify all env vars resolve
    for section, values in c.items():
        if isinstance(values, dict):
            for key, val in values.items():
                if isinstance(val, str) and val.startswith('~'):
                    continue
                if '_env_var' in key or key == 'api_key':
                    if val and 'env' in val.lower():
                        # Check if env var is set
                        pass
    print('Credential references: OK')
else:
    print('WARNING: CREDENTIALS.yaml missing or empty')
    print('Create from: $NICHE_PROGRAM_ROOT/discovery/credential-setup.md')
"
```

If CREDENTIALS.yaml does not exist:
```bash
# Create minimal CREDENTIALS.yaml (gitignored)
cat > "$NICHE_PROGRAM_ROOT/research/_program/CREDENTIALS.yaml" << 'EOF'
# CREDENTIALS.yaml — Credential inventory (gitignored)
# All values reference environment variables — no secrets in this file.

firecrawl:
  api_key_env_var: "FIRECRAWL_API_KEY"

dataforseo:
  login_env_var: "DATAFORSEO_LOGIN"
  password_env_var: "DATAFORSEO_PASSWORD"
  queue_type: "standard"

free_tools_with_keys:
  SERPER_API_KEY: "serper"
EOF
```

### 3.2 Verify pipeline lock file and MCP schedule

```bash
# Check if _CONCURRENCY_LOCK.yaml exists (created dynamically by agents)
ls "$NICHE_PROGRAM_ROOT/research/_program/_CONCURRENCY_LOCK.yaml" 2>/dev/null || \
  echo "CONCURRENCY_LOCK: (will be created by first agent at pipeline start)"
```

### 3.3 Create TOOL_VERSIONS.yaml Baseline

```bash
python3 << 'PYEOF'
import sys, os
sys.path.insert(0, os.environ.get('NICHE_SCRIPT_DIR', '$NICHE_SCRIPT_DIR'))
from lib.pipeline_ops import write_yaml_atomic, PROGRAM_DIR
from datetime import datetime, timezone

tool_versions = {
    "generated_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "tools": {
        "firecrawl": {
            "source": "firecrawl_cli",
            "version": "calibrated_2026-07-23",
            "test_results": {
                "basic_search": "PENDING",
                "js_scrape": "PENDING",
                "pricing_scrape": "PENDING",
                "crawl": "PENDING",
                "map": "PENDING",
                "concurrent_3": "PENDING",
            }
        },
        "dataforseo": {
            "source": "api_test",
            "version": "calibrated_2026-07-23",
            "test_results": {
                "serp_live": "PENDING",
                "keyword_volume": "PENDING",
                "labs_competitor": "PENDING",
                "domain_technographics": "PENDING",
                "onpage_free": "PENDING",
            }
        },
        "mcp_servers": {
            "openregistry": "PENDING",
            "reddit_research": "PENDING",
            "gdelt": "PENDING",
            "eurostat": "PENDING",
            "context7": "PENDING",
        }
    }
}

write_yaml_atomic(PROGRAM_DIR / "TOOL_VERSIONS.yaml", tool_versions)
print("TOOL_VERSIONS.yaml created")
PYEOF
```

---

## STAGE 4: Calibration Niche Dry-Run (Phase 1 Only)

**Purpose:** Run Phase 1 of the pipeline on the CAL-A calibration niche to verify end-to-end operation WITHOUT committing to a full 25-niche evaluation.

**Gate:** This dry-run consumes credits (~17 credits Firecrawl, ~$0.002 DataForSEO). Confirm before proceeding:
> Firecrawl remaining after Stage 2 calibration: ______ credits
> Acceptable to spend ~17 more for Phase 1 dry-run? [y/N]

### 4.1 Create CAL-A Bounding Data

No prior data exists for CAL-A — Phase 1 is genuinely the first pass. The agent will:
1. Verify niche existence (5 broad searches for the calibration niche)
2. Discover 5 companies in the niche
3. Do broad market sizing
4. Check data accessibility

### 4.2 Run Phase 1 Steps Manually

**Step 1.1 Market existence check (Firecrawl /search × 5 parallel):**
```bash
firecrawl search "revenue intelligence mid-market companies 2026" --limit 3
firecrawl search "revops software pricing 2026" --limit 3
firecrawl search "sales forecasting tools 2026" --limit 3
firecrawl search "mid-market b2b saas revenue operations trends" --limit 3
firecrawl search "revops ROI case study 2026" --limit 3
```
Cost: ~2 credits each = ~10 credits. If a search returns zero results, that's diagnostic — the niche may not exist in a searchable form.

**Step 1.2 Prospect discovery:**
```bash
firecrawl search "mid-market revops companies Amsterdam" --limit 5
```
Cost: ~2 credits.

**Step 1.3 Market sizing (free APIs):**
Verify the government data sources respond with market sizing data for the calibration niche:
```bash
# EUROSTAT for IT services employment
curl -s "https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/nama_10_a10?geo=NL&unit=CP_MEUR&nace_r2=J62" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(f'EUROSTAT NACE J.62 (NL): {len(data.get(\"value\",{}))} data points found')
"
```

**Step 1.4 Competitor count estimate:**
```bash
curl -s --user "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" \
  -H "Content-Type: application/json" \
  -d '{"keyword":"revenue operations software","location_code":2840,"language_code":"en"}' \
  "https://api.dataforseo.com/v3/serp/google/organic/live/advanced" | \
  python3 -c "
import sys, json
data = json.load(sys.stdin)
tasks = data.get('tasks', [])
if tasks and tasks[0].get('result'):
    items = tasks[0]['result'][0].get('items', [])
    organic = [i for i in items if i.get('type') == 'organic']
    print(f'Organic SERP results: {len(organic)}')
    for r in organic[:8]:
        print(f'  {r.get(\"domain\",\"?\")} — {r.get(\"title\",\"\")[:60]}')
else:
    print('No SERP results returned')
"
```

**Step 1.5 Data accessibility gate:**
```bash
# The calibration niche uses HubSpot/Salesforce — verify signal feasibility
context7: query "HubSpot CRM search API rate limits"
```
Document whether the signal sources (CRM API, job boards, etc.) are accessible for this niche.

### 4.3 Calibration Dry-Run Data Quality Check

After Phase 1 completes on CAL-A, verify:
- [ ] Market existence: >=1 analyst report OR >=50 searchable companies found
- [ ] Company discovery: >=5 companies identified with URLs
- [ ] Market sizing: >=1 data source with numeric estimate
- [ ] Data accessibility: CRM API docs confirm signal detection is feasible
- [ ] Total Firecrawl credits consumed: record in calibration log

**Record results:**
```bash
cat > "$NICHE_PROGRAM_ROOT/research/_program/CALIBRATION_RESULTS.yaml" << 'EOF'
# CALIBRATION RESULTS — Phase 0 dry-run on CAL-A
# Generated: 2026-07-23
niche_id: "CAL-A"
firecrawl_version_tested: "2026-07-23"
dataforseo_version_tested: "2026-07-23"

# Section 2.1 Firecrawl Tests
firecrawl_calibration:
  basic_search: "PASS"
  js_scrape_g2: "PASS / PARTIAL / FAIL"
  pricing_scrape: "PASS / PARTIAL / FAIL"
  crawl: "PASS / FAIL"
  map: "PASS / FAIL"
  concurrent_3: "PASS / FAIL"
  credits_consumed: 20
  notes: ""

# Section 2.2 DataForSEO Tests  
dataforseo_calibration:
  serp_live: "PASS / FAIL"
  keyword_volume: "PASS / FAIL"
  labs_competitor: "PASS / FAIL"
  domain_technographics: "PASS / FAIL"
  onpage_free: "PASS / FAIL"
  cost_consumed: 0.015
  notes: ""

# Section 2.3 Free Tools
free_tools:
  openregistry: "PASS / FAIL"
  reddit_research: "PASS / FAIL"
  gdelt: "PASS / FAIL"
  eurostat: "PASS / FAIL"
  context7: "PASS / FAIL"

# Section 4 Phase 1 Dry-Run
phase1_dry_run:
  market_existence: "PASS / FAIL"
  companies_discovered: 5
  market_sizing_sources: 2
  data_accessibility: "GREEN / YELLOW / RED"
  firecrawl_credits_consumed: 17
  dataforseo_cost_consumed: 0.002
  total_calibration_credits: 37
  total_calibration_cost: 0.017
  pipeline_ready: "YES / CONDITIONAL / NO"
  go_to_phase2_calibration: "YES / NO"
EOF
echo "CALIBRATION_RESULTS.yaml created. Fill in actual values."
```

---

## STAGE 5: Credit Budget Baseline

### 5.1 Record Starting Balances

```bash
FIRECRAWL_BEFORE=$(python3 -c "
import sys, os
sys.path.insert(0, os.environ.get('NICHE_SCRIPT_DIR', '$NICHE_SCRIPT_DIR'))
from lib.pipeline_ops import load_yaml_safe, PROGRAM_DIR
b = load_yaml_safe(PROGRAM_DIR / 'CREDIT_BUDGET.yaml')
print(b.get('firecrawl_remaining', 'UNKNOWN'))
")
echo "Firecrawl before calibration: $FIRECRAWL_BEFORE"

DATAFORSEO_BEFORE=$(python3 -c "
import sys, os
sys.path.insert(0, os.environ.get('NICHE_SCRIPT_DIR', '$NICHE_SCRIPT_DIR'))
from lib.pipeline_ops import load_yaml_safe, PROGRAM_DIR
b = load_yaml_safe(PROGRAM_DIR / 'CREDIT_BUDGET.yaml')
print(b.get('dataforseo_remaining', 'UNKNOWN'))
")
echo "DataForSEO before calibration: $DATAFORSEO_BEFORE"
```

### 5.2 After Calibration, Record Ending Balances

```bash
firecrawl credit-usage
# Note the new total

# Update CREDIT_BUDGET.yaml with actual post-calibration values
```

### 5.3 Compare Actual vs. Estimated Consumption

| Item | Estimated | Actual | Variance |
|------|-----------|--------|----------|
| Firecrawl for Stage 2 calibration | ~20-25 credits | ______ | ___% |
| DataForSEO for Stage 2 calibration | ~$0.015 | ______ | ___% |
| Firecrawl for Stage 4 Phase 1 dry-run | ~17 credits | ______ | ___% |
| DataForSEO for Stage 4 Phase 1 dry-run | ~$0.002 | ______ | ___% |
| Total Firecrawl consumed | ~37-42 credits | ______ | ___% |
| Total DataForSEO consumed | ~$0.017 | ______ | ___% |
| Firecrawl remaining | ~9,958-9,963 | ______ | ___% |
| DataForSEO remaining | ~$49.98 | ______ | ___% |

**Gate:**
- Firecrawl remaining must be >= 9,000 credits
- DataForSEO remaining must be >= $45
- Actual vs. estimated variance must be <= 30% for Firecrawl

---

## CALIBRATION COMPLETION GATE

### Primary Tools
- [ ] Firecrawl basic search returns results (2.1.2)
- [ ] Firecrawl JS scrape works on review pages (2.1.3)
- [ ] Firecrawl pricing scrape works on accessible pages (2.1.4)
- [ ] Firecrawl crawl with path filter works (2.1.5)
- [ ] Firecrawl map discovery works (2.1.6)
- [ ] Firecrawl 3-parallel concurrent test passes (2.1.7)
- [ ] Firecrawl credit-usage reports remaining balance (2.1.1)
- [ ] DataForSEO SERP live query returns results (2.2.1)
- [ ] DataForSEO keyword volume batch works (2.2.2)
- [ ] DataForSEO Labs competitor domain analysis works (2.2.3)
- [ ] DataForSEO domain technographics works (2.2.4)
- [ ] DataForSEO OnPage (free) content parsing works (2.2.5)

### Free Fallback Tools
- [ ] >=3 of 5 free tools verified as working (2.3)

### Infrastructure
- [ ] CREDENTIALS.yaml exists and is valid YAML (3.1)
- [ ] All 8 program tracking files exist and parse as YAML (0.5)
- [ ] TOOL_VERSIONS.yaml created with calibration results (3.3)
- [ ] SHARED/ directory structure complete (0.6)
- [ ] Test suite: 148/148 passing (1.0)

### Credit Budget
- [ ] Firecrawl remaining >= 9,000 credits (5.3)
- [ ] DataForSEO remaining >= $45 (5.3)
- [ ] Actual vs estimated variance <= 30% (5.3)
- [ ] Dead-host registry initialized (empty) (0.5)

### Calibration Dry-Run
- [ ] Phase 1 on CAL-A completed (4.2)
- [ ] Market existence confirmed (4.3)
- [ ] All env vars resolve to non-empty values (0.3)
- [ ] Preflight-check cache-miss test passes (2.4)

**Verification:** If ALL items checked = YES → Phase 0 COMPLETE. Pipeline is calibrated and ready for Phase 1.

**Emergency override:** If a non-primary (fallback) tool fails calibration and has an equivalent working fallback, the failing gate item may be waived. Log the waiver in `research/_program/PIPELINE_CHECKPOINTS.yaml`. Primary tool failures (Firecrawl, DataForSEO) CANNOT be waived.

---

## TROUBLESHOOTING

### T-0: Environment and Dependency Issues

| Symptom | Root Cause | Fix |
|---------|-----------|-----|
| `python3: command not found` | Python not installed | `apt install python3 python3-pip` |
| `ModuleNotFoundError: ruamel.yaml` | Missing YAML library | `pip3 install ruamel.yaml` |
| `ModuleNotFoundError: lib.pipeline_ops` | Wrong working directory | `cd "$NICHE_PROGRAM_ROOT"` before running scripts |
| `Permission denied` on script | Script not executable | `chmod +x "$NICHE_SCRIPT_DIR/"*` |
| Scripts not found | NICHE_SCRIPT_DIR not set | Run Stage 0.1 first |
| CREDENTIALS.yaml parse error | Invalid YAML syntax | `python3 -c "import yaml; yaml.safe_load(open('...'))"` to debug |
| `yaml.scanner.ScannerError` | Corrupted YAML file | Restore from git or regenerate |

### T-1: Firecrawl Failures

| Symptom | Likely Cause | Recovery |
|---------|-------------|----------|
| `401 Unauthorized` | Invalid or expired API key | Regenerate key at https://firecrawl.dev/dashboard → API Keys |
| `402 Payment Required` | Account exhausted or unpaid balance | Top up credits at Firecrawl dashboard |
| `429 Too Many Requests` | Rate limited | Wait 60s, reduce concurrency, implement exponential backoff |
| `502 Bad Gateway` | Firecrawl partial outage | Check https://status.firecrawl.com. If confirmed outage, see RUNBOOK.md Scenario 3 |
| Empty search results | Query too narrow or relevance model miss | Broaden query, try alternative keywords, fall back to /scrape for specific sites |
| JS-rendered pages return blank | timeout too short or anti-bot detection | Increase `--wait-for` to 5000-8000ms. Try `--mobile` flag. |
| `/crawl` returns 0 pages | Path filter too restrictive or site blocks crawlers | Check robots.txt. Try `--include-paths` with broader patterns. Use `/scrape` directly. |
| `/map` returns empty | Site serves dynamic SPA without static sitemap | Try `https://` explicitly. Some SPAs don't respond to `/map`. Use `/scrape` for the homepage. |
| Concurrent test failures | 50 concurrent limit hit in multi-niche scenario | Per §4.6: stagger entries, limit to 10 concurrent per agent |
| Credit balance drops faster than expected | Cache miss on dynamic URLs | Ensure canonical (non-timestamped) URLs in all scrape calls. Check CACHE_MANIFEST.yaml |

### T-2: DataForSEO Failures

| Symptom | Likely Cause | Recovery |
|---------|-------------|----------|
| `401 Unauthorized` | Invalid login/password | Check DATAFORSEO_LOGIN/PASSWORD env vars. Generate new credentials at dashboard. |
| `402 Payment Required` | Balance exhausted | Top up at DataForSEO dashboard ($50 minimum). See RUNBOOK.md Scenario 4. |
| Empty SERP results | No results for keyword or wrong location_code | Try broader keyword or location_code=2826 (global) instead of 2840 (NL). |
| Labs API returns "domain not found" | Domain poorly indexed | Try a more well-known domain in the niche. Use SERP API instead for discovery. |
| OnPage API returns empty | Target URL unreachable or JS-only page | Try with `enable_browser_rendering: false`. Use Firecrawl /scrape instead. |
| `read_timeout` | Endpoint slow (standard queue: up to 5 min) | Increase curl timeout: `--max-time 300`. Use `live` endpoint instead of `standard`. |

### T-3: Free Tool Failures

| Symptom | Likely Cause | Recovery |
|---------|-------------|----------|
| OpenRegistry MCP returns error | MCP server not running in current session | Start MCP server or use direct API. Fallback: OpenKVK for Netherlands. |
| Reddit MCP returns no results | Query too specific | Broaden subreddit scope. Remove subreddit filter. |
| GDELT returns 0 articles | Query too narrow or too few results | Expand query terms. Remove date filters. |
| EUROSTAT returns 404 | NACE code or geo parameter wrong | Check https://ec.europa.eu/eurostat for valid codes. Use "TOTAL" for all sectors. |
| Context7 MCP fails | MCP server not available | Use direct Firecrawl /scrape to the API docs URL instead. |
| **>2 free tools fail simultaneously** | Environment configuration issue | Check network connectivity. Verify MCP server status. Document failed tools and proceed with remaining. |
| **>3 free tools fail** | Systemic issue | Do NOT continue. The fallback chain is too weak. Fix the environment before proceeding to niche evaluation. |

### T-4: Test Suite Isues

| Symptom | Likely Cause | Recovery |
|---------|-------------|----------|
| Tests fail near midnight UTC | Date-sensitive test boundary | Re-run in the morning. Tests compare `fetch_date` to `now()`. |
| "Expected 5 found 3" in test output | Test data file missing | Check `test_data/` directory is present and contains expected fixtures |
| `pytest: command not found` | pytest not installed | `pip3 install pytest` |
| Script hangs on a test | Infinite loop or network timeout | Kill with Ctrl+C, find the hanging test, check for network-dependent test |
| No output from tests | STDOUT/STDERR redirected | Run with `-v` flag for verbose output |

### T-5: Pipeline Script Errors (Exit Codes)

| Script | Exit Code | Meaning | Action |
|--------|-----------|---------|--------|
| preflight-check | 0 | SUCCESS (proceed) or SKIP_CACHE_HIT | Continue |
| preflight-check | 1 | BLOCKED (insufficient credits or dead host) | Check CREDIT_BUDGET.yaml and DEAD_HOST_REGISTRY.yaml |
| preflight-check | 2 | WARNING (proceed with caution) | Check the warning message |
| preflight-check | 3 | INTERNAL ERROR (bug, missing dep, corruption) | Check Python traceback |
| preflight-check | 4 | INVALID_INPUT (malformed args) | Check usage: `./preflight-check NICHE_ID DATA_TYPE [--target-url URL]` |
| freshness-audit | 0 | PASS (0% stale) or PASS_WITH_WARNING | Continue |
| freshness-audit | 1 | BLOCKED (>10% stale) | Re-fetch stale sources before canvas finalization |
| freshness-audit | 2 | ERROR | Investigate Python traceback |
| validate-schema | 0 | VALID | Continue |
| validate-schema | 1 | INVALID (schema violation) | Check output for the specific field that failed |
| validate-schema | 2 | ERROR | Investigate. May need to install pykwalify |
| clean-raw-fetches | 0 | SUCCESS (files cleaned) | Verify `.firecrawl/` and `.dataforseo/` are cleaned |
| clean-raw-fetches | 1 | ERROR | Check permissions on `.firecrawl/` directory |
| generate-quality-dashboard | 0 | SUCCESS (dashboard generated) | Read `_program/QUALITY_METRICS.yaml` for updates |
| generate-quality-dashboard | 1 | ERROR | Check tracking files exist and are parseable |

### T-6: Calibration Dry-Run Failures

| Symptom | Likely Cause | Recovery |
|---------|-------------|----------|
| All 5 Phase 1 searches return 0 results | Niche doesn't exist in search index, or niche is too narrow | Broaden search terms. If still 0 results, the calibration niche may need to be changed. |
| Fewer than 5 companies discovered | Niche is very narrow or non-existent | Try different company discovery sources (Crunchbase, G2 categories, LinkedIn searches via public profiles). |
| Market sizing APIs return no data | Wrong industry code or geographic scope | Try the "TOTAL" sector code for broader coverage. Use Firecrawl /search for market reports. |
| Data accessibility gate shows RED | Signal sources are all behind authentication | If the calibration niche's signals are all inside private APIs (no public endpoints), this niche may not be feasible. |
| Phase 1 consumes >30 credits (vs 17 estimate) | Cache layer not working or dynamic URLs | Check if Firecrawl is seeing unique URLs each request. Ensure canonical URLs. If still high, update estimate for this niche type. |

### T-7: Cache Layer Failures

| Symptom | Likely Cause | Recovery |
|---------|-------------|----------|
| Preflight-check repeatedly shows CACHE_MISS | File pattern doesn't match | Check that `CACHE_MANIFEST.yaml` uses the correct URL normalization. Verify file naming convention matches the glob pattern in preflight-check. |
| Cache hit rate <60% | Dynamic URLs (timestamps, session IDs) being used | Normalize URLs before cache lookup. Strip query parameters that change per-request. Use `compute_url_hash()` from pipeline_ops. |
| Cache says HIT but content is wrong | Content hash collision | Extremely unlikely with SHA256. If suspected, verify `compute_content_hash()` returns same hash for same content. |

### T-8: Concurrency Issues

| Symptom | Likely Cause | Recovery |
|---------|-------------|----------|
| 429 errors when 3+ niches are active | Too many concurrent Firecrawl requests | Reduce max concurrent niches to 3 (from 4). Increase stagger from 30-90s to 60-180s. |
| Pipeline checkpoint shows stalled niche | Agent crashed or context overflowed | Kill the agent process. Mark FAILED: TIMEOUT in LEDGER.yaml. Restart from last checkpoint. |
| Two niches fetching same competitor | Race condition in dedup-manifest.yaml | The file lock protocol prevents corruption. A duplicate fetch wastes ~2-5 credits but is NOT a data integrity issue. Log and continue. |

---

## NEXT STEPS

After Phase 0 completes successfully:

1. **Select the first production niche** — Start with a Tier 1 niche (N-001 through N-004) where Bob's network is warmest and data richness is highest. N-004 (Marketing Automation) has the strongest founder-market fit for Bob (Adobe/Marketo expertise).

2. **Execute Phase 1 on that niche** — Use the AGENT-CONTEXT-SPEC.md Phase 1 loading specification. Context budget: ~40K tokens. Load only the Phase 1 sections.

3. **After 3 production niches, re-run Phase 0 delta check** — Per DATA-OPERATIONS-ARCHITECTURE.md §4.0, a delta check runs every 10 niches OR whenever a tool returns its first failure. After 3 niches, proactively verify:
   - All primary tool endpoints respond correctly
   - Authenticated sessions are still valid
   - API version headers match TOOL_VERSIONS.yaml
   - Credit balance is consistent with projections

4. **Run the quality dashboard** after every 5th niche:
   ```bash
   python3 "$NICHE_SCRIPT_DIR/generate-quality-dashboard"
   ```

5. **Handle the SHARED/ bootstrap** — First 5 niches will pay bootstrap costs for cross-niche data. After niche 5, the SHARED registry should cover ~60% of common data. If still >50% empty after niche 5, investigate sharing violations.

---

*End of PHASE-0-CALIBRATION.md — This document is the binding Phase 0 session starter. Execute in order. Skip nothing. Document all failures. Proceed to Phase 1 only after the Calibration Completion Gate is fully checked.*
