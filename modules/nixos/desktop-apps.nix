/*
  Title: Desktop Applications
  Description: Installs a set of desktop applications.
*/
{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.desktop.enable {
  programs.firefox.enable = true;
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    discord
    brave
    onedrive
    whatsapp-electron
  ];
}
