# Host: minidesk
# Purpose: Portable workstation
{ pkgs, ... }:
{
  imports = [ ../minipc/hardware-configuration.nix ];

  networking.hostName = "minidesk";
  system.stateVersion = "25.11";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  bigor = {
    features = {
      # From desktop profile
      graphics = {
        desktop.enable = true;
        flatpak.enable = true;
        gaming.enable = true; # Host specific
      };
      hardware = {
        audio.enable = true;
        bluetooth.enable = true;
      };

      # From dev profile
      dev = {
        tools.enable = true;
        scripts.enable = true;
        nixvim.enable = true;
      };
    };
  };

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/a1ee534d-78d8-42df-be26-9cadae8197cf";
    fsType = "ext4";
  };
}
