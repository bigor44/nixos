# Module: dev-scripts
# Purpose: Development QA scripts for fast quality checks
#
# Provides 5 commands:
# - check-quick: Fast incremental check (changed files only, <0.1s)
# - check-full: Complete QA check (CI-equivalent, ~16s)
# - check-mega: Intelligent check orchestrator (adapts to git state)
# - dns-test: DNS stack functional test (local DNS, ad blocking, DNSSEC)
# - install-git-hooks: Install pre-commit hook

{ pkgs, ... }:
let

  # Script: check-quick
  # Fast incremental check: only verify changed Nix files
  check-quick = pkgs.writeShellScriptBin "check-quick" ''
    #!/usr/bin/env bash
    set -euo pipefail

    MODE="''${1:---unstaged}"

    # Detect changed Nix files based on mode
    if [[ "$MODE" == "--staged" ]]; then
      FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.nix$' || true)
    else
      FILES=$(git diff --name-only --diff-filter=ACM HEAD | grep '\.nix$' || true)
    fi

    # Early exit if no files changed
    if [[ -z "$FILES" ]]; then
      echo "✓ No Nix files changed"
      exit 0
    fi

    FILE_COUNT=$(echo "$FILES" | wc -l)
    echo "Checking $FILE_COUNT file(s)..."

    # Format check
    FAILED=0
    for file in $FILES; do
      if ! ${pkgs.nixfmt}/bin/nixfmt --check "$file" 2>/dev/null; then
        echo "✗ Format check failed: $file"
        FAILED=1
      fi
    done
    if [[ $FAILED -eq 1 ]]; then
      echo ""
      echo "Fix with:"
      echo "  nix fmt                 # Format all files"
      echo "  nixfmt <file>           # Format specific file"
      exit 1
    fi

    # Lint check
    FAILED=0
    for file in $FILES; do
      if ! ${pkgs.statix}/bin/statix check "$file" 2>&1; then
        FAILED=1
      fi
    done
    if [[ $FAILED -eq 1 ]]; then
      echo ""
      echo "Fix linting issues above, then re-run checks"
      exit 1
    fi

    # Dead code check
    FAILED=0
    for file in $FILES; do
      if ! ${pkgs.deadnix}/bin/deadnix --fail "$file" 2>&1; then
        FAILED=1
      fi
    done
    if [[ $FAILED -eq 1 ]]; then
      echo ""
      echo "Remove dead code manually or with:"
      echo "  deadnix --edit <file>   # Interactive removal"
      exit 1
    fi

    echo "✓ All checks passed"
  '';

  # Script: check-full
  # Complete QA check: format, lint, dead code, evaluation, flake checks
  check-full = pkgs.writeShellScriptBin "check-full" ''
    #!/usr/bin/env bash
    set -euo pipefail

    REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
    cd "$REPO_ROOT"

    echo "=== Full QA Check ==="
    echo ""

    # [1/5] Format check
    echo "[1/5] Format check..."
    if ! ${pkgs.treefmt}/bin/treefmt --fail-on-change 2>&1 | grep -v "traversed"; then
      echo "✗ Format check failed"
      echo "  Run: nix fmt"
      exit 1
    fi
    echo "  ✓ Format OK"
    echo ""

    # [2/5] Dead code check
    echo "[2/5] Dead code check..."
    if ! ${pkgs.deadnix}/bin/deadnix --fail . 2>&1; then
      echo "✗ Dead code found"
      exit 1
    fi
    echo "  ✓ No dead code"
    echo ""

    # [3/5] Linter check
    echo "[3/5] Linter check..."
    if ! ${pkgs.statix}/bin/statix check --ignore .* . 2>&1; then
      echo "✗ Linter failed"
      exit 1
    fi
    echo "  ✓ Lint OK"
    echo ""

    # [4/5] Evaluation check
    echo "[4/5] Evaluation check..."
    if ! nix flake show --no-write-lock-file >/dev/null 2>&1; then
      echo "✗ Flake evaluation failed"
      exit 1
    fi
    echo "  ✓ Evaluation OK"
    echo ""

    # [5/5] Flake checks
    echo "[5/5] Flake checks..."
    if ! nix flake check --no-write-lock-file 2>&1; then
      echo "✗ Flake checks failed"
      exit 1
    fi
    echo "  ✓ Flake checks OK"
    echo ""

    echo "╔════════════════════════════════════════════╗"
    echo "║  ✓ All checks passed! Safe to commit/push ║"
    echo "╚════════════════════════════════════════════╝"
  '';

  # Script: check-mega
  # Intelligent check orchestrator: analyzes git state and runs appropriate check
  check-mega = pkgs.writeShellScriptBin "check-mega" ''
    #!/usr/bin/env bash
    set -euo pipefail

    REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
    cd "$REPO_ROOT"

    # Analyze git state
    CHANGED=$(git diff --name-only HEAD 2>/dev/null | wc -l)
    STAGED=$(git diff --cached --name-only 2>/dev/null | wc -l)
    UNPUSHED=$(git log @{u}.. --oneline 2>/dev/null | wc -l || echo 0)

    echo "=== Mega Check ==="
    echo "Changed: $CHANGED | Staged: $STAGED | Unpushed: $UNPUSHED"
    echo ""

    # Decision tree: choose appropriate check level
    if [[ $CHANGED -eq 0 ]] && [[ $STAGED -eq 0 ]]; then
      if [[ $UNPUSHED -gt 0 ]]; then
        echo "→ Running FULL check (unpushed commits detected)"
        echo ""
        exec ${check-full}/bin/check-full
      else
        echo "✓ Working tree clean, nothing to check"
        exit 0
      fi
    elif [[ $STAGED -gt 0 ]]; then
      echo "→ Running QUICK check (staged files)"
      echo ""
      exec ${check-quick}/bin/check-quick --staged
    else
      echo "→ Running QUICK check (modified files)"
      echo ""
      exec ${check-quick}/bin/check-quick
    fi
  '';

  # Script: dns-test
  # DNS stack functional test: validates local DNS, ad blocking, DNSSEC
  dns-test = pkgs.writeShellScriptBin "dns-test" ''
    #!/usr/bin/env bash
    set -euo pipefail

    DNS_SERVER="127.0.0.1"
    TIMEOUT=2

    fail() {
      echo "❌ $1"
      exit 1
    }

    ok() {
      echo "✅ $1"
    }

    dig_test() {
      ${pkgs.dnsutils}/bin/dig @"$DNS_SERVER" "$1" +time="$TIMEOUT" +tries=1 +short
    }

    echo "== DNS Stack Functional Test =="

    # 1. DNS reachable
    dig_test google.com >/dev/null || fail "DNS server not reachable"
    ok "DNS server reachable"

    # 2. Local rewrites
    EXPECTED_MINIPC="$(dig_test minipc.bigor.lan)"
    [ -n "$EXPECTED_MINIPC" ] || fail "Local rewrite minipc.bigor.lan failed"
    ok "Local rewrite minipc.bigor.lan → $EXPECTED_MINIPC"

    # 3. External resolution
    dig_test google.com | grep -E '^[0-9.]+' >/dev/null ||
      fail "External resolution failed"
    ok "External resolution works"

    # 4. Ad blocking
    BLOCKED="$(dig_test ads.youtube.com || true)"
    [ "$BLOCKED" = "0.0.0.0" ] || fail "Ad blocking not effective"
    ok "Ad blocking works"

    # 5. DNSSEC validation
    ${pkgs.dnsutils}/bin/dig @"$DNS_SERVER" sigok.verteiltesysteme.net +dnssec +short >/dev/null ||
      fail "DNSSEC validation failed"
    ok "DNSSEC validation works"

    echo "🎉 DNS stack OK"
  '';

  # Script: install-git-hooks
  # Install pre-commit hook for automatic validation
  install-git-hooks = pkgs.writeShellScriptBin "install-git-hooks" ''
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
        cat > "$HOOK_DST" << 'EOHOOK'
    #!/usr/bin/env bash
    # Auto-generated pre-commit hook
    # Purpose: Validate staged changes before commit
    set -euo pipefail

    # Skip during merge/rebase
    if git rev-parse -q --verify MERGE_HEAD >/dev/null 2>&1; then
      exit 0
    fi

    echo "Running pre-commit checks..."

    # 1. Check staged Nix files
    STAGED_NIX=$(git diff --cached --name-only --diff-filter=ACM | grep '\.nix$' || true)
    if [[ -n "$STAGED_NIX" ]]; then
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
  '';
in
{
  home.packages = [
    check-quick
    check-full
    check-mega
    dns-test
    install-git-hooks
  ];
}
