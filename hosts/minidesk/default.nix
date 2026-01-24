# Host: minidesk
# Purpose: Portable workstation
{ pkgs, ... }:
{
  imports = [ ../minipc/hardware-configuration.nix ];

  networking.hostName = "minidesk";
  system.stateVersion = "25.11";

  # Kernel: Zen for responsiveness
  boot.kernelPackages = pkgs.linuxPackages_zen;

  bigor = {
    profiles = [
      "desktop"
      "dev"
    ];

    # Gaming volontairement explicite (si tu veux le garder)
    features.graphics.gaming.enable = true;
  };

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/a1ee534d-78d8-42df-be26-9cadae8197cf";
    fsType = "ext4";
  };
}
