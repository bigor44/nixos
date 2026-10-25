# Flake: devshell
# Purpose: Development shell with QA tools and pre-commit hook auto-install
{
  perSystem =
    { pkgs, config, ... }:
    let
      # Real executables rather than aliases: shellHook aliases only exist in the
      # bash spawned by `nix develop`, not in zsh, direnv or non-interactive shells
      shortcuts = pkgs.lib.mapAttrsToList pkgs.writeShellScriptBin {
        qc = ''pre-commit run "$@"'';
        qf = ''nix flake check "$@"'';
        gcn = ''git add . && pre-commit run && git commit "$@"'';
        gps = ''nix flake check && git push "$@"'';
        nrs = ''nix flake check && sudo nixos-rebuild switch --flake . "$@"'';
        nrb = ''nix flake check && sudo nixos-rebuild boot --flake . "$@"'';
      };
    in
    {
      devShells.default = pkgs.mkShell {
        name = "nixos-config-dev";

        packages =
          shortcuts
          ++ (with pkgs; [
            # Formatters
            treefmt
            nixfmt
            shfmt
            prettier
            taplo

            # Linters
            statix
            deadnix
            shellcheck
            luaPackages.luacheck
            stylua

            # QA
            pre-commit

            # Build tools
            # nh # Removed in favor of nixos-rebuild

            # Secrets management
            sops
            age

            # Version control
            git
          ]);

        shellHook = ''
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
