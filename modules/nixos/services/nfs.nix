{
  config,
  lib,
  ...
}:
let
  cfg = config.nfs;
  inherit (config.myNetwork) ips;
in
{
  config = lib.mkMerge [
    # --- Configuration SERVEUR (minipc) ---
    (lib.mkIf cfg.server {
      services.nfs.server = {
        enable = true;
        exports = ''
          /mnt/storage 192.168.1.0/24(rw,sync,no_subtree_check,secure,all_squash,anonuid=1000,anongid=100)
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
    })

    # --- Configuration CLIENT (grospc) ---
    (lib.mkIf cfg.client {
      fileSystems."/mnt/storage" = {
        device = "${ips.minipc}:/mnt/storage";
        fsType = "nfs";
        # x-systemd.automount évite de bloquer le boot si le serveur est éteint
        options = [
          "x-systemd.automount"
          "noauto"
          "nfsvers=4.2"
        ];
      };
    })
  ];
}
