#!/usr/bin/env bash
#
# run_all_tests.sh — Master test runner for the ClarityRev Niche Pipeline.
#
# Runs all 6 test files in order:
#   1. test_pipeline_ops.py   (pytest unit tests)
#   2. test_preflight_check.sh
#   3. test_freshness_audit.sh
#   4. test_validate_schema.sh
#   5. test_clean_raw_fetches.sh
#   6. test_quality_dashboard.sh
#
# Reports: total tests, passed, failed, skipped.
# Exit 0 only if ALL pass.
# Colored output (green PASS, red FAIL, yellow SKIP).
# Captures Python tracebacks and script stderr for failed tests.
#
# Usage: bash run_all_tests.sh [-v]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

TOTAL=0
TOTAL_PASSED=0
TOTAL_FAILED=0
TOTAL_SKIPPED=0
FAILED_FILES=()

# ── Check prerequisites ───────────────────────────────────────────────────────

check_prereqs() {
    local missing=0
    for cmd in python3 pytest; do
        if ! command -v "$cmd" &>/dev/null; then
            echo -e "${RED}ERROR:${NC} '$cmd' not found. Install it first."
            missing=1
        fi
    done
    # Check ruamel.yaml
    if ! python3 -c "import ruamel.yaml" 2>/dev/null; then
        echo -e "${RED}ERROR:${NC} 'ruamel.yaml' not installed. Run: pip install ruamel.yaml"
        missing=1
    fi
    return "$missing"
}

# ── Banner ─────────────────────────────────────────────────────────────────────

print_banner() {
    echo ""
    echo -e "${CYAN}${BOLD}============================================================${NC}"
    echo -e "${CYAN}${BOLD}  ClarityRev Niche Pipeline — Master Test Suite${NC}"
    echo -e "${CYAN}${BOLD}============================================================${NC}"
    echo -e "  Date: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
    echo -e "  Scripts dir: ${SCRIPT_DIR}"
    echo ""
}

# ── Run a single test file and report ─────────────────────────────────────────

