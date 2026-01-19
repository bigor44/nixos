# Feature: nfs-client
# Purpose: NFS client configuration for mounting remote storage
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.features.nfs-client;
in
{
  options.bigor.features.nfs-client.enable = mkEnableOption "NFS client";

  config = mkIf cfg.enable {
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
