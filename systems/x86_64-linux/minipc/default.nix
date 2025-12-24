# System: minipc
# Purpose: Homelab server with monitoring, NFS, and Tailscale exit node
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "minipc";
  system.stateVersion = "25.05";

  bigor = {
    profiles.homelab-master.enable = true;
    network.mainInterface = "enp2s0";

    # Open Unbound to LAN for other hosts
    services.unbound.listenOnLan = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [ "amd_pstate=active" ];
  };

  hardware.cpu.amd.updateMicrocode = true;

  # UDP GRO forwarding critical for Tailscale throughput
  systemd.services.network-udp-gro = {
    description = "Enable UDP GRO forwarding for Tailscale";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.concatStringsSep " " [
        "${pkgs.ethtool}/bin/ethtool"
        "-K ${config.bigor.network.mainInterface}"
        "rx-udp-gro-forwarding on"
        "rx-gro-list on"
      ];
      SuccessExitStatus = "0 1";
    };
  };
}
