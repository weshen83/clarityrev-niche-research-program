#!/usr/bin/env bash
#
# test_clean_raw_fetches.sh — Integration tests for clean-raw-fetches pipeline script.
#
# Tests: clean old files, no old files, --dry-run, --older-than minimum,
# below-minimum, missing directories.
#
# Usage: bash test_clean_raw_fetches.sh [-v]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PIPELINES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CLEAN="$PIPELINES_DIR/clean-raw-fetches"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

PASSED=0
FAILED=0
SKIPPED=0

setup() {
    TEST_ROOT=$(mktemp -d "/tmp/clean-test-XXXXXX")
    mkdir -p "$TEST_ROOT/niche-program/research/_pipelines"
    mkdir -p "$TEST_ROOT/niche-program/research/_pipelines/lib"
    

    cp "$CLEAN" "$TEST_ROOT/niche-program/research/_pipelines/clean-raw-fetches"
    cp -r "$PIPELINES_DIR/lib"/. "$TEST_ROOT/niche-program/research/_pipelines/lib/"
    chmod +x "$TEST_ROOT/niche-program/research/_pipelines/clean-raw-fetches"

    # Initialize git repo so clean-raw-fetches can find the repo root
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
        echo "    Expected $field='$expected', got '$actual'"
        FAILED=$((FAILED + 1))
    fi
}

# ==============================================================================
# Tests
# ==============================================================================

run_tests() {
    echo -e "${CYAN}============================================${NC}"
    echo -e "${CYAN}  clean-raw-fetches integration tests${NC}"
    echo -e "${CYAN}============================================${NC}"

    # Test 1: Clean old files → CLEANED (exit 0)
    echo -e "\n${YELLOW}[Test 1] Clean old files${NC}"
    setup
    cd "$TEST_ROOT"
    # Create .firecrawl with files older than 30 days
    mkdir -p ".firecrawl/subdir"
    # Create a file with old mtime (60 days ago)
    touch -t "$(date -d '-60 days' +%Y%m%d%H%M.%S 2>/dev/null || echo '202505010000.00')" ".firecrawl/old-file.md" 2>/dev/null || true
    echo "old content" > ".firecrawl/old-file.md"
    # Force old mtime
    touch -t 202605010000.00 ".firecrawl/old-file.md" 2>/dev/null || true
    # Create a recent file (should not be cleaned)
    echo "new content" > ".firecrawl/new-file.md"
    set +e; output=$(python3 niche-program/research/_pipelines/clean-raw-fetches --older-than 30 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 0 (CLEANED)" "$exit_code" 0
    assert_json_field "verdict=CLEANED" "$output" "verdict" "CLEANED"
    teardown

    # Test 2: No old files → CLEANED (nothing to do)
    echo -e "\n${YELLOW}[Test 2] No old files${NC}"
    setup
    cd "$TEST_ROOT"
    mkdir -p ".firecrawl" ".dataforseo"
    echo "recent" > ".firecrawl/recent-file.md"
    set +e; output=$(python3 niche-program/research/_pipelines/clean-raw-fetches --older-than 30 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 0 (CLEANED - nothing old)" "$exit_code" 0
    teardown

    # Test 3: --dry-run → no deletions
    echo -e "\n${YELLOW}[Test 3] --dry-run${NC}"
    setup
    cd "$TEST_ROOT"
    mkdir -p ".firecrawl"
    echo "old content" > ".firecrawl/old-for-dryrun.md"
    touch -t 202605010000.00 ".firecrawl/old-for-dryrun.md" 2>/dev/null || true
    set +e; output=$(python3 niche-program/research/_pipelines/clean-raw-fetches --older-than 7 --dry-run 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 0 (dry-run)" "$exit_code" 0
    # Verify file still exists
    if [ -f ".firecrawl/old-for-dryrun.md" ]; then
        echo -e "  ${GREEN}PASS${NC} --dry-run: file not deleted"
        PASSED=$((PASSED + 1))
    else
        echo -e "  ${RED}FAIL${NC} --dry-run: file was deleted despite --dry-run"
        FAILED=$((FAILED + 1))
    fi
    teardown

    # Test 4: --older-than 7 (minimum valid)
    echo -e "\n${YELLOW}[Test 4] --older-than 7 (minimum)${NC}"
    setup
    cd "$TEST_ROOT"
    mkdir -p ".firecrawl"
    echo "old content" > ".firecrawl/old-7d.md"
    touch -t 202605010000.00 ".firecrawl/old-7d.md" 2>/dev/null || true
    set +e; output=$(python3 niche-program/research/_pipelines/clean-raw-fetches --older-than 7 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 0 (minimum 7)" "$exit_code" 0
    teardown

    # Test 5: --older-than 3 (below minimum) → INVALID_INPUT (exit 4)
    echo -e "\n${YELLOW}[Test 5] --older-than 3 (below minimum)${NC}"
    setup
    cd "$TEST_ROOT"
    set +e; output=$(python3 niche-program/research/_pipelines/clean-raw-fetches --older-than 3 2>&1 )
    exit_code=$?; set -e
    assert_exit_code "Exit 4 (INVALID_INPUT)" "$exit_code" 4
    teardown

    # Test 6: Missing directories → no error, exit 0 (WARNING/EMPTY)
    echo -e "\n${YELLOW}[Test 6] Missing directories${NC}"
    setup
    cd "$TEST_ROOT"
    # Don't create .firecrawl or .dataforseo directories
    # Must make sure git detects root correctly
    set +e; output=$(python3 niche-program/research/_pipelines/clean-raw-fetches 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 2 (missing dirs = EMPTY/WARNING)" "$exit_code" 2
    teardown

    # Test 7: Both dirs present, nothing to clean
    echo -e "\n${YELLOW}[Test 7] Both dirs empty${NC}"
    setup
    cd "$TEST_ROOT"
    mkdir -p ".firecrawl" ".dataforseo"
    set +e; output=$(python3 niche-program/research/_pipelines/clean-raw-fetches 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 0 (empty dirs)" "$exit_code" 0
    teardown

    # Test 8: Verify old files actually get removed
    echo -e "\n${YELLOW}[Test 8] Old files removed from disk${NC}"
    setup
    cd "$TEST_ROOT"
    mkdir -p ".firecrawl"
    echo "old content" > ".firecrawl/will-be-deleted.md"
    touch -t 202605010000.00 ".firecrawl/will-be-deleted.md" 2>/dev/null || true
    python3 niche-program/research/_pipelines/clean-raw-fetches --older-than 7 > /dev/null 2>&1 || true
    if [ ! -f ".firecrawl/will-be-deleted.md" ]; then
        echo -e "  ${GREEN}PASS${NC} Old file removed from disk"
        PASSED=$((PASSED + 1))
    else
        echo -e "  ${RED}FAIL${NC} Old file still on disk after clean"
        FAILED=$((FAILED + 1))
    fi
    teardown

    # Summary
    echo ""
    echo -e "${CYAN}============================================${NC}"
    echo -e "${CYAN}  Results: ${PASSED} passed, ${FAILED} failed, ${SKIPPED} skipped${NC}"
    echo -e "${CYAN}============================================${NC}"
    [ "$FAILED" -eq 0 ]
}

run_tests
