# Host: grospc
# Purpose: Desktop workstation with gaming
{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/core.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/packages.nix
    ../../modules/nixos/shell.nix
    ../../modules/nixos/dev.nix
    ../../modules/nixos/desktop.nix
  ];

  networking.hostName = "grospc";
  # Release this machine was installed with; governs stateful data formats, not package versions. Do not bump.
  system.stateVersion = "26.05";

  boot.kernelPackages = pkgs.linuxPackages_zen;
}
