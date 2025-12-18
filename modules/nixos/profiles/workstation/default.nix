{ lib, config, ... }:
# ============================================================================
# File: modules/nixos/profiles/workstation/default.nix
# Description: Workstation profile for desktop systems.
# Author: Bigor
# Date: 2025-12-18
# Purpose: This profile aggregates several desktop-oriented features into a
#          single, reusable configuration. It is intended for workstations
#          that require a full graphical environment.
# ============================================================================
let
  cfg = config.bigor.profiles.workstation;
in
{
  options.bigor.profiles.workstation.enable = lib.mkEnableOption "Desktop workstation profile";

  config = lib.mkIf cfg.enable {
    # Enable all the necessary features for a complete desktop experience.
    bigor.features = {
      audio.enable = true;
      bluetooth.enable = true;
      cosmic.enable = true;
      fonts.enable = true;
      gaming.enable = lib.mkDefault true;
    };

    # Enable node-exporter for monitoring by default on workstations.
    bigor.services.monitoring.node-exporter.enable = lib.mkDefault true;
  };
}
