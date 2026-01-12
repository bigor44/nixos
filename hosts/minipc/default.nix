# Host: minipc
# Purpose: Homelab server with DNS, Caddy, and NFS
{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "minipc";
  system.stateVersion = "25.11";

  # Kernel: LTS for stability
  boot.kernelPackages = pkgs.linuxPackages;

  bigor = {
    # Policies: strategic decisions
    policies = {
      dns.mode = "local-recursive";
      storage = {
        mode = "nfs-server";
        device = "/dev/disk/by-uuid/a1ee534d-78d8-42df-be26-9cadae8197cf";
      };
    };

    # Features
    features = {
      cpu-power-management.enable = true;
    };

    # Profile
    profiles.homelab-master.enable = true;
  };

  hardware.cpu.amd.updateMicrocode = true;
}
