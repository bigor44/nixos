# Host: grospc
# Purpose: Desktop workstation with gaming
{ pkgs, config, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "grospc";
  system.stateVersion = "25.11";

  # Kernel: latest for desktop performance
  boot.kernelPackages = pkgs.linuxPackages_latest;

  bigor = {
    profiles = [
      "desktop"
      "dev"
    ];

    platform.dns.upstreamServers = [
      "${config.bigor.network.hosts.minipc.ip}:${toString config.bigor.network.ports.dns.main}"
    ]
    ++ config.bigor.platform.dns.defaultDohUpstreams;

    # Host-specific, volontairement hors profil
    features.graphics.gaming.enable = true;
    features.hardware.keyboardVIA.enable = true;
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
