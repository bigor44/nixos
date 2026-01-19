#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

echo "=== Full QA Check ==="
echo ""

# [1/6] Format check
echo "[1/6] Format check..."
if ! treefmt --fail-on-change 2>&1 | grep -v "traversed"; then
  echo "✗ Format check failed"
  echo "  Run: nix fmt"
  exit 1
fi
echo "  ✓ Format OK"
echo ""

# [2/6] Dead code check
echo "[2/6] Dead code check..."
if ! deadnix --fail . 2>&1; then
  echo "✗ Dead code found"
  exit 1
fi
echo "  ✓ No dead code"
echo ""

# [3/6] Linter check
echo "[3/6] Linter check..."
if ! statix check --ignore .* . 2>&1; then
  echo "✗ Linter failed"
  exit 1
fi
echo "  ✓ Lint OK"
echo ""

# [4/6] Shellcheck
echo "[4/6] Shellcheck..."
# Use git ls-files to find tracked shell scripts
if ! git ls-files '*.sh' | xargs shellcheck; then
  echo "✗ Shellcheck failed"
  exit 1
fi
echo "  ✓ Shellcheck OK"
echo ""

# [5/6] Evaluation check
echo "[5/6] Evaluation check..."
if ! nix flake show --no-write-lock-file >/dev/null 2>&1; then
  echo "✗ Flake evaluation failed"
  exit 1
fi
echo "  ✓ Evaluation OK"
echo ""

# [6/6] Flake checks
echo "[6/6] Flake checks..."
if ! nix flake check --no-write-lock-file 2>&1; then
  echo "✗ Flake checks failed"
  exit 1
fi
echo "  ✓ Flake checks OK"
echo ""

echo "╔════════════════════════════════════════════╗"
echo "║  ✓ All checks passed! Safe to commit/push ║"
echo "╚════════════════════════════════════════════╝"
