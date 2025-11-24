{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.enable {
  programs = {
    firefox.enable = true;
    gamemode.enable = true;
    steam.enable = true;
  };
  environment.systemPackages = with pkgs; [
    alacritty
    discord
    brave
    onedrive
    youtube-music
    whatsapp-electron
    antigravity-fhs
  ];
}
