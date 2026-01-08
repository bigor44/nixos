# Module: features.shell.starship
# Purpose: Starship prompt configuration
{
  config,
  lib,
  ...
}:
with lib;
let
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
