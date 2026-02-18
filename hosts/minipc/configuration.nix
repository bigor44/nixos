# Host: minipc
# Purpose: Homelab server (DNS, Caddy, monitoring)
{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "minipc";
  system.stateVersion = "25.11";

  boot.kernelPackages = pkgs.linuxPackages;

  bigor = {
    features = {
      dev = {
        tools.enable = true;
        scripts.enable = true;
      };
      services = {
        blocky = {
          enable = true;
          openFirewall = true;
        };
        sshd = {
          enable = true;
          openFirewall = true;
        };
        caddy.enable = true;
      };

    };
  };

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/a1ee534d-78d8-42df-be26-9cadae8197cf";
    fsType = "ext4";
  };

  hardware.cpu.amd.updateMicrocode = true;
}
