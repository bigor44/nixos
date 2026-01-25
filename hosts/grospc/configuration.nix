# Host: grospc
# Purpose: Desktop workstation with gaming
{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "grospc";
  system.stateVersion = "25.11";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  bigor = {
    platform.dns.upstreamServers = [
      "${config.bigor.network.hosts.minipc.ip}:${toString config.bigor.network.ports.dns.main}"
    ]
    ++ config.bigor.platform.dns.defaultDohUpstreams;

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
        keyboardVIA.enable = true; # Host specific
      };

      # From dev profile
      dev = {
        tools.enable = true;
        scripts.enable = true;
        nixvim.enable = true;
      };
    };
  };

  fileSystems."/steamlibrary" = {
    device = "/dev/disk/by-uuid/eca2097b-72d2-46cc-95d3-3b1d546afffc";
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
    ];
  };
}
