# Flake: devshell
# Purpose: Development shell with QA tools and pre-commit hook auto-install
{
  perSystem =
    { pkgs, config, ... }:
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
          shellcheck

          # Build tools
          # nh # Removed in favor of nixos-rebuild

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
          echo "  nrs    → Full check + rebuild (safe)"
          echo "  nrb    → Full check + rebuild boot (safe)"
          echo ""

          # Auto-install pre-commit hook
          ${config.pre-commit.installationScript}

          echo "Ready! Try 'qc' to check your changes."
          echo "      Try 'mega' for intelligent check."
        '';
      };
    };
}
