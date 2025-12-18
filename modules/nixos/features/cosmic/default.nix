# ============================================================================
# File: /home/bigor/nixos/modules/nixos/features/cosmic/default.nix
# Description: Configures the COSMIC desktop environment.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{ lib, config, ... }:
with lib;
let
  cfg = config.bigor.features.cosmic;
in
{
  options.bigor.features.cosmic = {
    enable = mkEnableOption "Enable COSMIC desktop environment";
  };

  config = mkIf cfg.enable {
    # Enable the COSMIC greeter (login screen).
    services.displayManager.cosmic-greeter.enable = true;
    # Enable the COSMIC desktop environment itself.
    services.desktopManager.cosmic.enable = true;

    # Enable Firefox as the default web browser.
    programs.firefox.enable = true;

    # Enable NetworkManager for network connectivity in a desktop environment.
    networking.networkmanager.enable = true;
    # Kernel parameters to provide a quieter boot experience.
    boot.kernelParams = [ "quiet" ];
    boot.consoleLogLevel = 3;
  };
}
