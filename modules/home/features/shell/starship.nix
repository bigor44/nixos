# Module: features.shell.starship
# Purpose: Starship prompt configuration
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.bigor.home.features.shell;
in
{
  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
      };
    };
  };
}
