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
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
  };
  environment.systemPackages = with pkgs; [
    discord
    brave
    onedrive
    youtube-music
    whatsapp-electron
  ];
}
