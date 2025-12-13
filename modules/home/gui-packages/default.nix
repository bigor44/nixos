{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.bigor.home.gui-packages;
in {
  options.bigor.home.gui-packages = {
    enable = mkEnableOption "Enable user desktop apps";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
      onedrive
      youtube-music
      whatsapp-electron
      antigravity-fhs
      brave
      pkgs.bigor.turtle-wow
    ];
    xdg.configFile = {
      cosmic.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/cosmic";
      autostart.source = ../../../dotfiles/autostart;
    };
  };
}
