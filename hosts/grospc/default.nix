# Host: grospc
# Purpose: Desktop workstation with gaming optimizations
{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "grospc";
  system.stateVersion = "25.11";

  bigor = {
    # Policies: strategic decisions
    policies = {
      kernel = "desktop";
      power = "amd-pstate";
      dns.mode = "lan-recursive";
      storage.mode = "nfs-client";
    };

    # Profile and features
    profiles.workstation.enable = true;
    features.via.enable = true;
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
