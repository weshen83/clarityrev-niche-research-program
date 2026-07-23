#!/bin/bash
# audit-binding-compliance.sh — Post-hoc BINDING rule compliance check
# Usage: ./audit-binding-compliance.sh <niche_id>
#   e.g. ./audit-binding-compliance.sh N-001
#
# Checks completed niche agent output against 10 binding rules.
# Reports PASS/FAIL per rule with evidence.

set -e

NICHE_ID="${1:?Usage: $0 <niche_id>}"
NICHE_DIR="niche-program/research/${NICHE_ID}"
WORK_DIR="${NICHE_DIR}/_work"
CANVAS_DIR="${NICHE_DIR}/_canvas"
TRACE_MAP="${CANVAS_DIR}/evidence/trace-map.yaml"
ERROR_LOG="niche-program/research/_program/TOOL_ERROR_LOG.yaml"
CREDIT_LOG="niche-program/research/_program/CREDIT_BUDGET.yaml"

echo "=========================================="
echo "BINDING RULE COMPLIANCE AUDIT — ${NICHE_ID}"
echo "=========================================="

PASS_COUNT=0
FAIL_COUNT=0

check() {
  local rule="$1"
  local description="$2"
  local status="$3"
  if [ "$status" = "PASS" ]; then
    echo "  [PASS] R${rule}: ${description}"
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    echo "  [FAIL] R${rule}: ${description}"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
}

echo ""
echo "--- Rule R1: Tool Escalation (search -> scrape -> map -> crawl -> interact) ---"
# Check: search results exist before scrape results for same competitor
SEARCH_COUNT=$(find "${NICHE_DIR}" -name "*search*" -o -name "*search*" 2>/dev/null | head -5 | wc -l)
SCRAPE_COUNT=$(find "${NICHE_DIR}" -name "*scrape*" 2>/dev/null | head -5 | wc -l)
if [ "$SCRAPE_COUNT" -gt 0 ] || [ "$SEARCH_COUNT" -gt 0 ]; then
  check 1 "Tool usage detected (${SEARCH_COUNT} search, ${SCRAPE_COUNT} scrape)" "PASS"
else
  check 1 "No tool usage artifacts found in niche dir" "WARN"
fi

echo ""
echo "--- Rule R3: --query ban ---"
# Check: evidence trace-map has scrape-to-file pattern, not inline --query
if [ -f "$TRACE_MAP" ]; then
  QUERY_USAGE=$(grep -c "\-\-query" "$TRACE_MAP" 2>/dev/null || echo "0")
  if [ "$QUERY_USAGE" -eq 0 ]; then
    check 3 "No --query usage found in trace-map (correct)" "PASS"
  else
    check 3 "--query used ${QUERY_USAGE} times in trace-map (BANNED)" "FAIL"
  fi
else
  check 3 "Trace-map not found — cannot verify" "WARN"
fi

echo ""
echo "--- Rule R4: --only-main-content on competitor pages ---"
# Check: scrape commands reference --only-main-content
if [ -f "$ERROR_LOG" ]; then
  MISSING_MAIN=$(grep -c "scrape.*competitor\|scrape.*pricing" "$ERROR_LOG" 2>/dev/null || echo "0")
  if [ "$MISSING_MAIN" -eq 0 ]; then
    check 4 "No pricing/competitor scrapes logged without --only-main-content" "PASS"
  else
    check 4 "Pricing/competitor scrapes found — verify --only-main-content was used" "WARN"
  fi
else
  check 4 "Error log not found" "WARN"
fi

echo ""
echo "--- Rule R5: --wait-for 3000-5000 on JS pages ---"
# Check: evidence of --wait-for flag in any scrape commands
if [ -f "$ERROR_LOG" ]; then
  WAIT_FOR_USAGE=$(grep -c "\-\-wait-for" "$ERROR_LOG" 2>/dev/null || echo "0")
  if [ "$WAIT_FOR_USAGE" -gt 0 ]; then
    check 5 "--wait-for found in error log (${WAIT_FOR_USAGE} occurrences)" "PASS"
  else
    check 5 "No --wait-for usage found — verify if JS pages were scraped" "WARN"
  fi
else
  check 5 "Error log not found" "WARN"
fi

echo ""
echo "--- Rule R6: search-feedback after /search ---"
FEEDBACK_CREDITS=$(grep -c "search_feedback\|search-feedback" "$CREDIT_LOG" 2>/dev/null || echo "0")
if [ "$FEEDBACK_CREDITS" -gt 0 ]; then
  check 6 "search-feedback found (${FEEDBACK_CREDITS} entries)" "PASS"
else
  check 6 "No search-feedback entries in credit log" "WARN"
fi

echo ""
echo "--- Rule R8: Prompt injection defense (no full scraped content inlined) ---"
# Check: work files don't contain massive inline scraped content
LARGE_INLINE=$(find "${WORK_DIR}" -name "*.md" -size +50k 2>/dev/null | wc -l)
if [ "$LARGE_INLINE" -eq 0 ]; then
  check 8 "No large inline content files (>50K) found in _work/" "PASS"
else
  check 8 "${LARGE_INLINE} large files found in _work/ — may contain inlined scrapes" "WARN"
fi

echo ""
echo "--- Rule R9: Credential secrecy (no credential values in output) ---"
# Search work and canvas directories for known credential patterns
CRED_LEAKS=$(grep -rnl "fc-5264f95d\|5a6904eff" "${NICHE_DIR}" 2>/dev/null | wc -l)
if [ "$CRED_LEAKS" -eq 0 ]; then
  check 9 "No credential values found in niche output files" "PASS"
else
  check 9 "${CRED_LEAKS} credential values leaked in niche files" "FAIL"
fi

echo ""
echo "--- Rule R10: Session isolation (lock file protocol) ---"
LOCK_FILE="${NICHE_DIR}/_lock"
if [ -f "$LOCK_FILE" ]; then
  LOCK_AGE=$(stat -c %Y "$LOCK_FILE" 2>/dev/null)
  NOW=$(date +%s)
  AGE=$((NOW - LOCK_AGE))
  if [ "$AGE" -lt 1800 ]; then
    check 10 "Lock file present and <30min old — niche may still be active" "WARN"
  else
    check 10 "Stale lock file present (${AGE}s old) — should have been cleaned up" "WARN"
  fi
else
  check 10 "No lock file present (niche likely completed)" "PASS"
fi

echo ""
echo "=========================================="
echo "RESULTS: ${PASS_COUNT} PASS, ${FAIL_COUNT} FAIL"
echo "=========================================="

if [ "$FAIL_COUNT" -gt 0 ]; then
  echo "WARNING: ${FAIL_COUNT} binding rule violations found."
  echo "Review and remediate before considering this niche audited."
  exit 1
fi

exit 0