run_test_file() {
    local test_file="$1" label="$2"
    local pass=0 fail=0 skip=0

    echo ""
    echo -e "${YELLOW}${BOLD}[--- ${label} ---]${NC}"
    echo -e "${YELLOW}File: ${test_file}${NC}"

    local exit_code=0
    local output_file
    output_file=$(mktemp "/tmp/test-output-XXXXXX.txt")

    # Run the test file
    if [[ "$test_file" == *.py ]]; then
        # pytest: capture all output, parse counts
        set +e
        pytest "$test_file" -v --tb=short 2>&1 | tee "$output_file"
        exit_code=$?
        set -e
        # Parse pytest output for counts
        local summary_line
        summary_line=$(tail -3 "$output_file" | grep -E "passed|failed|error" || true)
        pass=$(echo "$summary_line" | grep -oP '\d+(?= passed)' | head -1 || echo "0")
        fail=$(echo "$summary_line" | grep -oP '\d+(?= failed)' | head -1 || echo "0")
        if [ "$exit_code" -ne 0 ] && [ "$fail" = "0" ]; then
            fail=1
        fi
    else
        # bash test script
        set +e
        bash "$test_file" 2>&1 | tee "$output_file"
        exit_code=$?
        set -e
        # Parse bash test output for PASS/FAIL counts from the "Results:" summary line
        local result_line
        result_line=$(grep -E "Results?:?\s+" "$output_file" | tail -1 || true)
        # Strip ANSI escape codes
        result_line=$(echo "$result_line" | sed 's/\x1b\[[0-9;]*m//g')
        if [[ "$result_line" =~ ([0-9]+)\ passed ]]; then
            pass="${BASH_REMATCH[1]}"
        else
            pass=$(grep -cP '^\s+PASS' "$output_file" 2>/dev/null || echo "0")
        fi
        if [[ "$result_line" =~ ([0-9]+)\ failed ]]; then
            fail="${BASH_REMATCH[1]}"
        else
            fail=$(grep -cP '^\s+FAIL' "$output_file" 2>/dev/null || echo "0")
        fi
        if [[ "$result_line" =~ ([0-9]+)\ skipped ]]; then
            skip="${BASH_REMATCH[1]}"
        fi
        # Sanitize: remove trailing non-numeric
        pass=$(echo "$pass" | grep -oP '^\d+' || echo "0")
        fail=$(echo "$fail" | grep -oP '^\d+' || echo "0")
        skip=$(echo "$skip" | grep -oP '^\d+' || echo "0")
    fi

    # Clean up output file
    rm -f "$output_file"

    # Accumulate
    TOTAL=$((TOTAL + pass + fail + skip))
    TOTAL_PASSED=$((TOTAL_PASSED + pass))
    TOTAL_FAILED=$((TOTAL_FAILED + fail))
    TOTAL_SKIPPED=$((TOTAL_SKIPPED + skip))

    if [ "$exit_code" -eq 0 ] && [ "$fail" -eq 0 ]; then
        echo -e "${GREEN}${BOLD}>> ${label}: ALL PASSED ($pass passed, $skip skipped)${NC}"
    else
        echo -e "${RED}${BOLD}>> ${label}: FAILED ($fail failures, $pass passed, $skip skipped)${NC}"
        FAILED_FILES+=("$label")
    fi
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════════════════

main() {
    if ! check_prereqs; then
        exit 1
    fi

    print_banner

    # Ensure all test scripts are executable
    for f in "$SCRIPT_DIR"/*.sh "$SCRIPT_DIR"/*.py; do
        [ -f "$f" ] && chmod +x "$f" 2>/dev/null || true
    done

    # ── 1. Pytest unit tests ──
    run_test_file "$SCRIPT_DIR/test_pipeline_ops.py" "pytest: pipeline_ops.py unit tests"

    # ── 2. Preflight-check ──
    run_test_file "$SCRIPT_DIR/test_preflight_check.sh" "bash: preflight-check integration"

    # ── 3. Freshness-audit ──
    run_test_file "$SCRIPT_DIR/test_freshness_audit.sh" "bash: freshness-audit integration"

    # ── 4. Validate-schema ──
    run_test_file "$SCRIPT_DIR/test_validate_schema.sh" "bash: validate-schema integration"

    # ── 5. Clean-raw-fetches ──
    run_test_file "$SCRIPT_DIR/test_clean_raw_fetches.sh" "bash: clean-raw-fetches integration"

    # ── 6. Quality dashboard ──
    run_test_file "$SCRIPT_DIR/test_quality_dashboard.sh" "bash: generate-quality-dashboard integration"

    # ── Summary ──
    echo -e "${CYAN}${BOLD}============================================================${NC}"
    echo -e "${CYAN}${BOLD}  FINAL RESULTS${NC}"
    echo -e "${CYAN}${BOLD}============================================================${NC}"
    echo -e "  Total tests:  ${BOLD}${TOTAL}${NC}"
    echo -e "  ${GREEN}Passed:       ${TOTAL_PASSED}${NC}"
    if [ "$TOTAL_FAILED" -gt 0 ]; then
        echo -e "  ${RED}Failed:       ${TOTAL_FAILED}${NC}"
    else
        echo -e "  ${GREEN}Failed:       ${TOTAL_FAILED}${NC}"
    fi
    echo -e "  ${YELLOW}Skipped:      ${TOTAL_SKIPPED}${NC}"
    echo ""

    if [ ${#FAILED_FILES[@]} -eq 0 ]; then
        echo -e "${GREEN}${BOLD}ALL TESTS PASSED${NC}"
        echo ""
        exit 0
    else
        echo -e "${RED}${BOLD}FAILED TEST FILES:${NC}"
        for f in "${FAILED_FILES[@]}"; do
            echo -e "  ${RED}- ${f}${NC}"
        done
        echo ""
        echo -e "${RED}${BOLD}Some tests failed. Fix the failures and re-run.${NC}"
        echo ""
        exit 1
    fi
}

main
