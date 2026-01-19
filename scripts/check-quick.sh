#!/usr/bin/env bash
set -euo pipefail

MODE="${1:---unstaged}"

# Detect changed files based on mode
if [[ $MODE == "--staged" ]]; then
  FILES=$(git diff --cached --name-only --diff-filter=ACM || true)
else
  FILES=$(git diff --name-only --diff-filter=ACM HEAD || true)
fi

# Early exit if no files changed
if [[ -z $FILES ]]; then
  echo "✓ No files changed"
  exit 0
fi

# Filter for Nix files for statix/deadnix
NIX_FILES=$(echo "$FILES" | grep '\.nix$' || true)
# Filter for Shell files for shellcheck
SHELL_FILES=$(echo "$FILES" | grep '\.sh$' || true)

FILE_COUNT=$(echo "$FILES" | wc -l)
echo "Checking $FILE_COUNT file(s)..."

FAILED=0
for file in $FILES; do
  if ! treefmt --fail-on-change "$file" >/dev/null 2>&1; then
    echo "✗ Format check failed: $file"
    FAILED=1
  fi
done
if [[ $FAILED -eq 1 ]]; then
  echo ""
  echo "Fix with:"
  echo "  nix fmt                 # Format all files"
  echo "  treefmt <file>          # Format specific file"
  exit 1
fi

if [[ -n $SHELL_FILES ]]; then
  FAILED=0
  for file in $SHELL_FILES; do
    if ! shellcheck "$file"; then
      FAILED=1
    fi
  done
  if [[ $FAILED -eq 1 ]]; then
    echo ""
    echo "Fix shellcheck issues above"
    exit 1
  fi
fi

if [[ -n $NIX_FILES ]]; then
  FAILED=0
  for file in $NIX_FILES; do
    if ! statix check "$file" 2>&1; then
      FAILED=1
    fi
  done
  if [[ $FAILED -eq 1 ]]; then
    echo ""
    echo "Fix linting issues above, then re-run checks"
    exit 1
  fi

  FAILED=0
  for file in $NIX_FILES; do
    if ! deadnix --fail "$file" 2>&1; then
      FAILED=1
    fi
  done
  if [[ $FAILED -eq 1 ]]; then
    echo ""
    echo "Remove dead code manually or with:"
    echo "  deadnix --edit <file>   # Interactive removal"
    exit 1
  fi
fi

echo "✓ All checks passed"
