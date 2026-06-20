#!/usr/bin/env bash
#
# Smoke tests for claunch.
#
# These tests exercise claunch's CLI surface without launching a real Claude
# session. A fake `claude` executable is placed on PATH and an isolated HOME is
# used so the tests never touch the real environment.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUNCH="$SCRIPT_DIR/bin/claunch"

pass=0
fail=0

# check <name> <expected-substring> <actual-output>
check() {
  local name="$1" expected="$2" actual="$3"
  if [[ "$actual" == *"$expected"* ]]; then
    echo "  ✅ $name"
    ((pass++))
  else
    echo "  ❌ $name"
    echo "     expected to contain: $expected"
    echo "     actual: $actual"
    ((fail++))
  fi
}

# --- Set up an isolated sandbox -------------------------------------------
TMPHOME="$(mktemp -d)"
FAKEBIN="$(mktemp -d)"
trap 'rm -rf "$TMPHOME" "$FAKEBIN"' EXIT

# Fake `claude` so the CLI check passes during tests.
cat > "$FAKEBIN/claude" << 'EOF'
#!/bin/bash
echo "fake claude $*"
EOF
chmod +x "$FAKEBIN/claude"

# Pre-acknowledge the security warning so non-interactive runs don't block.
touch "$TMPHOME/.claunch_warning_acknowledged"

echo "Running claunch smoke tests..."

# --- 1. --version ---------------------------------------------------------
out="$(bash "$CLAUNCH" --version 2>&1)"
check "--version prints version" "claunch v" "$out"

# --- 2. --help ------------------------------------------------------------
out="$(bash "$CLAUNCH" --help 2>&1)"
check "--help shows usage" "Usage:" "$out"

# --- 3. Missing Claude CLI is reported ------------------------------------
out="$(PATH="/usr/bin:/bin" bash "$CLAUNCH" 2>&1 || true)"
check "missing claude CLI detected" "Claude CLI not found" "$out"

# --- 4. list shows saved sessions -----------------------------------------
echo "sess-abc123" > "$TMPHOME/.claude_session_testproj"
out="$(HOME="$TMPHOME" PATH="$FAKEBIN:$PATH" bash "$CLAUNCH" list 2>&1)"
check "list shows saved session" "testproj" "$out"

# --- 5. clean runs without error ------------------------------------------
out="$(HOME="$TMPHOME" PATH="$FAKEBIN:$PATH" bash "$CLAUNCH" clean 2>&1)"
check "clean reports cleanup" "Cleaning up" "$out"

# --- 6. Invalid session ID format is rejected -----------------------------
mkdir -p "$TMPHOME/badproj"
echo "not-a-valid-id" > "$TMPHOME/.claude_session_badproj"
out="$(cd "$TMPHOME/badproj" && HOME="$TMPHOME" PATH="$FAKEBIN:$PATH" bash "$CLAUNCH" 2>&1 || true)"
check "invalid session ID rejected" "Invalid session ID format" "$out"

# --- 7. Empty session file is detected ------------------------------------
mkdir -p "$TMPHOME/emptyproj"
: > "$TMPHOME/.claude_session_emptyproj"
out="$(cd "$TMPHOME/emptyproj" && HOME="$TMPHOME" PATH="$FAKEBIN:$PATH" bash "$CLAUNCH" 2>&1 || true)"
check "empty session file detected" "Session file is empty" "$out"

# --- Summary --------------------------------------------------------------
echo ""
echo "Results: $pass passed, $fail failed"
[[ "$fail" -eq 0 ]]
