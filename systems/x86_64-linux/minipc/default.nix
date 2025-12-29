# System: minipc
# Purpose: Homelab server with DNS, Caddy, and NFS
{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "minipc";
  system.stateVersion = "25.05";

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

  # Swapfile configuration (16GB, encrypted)
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB in MB
      randomEncryption = true; # Encrypted swap for security
    }
  ];
}
