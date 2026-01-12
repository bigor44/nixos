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
    # Policies: strategic decisions
    policies = {
      dns.mode = "portable";
      storage = {
        mode = "local";
        device = "/dev/disk/by-uuid/a1ee534d-78d8-42df-be26-9cadae8197cf";
      };
    };

    # Features
    features = {
      cpu-power-management.enable = true;
    };

    # Profile and overrides
    profiles.workstation.enable = true;
    services.ssh.enable = true;
  };
}
