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
    platform = {
      dns.mode = "client";
      policies.storage.mode = "nfs-client";
    };

    features = {
      cpu-power-management.enable = true;
      keyboardVIA.enable = true;
      nixvim.enable = true;
      desktop.enable = true;
      desktop-apps.enable = true;
      audio.enable = true;
      flatpak.enable = true;
      bluetooth.enable = true;
      gaming.enable = true;
    };
  };

  fileSystems."/steamlibrary" = {
    device = "/dev/disk/by-uuid/eca2097b-72d2-46cc-95d3-3b1d546afffc";
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
    ];
  };
}
