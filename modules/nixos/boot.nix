/*
  Title: Bootloader Configuration
  Description: Configures the systemd-boot loader and sets the Zen kernel.
*/
{ pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
}
