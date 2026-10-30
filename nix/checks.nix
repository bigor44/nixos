{
  perSystem =
    { pkgs, config, ... }:
    {
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
        check.enable = true;
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
