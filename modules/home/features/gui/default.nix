# ============================================================================
# File: /home/bigor/nixos/modules/home/features/gui/default.nix
# Description: Configures GUI applications and related settings.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{
  config,
  lib,
  pkgs,
  ...
}:
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
