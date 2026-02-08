#!/usr/bin/env bash
# Test contract for json-schema-generator

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUN="$SCRIPT_DIR/run.py"
PASS=0; FAIL=0; TOTAL=0

assert_contains() {
  local desc="$1" needle="$2" haystack="$3"
  ((TOTAL++))
  if echo "$haystack" | grep -qF -- "$needle"; then
    ((PASS++)); echo "  PASS: $desc"
  else
    ((FAIL++)); echo "  FAIL: $desc (missing '$needle')"
  fi
}

echo "=== Tests for json-schema-generator ==="

# Test 1: Simple object
SAMPLE1='{"name": "Alice", "age": 30}'
OUTPUT1=$(echo "$SAMPLE1" | python3 "$RUN")
assert_contains "simple object - string" '"type": "string"' "$OUTPUT1"
assert_contains "simple object - integer" '"type": "integer"' "$OUTPUT1"

# Test 2: Nested object
SAMPLE2='{"user": {"id": 1}}'
OUTPUT2=$(echo "$SAMPLE2" | python3 "$RUN")
assert_contains "nested object - object type" '"type": "object"' "$OUTPUT2"
assert_contains "nested object - inner id" '"id"' "$OUTPUT2"

# Test 3: Array of items
SAMPLE3='{"tags": ["a", "b"]}'
OUTPUT3=$(echo "$SAMPLE3" | python3 "$RUN")
assert_contains "array - items" '"items"' "$OUTPUT3"

# Test 4: Help flag
assert_contains "help flag" "Usage:" "$(python3 "$RUN" --help 2>&1)"

echo ""
echo "=== Results: $PASS/$TOTAL passed ==="
[ "$FAIL" -eq 0 ] || { echo "BLOCKED: $FAIL test(s) failed"; exit 1; }
