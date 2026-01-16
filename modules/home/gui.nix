# Module: gui
# Purpose: User-level desktop applications and COSMIC dotfiles
# Note: System-level desktop (DE + Firefox) is in nixos/features/desktop.nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bigor.home.gui;
in
{
  options.bigor.home.gui.enable = lib.mkEnableOption "Desktop applications";

  config =
    let
      dotfilesPath = "${config.home.homeDirectory}/nixos/dotfiles";
    in
    lib.mkIf cfg.enable {
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
