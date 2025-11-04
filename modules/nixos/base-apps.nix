/*
  Title: Base Applications
  Description: Installs a set of essential command-line tools and utilities.
*/
{ pkgs, ... }:
{
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    bat
    dig
    btop
    wget
    curl
    fastfetch
    tree
    zip
    unzip
    htop
    ripgrep
    pciutils
    sl
    sysstat
    lm_sensors
  ];
}
