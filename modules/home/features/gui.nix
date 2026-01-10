# Module: features.gui
# Purpose: Desktop applications and COSMIC DE dotfiles
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.home.features.gui;
in
{
  options.bigor.home.features.gui.enable = mkEnableOption "Desktop applications";

  config =
    let
      dotfilesPath = "${config.home.homeDirectory}/nixos/dotfiles";
    in
    mkIf cfg.enable {
      home.packages = with pkgs; [
        prismlauncher
        discord
        whatsapp-electron
        brave
      ];

      # Symlink dotfiles for live editing without rebuild
      xdg.configFile = {
        cosmic.source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/cosmic";
        autostart.source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/autostart";
      };
    };
}
