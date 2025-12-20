# System: grospc
# Purpose: Desktop workstation with gaming optimizations
{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "grospc";
  system.stateVersion = "25.11";

  # AMD P-State EPP active mode for better power management
  boot.kernelParams = [ "amd_pstate=active" ];
  boot.kernelPackages = pkgs.linuxPackages_zen;

  bigor = {
    profiles.workstation.enable = true;
    services.nfs.client = true;
    network.mainInterface = "enp14s0";
    lib.exposedService.grospc = {
      domain = "grospc.bigor.lan";
      port = 0; # DNS-only entry
    };
  };

  fileSystems."/steamlibrary" = {
    device = "/dev/disk/by-uuid/84c2f17e-37c6-4ef9-b98c-6862c808990b";
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
    ]; # Reduce write wear
  };
}
