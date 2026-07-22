#!/usr/bin/env bash
#
# test_quality_dashboard.sh — Integration tests for generate-quality-dashboard.
#
# Tests: all data sources present, missing TOOL_ERROR_LOG, --format json,
# --format text, --output FILE, --since NICHE_ID, --dry-run, empty data sources.
#
# Usage: bash test_quality_dashboard.sh [-v]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PIPELINES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DASHBOARD="$PIPELINES_DIR/generate-quality-dashboard"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

PASSED=0
FAILED=0
SKIPPED=0

setup() {
    TEST_ROOT=$(mktemp -d "/tmp/dash-test-XXXXXX")
    mkdir -p "$TEST_ROOT/niche-program/research/_pipelines"
    mkdir -p "$TEST_ROOT/niche-program/research/_pipelines/lib"
    
    mkdir -p "$TEST_ROOT/niche-program/research/_program"
    mkdir -p "$TEST_ROOT/niche-program/research/N-001"
    mkdir -p "$TEST_ROOT/niche-program/research/N-002"
    mkdir -p "$TEST_ROOT/niche-program/research/N-003"

    cp "$DASHBOARD" "$TEST_ROOT/niche-program/research/_pipelines/generate-quality-dashboard"
    cp -r "$PIPELINES_DIR/lib"/. "$TEST_ROOT/niche-program/research/_pipelines/lib/"
    chmod +x "$TEST_ROOT/niche-program/research/_pipelines/generate-quality-dashboard"

    cd "$TEST_ROOT"
    git init >/dev/null 2>&1
    git config user.email "test@clarityrev.com"
    git config user.name "Test Runner"
}

teardown() {
    rm -rf "$TEST_ROOT"
}

trap teardown EXIT

assert_exit_code() {
    local label="$1" actual="$2" expected="$3"
    if [ "$actual" -eq "$expected" ]; then
        echo -e "  ${GREEN}PASS${NC} $label"
        PASSED=$((PASSED + 1))
    else
        echo -e "  ${RED}FAIL${NC} $label"
        echo "    Expected exit $expected, got $actual"
        [ -n "${output:-}" ] && echo "    stdout: $(echo "$output" | head -3)"
        FAILED=$((FAILED + 1))
    fi
}

assert_json_field() {
    local label="$1" json="$2" field="$3" expected="$4"
    local actual
    actual=$(echo "$json" | python3 -c "import sys,json; print(json.load(sys.stdin)['$field'])" 2>/dev/null || echo "__PARSE_ERROR__")
    if [ "$actual" = "$expected" ]; then
        echo -e "  ${GREEN}PASS${NC} $label"
        PASSED=$((PASSED + 1))
    else
        echo -e "  ${RED}FAIL${NC} $label"
        echo "    Expected $field='$expected', got '$actual"
        FAILED=$((FAILED + 1))
    fi
}

# ==============================================================================
# Test Fixture Helpers
# ==============================================================================

write_quality_metrics() {
    local file="$1"
    cat > "$file" << YAML
last_updated: "2026-07-23"
cross_niche_summary:
  total_niches_completed: 3
  aggregate_evidence_quality: 0.72
  aggregate_staleness_rate: 0.05
per_data_type_staleness:
  competitor_pricing:
    total_sources: 50
    staleness_rate: 0.02
    staleness_violations: 1
  market_sizing:
    total_sources: 30
    staleness_rate: 0.10
    staleness_violations: 3
per_tool_errors:
  firecrawl:
    total_errors: 2
    error_rate: 0.01
    last_error: "2026-07-20"
  dataforseo:
    total_errors: 0
    error_rate: 0.0
per_niche_evidence:
  N-001:
    evidence_quality: 0.75
  N-002:
    evidence_quality: 0.70
  N-003:
    evidence_quality: 0.72
per_niche_wall_clock:
  N-001:
    estimated_minutes: 30
    actual_minutes: 28
  N-002:
    estimated_minutes: 30
    actual_minutes: 32
  N-003:
    estimated_minutes: 30
    actual_minutes: 25
YAML
}

