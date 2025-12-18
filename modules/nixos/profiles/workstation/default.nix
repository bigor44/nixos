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
with lib;
let
  cfg = config.bigor.profiles.workstation;
in
{
  options.bigor.profiles.workstation.enable = mkEnableOption "Desktop workstation profile";

  config = mkIf cfg.enable {
    # Enable all the necessary features for a complete desktop experience.
    bigor.features = {
      audio.enable = mkDefault true;
      bluetooth.enable = mkDefault true;
      cosmic.enable = mkDefault true;
      fonts.enable = mkDefault true;
      gaming.enable = mkDefault true;
    };

    # Enable node-exporter for monitoring by default on workstations.
    bigor.services.monitoring.node-exporter.enable = mkDefault true;
  };
}
