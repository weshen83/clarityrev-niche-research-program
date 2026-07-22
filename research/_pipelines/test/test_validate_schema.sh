#!/usr/bin/env bash
#
# test_validate_schema.sh — Integration tests for validate-schema pipeline script.
#
# Tests: valid competitor profile, missing required, invalid enum, rating out of range,
# missing optional fields, total_reviews mismatch, corrupted YAML, --dry-run, invalid DATA_TYPE.
#
# Usage: bash test_validate_schema.sh [-v]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PIPELINES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
VALIDATE="$PIPELINES_DIR/validate-schema"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

PASSED=0
FAILED=0
SKIPPED=0

setup() {
    TEST_ROOT=$(mktemp -d "/tmp/validate-test-XXXXXX")
    # We need schemas/ directory at the project root level (niche-program/)
    mkdir -p "$TEST_ROOT/niche-program/schemas"
    mkdir -p "$TEST_ROOT/niche-program/research/_pipelines"
    mkdir -p "$TEST_ROOT/niche-program/research/_pipelines/lib"
    

    # Copy validate-schema script and lib
    cp "$VALIDATE" "$TEST_ROOT/niche-program/research/_pipelines/validate-schema"
    cp -r "$PIPELINES_DIR/lib"/. "$TEST_ROOT/niche-program/research/_pipelines/lib/"
    chmod +x "$TEST_ROOT/niche-program/research/_pipelines/validate-schema"

    # Copy schema files from real schemas/ directory
    # PIPELINES_DIR = _pipelines/, schemas/ is at niche-program/schemas/
    # Relative: _pipelines/ -> ../ -> research/ -> ../../ -> niche-program/ -> ../../schemas/
    # Absolute: PIPELINES_DIR/../../schemas
    local real_schemas
    real_schemas="$(cd "$(dirname "$(realpath "$VALIDATE")")/../../schemas" && pwd)" || {
        echo "ERROR: Cannot find schemas directory"
        echo "  Tried: $(dirname "$(realpath "$VALIDATE")")/../../schemas"
        exit 1
    }
    cp "$real_schemas/"*.yaml "$TEST_ROOT/niche-program/schemas/"
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

make_competitor_profile() {
    local file="$1" variant="$2"
    mkdir -p "$(dirname "$file")"
    case "$variant" in
        valid)
            cat > "$file" << YAML
competitor_id: comp_syncgtm_v1
name: SyncGTM
url: "https://syncgtm.com"
fetch_date: "2026-07-01"
fetch_method: firecrawl_scrape
freshness_sla: "90d"
fresh_until: "2026-09-29"
freshness_status: FRESH
niches_where_relevant: []
source_urls:
  - url: "https://syncgtm.com"
    fetch_date: "2026-07-01"
    http_status: 200
    content_hash: "sha256:abc123"
    raw_file: ".firecrawl/syncgtm.md"
profile:
  funding: "VC-backed (\$5M Series A)"
  delivery_model: SOFTWARE
  gtm_motion: Sales-led
  estimated_customers: "500+ (G2 reviews: 150)"
  positioning_headline: "Revenue Intelligence for Modern GTM Teams"
  pricing:
    - tier: Growth
      price_monthly_eur: 1500
      billing: monthly
      source_url: "https://syncgtm.com/pricing"
      source_verified_date: "2026-07-01"
  strengths: ["Multi-source detection", "Rich integrations"]
  weaknesses: ["Pricing jumps at scale"]
  review_summary:
    total_reviews_analyzed: 25
    sources: ["G2 (15)", "Capterra (7)", "Reddit (3)"]
    avg_rating: 4.2
    top_praise: "Ease of use"
    top_complaint: "Pricing at scale"
  tech_stack:
    - category: "AI/LLM"
      tools: ["GPT-4", "Claude"]
      detection_method: dataforseo_domain_analytics
  vulnerabilities: ["No native HubSpot integration"]
YAML
            ;;
        missing_required)
            cat > "$file" << YAML
name: SyncGTM
url: "https://syncgtm.com"
fetch_date: "2026-07-01"
fetch_method: firecrawl_scrape
freshness_sla: "90d"
fresh_until: "2026-09-29"
freshness_status: FRESH
YAML
            ;;
        invalid_enum)
            cat > "$file" << YAML
competitor_id: comp_syncgtm_v1
name: SyncGTM
url: "https://syncgtm.com"
fetch_date: "2026-07-01"
fetch_method: invalid_method_xyz
freshness_sla: "90d"
fresh_until: "2026-09-29"
freshness_status: FRESH
niches_where_relevant: []
source_urls: []
profile:
  funding: "Bootstrapped"
  delivery_model: SOFTWARE
  gtm_motion: Self-serve
  estimated_customers: "100+"
  positioning_headline: "Test"
  pricing: []
  strengths: ["A"]
  weaknesses: ["B"]
  review_summary:
    total_reviews_analyzed: 0
    sources: []
    avg_rating: 0
    top_praise: ""
    top_complaint: ""
  tech_stack: []
  vulnerabilities: ["X"]
