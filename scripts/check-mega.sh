#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

# Analyze git state
CHANGED=$(git diff --name-only HEAD 2>/dev/null | wc -l)
STAGED=$(git diff --cached --name-only 2>/dev/null | wc -l)
UNPUSHED=$(git log "@{u}.." --oneline 2>/dev/null | wc -l || echo 0)

echo "=== Mega Check ==="
echo "Changed: $CHANGED | Staged: $STAGED | Unpushed: $UNPUSHED"
echo ""

# Decision tree: choose appropriate check level
if [[ $CHANGED -eq 0 ]] && [[ $STAGED -eq 0 ]]; then
  if [[ $UNPUSHED -gt 0 ]]; then
    echo "→ Running FULL check (unpushed commits detected)"
    echo ""
    exec check-full
  else
    echo "✓ Working tree clean, nothing to check"
    exit 0
  fi
elif [[ $STAGED -gt 0 ]]; then
  echo "→ Running QUICK check (staged files)"
  echo ""
  exec check-quick --staged
else
  echo "→ Running QUICK check (modified files)"
  echo ""
  exec check-quick
fi
