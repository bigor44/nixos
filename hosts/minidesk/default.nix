# Host: minidesk
# Purpose: Portable workstation (travel mode, no NFS mount)
{ lib, pkgs, ... }:
{
  # Reuse minipc hardware config (same hardware base)
  imports = [ ../minipc/hardware-configuration.nix ];

  # Disable NFS mount in travel mode (disk not present)
  fileSystems."/mnt/storage" = lib.mkForce {
    device = "none";
    fsType = "none";
    options = [ "noauto" ];
  };

  networking.hostName = "minidesk";
  system.stateVersion = "25.11";

  boot.kernelParams = [ "amd_pstate=active" ];
  boot.kernelPackages = pkgs.linuxPackages_zen;

  bigor = {
    profiles.workstation.enable = true;
    network.mainInterface = "enp2s0";

    services.ssh.enable = true;
  };
}
