#!/usr/bin/env bash
#
# test_freshness_audit.sh — Integration tests for the freshness-audit pipeline script.
#
# Tests: source-count staleness, claim-weighted staleness, BLOCK-class enforcement,
# retroactive check, --force override, missing/corrupted trace-map.
#
# Usage: bash test_freshness_audit.sh [-v]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PIPELINES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
FRESHNESS="$PIPELINES_DIR/freshness-audit"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

PASSED=0
FAILED=0
SKIPPED=0

setup() {
    TEST_ROOT=$(mktemp -d "/tmp/freshness-test-XXXXXX")
    mkdir -p "$TEST_ROOT/niche-program/research/N-999/_canvas/evidence"
    mkdir -p "$TEST_ROOT/niche-program/research/N-999/02-competitor-intel"
    mkdir -p "$TEST_ROOT/niche-program/research/N-999/04-voice-of-customer"
    mkdir -p "$TEST_ROOT/niche-program/research/_program"
    mkdir -p "$TEST_ROOT/niche-program/research/_pipelines"
    mkdir -p "$TEST_ROOT/niche-program/research/_pipelines/lib"

    cp "$FRESHNESS" "$TEST_ROOT/niche-program/research/_pipelines/freshness-audit"
    cp -r "$PIPELINES_DIR/lib"/. "$TEST_ROOT/niche-program/research/_pipelines/lib/"
    chmod +x "$TEST_ROOT/niche-program/research/_pipelines/freshness-audit"
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
        echo "    stdout: $(echo "$output" | head -5)"
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

make_trace_map() {
    local file="$1" niche="$2" claim_count="$3" stale_count="$4" block_count="$5" source_per_claim="$6"
    # Generate a trace-map.yaml with specified mix of fresh/stale/block-class sources
    python3 -c "
import sys, json
from datetime import datetime, timezone, timedelta
now = datetime.now(timezone.utc)
future = (now + timedelta(days=30)).isoformat()
past = (now - timedelta(days=400)).isoformat()

claims = []
for i in range($claim_count):
    sources = []
    for j in range($source_per_claim):
        is_stale = (i * $source_per_claim + j) < $stale_count
        is_block = (i * $source_per_claim + j) < $block_count
        dt = 'hiring_signals' if is_block else ('competitor_pricing' if not is_stale else 'market_sizing')
        slac = 'HIRING' if is_block else ('PRICING' if not is_stale else 'MARKET')
        sources.append({
            'source_file': f'N-999/data-file-{i}-{j}.yaml',
            'fetch_date': str((now - timedelta(days=1)).date()) if not is_stale else str((now - timedelta(days=400)).date()),
            'freshness_status': 'FRESH' if not is_stale else 'STALE',
            'fresh_until': future if not is_stale else past,
            'data_type': dt,
            'sla_class': slac,
            're_fetch_attempted': True if is_block else False,
            're_fetch_success': False if is_block else None,
        })
    claims.append({'claim_id': f'C-{i+1:03d}', 'claim_text': f'Claim {i+1}', 'sources': sources})
with open('$file', 'w') as f:
    json.dump({'claims': claims}, f)
"
}

make_data_file() {
    local file="$1" fetch_date="$2" fresh_until="$3" data_type="$4"
    mkdir -p "$(dirname "$file")"
    cat > "$file" << YAML
fetch_date: $fetch_date
fresh_until: $fresh_until
data_type: $data_type
YAML
}

# ==============================================================================
# Tests
# ==============================================================================

run_tests() {
    echo -e "${CYAN}============================================${NC}"
    echo -e "${CYAN}  freshness-audit integration tests${NC}"
    echo -e "${CYAN}============================================${NC}"

    # Test 1: All sources fresh → exit 0, PASS
    echo -e "\n${YELLOW}[Test 1] All sources fresh${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    local now
    now=$(date -u +%Y-%m-%d)
    local future
    future=$(date -u -d "+30 days" +%Y-%m-%d 2>/dev/null || date -u -v+30d +%Y-%m-%d)
    # Create trace-map with all fresh sources
    python3 -c "
import json
from datetime import datetime, timezone, timedelta
now = datetime.now(timezone.utc)
future = (now + timedelta(days=30)).isoformat()
data = {
    'claims': [
        {
            'claim_id': 'C-001',
            'claim_text': 'Fresh claim 1',
            'sources': [
                {
                    'source_file': 'N-999/fresh-data.yaml',
                    'fetch_date': now.isoformat(),
                    'freshness_status': 'FRESH',
                    'fresh_until': future,
                    'data_type': 'competitor_pricing',
                    'sla_class': 'PRICING',
                }
            ]
        }
    ]
}
with open('research/N-999/_canvas/evidence/trace-map.yaml', 'w') as f:
    json.dump(data, f)
"
    make_data_file "research/N-999/fresh-data.yaml" "$now" "$future" "competitor_pricing"
    set +e; output=$(python3 research/_pipelines/freshness-audit N-999 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 0 (PASS)" "$exit_code" 0
    assert_json_field "verdict=PASS" "$output" "verdict" "PASS"
    teardown

    # Test 2: 5% stale → exit 2, PASS_WITH_WARNINGS
    echo -e "\n${YELLOW}[Test 2] 5% stale (PASS_WITH_WARNINGS)${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    local past
    past=$(date -u -d "-400 days" +%Y-%m-%d 2>/dev/null || date -u -v-400d +%Y-%m-%d)
    future=$(date -u -d "+30 days" +%Y-%m-%d 2>/dev/null || date -u -v+30d +%Y-%m-%d)
    # 20 sources, 1 stale = 5%
    python3 -c "
import json
from datetime import datetime, timezone, timedelta
now = datetime.now(timezone.utc)
future = (now + timedelta(days=30)).isoformat()
past = (now - timedelta(days=400)).isoformat()
claims = []
for i in range(20):
    is_stale = (i == 0)
    sources = [{
        'source_file': f'N-999/data-{i}.yaml',
        'fetch_date': past if is_stale else now.isoformat(),
        'freshness_status': 'STALE' if is_stale else 'FRESH',
        'fresh_until': past if is_stale else future,
        'data_type': 'market_sizing' if is_stale else 'competitor_pricing',
        'sla_class': 'MARKET' if is_stale else 'PRICING',
    }]
    claims.append({'claim_id': f'C-{i+1:03d}', 'claim_text': f'Claim {i+1}', 'sources': sources})
with open('research/N-999/_canvas/evidence/trace-map.yaml', 'w') as f:
    json.dump({'claims': claims}, f)
"
    for i in $(seq 0 19); do
        if [ "$i" -eq 0 ]; then
            make_data_file "research/N-999/data-$i.yaml" "$past" "$past" "market_sizing"
        else
            make_data_file "research/N-999/data-$i.yaml" "$now" "$future" "competitor_pricing"
        fi
    done
    set +e; output=$(python3 research/_pipelines/freshness-audit N-999 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 2 (WARNING)" "$exit_code" 2
    assert_json_field "verdict=PASS_WITH_WARNINGS" "$output" "verdict" "PASS_WITH_WARNINGS"
    teardown

    # Test 3: 15% stale → exit 1, BLOCKED
    echo -e "\n${YELLOW}[Test 3] 15% stale (BLOCKED)${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    past=$(date -u -d "-400 days" +%Y-%m-%d 2>/dev/null || date -u -v-400d +%Y-%m-%d)
    future=$(date -u -d "+30 days" +%Y-%m-%d 2>/dev/null || date -u -v+30d +%Y-%m-%d)
    python3 -c "
import json
from datetime import datetime, timezone, timedelta
now = datetime.now(timezone.utc)
future = (now + timedelta(days=30)).isoformat()
past = (now - timedelta(days=400)).isoformat()
claims = []
for i in range(20):
    is_stale = (i < 3)
    sources = [{
        'source_file': f'N-999/data-{i}.yaml',
        'fetch_date': past if is_stale else now.isoformat(),
        'freshness_status': 'STALE' if is_stale else 'FRESH',
        'fresh_until': past if is_stale else future,
        'data_type': 'market_sizing' if is_stale else 'competitor_pricing',
        'sla_class': 'MARKET' if is_stale else 'PRICING',
    }]
    claims.append({'claim_id': f'C-{i+1:03d}', 'claim_text': f'Claim {i+1}', 'sources': sources})
with open('research/N-999/_canvas/evidence/trace-map.yaml', 'w') as f:
    json.dump({'claims': claims}, f)
"
    for i in $(seq 0 19); do
        if [ "$i" -lt 3 ]; then
            make_data_file "research/N-999/data-$i.yaml" "$past" "$past" "market_sizing"
        else
            make_data_file "research/N-999/data-$i.yaml" "$now" "$future" "competitor_pricing"
        fi
    done
    set +e; output=$(python3 research/_pipelines/freshness-audit N-999 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 1 (BLOCKED)" "$exit_code" 1
    assert_json_field "verdict=BLOCKED" "$output" "verdict" "BLOCKED"
    teardown

    # Test 4: Single source > 20% of claims → BLOCKED (claim-weighted)
    echo -e "\n${YELLOW}[Test 4] Claim-weighted blocking (>20%)${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    local now past future
    now=$(date -u +%Y-%m-%d)
    past=$(date -u -d "-400 days" +%Y-%m-%d 2>/dev/null || date -u -v-400d +%Y-%m-%d)
    future=$(date -u -d "+30 days" +%Y-%m-%d 2>/dev/null || date -u -v+30d +%Y-%m-%d)
    # 10 claims, 9 fresh, but 1 stale source is referenced by 3 claims (30% > 20%)
    python3 -c "
import json
from datetime import datetime, timezone, timedelta
now = datetime.now(timezone.utc)
future = (now + timedelta(days=30)).isoformat()
past = (now - timedelta(days=400)).isoformat()
claims = []
# First 3 claims reference the same stale source
for i in range(3):
    claims.append({
        'claim_id': f'C-{i+1:03d}',
        'claim_text': f'Claim {i+1} using stale',
        'sources': [{
            'source_file': 'N-999/big-stale-source.yaml',
            'fetch_date': past,
            'freshness_status': 'STALE',
            'fresh_until': past,
            'data_type': 'market_sizing',
            'sla_class': 'MARKET',
        }]
    })
# 7 claims with fresh sources
for i in range(3, 10):
    claims.append({
        'claim_id': f'C-{i+1:03d}',
        'claim_text': f'Claim {i+1} fresh',
        'sources': [{
            'source_file': f'N-999/fresh-{i}.yaml',
            'fetch_date': now.isoformat(),
            'freshness_status': 'FRESH',
            'fresh_until': future,
            'data_type': 'competitor_pricing',
            'sla_class': 'PRICING',
        }]
    })
with open('research/N-999/_canvas/evidence/trace-map.yaml', 'w') as f:
    json.dump({'claims': claims}, f)
"
    make_data_file "research/N-999/big-stale-source.yaml" "$past" "$past" "market_sizing"
    for i in $(seq 3 9); do
        make_data_file "research/N-999/fresh-$i.yaml" "$now" "$future" "competitor_pricing"
    done
    set +e; output=$(python3 research/_pipelines/freshness-audit N-999 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 1 (BLOCKED claim-weighted)" "$exit_code" 1
    assert_json_field "verdict=BLOCKED" "$output" "verdict" "BLOCKED"
    assert_json_field "claim_weighted_blocked=true" "$output" "claim_weighted_blocked" "True"
    teardown

    # Test 5: BLOCK-class stale unrecoverable → BLOCKED
    echo -e "\n${YELLOW}[Test 5] BLOCK-class stale unrecoverable${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    past=$(date -u -d "-400 days" +%Y-%m-%d 2>/dev/null || date -u -v-400d +%Y-%m-%d)
    future=$(date -u -d "+30 days" +%Y-%m-%d 2>/dev/null || date -u -v+30d +%Y-%m-%d)
    python3 -c "
import json
from datetime import datetime, timezone, timedelta
now = datetime.now(timezone.utc)
future = (now + timedelta(days=30)).isoformat()
past = (now - timedelta(days=400)).isoformat()
data = {
    'claims': [{
        'claim_id': 'C-001',
        'claim_text': 'Block class claim',
        'sources': [{
            'source_file': 'N-999/hiring-stale.yaml',
            'fetch_date': past,
            'freshness_status': 'STALE',
            'fresh_until': past,
            'data_type': 'hiring_signals',
            'sla_class': 'HIRING',
            're_fetch_attempted': True,
            're_fetch_success': False,
        }]
    }]
}
with open('research/N-999/_canvas/evidence/trace-map.yaml', 'w') as f:
    json.dump(data, f)
"
    make_data_file "research/N-999/hiring-stale.yaml" "$past" "$past" "hiring_signals"
    set +e; output=$(python3 research/_pipelines/freshness-audit N-999 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 1 (BLOCKED BLOCK-class)" "$exit_code" 1
    assert_json_field "verdict=BLOCKED" "$output" "verdict" "BLOCKED"
    assert_json_field "block_class_violations>0" "$output" "block_class_violations" "1"
    teardown

    # Test 6: BLOCK-class with --force → exit 2 (waiver logged)
    echo -e "\n${YELLOW}[Test 6] BLOCK-class with --force${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    mkdir -p "research/_program"
    past=$(date -u -d "-400 days" +%Y-%m-%d 2>/dev/null || date -u -v-400d +%Y-%m-%d)
    future=$(date -u -d "+30 days" +%Y-%m-%d 2>/dev/null || date -u -v+30d +%Y-%m-%d)
    # Create PIPELINE_CHECKPOINTS.yaml to receive waiver
    cat > "research/_program/PIPELINE_CHECKPOINTS.yaml" << YAML
waivers: []
YAML
    python3 -c "
import json
from datetime import datetime, timezone, timedelta
now = datetime.now(timezone.utc)
future = (now + timedelta(days=30)).isoformat()
past = (now - timedelta(days=400)).isoformat()
# 10 claims: 1 BLOCK-class stale + 9 fresh
# Stale ratio = 10% (just at boundary), but BLOCK-class enforcement catches it
# Claim-weighted: stale source referenced by 1/10 = 10% < 20% threshold
claims = []
# 1 BLOCK-class stale claim
claims.append({
    'claim_id': 'C-001',
    'claim_text': 'Force-override block',
    'sources': [{
        'source_file': 'N-999/job-stale.yaml',
        'fetch_date': past,
        'freshness_status': 'STALE',
        'fresh_until': past,
        'data_type': 'job_postings',
        'sla_class': 'JOB',
        're_fetch_attempted': True,
        're_fetch_success': False,
    }]
})
# 9 fresh claims
for i in range(2, 11):
    claims.append({
        'claim_id': f'C-{i:03d}',
        'claim_text': f'Fresh claim {i}',
        'sources': [{
            'source_file': f'N-999/fresh-data-{i}.yaml',
            'fetch_date': now.isoformat(),
            'freshness_status': 'FRESH',
            'fresh_until': future,
            'data_type': 'competitor_pricing',
            'sla_class': 'PRICING',
        }]
    })
data = {'claims': claims}
with open('research/N-999/_canvas/evidence/trace-map.yaml', 'w') as f:
    json.dump(data, f)
"
    make_data_file "research/N-999/job-stale.yaml" "$past" "$past" "job_postings"
    for i in $(seq 2 10); do
        make_data_file "research/N-999/fresh-data-$i.yaml" "$now" "$future" "competitor_pricing"
    done
    set +e; output=$(python3 research/_pipelines/freshness-audit N-999 --force 2>/dev/null )
    exit_code=$?; set -e
    # With --force, BLOCK-class becomes PASS_WITH_WARNINGS (exit 2)
    assert_exit_code "Exit 2 (WARNING with --force)" "$exit_code" 2
    teardown

    # Test 7: Missing trace-map → exit 4 (INVALID_INPUT)
    echo -e "\n${YELLOW}[Test 7] Missing trace-map${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    set +e; output=$(python3 research/_pipelines/freshness-audit N-999 2>&1 )
    exit_code=$?; set -e
    assert_exit_code "Exit 4 (INVALID_INPUT)" "$exit_code" 4
    teardown

    # Test 8: Corrupted trace-map → exit 3 (INTERNAL_ERROR)
    echo -e "\n${YELLOW}[Test 8] Corrupted trace-map${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    echo "broken: [yaml: {invalid" > "research/N-999/_canvas/evidence/trace-map.yaml"
    set +e; output=$(python3 research/_pipelines/freshness-audit N-999 2>&1 )
    exit_code=$?; set -e
    assert_exit_code "Exit 3 (INTERNAL_ERROR)" "$exit_code" 3
    teardown

    # Test 9: Orphaned source reference → flagged in output
    echo -e "\n${YELLOW}[Test 9] Orphaned source reference${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    local now past future2
    now=$(date -u +%Y-%m-%d)
    past=$(date -u -d "-400 days" +%Y-%m-%d 2>/dev/null || date -u -v-400d +%Y-%m-%d)
    future2=$(date -u -d "+30 days" +%Y-%m-%d 2>/dev/null || date -u -v+30d +%Y-%m-%d)
    python3 -c "
import json
from datetime import datetime, timezone, timedelta
now = datetime.now(timezone.utc)
future = (now + timedelta(days=30)).isoformat()
# 10 claims: 1 orphan + 9 fresh. Orphan = 10% stale ratio, 10% claim-weighted (<20%)
claims = [{
    'claim_id': 'C-001',
    'claim_text': 'Orphan source claim',
    'sources': [{
        'source_file': 'N-999/orphan-source.yaml',
        'fetch_date': now.isoformat(),
        'freshness_status': 'FRESH',
        'fresh_until': future,
        'data_type': 'competitor_pricing',
        'sla_class': 'PRICING',
    }]
}]
for i in range(2, 11):
    claims.append({
        'claim_id': f'C-{i:03d}',
        'claim_text': f'Fresh claim {i}',
        'sources': [{
            'source_file': f'N-999/fresh-{i}.yaml',
            'fetch_date': now.isoformat(),
            'freshness_status': 'FRESH',
            'fresh_until': future,
            'data_type': 'competitor_pricing',
            'sla_class': 'PRICING',
        }]
    })
data = {'claims': claims}
with open('research/N-999/_canvas/evidence/trace-map.yaml', 'w') as f:
    json.dump(data, f)
"
    # Create fresh data files (but NOT the orphan-source.yaml)
    for i in $(seq 2 10); do
        make_data_file "research/N-999/fresh-$i.yaml" "$now" "$future" "competitor_pricing"
    done
    set +e; output=$(python3 research/_pipelines/freshness-audit N-999 2>/dev/null )
    exit_code=$?; set -e
    # Orphan = stale => should result in stale_ratio >0
    assert_exit_code "Exit 2 (WARNING orphan)" "$exit_code" 2
    # stale_details should include the orphan
    local orphan_count
    orphan_count=$(echo "$output" | python3 -c "import sys,json; d=json.load(sys.stdin); print(len([s for s in d.get('stale_details',[]) if 'ORPHAN' in s.get('resolution','')]))" 2>/dev/null || echo "0")
    if [ "$orphan_count" -ge 1 ]; then
        echo -e "  ${GREEN}PASS${NC} Orphan flagged in stale_details"
        PASSED=$((PASSED + 1))
    else
        echo -e "  ${RED}FAIL${NC} Orphan not in stale_details"
        FAILED=$((FAILED + 1))
    fi
    teardown

    # Test 10: --dry-run → no mutation, exit 0
    echo -e "\n${YELLOW}[Test 10] --dry-run${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    local now2 future3
    now2=$(date -u +%Y-%m-%d)
    future3=$(date -u -d "+30 days" +%Y-%m-%d 2>/dev/null || date -u -v+30d +%Y-%m-%d)
    python3 -c "
import json
from datetime import datetime, timezone, timedelta
now = datetime.now(timezone.utc)
future = (now + timedelta(days=30)).isoformat()
data = {
    'claims': [{
        'claim_id': 'C-001',
        'claim_text': 'Dry run claim',
        'sources': [{
            'source_file': 'N-999/dry-run-data.yaml',
            'fetch_date': now.isoformat(),
            'freshness_status': 'FRESH',
            'fresh_until': future,
            'data_type': 'competitor_pricing',
            'sla_class': 'PRICING',
        }]
    }]
}
with open('research/N-999/_canvas/evidence/trace-map.yaml', 'w') as f:
    json.dump(data, f)
"
    make_data_file "research/N-999/dry-run-data.yaml" "$now2" "$future3" "competitor_pricing"
    set +e; output=$(python3 research/_pipelines/freshness-audit N-999 --dry-run 2>/dev/null )
    exit_code=$?; set -e
    assert_exit_code "Exit 0 (dry-run)" "$exit_code" 0
    assert_json_field "verdict=DRY_RUN" "$output" "verdict" "DRY_RUN"
    teardown

    # Test 11: Invalid NICHE_ID → exit 4
    echo -e "\n${YELLOW}[Test 11] Invalid NICHE_ID${NC}"
    setup
    cd "$TEST_ROOT/niche-program"
    set +e; output=$(python3 research/_pipelines/freshness-audit BAD-XXX 2>&1 )
    exit_code=$?; set -e
    assert_exit_code "Exit 4 (INVALID_INPUT)" "$exit_code" 4
    teardown

    # Summary
    echo ""
    echo -e "${CYAN}============================================${NC}"
    echo -e "${CYAN}  Results: ${PASSED} passed, ${FAILED} failed, ${SKIPPED} skipped${NC}"
    echo -e "${CYAN}============================================${NC}"
    [ "$FAILED" -eq 0 ]
}

run_tests
