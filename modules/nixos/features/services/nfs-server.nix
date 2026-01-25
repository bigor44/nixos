# Feature: services-nfs-server
# Purpose: NFS server configuration for exporting storage
{
  config,
  lib,
  ...
}:
let
  cfg = config.bigor.features.services.nfs-server;

  # NFS export options: all requests mapped to bigor (1000:100) for security
  nfsOptions = "rw,sync,no_subtree_check,secure,all_squash,anonuid=1000,anongid=100";
in
{
  options.bigor.features.services.nfs-server.enable = lib.mkEnableOption "NFS server";

  config = lib.mkIf cfg.enable {
    services.nfs.server = {
      enable = true;
      exports = ''
        /mnt/storage ${config.bigor.network.subnet}(${nfsOptions})
      '';
    };

    networking.firewall = {
      allowedTCPPorts = [
        111
        2049
      ];
      allowedUDPPorts = [
        111
        2049
      ];
    };
  };
}
