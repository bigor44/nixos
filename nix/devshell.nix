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

          # QA
          pre-commit

          # Build tools
          # nh # Removed in favor of nixos-rebuild

          # Secrets management
          sops
          age

          # Version control
          git
        ];

        shellHook = ''
          # Aliases
          alias qc='pre-commit run'
          alias qf='nix flake check'
          alias gcn='git add . && pre-commit run && git commit'
          alias gps='nix flake check && git push'
          alias nrs='nix flake check && sudo nixos-rebuild switch --flake .'
          alias nrb='nix flake check && sudo nixos-rebuild boot --flake .'

          echo "╔═══════════════════════════════════════════════╗"
          echo "║   NixOS Config Development Shell              ║"
          echo "╚═══════════════════════════════════════════════╝"
          echo ""
          echo "QA Commands:"
          echo "  qc     → Quick check (pre-commit run)"
          echo "  qf     → Full check (nix flake check)"
          echo ""
          echo "Workflows:"
          echo "  gcn    → Add + check + commit (safe)"
          echo "  gps    → Full check + push (safe)"
          echo "  nrs    → Full check + rebuild (safe)"
          echo "  nrb    → Full check + rebuild boot (safe)"
          echo ""

          # Auto-install pre-commit hook
          ${config.pre-commit.installationScript}

          echo "Ready! Try 'qc' to check your changes."
        '';
      };
    };
}
