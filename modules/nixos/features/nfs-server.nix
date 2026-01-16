# Feature: nfs-server
# Purpose: NFS server configuration for exporting storage
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.features.nfs-server;

  # NFS export options: all requests mapped to bigor (1000:100) for security
  nfsOptions = "rw,sync,no_subtree_check,secure,all_squash,anonuid=1000,anongid=100";
in
{
  options.bigor.features.nfs-server.enable = mkEnableOption "NFS server";

  config = mkIf cfg.enable {
    services.nfs.server = {
      enable = true;
      exports = ''
        /mnt/storage ${config.bigor.network.subnet}(${nfsOptions})
      '';
    };
  };
}
