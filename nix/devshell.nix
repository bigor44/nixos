# Flake: devshell
# Purpose: Development shell with QA tools and pre-commit hook auto-install
{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "nixos-config-dev";

        packages = with pkgs; [
          # Formatters
          treefmt
          nixfmt
          shfmt
          nodePackages.prettier
          taplo

          # Linters
          statix
          deadnix

          # Build tools
          nh # NixOS helper

          # Secrets management
          sops
          age

          # Version control
          git
        ];

        shellHook = ''
          echo "╔═══════════════════════════════════════════════╗"
          echo "║   NixOS Config Development Shell              ║"
          echo "╚═══════════════════════════════════════════════╝"
          echo ""
          echo "QA Commands:"
          echo "  qc, check-quick    → Quick check (changed files, <0.1s)"
          echo "  qs                 → Check staged files"
          echo "  qf, check-full     → Full check (CI-equivalent, ~16s)"
          echo "  mega, check-mega   → Intelligent check"
          echo ""
          echo "Workflows:"
          echo "  gcn    → Add + format + check + commit (safe)"
          echo "  gps    → Full check + push (safe)"
          echo "  nhs    → Full check + rebuild (safe)"
          echo "  nhb    → Full check + rebuild boot (safe)"
          echo ""

          # Auto-install pre-commit hook if not present
          if [[ -d .git ]] && [[ ! -f .git/hooks/pre-commit ]]; then
            echo "Installing pre-commit hook..."
            if command -v install-git-hooks &>/dev/null; then
              install-git-hooks
            else
              echo "⚠ install-git-hooks not found in PATH"
              echo "  Enable dev-scripts in your Home Manager config and rebuild"
            fi
            echo ""
          fi

          echo "Ready! Try 'qc' to check your changes."
          echo "      Try 'mega' for intelligent check."
        '';
      };
    };
}
