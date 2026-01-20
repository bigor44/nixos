# Feature: graphics-desktop
# Purpose: Desktop environment (COSMIC DE + NetworkManager + Firefox)
{
  lib,
  config,
  ...
}:
let
  cfg = config.bigor.features.graphics.desktop;
in
{
  options.bigor.features.graphics.desktop.enable = lib.mkEnableOption "Desktop environment (COSMIC)";

  config = lib.mkIf cfg.enable {
    services.displayManager.cosmic-greeter.enable = true;
    services.desktopManager.cosmic.enable = true;

    networking.networkmanager.enable = true;

    programs.firefox.enable = true;
  };
}
