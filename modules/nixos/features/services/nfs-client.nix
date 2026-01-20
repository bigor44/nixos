# Feature: services-nfs-client
# Purpose: NFS client configuration for mounting remote storage
{
  config,
  lib,
  ...
}:
let
  cfg = config.bigor.features.services.nfs-client;
in
{
  options.bigor.features.services.nfs-client.enable = lib.mkEnableOption "NFS client";

  config = lib.mkIf cfg.enable {
    fileSystems."/mnt/storage" = {
      device = "${config.bigor.network.hosts.minipc.ip}:/mnt/storage";
      fsType = "nfs";
      # Automount on access, not at boot
      options = [
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
        "_netdev"
        "nofail"
        "noatime"
        "soft"
        "timeo=30"
        "retrans=2"
        "rsize=32768"
        "wsize=32768"
      ];
    };
  };
}