write_freshness_violations() {
    local file="$1"
    cat > "$file" << YAML
violations:
  - niche_id: N-001
    source_file: "N-001/stale-data.yaml"
    data_type: market_sizing
    days_overdue: 45
  - niche_id: N-002
    source_file: "N-002/old-data.yaml"
    data_type: competitor_pricing
    days_overdue: 12
YAML
}

write_tool_errors() {
    local file="$1"
    cat > "$file" << YAML
errors:
  - tool: firecrawl
    error_code: TIMEOUT
    niche_id: N-001
    date: "2026-07-15"
    url: "https://example.com/timeout"
  - tool: firecrawl
    error_code: RATE_LIMIT
    niche_id: N-002
    date: "2026-07-16"
    url: "https://example.com/rate"
YAML
}

write_sli_definitions() {
    local file="$1"
    cat > "$file" << YAML
slis:
  fetch_success_rate:
    target: ">95%"
    description: "Percentage of fetch operations that complete without error"
  freshness_compliance:
    target: ">90%"
    description: "Percentage of data sources within SLA"
  credit_forecast_accuracy:
    target: "Within 20% of estimate"
    description: "Credit consumption deviates less than 20% from estimate"
  per_niche_wall_clock:
    target: "<45 minutes"
    description: "Time to complete a single niche evaluation"
  evidence_quality:
    target: ">70%"
    description: "Average evidence quality score across niches"
  pipeline_availability:
    target: ">99%"
    description: "Pipeline uptime across all operations"
alert_thresholds:
  firecrawl_error_rate:
    warning: 5.0
    critical: 10.0
    unit: "%"
  dataforseo_error_rate:
    warning: 5.0
    critical: 10.0
    unit: "%"
  staleness_rate:
    warning: 10.0
    critical: 20.0
    unit: "%"
  credit_burn_rate:
    warning: 500
    critical: 1000
    unit: " credits/hr"
  niche_wall_clock:
    warning: 40
    critical: 60
    unit: " min"
YAML
}

write_credit_budget() {
    local file="$1"
    cat > "$file" << YAML
firecrawl_remaining: 100000
dataforseo_remaining: 500.0
niches:
  N-001:
    estimated_credits: 3
    actual_credits: 2
  N-002:
    estimated_credits: 3
    actual_credits: 4
  N-003:
    estimated_credits: 3
    actual_credits: 3
YAML
}

# ==============================================================================
# Tests
# ==============================================================================

