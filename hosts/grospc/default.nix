# Host: grospc
# Purpose: Desktop workstation with gaming optimizations
{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "grospc";
  system.stateVersion = "25.11";

  # Kernel: Zen for desktop performance
  boot.kernelPackages = pkgs.linuxPackages_zen;

  bigor = {
    # Policies: strategic decisions
    policies = {
      dns.mode = "lan-recursive";
      storage.mode = "nfs-client";
    };

    # Profile and features
    profiles.workstation.enable = true;
    features = {
      cpu-power-management.enable = true;
      via.enable = true;
    };
  };

  fileSystems."/steamlibrary" = {
    device = "/dev/disk/by-uuid/eca2097b-72d2-46cc-95d3-3b1d546afffc";
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
    ]; # Reduce write wear
  };
}
