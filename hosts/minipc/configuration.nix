# Host: minipc
# Purpose: Homelab server (DNS, Caddy, NFS, monitoring)
{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "minipc";
  system.stateVersion = "25.11";

  bigor = {
    profiles = [
      "server"
      "homelab-master"
    ];
  };

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/a1ee534d-78d8-42df-be26-9cadae8197cf";
    fsType = "ext4";
  };

  hardware.cpu.amd.updateMicrocode = true;
}
