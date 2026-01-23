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
      dev = {
        tools.enable = true;
        scripts.enable = true;
      };
      graphics = {
        desktop.enable = true;
        flatpak.enable = true;
        gaming.enable = true;
      };
      hardware = {
        audio.enable = true;
        bluetooth.enable = true;
      };
    };
  };
}
