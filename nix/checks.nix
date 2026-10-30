# Flake: checks
# Purpose: git-hooks.nix hooks exposed as `nix fmt` (rewrite) and `nix flake check` (verify)
{
  # flake-parts module; perSystem is evaluated once per entry in `systems`
  perSystem =
    # config: this system's perSystem config, where the git-hooks module puts `pre-commit`
    { pkgs, config, ... }:
    {
      # pre-commit run against the generated config, no installed hook needed.
      # `nix fmt` with no arguments (or ".") covers the whole repo, otherwise only the given files
      formatter = pkgs.writeShellApplication {
        name = "pre-commit-fmt";
        runtimeInputs = [
          config.pre-commit.settings.package
          pkgs.git
        ];
        text = ''
          cfg=${config.pre-commit.settings.configFile}
          if [ $# -eq 0 ] || [ "$*" = "." ]; then
            pre-commit run --config "$cfg" --all-files
          else
            pre-commit run --config "$cfg" --files "$@"
          fi
        '';
      };
      pre-commit = {
        # Adds a read-only run of the same hooks to `nix flake check`
        check.enable = true;
        # Formatters first, then linters (report only), then the secret guard
        settings.hooks = {
          nixfmt.enable = true;
          taplo.enable = true;
          prettier.enable = true;
          statix.enable = true;
          deadnix.enable = true;
          shellcheck.enable = true;
          detect-private-keys.enable = true;
        };
      };
    };
}
