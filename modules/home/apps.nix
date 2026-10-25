# Home: apps
# Purpose: User-level desktop applications
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    prismlauncher
    discord
    whatsapp-electron
    brave
  ];
}
