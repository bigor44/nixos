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
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/dev.nix
    ../../modules/nixos/home-manager.nix
  ];

  networking.hostName = "grospc";
  system.stateVersion = "25.11";

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