run_tests() {
    echo -e "${CYAN}============================================${NC}"
    echo -e "${CYAN}  generate-quality-dashboard tests${NC}"
    echo -e "${CYAN}============================================${NC}"

    # Test 1: All data sources present → exit 0
    echo -e "\n${YELLOW}[Test 1] All data sources present${NC}"
    setup
    cd "$TEST_ROOT"
    write_quality_metrics "niche-program/research/_program/QUALITY_METRICS.yaml"
    write_freshness_violations "niche-program/research/_program/FRESHNESS_VIOLATION_LOG.yaml"
    write_tool_errors "niche-program/research/_program/TOOL_ERROR_LOG.yaml"
    write_sli_definitions "niche-program/research/_program/SLI_DEFINITIONS.yaml"
    write_credit_budget "niche-program/research/_program/CREDIT_BUDGET.yaml"
    set +e; output=$(python3 niche-program/research/_pipelines/generate-quality-dashboard 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 0 (SUCCESS)" "$exit_code" 0
    assert_json_field "verdict=GENERATED" "$output" "verdict" "GENERATED"
    teardown

    # Test 2: Missing TOOL_ERROR_LOG.yaml → degraded (exit 2)
    echo -e "\n${YELLOW}[Test 2] Missing TOOL_ERROR_LOG${NC}"
    setup
    cd "$TEST_ROOT"
    write_quality_metrics "niche-program/research/_program/QUALITY_METRICS.yaml"
    write_freshness_violations "niche-program/research/_program/FRESHNESS_VIOLATION_LOG.yaml"
    # Don't create TOOL_ERROR_LOG.yaml
    write_sli_definitions "niche-program/research/_program/SLI_DEFINITIONS.yaml"
    write_credit_budget "niche-program/research/_program/CREDIT_BUDGET.yaml"
    set +e; output=$(python3 niche-program/research/_pipelines/generate-quality-dashboard 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 2 (WARNING degraded)" "$exit_code" 2
    teardown

    # Test 3: --format json → valid JSON output
    echo -e "\n${YELLOW}[Test 3] --format json${NC}"
    setup
    cd "$TEST_ROOT"
    write_quality_metrics "niche-program/research/_program/QUALITY_METRICS.yaml"
    write_freshness_violations "niche-program/research/_program/FRESHNESS_VIOLATION_LOG.yaml"
    write_tool_errors "niche-program/research/_program/TOOL_ERROR_LOG.yaml"
    write_sli_definitions "niche-program/research/_program/SLI_DEFINITIONS.yaml"
    write_credit_budget "niche-program/research/_program/CREDIT_BUDGET.yaml"
    local json_output
    json_output=$(python3 niche-program/research/_pipelines/generate-quality-dashboard --format json --output /dev/null 2>/dev/null || true)
    # Check that the result JSON on stdout is valid JSON
    if echo "$json_output" | python3 -c "import sys,json; json.load(sys.stdin)" 2>/dev/null; then
        echo -e "  ${GREEN}PASS${NC} Valid JSON output"
        PASSED=$((PASSED + 1))
    else
        echo -e "  ${RED}FAIL${NC} Invalid JSON output"
        FAILED=$((FAILED + 1))
    fi
    teardown

    # Test 4: --format text → human-readable output
    echo -e "\n${YELLOW}[Test 4] --format text${NC}"
    setup
    cd "$TEST_ROOT"
    write_quality_metrics "niche-program/research/_program/QUALITY_METRICS.yaml"
    write_freshness_violations "niche-program/research/_program/FRESHNESS_VIOLATION_LOG.yaml"
    write_tool_errors "niche-program/research/_program/TOOL_ERROR_LOG.yaml"
    write_sli_definitions "niche-program/research/_program/SLI_DEFINITIONS.yaml"
    write_credit_budget "niche-program/research/_program/CREDIT_BUDGET.yaml"
    set +e; output=$(python3 niche-program/research/_pipelines/generate-quality-dashboard --format text 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 0 (text format)" "$exit_code" 0
    if echo "$output" | grep -qi "DASHBOARD\|SUMMARY\|SLI\|COMPLIANCE"; then
        echo -e "  ${GREEN}PASS${NC} Text output contains expected headers"
        PASSED=$((PASSED + 1))
    else
        echo -e "  ${RED}FAIL${NC} Text output missing expected headers"
        FAILED=$((FAILED + 1))
    fi
    teardown

    # Test 5: --output FILE → file created
    echo -e "\n${YELLOW}[Test 5] --output FILE${NC}"
    setup
    cd "$TEST_ROOT"
    write_quality_metrics "niche-program/research/_program/QUALITY_METRICS.yaml"
    write_freshness_violations "niche-program/research/_program/FRESHNESS_VIOLATION_LOG.yaml"
    write_tool_errors "niche-program/research/_program/TOOL_ERROR_LOG.yaml"
    write_sli_definitions "niche-program/research/_program/SLI_DEFINITIONS.yaml"
    write_credit_budget "niche-program/research/_program/CREDIT_BUDGET.yaml"
    local out_file="$TEST_ROOT/test_dashboard_output.yaml"
    set +e; output=$(python3 niche-program/research/_pipelines/generate-quality-dashboard --output "$out_file" 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 0 (output file)" "$exit_code" 0
    if [ -f "$out_file" ] && [ -s "$out_file" ]; then
        echo -e "  ${GREEN}PASS${NC} Output file created and non-empty"
        PASSED=$((PASSED + 1))
    else
        echo -e "  ${RED}FAIL${NC} Output file missing or empty"
        FAILED=$((FAILED + 1))
    fi
    teardown

    # Test 6: --since NICHE_ID → filtered dashboard
    echo -e "\n${YELLOW}[Test 6] --since N-002${NC}"
    setup
    cd "$TEST_ROOT"
    write_quality_metrics "niche-program/research/_program/QUALITY_METRICS.yaml"
    write_freshness_violations "niche-program/research/_program/FRESHNESS_VIOLATION_LOG.yaml"
    write_tool_errors "niche-program/research/_program/TOOL_ERROR_LOG.yaml"
    write_sli_definitions "niche-program/research/_program/SLI_DEFINITIONS.yaml"
    write_credit_budget "niche-program/research/_program/CREDIT_BUDGET.yaml"
    set +e; output=$(python3 niche-program/research/_pipelines/generate-quality-dashboard --since N-002 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 0 (since filter)" "$exit_code" 0
    assert_json_field "verdict=GENERATED" "$output" "verdict" "GENERATED"
    teardown

    # Test 7: --dry-run → no output file created
    echo -e "\n${YELLOW}[Test 7] --dry-run${NC}"
    setup
    cd "$TEST_ROOT"
    write_quality_metrics "niche-program/research/_program/QUALITY_METRICS.yaml"
    write_freshness_violations "niche-program/research/_program/FRESHNESS_VIOLATION_LOG.yaml"
    write_tool_errors "niche-program/research/_program/TOOL_ERROR_LOG.yaml"
    write_sli_definitions "niche-program/research/_program/SLI_DEFINITIONS.yaml"
    write_credit_budget "niche-program/research/_program/CREDIT_BUDGET.yaml"
    local out_file2="$TEST_ROOT/dry_run_out.yaml"
    set +e; output=$(python3 niche-program/research/_pipelines/generate-quality-dashboard --output "$out_file2" --dry-run 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 0 (dry-run)" "$exit_code" 0
    if [ -f "$out_file2" ]; then
        echo -e "  ${RED}FAIL${NC} --dry-run: output file was created"
        FAILED=$((FAILED + 1))
    else
        echo -e "  ${GREEN}PASS${NC} --dry-run: no output file created"
        PASSED=$((PASSED + 1))
    fi
    teardown

    # Test 8: Empty data sources → NO_DATA markers
    echo -e "\n${YELLOW}[Test 8] Empty data sources${NC}"
    setup
    cd "$TEST_ROOT"
    # Create empty QUALITY_METRICS (minimal)
    cat > "niche-program/research/_program/QUALITY_METRICS.yaml" << YAML
last_updated: "2026-07-23"
cross_niche_summary: {}
per_data_type_staleness: {}
per_tool_errors: {}
per_niche_evidence: {}
per_niche_wall_clock: {}
YAML
    cat > "niche-program/research/_program/FRESHNESS_VIOLATION_LOG.yaml" << YAML
violations: []
YAML
    cat > "niche-program/research/_program/TOOL_ERROR_LOG.yaml" << YAML
errors: []
YAML
    cat > "niche-program/research/_program/SLI_DEFINITIONS.yaml" << YAML
slis: {}
alert_thresholds: {}
YAML
    write_credit_budget "niche-program/research/_program/CREDIT_BUDGET.yaml"
    set +e; output=$(python3 niche-program/research/_pipelines/generate-quality-dashboard 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 0 (empty data, no alerts)" "$exit_code" 0
    teardown

    # Test 9: Invalid --since format → exit 4
    echo -e "\n${YELLOW}[Test 9] Invalid --since format${NC}"
    setup
    cd "$TEST_ROOT"
    set +e; output=$(python3 niche-program/research/_pipelines/generate-quality-dashboard --since INVALID 2>&1 )
    exit_code=$?; set -e
    assert_exit_code "Exit 4 (INVALID_INPUT)" "$exit_code" 4
    teardown

    # Test 10: All source files missing → exit 2 (degraded)
    echo -e "\n${YELLOW}[Test 10] All source files missing${NC}"
    setup
    cd "$TEST_ROOT"
    set +e; output=$(python3 niche-program/research/_pipelines/generate-quality-dashboard 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 2 (degraded, no sources)" "$exit_code" 2
    teardown

    # Summary
    echo ""
    echo -e "${CYAN}============================================${NC}"
    echo -e "${CYAN}  Results: ${PASSED} passed, ${FAILED} failed, ${SKIPPED} skipped${NC}"
    echo -e "${CYAN}============================================${NC}"
    [ "$FAILED" -eq 0 ]
}

run_tests
