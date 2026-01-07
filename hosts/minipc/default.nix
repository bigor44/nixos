# Host: minipc
# Purpose: Homelab server with DNS, Caddy, and NFS
{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "minipc";
  system.stateVersion = "25.11";

  bigor = {
    profiles.homelab-master.enable = true;
    network.mainInterface = "enp2s0";

    services = {
      # DNS Stack: Unbound + Blocky
      unbound.listenOnLan = true;
      blocky.useLocalUnbound = true;

      # Local storage for NFS server
      nfs.localStorage = {
        enable = true;
        device = "/dev/disk/by-uuid/a1ee534d-78d8-42df-be26-9cadae8197cf";
      };
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [ "amd_pstate=active" ];
  };

  hardware.cpu.amd.updateMicrocode = true;
}
