# ============================================================================
# File: /home/bigor/nixos/modules/nixos/features/cosmic/default.nix
# Description: Configures the COSMIC desktop environment.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{ lib, config, ... }:
with lib;
let
  cfg = config.bigor.features.desktop.cosmic;
in
{
  options.bigor.features.desktop.cosmic = {
    enable = mkEnableOption "Enable COSMIC desktop environment";
  };

  config = mkIf cfg.enable {
    # Enable the COSMIC greeter (login screen).
    services.displayManager.cosmic-greeter.enable = true;
    # Enable the COSMIC desktop environment itself.
    services.desktopManager.cosmic.enable = true;
  };
}
