# Host: grospc
# Purpose: Desktop workstation with gaming optimizations
{ pkgs, config, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "grospc";
  system.stateVersion = "25.11";

  # Kernel: Zen for desktop performance
  boot.kernelPackages = pkgs.linuxPackages_zen;

  bigor = {
    platform = {
      dns.upstreamServers = [
        "${config.bigor.network.hosts.minipc.ip}:${toString config.bigor.network.ports.blocky.dns}"
      ]
      ++ config.bigor.platform.dns.defaultDohUpstreams;
    };

    features = {
      services.nfs-client.enable = true;

      dev = {
        tools.enable = true;
        scripts.enable = true;
        nixvim.enable = true;
      };
      graphics = {
        desktop.enable = true;
        flatpak.enable = true;
        gaming.enable = true;
      };
      hardware = {
        cpu-power-management.enable = true;
        keyboardVIA.enable = true;
        audio.enable = true;
        bluetooth.enable = true;
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
