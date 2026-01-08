# Host: minidesk
# Purpose: Portable workstation (can use local storage when available)
{ pkgs, ... }:
{
  # Reuse minipc hardware config (same hardware base)
  imports = [ ../minipc/hardware-configuration.nix ];

  networking.hostName = "minidesk";
  system.stateVersion = "25.11";

  boot.kernelParams = [ "amd_pstate=active" ];
  boot.kernelPackages = pkgs.linuxPackages_zen;

  bigor = {
    profiles.workstation.enable = true;

    services = {
      ssh.enable = true;
      blocky.portableMode = true; # Skip minipc, use Cloudflare directly

      # Local storage (same disk as minipc)
      nfs.localStorage = {
        enable = true;
        device = "/dev/disk/by-uuid/a1ee534d-78d8-42df-be26-9cadae8197cf";
      };
    };
  };
}
