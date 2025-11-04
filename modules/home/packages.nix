/*
  Title: Home Manager Packages
  Description: Installs user-specific packages using Home Manager.
*/
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    eza
    gemini-cli
  ];
}
