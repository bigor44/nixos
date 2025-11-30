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
    # --- SERVER Configuration (minipc) ---
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

    # --- CLIENT Configuration (grospc) ---
    (lib.mkIf cfg.client {
      fileSystems."/mnt/storage" = {
        device = "${ips.minipc}:/mnt/storage";
        fsType = "nfs";
        # x-systemd.automount avoids blocking boot if server is off
        options = [
          "x-systemd.automount"
          "noauto"
          "nfsvers=4.2"
          "timeo=14"
          "retrans=2"
        ];
      };
    })
  ];
}