YAML
            ;;
        rating_out_of_range)
            cat > "$file" << YAML
competitor_id: comp_syncgtm_v1
name: SyncGTM
url: "https://syncgtm.com"
fetch_date: "2026-07-01"
fetch_method: firecrawl_scrape
freshness_sla: "90d"
fresh_until: "2026-09-29"
freshness_status: STALE
niches_where_relevant: []
source_urls:
  - url: "https://syncgtm.com"
    fetch_date: "2026-07-01"
    http_status: 200
    content_hash: "sha256:abc"
    raw_file: ".firecrawl/x.md"
profile:
  funding: "Bootstrapped"
  delivery_model: SOFTWARE
  gtm_motion: Self-serve
  estimated_customers: "100+"
  positioning_headline: "P"
  pricing:
    - tier: Growth
      price_monthly_eur: 1500
      billing: monthly
      source_url: "https://example.com"
      source_verified_date: "2026-07-01"
  strengths: ["A"]
  weaknesses: ["B"]
  review_summary:
    total_reviews_analyzed: 10
    sources: ["G2 (5)", "Capterra (3)", "Reddit (2)"]
    avg_rating: 4.0
    top_praise: "Good"
    top_complaint: "Bad"
  tech_stack:
    - category: AI
      tools: ["GPT-4"]
      detection_method: manual
  vulnerabilities: ["X"]
YAML
            ;;
        total_reviews_mismatch)
            cat > "$file" << YAML
competitor_id: comp_syncgtm_v1
name: SyncGTM
url: "https://syncgtm.com"
fetch_date: "2026-07-01"
fetch_method: firecrawl_scrape
freshness_sla: "90d"
fresh_until: "2026-09-29"
freshness_status: FRESH
niches_where_relevant: []
source_urls:
  - url: "https://syncgtm.com"
    fetch_date: "2026-07-01"
    http_status: 200
    content_hash: "sha256:abc"
    raw_file: ".firecrawl/x.md"
profile:
  funding: "Bootstrapped"
  delivery_model: SOFTWARE
  gtm_motion: Self-serve
  estimated_customers: "100+"
  positioning_headline: "P"
  pricing:
    - tier: Growth
      price_monthly_eur: 1500
      billing: monthly
      source_url: "https://example.com"
      source_verified_date: "2026-07-01"
  strengths: []
  weaknesses: ["B"]
  review_summary:
    total_reviews_analyzed: 10
    sources: ["G2 (5)", "Capterra (3)", "Reddit (2)"]
    avg_rating: 4.0
    top_praise: "Good"
    top_complaint: "Bad"
  tech_stack:
    - category: AI
      tools: ["GPT-4"]
      detection_method: manual
  vulnerabilities: ["X"]
YAML
            ;;
        corrupted)
            echo "broken: [yaml: {invalid" > "$file"
            ;;
    esac
}

# ==============================================================================
# Tests
# ==============================================================================

