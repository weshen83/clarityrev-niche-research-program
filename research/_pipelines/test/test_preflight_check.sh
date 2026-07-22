#!/usr/bin/env bash
#
# test_preflight_check.sh — Integration tests for the preflight-check pipeline script.
#
# Google SRE pattern: test each exit path and verdict combination explicitly.
# Every test creates isolated temp directories and cleans up on exit.
#
# Usage: bash test_preflight_check.sh [-v]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PIPELINES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PIPELINES_DIR/../../.." && pwd)"
PREFLIGHT="$PIPELINES_DIR/preflight-check"

# --- Colors ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

PASSED=0
FAILED=0
SKIPPED=0

# --- Test harness ---
setup() {
    TEST_ROOT=$(mktemp -d "/tmp/preflight-test-XXXXXX")
    # Create required directory structure
    mkdir -p "$TEST_ROOT/niche-program/research/N-999/02-competitor-intel"
    mkdir -p "$TEST_ROOT/niche-program/research/N-999/04-voice-of-customer"
    mkdir -p "$TEST_ROOT/niche-program/research/_program"
    mkdir -p "$TEST_ROOT/niche-program/research/_pipelines"
    mkdir -p "$TEST_ROOT/niche-program/research/_pipelines/lib"
    mkdir -p "$TEST_ROOT/.firecrawl"
    mkdir -p "$TEST_ROOT/.dataforseo"

    # Link the preflight-check script and lib into our test pipelines dir
    cp "$PREFLIGHT" "$TEST_ROOT/niche-program/research/_pipelines/preflight-check"
    cp -r "$PIPELINES_DIR/lib"/. "$TEST_ROOT/niche-program/research/_pipelines/lib/"

    # Create default CREDIT_BUDGET.yaml
    cat > "$TEST_ROOT/niche-program/research/_program/CREDIT_BUDGET.yaml" << 'YAML'
firecrawl_remaining: 10000
dataforseo_remaining: 50.0
YAML

    chmod +x "$TEST_ROOT/niche-program/research/_pipelines/preflight-check"
}

teardown() {
    rm -rf "$TEST_ROOT"
}

assert_contains() {
    local label="$1" haystack="$2" needle="$3"
    if echo "$haystack" | grep -qF "$needle"; then
        echo -e "  ${GREEN}PASS${NC} $label"
        PASSED=$((PASSED + 1))
    else
        echo -e "  ${RED}FAIL${NC} $label"
        echo "    Expected to find: $needle"
        echo "    In output: $haystack"
        FAILED=$((FAILED + 1))
    fi
}

