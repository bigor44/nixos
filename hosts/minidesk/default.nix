# Host: minidesk
# Purpose: Portable workstation (can use local storage when available)
{ pkgs, ... }:
{
  # Reuse minipc hardware config (same hardware base)
  imports = [ ../minipc/hardware-configuration.nix ];

  networking.hostName = "minidesk";
  system.stateVersion = "25.11";

  # Kernel: Zen for desktop performance
  boot.kernelPackages = pkgs.linuxPackages_zen;

  bigor = {
    platform = {
      dns.mode = "standalone";

      policies.storage = {
        mode = "local";
        device = "/dev/disk/by-uuid/a1ee534d-78d8-42df-be26-9cadae8197cf";
      };
    };

    features = {
      cpu-power-management.enable = true;
      sshd.enable = true;
      nixvim.enable = true;

      desktop.enable = true;
      audio.enable = true;
      flatpak.enable = true;
      bluetooth.enable = true;
      gaming.enable = true;
    };
  };
}
