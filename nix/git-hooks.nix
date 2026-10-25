# Flake: git-hooks
# Purpose: Configuration for pre-commit hooks (cachix/git-hooks.nix)
{
  perSystem =
    { pkgs, ... }:
    {
      pre-commit = {
        check.enable = true;

        settings.hooks = {
          # Formatters
          treefmt = {
            enable = true;
            package =
              pkgs.runCommand "treefmt-wrapped"
                {
                  nativeBuildInputs = [ pkgs.makeWrapper ];
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
          };

          # Linters
          statix.enable = true;
          deadnix.enable = true;
          shellcheck.enable = true;
          luacheck = {
            enable = true;
            package = pkgs.luaPackages.luacheck;
            entry = "${pkgs.luaPackages.luacheck}/bin/luacheck --config .luacheckrc";
          };

          # Security
          detect-private-keys.enable = true;
        };
      };
    };
}
