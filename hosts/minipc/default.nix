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
    platform = {
      dns.mode = "server";

      policies.storage = {
        mode = "nfs-server";
        device = "/dev/disk/by-uuid/a1ee534d-78d8-42df-be26-9cadae8197cf";
      };
    };

    features = {
      dev = {
        git.enable = true;
        tools.enable = true;
        scripts.enable = true;
        nixvim.enable = true;
      };
      hardware = {
        cpu-power-management.enable = true;
      };
      services = {
        sshd.enable = true;
        caddy.enable = true;
        gatus.enable = true;
      };
    };
  };

  hardware.cpu.amd.updateMicrocode = true;
}