run_tests() {
    echo -e "${CYAN}============================================${NC}"
    echo -e "${CYAN}  validate-schema integration tests${NC}"
    echo -e "${CYAN}============================================${NC}"

    # Test 1: Valid competitor profile → PASS (exit 0)
    echo -e "\n${YELLOW}[Test 1] Valid competitor profile${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    make_competitor_profile "data/profile_valid.yaml" "valid"
    set +e; output=$(python3 research/_pipelines/validate-schema competitor-profile "data/profile_valid.yaml" 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 0 (PASS)" "$exit_code" 0
    teardown

    # Test 2: Missing required field → FAIL (exit 1)
    echo -e "\n${YELLOW}[Test 2] Missing required field${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    make_competitor_profile "data/profile_missing.yaml" "missing_required"
    set +e; output=$(python3 research/_pipelines/validate-schema competitor-profile "data/profile_missing.yaml" 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 1 (FAIL)" "$exit_code" 1
    assert_json_field "verdict=FAIL" "$output" "verdict" "FAIL"
    teardown

    # Test 3: Invalid enum value → FAIL (exit 1)
    echo -e "\n${YELLOW}[Test 3] Invalid enum value${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    make_competitor_profile "data/profile_enum.yaml" "invalid_enum"
    set +e; output=$(python3 research/_pipelines/validate-schema competitor-profile "data/profile_enum.yaml" 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 1 (FAIL)" "$exit_code" 1
    assert_json_field "verdict=FAIL" "$output" "verdict" "FAIL"
    teardown

    # Test 4: freshness_status inconsistent with fresh_until → FAIL (exit 1)
    echo -e "\n${YELLOW}[Test 4] freshness_status inconsistent${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    make_competitor_profile "data/profile_rating.yaml" "rating_out_of_range"
    set +e; output=$(python3 research/_pipelines/validate-schema competitor-profile "data/profile_rating.yaml" 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 1 (FAIL)" "$exit_code" 1
    teardown

    # Test 5: Empty strengths (custom rule violation) → FAIL (exit 1)
    echo -e "\n${YELLOW}[Test 5] Empty strengths${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    make_competitor_profile "data/profile_reviews.yaml" "total_reviews_mismatch"
    set +e; output=$(python3 research/_pipelines/validate-schema competitor-profile "data/profile_reviews.yaml" 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 1 (FAIL)" "$exit_code" 1
    teardown

    # Test 6: Corrupted YAML → INTERNAL_ERROR (exit 3)
    echo -e "\n${YELLOW}[Test 6] Corrupted YAML${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    make_competitor_profile "data/profile_corrupted.yaml" "corrupted"
    set +e; output=$(python3 research/_pipelines/validate-schema competitor-profile "data/profile_corrupted.yaml" 2>&1 )
    exit_code=$?; set -e
    assert_exit_code "Exit 3 (INTERNAL_ERROR)" "$exit_code" 3
    teardown

    # Test 7: --dry-run → no validation performed (exit 0, DRY_RUN verdict)
    echo -e "\n${YELLOW}[Test 7] --dry-run${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    make_competitor_profile "data/profile_dryrun.yaml" "valid"
    set +e; output=$(python3 research/_pipelines/validate-schema competitor-profile "data/profile_dryrun.yaml" --dry-run 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 0 (dry-run)" "$exit_code" 0
    assert_json_field "verdict=DRY_RUN" "$output" "verdict" "DRY_RUN"
    teardown

    # Test 8: Invalid DATA_TYPE → INVALID_INPUT (exit 4)
    echo -e "\n${YELLOW}[Test 8] Invalid DATA_TYPE${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    make_competitor_profile "data/profile_any.yaml" "valid"
    set +e; output=$(python3 research/_pipelines/validate-schema nonexistent-type "data/profile_any.yaml" 2>&1 )
    exit_code=$?; set -e
    assert_exit_code "Exit 4 (INVALID_INPUT)" "$exit_code" 4
    teardown

    # Test 9: File path outside project → INVALID_INPUT (exit 4)
    echo -e "\n${YELLOW}[Test 9] File outside project root${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    echo 'competitor_id: test' > /tmp/outside_project.yaml
    set +e; output=$(python3 research/_pipelines/validate-schema competitor-profile "/tmp/outside_project.yaml" 2>&1 )
    exit_code=$?; set -e
    assert_exit_code "Exit 4 (INVALID_INPUT)" "$exit_code" 4
    rm -f /tmp/outside_project.yaml
    teardown

    # Test 10: Valid review-corpus → PASS (exit 0)
    echo -e "\n${YELLOW}[Test 10] Valid review-corpus${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    mkdir -p "data"
    cat > "data/reviews_valid.yaml" << YAML
competitor_name: SyncGTM
fetch_date: "2026-07-01"
total_reviews: 5
sources:
  g2:
    count: 3
    url: "https://g2.com/p/syncgtm/reviews"
  capterra:
    count: 1
    url: "https://capterra.com/p/123/reviews"
  reddit:
    count: 1
    subreddits: ["r/RevOps"]
reviews:
  - review_id: rev_001
    source: g2
    source_url: "https://g2.com/r/1"
    rating: 5
    reviewer_role: "VP Sales"
    reviewer_company_size: "50-200"
    date: "2026-06-15"
    title: "Great"
    pros: "Easy"
    cons: "Could be cheaper"
    verbatim_quotes: ["Great product."]
theme_analysis:
  top_praise_themes:
    - theme: "Ease"
      frequency: 3
      pct: 60
  top_complaint_themes:
    - theme: "Price"
      frequency: 1
      pct: 20
YAML
    set +e; output=$(python3 research/_pipelines/validate-schema review-corpus "data/reviews_valid.yaml" 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 0 (PASS)" "$exit_code" 0
    teardown

    # Summary
    echo ""
    echo -e "${CYAN}============================================${NC}"
    echo -e "${CYAN}  Results: ${PASSED} passed, ${FAILED} failed, ${SKIPPED} skipped${NC}"
    echo -e "${CYAN}============================================${NC}"
    [ "$FAILED" -eq 0 ]
}

run_tests
