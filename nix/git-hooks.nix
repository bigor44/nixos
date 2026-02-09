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
                          nodePackages.prettier
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

          # Custom: Validate SOPS secrets
          check-sops = {
            enable = true;
            name = "Check SOPS secrets";
            entry = "${pkgs.bash}/bin/bash -c 'if [ -n \"$NIX_BUILD_TOP\" ]; then exit 0; fi; for file in \"$@\"; do ${pkgs.sops}/bin/sops -d \"$file\" >/dev/null; done' --";
            files = "secrets/.*\\.yaml$";
            pass_filenames = true;
          };
        };
      };
    };
}