assert_exit_code() {
    local label="$1" actual="$2" expected="$3"
    if [ "$actual" -eq "$expected" ]; then
        echo -e "  ${GREEN}PASS${NC} $label"
        PASSED=$((PASSED + 1))
    else
        echo -e "  ${RED}FAIL${NC} $label"
        echo "    Expected exit $expected, got $actual"
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

# --- Traps ---
trap teardown EXIT

# --- Clean before failing fast exit ---
clean_exit() {
    local code=$1
    trap - EXIT
    teardown
    exit "$code"
}

# ==============================================================================
# Tests
# ==============================================================================

run_tests() {
    echo -e "${CYAN}============================================${NC}"
    echo -e "${CYAN}  preflight-check integration tests${NC}"
    echo -e "${CYAN}============================================${NC}"

    # ---------------------------------------------------------------
    # Test 1: Fresh cache hit → exit 0, verdict=SKIP_CACHE_HIT
    # ---------------------------------------------------------------
    echo -e "\n${YELLOW}[Test 1] Fresh cache hit${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    local now
    now=$(date -u +%Y-%m-%d)
    # Create a fresh cache manifest with a valid cache entry
    # First compute url hash for our target url
    local url_hash
    url_hash=$(python3 -c "
import hashlib, sys
sys.path.insert(0, 'research/_pipelines')
from lib.pipeline_ops import normalize_url
url = normalize_url('https://syncgtm.com/pricing')
print('sha256:' + hashlib.sha256(url.encode()).hexdigest())
")
    # Create the structured data file with today's fetch_date
    mkdir -p "research/N-999/02-competitor-intel"
    cat > "research/N-999/02-competitor-intel/N-999-competitor-pricing-syncgtm-v1.yaml" << YAML
competitor_id: comp_syncgtm_v1
fetch_date: "$now"
name: SyncGTM
YAML
    # Compute its content hash
    local content_hash
    content_hash=$(python3 -c "
import hashlib
h = hashlib.sha256(open('research/N-999/02-competitor-intel/N-999-competitor-pricing-syncgtm-v1.yaml','rb').read()).hexdigest()
print('sha256:'+h)
")
    # Write CACHE_MANIFEST.yaml
    cat > "research/_pipelines/CACHE_MANIFEST.yaml" << YAML
entries:
  $url_hash:
    structured_file: N-999/02-competitor-intel/N-999-competitor-pricing-syncgtm-v1.yaml
    fetch_date: "$now"
    content_hash: "$content_hash"
YAML
    local output
    set +e; output=$(python3 research/_pipelines/preflight-check N-999 competitor-pricing --target-url "https://syncgtm.com/pricing" 2>/dev/null )
    local exit_code=$?; set -e
    assert_exit_code "Exit code 0" "$exit_code" 0
    assert_json_field "verdict=SKIP_CACHE_HIT" "$output" "verdict" "SKIP_CACHE_HIT"
    assert_json_field "cache_status=HIT" "$output" "cache_status" "HIT"
    teardown

    # ---------------------------------------------------------------
    # Test 2: Stale cache → exit 0, cache_status=STALE
    # ---------------------------------------------------------------
    echo -e "\n${YELLOW}[Test 2] Stale cache${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    local past
    past=$(date -u -d "-400 days" +%Y-%m-%d 2>/dev/null || date -u -v-400d +%Y-%m-%d)
    url_hash=$(python3 -c "
import hashlib, sys
sys.path.insert(0, 'research/_pipelines')
from lib.pipeline_ops import normalize_url
url = normalize_url('https://old-data.example.com/report')
print('sha256:' + hashlib.sha256(url.encode()).hexdigest())
")
    # Create the stale data file
    cat > "research/N-999/stale-data-v1.yaml" << YAML
fetch_date: "$past"
name: Stale Report
YAML
    content_hash=$(python3 -c "import hashlib; h=hashlib.sha256(open('research/N-999/stale-data-v1.yaml','rb').read()).hexdigest(); print('sha256:'+h)")
    cat > "research/_pipelines/CACHE_MANIFEST.yaml" << YAML
entries:
  $url_hash:
    structured_file: N-999/stale-data-v1.yaml
    fetch_date: "$past"
    content_hash: "$content_hash"
YAML
    set +e; output=$(python3 research/_pipelines/preflight-check N-999 competitor-pricing --target-url "https://old-data.example.com/report" 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit code 0 (stale = proceed)" "$exit_code" 0
    assert_json_field "cache_status=STALE" "$output" "cache_status" "STALE"
    teardown

    # ---------------------------------------------------------------
    # Test 3: Insufficient credits → exit 1, verdict=BLOCKED_CREDITS
    # ---------------------------------------------------------------
    echo -e "\n${YELLOW}[Test 3] Insufficient credits${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    # Set very low credits
    cat > "research/_program/CREDIT_BUDGET.yaml" << YAML
firecrawl_remaining: 1
dataforseo_remaining: 0.0
YAML
    set +e; output=$(python3 research/_pipelines/preflight-check N-999 competitor-pricing --target-url "https://example.com" 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit code 1 (BLOCKED)" "$exit_code" 1
    assert_json_field "verdict=BLOCKED_CREDITS" "$output" "verdict" "BLOCKED_CREDITS"
    teardown

    # ---------------------------------------------------------------
    # Test 4: Dead host → exit 1, verdict=BLOCKED_DEAD_HOST
    # ---------------------------------------------------------------
    echo -e "\n${YELLOW}[Test 4] Dead host${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    # Create DEAD_HOST_REGISTRY.yaml
    cat > "research/_program/DEAD_HOST_REGISTRY.yaml" << YAML
blocked_hosts:
  - host: dead-site.example.com
    reason: Consistent 503 errors
YAML
    set +e; output=$(python3 research/_pipelines/preflight-check N-999 competitor-pricing --target-url "https://dead-site.example.com/pricing" 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit code 1 (BLOCKED)" "$exit_code" 1
    assert_json_field "verdict=BLOCKED_DEAD_HOST" "$output" "verdict" "BLOCKED_DEAD_HOST"
    teardown

    # ---------------------------------------------------------------
    # Test 5: No --target-url → legacy file-pattern fallback (exit 0)
    # ---------------------------------------------------------------
    echo -e "\n${YELLOW}[Test 5] Legacy file-pattern fallback${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    local future
    future=$(date -u -d "+30 days" +%Y-%m-%d 2>/dev/null || date -u -v+30d +%Y-%m-%d)
    # Create a data file matching the legacy pattern
    cat > "research/N-999/02-competitor-intel/_N-999-competitor-pricing-syncgtm-v1.yaml" << YAML
fetch_date: "$future"
competitor_id: comp_syncgtm_v1
YAML
    set +e; output=$(python3 research/_pipelines/preflight-check N-999 competitor-pricing 2>/dev/null )
    exit_code=$?; set -e
    # Should exit 0 (skip cache hit from legacy pattern)
    assert_exit_code "Exit code 0 (legacy hit)" "$exit_code" 0
    assert_json_field "verdict=SKIP_CACHE_HIT" "$output" "verdict" "SKIP_CACHE_HIT"
    teardown

    # ---------------------------------------------------------------
    # Test 6: Corrupted CACHE_MANIFEST.yaml → exit 3 (INTERNAL_ERROR)
    # ---------------------------------------------------------------
    echo -e "\n${YELLOW}[Test 6] Corrupted CACHE_MANIFEST.yaml${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    echo "{invalid: [yaml: broken" > "research/_pipelines/CACHE_MANIFEST.yaml"
    set +e; output=$(python3 research/_pipelines/preflight-check N-999 competitor-pricing --target-url "https://example.com" 2>&1 )
    exit_code=$?; set -e
    assert_exit_code "Exit code 3 (INTERNAL_ERROR)" "$exit_code" 3
    teardown

    # ---------------------------------------------------------------
    # Test 7: Corrupted CREDIT_BUDGET.yaml → exit 3 (INTERNAL_ERROR)
    # ---------------------------------------------------------------
    echo -e "\n${YELLOW}[Test 7] Corrupted CREDIT_BUDGET.yaml${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    echo "broken: [yaml" > "research/_program/CREDIT_BUDGET.yaml"
    set +e; output=$(python3 research/_pipelines/preflight-check N-999 competitor-pricing --target-url "https://example.com" 2>&1 )
    exit_code=$?; set -e
    assert_exit_code "Exit code 3 (INTERNAL_ERROR)" "$exit_code" 3
    teardown

    # ---------------------------------------------------------------
    # Test 8: --dry-run → no mutation to CACHE_MANIFEST.yaml
    # ---------------------------------------------------------------
    echo -e "\n${YELLOW}[Test 8] --dry-run no mutation${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    # Start with empty manifest
    cat > "research/_pipelines/CACHE_MANIFEST.yaml" << YAML
entries: {}
YAML
    # Dry run — should not create any new entries
    python3 research/_pipelines/preflight-check N-999 competitor-pricing --target-url "https://example.com" --dry-run > /dev/null 2>&1 || true
    # Check manifest is unchanged
    local manifest_content
    manifest_content=$(cat "research/_pipelines/CACHE_MANIFEST.yaml")
    if echo "$manifest_content" | grep -q "^entries: {}"; then
        echo -e "  ${GREEN}PASS${NC} --dry-run: manifest not mutated"
        PASSED=$((PASSED + 1))
    else
        echo -e "  ${RED}FAIL${NC} --dry-run: manifest was mutated"
        echo "    Manifest: $manifest_content"
        FAILED=$((FAILED + 1))
    fi
    teardown

    # ---------------------------------------------------------------
    # Test 9: Orphaned manifest entry → auto-clean
    # ---------------------------------------------------------------
    echo -e "\n${YELLOW}[Test 9] Orphaned manifest entry auto-clean${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    # Create manifest with entry pointing to non-existent file
    # Compute the correct URL hash so preflight-check can find the entry
    local orphan_url_hash
    orphan_url_hash=$(python3 -c "
import hashlib, sys
sys.path.insert(0, 'research/_pipelines')
from lib.pipeline_ops import normalize_url
url = normalize_url('https://orphaned.example.com')
print('sha256:' + hashlib.sha256(url.encode()).hexdigest())
")
    cat > "research/_pipelines/CACHE_MANIFEST.yaml" << YAML
entries:
  $orphan_url_hash:
    structured_file: N-999/nonexistent-file.yaml
    fetch_date: "2026-01-01"
YAML
    set +e; output=$(python3 research/_pipelines/preflight-check N-999 competitor-pricing --target-url "https://orphaned.example.com" 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit code 0 (orphan cleaned, proceed)" "$exit_code" 0
    # Verify the orphaned entry was removed from manifest
    manifest_after=$(cat "research/_pipelines/CACHE_MANIFEST.yaml")
    if echo "$manifest_after" | grep -q "nonexistent-file"; then
        echo -e "  ${RED}FAIL${NC} Orphaned entry still in manifest after clean"
        FAILED=$((FAILED + 1))
    else
        echo -e "  ${GREEN}PASS${NC} Orphaned entry removed from manifest"
        PASSED=$((PASSED + 1))
    fi
    teardown

    # ---------------------------------------------------------------
    # Test 10: Invalid NICHE_ID → exit 4 (INVALID_INPUT)
    # ---------------------------------------------------------------
    echo -e "\n${YELLOW}[Test 10] Invalid NICHE_ID${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    set +e; output=$(python3 research/_pipelines/preflight-check BAD-123 competitor-pricing --target-url "https://example.com" 2>&1 )
    exit_code=$?; set -e
    assert_exit_code "Exit code 4 (INVALID_INPUT)" "$exit_code" 4
    teardown

    # ---------------------------------------------------------------
    # Test 11: Malformed URL in --target-url → exit 4 (INVALID_INPUT)
    # ---------------------------------------------------------------
    echo -e "\n${YELLOW}[Test 11] Malformed URL${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    set +e; output=$(python3 research/_pipelines/preflight-check N-999 competitor-pricing --target-url "not-a-url" 2>&1 )
    exit_code=$?; set -e
    assert_exit_code "Exit code 4 (INVALID_INPUT)" "$exit_code" 4
    teardown

    # ---------------------------------------------------------------
    # Test 12: Missing CREDIT_BUDGET.yaml → exit 3 (INTERNAL_ERROR)
    # ---------------------------------------------------------------
    echo -e "\n${YELLOW}[Test 12] Missing CREDIT_BUDGET${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    rm -f "research/_program/CREDIT_BUDGET.yaml"
    set +e; output=$(python3 research/_pipelines/preflight-check N-999 competitor-pricing --target-url "https://example.com" 2>&1 )
    exit_code=$?; set -e
    assert_exit_code "Exit code 3 (INTERNAL_ERROR)" "$exit_code" 3
    teardown

    # ---------------------------------------------------------------
    # Test 13: Primary tool in dead-host registry → WARNING, not BLOCKED
    # ---------------------------------------------------------------
    echo -e "\n${YELLOW}[Test 13] Primary tool dead-host warning${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    cat > "research/_program/DEAD_HOST_REGISTRY.yaml" << YAML
blocked_hosts:
  - host: api.firecrawl.dev
    reason: Test primary tool block
YAML
    set +e; output=$(python3 research/_pipelines/preflight-check N-999 competitor-pricing --target-url "https://api.firecrawl.dev/v1/scrape" 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit code 2 (WARNING for primary tool)" "$exit_code" 2
    assert_json_field "dead_host_check=WARNING" "$output" "dead_host_check" "WARNING"
    teardown

    # ---------------------------------------------------------------
    # Summary
    # ---------------------------------------------------------------
    echo ""
    echo -e "${CYAN}============================================${NC}"
    echo -e "${CYAN}  Results: ${PASSED} passed, ${FAILED} failed, ${SKIPPED} skipped${NC}"
    echo -e "${CYAN}============================================${NC}"
    [ "$FAILED" -eq 0 ]
}

run_tests
