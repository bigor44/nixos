{
  config,
  lib,
  pkgs,
  ...
}:
# ============================================================================
# File: modules/home/features/gui/default.nix
# Description: Desktop Applications (GUI)
# Author: Bigor
# Date: 2025-12-18
# Purpose: Installs graphical applications and manages dotfiles for desktop
#          components (COSMIC, Autostart).
# ============================================================================

with lib;
let
  cfg = config.bigor.home.features.gui;
in
{
  options.bigor.home.features.gui = {
    enable = mkEnableOption "Enable user desktop apps";
  };

  config = mkIf cfg.enable {
    # ==========================================================================
    # Applications
    # ==========================================================================
    home.packages = with pkgs; [
      discord
      youtube-music
      whatsapp-electron
      brave
      pkgs.bigor.turtle-wow # Custom package
    ];

    # ==========================================================================
    # Configuration Files (Dotfiles)
    # ==========================================================================
    xdg.configFile = {
      # Symlink mutable configuration files from the local repository.
      # mkOutOfStoreSymlink allows editing files in ~/nixos/dotfiles/ and
      # seeing changes immediately without rebuilding.
      cosmic.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/cosmic";
      autostart.source = ../../../../dotfiles/autostart;
    };
  };
}
