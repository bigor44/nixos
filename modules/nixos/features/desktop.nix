# Feature: desktop
# Purpose: Desktop environment (COSMIC DE + NetworkManager + Firefox)
{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.features.desktop;
in
{
  options.bigor.features.desktop.enable = mkEnableOption "Desktop environment (COSMIC)";

  config = mkIf cfg.enable {
    # Desktop environment: COSMIC
    services.displayManager.cosmic-greeter.enable = true;
    services.desktopManager.cosmic.enable = true;

    # Network management for desktop
    networking.networkmanager.enable = true;

    # System-wide browser
    programs.firefox.enable = true;
  };
}
