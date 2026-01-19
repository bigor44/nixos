#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
HOOK_DST="$REPO_ROOT/.git/hooks/pre-commit"

# Verify we're in a git repository
if [[ ! -d "$REPO_ROOT/.git" ]]; then
  echo "✗ Not in a git repository"
  exit 1
fi

# Create pre-commit hook
cat >"$HOOK_DST" <<'EOHOOK'
#!/usr/bin/env bash
# Auto-generated pre-commit hook
# Purpose: Validate staged changes before commit
set -euo pipefail

# Skip during merge/rebase
if git rev-parse -q --verify MERGE_HEAD >/dev/null 2>&1; then
  exit 0
fi

echo "Running pre-commit checks..."

# 1. Check staged files
STAGED=$(git diff --cached --name-only --diff-filter=ACM || true)
if [[ -n "$STAGED" ]]; then
  if ! check-quick --staged; then
    echo ""
    echo "✗ Pre-commit checks failed"
    echo "  Fix the issues above or skip with: git commit --no-verify"
    exit 1
  fi
fi

# 2. Validate SOPS secrets if modified
STAGED_SECRETS=$(git diff --cached --name-only --diff-filter=ACM | grep 'secrets/.*\.yaml$' || true)
if [[ -n "$STAGED_SECRETS" ]]; then
  echo "Validating SOPS secrets..."
  for secret in $STAGED_SECRETS; do
    if ! sops -d "$secret" >/dev/null 2>&1; then
      echo "✗ SOPS validation failed: $secret"
      echo "  Ensure the secret file is properly encrypted"
      exit 1
    fi
  done
  echo "  ✓ SOPS secrets valid"
fi

# 3. Prevent committing sensitive files
SENSITIVE=$(git diff --cached --name-only | grep -E '\.(pem|key|p12)$|id_rsa|id_ed25519' || true)
if [[ -n "$SENSITIVE" ]]; then
  echo "✗ ERROR: Attempting to commit sensitive files:"
  echo "$SENSITIVE"
  echo ""
  echo "  Remove from staging: git reset HEAD <file>"
  exit 1
fi

echo "✓ Pre-commit checks passed"
EOHOOK

chmod +x "$HOOK_DST"
echo "✓ Pre-commit hook installed at:"
echo "  $HOOK_DST"
echo ""
echo "The hook will:"
echo "  • Check format/lint on staged .nix files"
echo "  • Validate SOPS secrets if modified"
echo "  • Prevent committing sensitive files (.pem, .key, etc.)"
echo ""
echo "To skip: git commit --no-verify"
