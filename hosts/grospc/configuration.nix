# Host: grospc
# Purpose: Desktop workstation with gaming
{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/core.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/packages.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/dev.nix
  ];

  networking.hostName = "grospc";
  system.stateVersion = "26.05";

  boot.kernelPackages = pkgs.linuxPackages_zen;
}
