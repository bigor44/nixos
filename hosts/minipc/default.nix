# Host: minipc
# Purpose: Homelab server with DNS, Caddy, and NFS
{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Mount external storage
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/a1ee534d-78d8-42df-be26-9cadae8197cf";
    fsType = "ext4";
  };

  networking.hostName = "minipc";
  system.stateVersion = "25.11";

  bigor = {
    profiles.homelab-master.enable = true;
    network.mainInterface = "enp2s0";

    # DNS Stack: Unbound + Blocky
    services = {
      # Open Unbound to LAN for other hosts
      unbound.listenOnLan = true;
      # Blocky uses local Unbound (no failover needed)
      blocky.useLocalUnbound = true;
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [ "amd_pstate=active" ];
  };

  hardware.cpu.amd.updateMicrocode = true;
}
