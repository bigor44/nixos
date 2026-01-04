# Module: nfs
# Purpose: Network file sharing (server exports, client mounts)
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.services.nfs;
  inherit (config.bigor.network) ips mainInterface;
in
{
  options.bigor.services.nfs = {
    server = mkEnableOption "NFS server exporting /mnt/storage";
    client = mkEnableOption "NFS client mounting remote shares";
  };

  config =
    let
      # NFS export options: all requests mapped to bigor (1000:100) for security
      nfsOptions = "rw,sync,no_subtree_check,secure,all_squash,anonuid=1000,anongid=100";
    in
    mkMerge [
      (mkIf cfg.server {
        services.nfs.server = {
          enable = true;
          exports = ''
            /mnt/storage ${config.bigor.network.subnet}(${nfsOptions})
          '';
        };

        # Open NFS ports (RPC + NFS server)
        networking.firewall.interfaces.${mainInterface} = {
          allowedTCPPorts = [
            111
            2049
          ];
          allowedUDPPorts = [
            111
            2049
          ];
        };
      })

      (mkIf cfg.client {
        fileSystems."/mnt/storage" = {
          device = "${ips.minipc}:/mnt/storage";
          fsType = "nfs";
          # Automount on access, not at boot
          options = [
            "x-systemd.automount"
            "_netdev"
            "nofail"
            "noatime"
            "soft"
            "timeo=600"
            "retrans=5"
          ];
        };
      })
    ];
}
