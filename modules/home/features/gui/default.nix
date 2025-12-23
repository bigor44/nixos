# Module: features.gui
# Purpose: Desktop applications and COSMIC DE dotfiles
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
  options.bigor.home.features.gui.enable = mkEnableOption "Desktop applications";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      prismlauncher
      discord
      youtube-music
      whatsapp-electron
      brave
    ];

    # Symlink dotfiles for live editing without rebuild
    xdg.configFile = {
      cosmic.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/cosmic";
      autostart.source = ../../../../dotfiles/autostart;
    };
  };
}
