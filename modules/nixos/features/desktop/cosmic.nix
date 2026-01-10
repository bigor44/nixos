# Feature: desktop.cosmic
# Purpose: COSMIC desktop environment (System76)
{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.features.desktop.cosmic;
in
{
  options.bigor.features.desktop.cosmic.enable = mkEnableOption "COSMIC desktop environment";

  config = mkIf cfg.enable {
    services.displayManager.cosmic-greeter.enable = true;
    services.desktopManager.cosmic.enable = true;
  };
}
