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
    # Platform policies: strategic infrastructure decisions
    platform.policies = {
      dns.mode = "local-recursive";
      storage = {
        mode = "nfs-server";
        device = "/dev/disk/by-uuid/a1ee534d-78d8-42df-be26-9cadae8197cf";
      };
    };

    # Capabilities: optional features and services
    capabilities = {
      cpu-power-management.enable = true;

      # Services (expanded from homelab-master profile)
      ssh.enable = true;
      caddy.enable = true;
      unbound.enable = true;
      uptime-kuma.enable = true;
      blocky.enable = true;
      nfs-server.enable = true;
    };
  };

  hardware.cpu.amd.updateMicrocode = true;
}
