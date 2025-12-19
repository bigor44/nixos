# ============================================================================
# File: modules/nixos/features/desktop/apps/default.nix
# Description: Configures default desktop applications.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{ lib, config, ... }:
with lib;
let
  cfg = config.bigor.features.desktop.apps;
in
{
  options.bigor.features.desktop.apps = {
    enable = mkEnableOption ''
      System-wide desktop applications required for a usable graphical session
      (for users without Home Manager profiles)
    '';
  };

  config = mkIf cfg.enable {
    # Enable Firefox as the default web browser.
    programs.firefox.enable = true;
  };
}
