# Flake: devshell
# Purpose: Formatter, pre-commit hooks (cachix/git-hooks.nix) and development shell
{
  perSystem =
    { pkgs, config, ... }:
    {
      # Bundle the formatters so `nix fmt` and the hook work outside the devshell
      formatter =
        pkgs.runCommand "treefmt-wrapped"
          {
            nativeBuildInputs = [ pkgs.makeWrapper ];
            meta.mainProgram = "treefmt";
          }
          ''
            mkdir -p $out/bin
            makeWrapper ${pkgs.treefmt}/bin/treefmt $out/bin/treefmt \
              --prefix PATH : ${
                pkgs.lib.makeBinPath (
                  with pkgs;
                  [
                    nixfmt
                    shfmt
                    taplo
                    prettier
                    stylua
                  ]
                )
              }
          '';

      pre-commit = {
        check.enable = true;

        settings.hooks = {
          treefmt = {
            enable = true;
            package = config.formatter;
          };

          statix.enable = true;
          deadnix.enable = true;
          shellcheck.enable = true;
          luacheck = {
            enable = true;
            package = pkgs.luaPackages.luacheck;
            entry = "${pkgs.luaPackages.luacheck}/bin/luacheck --config .luacheckrc";
          };

          detect-private-keys.enable = true;
        };
      };

      # Provides the hook tools and installs the git hook on entry
      devShells.default = pkgs.mkShell {
        name = "nixos-config-dev";
        inputsFrom = [ config.pre-commit.devShell ];
      };
    };
}
