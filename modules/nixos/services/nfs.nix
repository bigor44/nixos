{
  config,
  lib,
  ...
}: let
  cfg = config.nfs;
in {
  config = lib.mkMerge [
    # --- Configuration SERVEUR (minipc) ---
    (lib.mkIf cfg.server {
      services.nfs.server = {
        enable = true;
        # Sécurisé : all_squash mappe tout accès vers l'utilisateur anonyme
        # anonuid/anongid forcent l'utilisation de votre user (1000:100)
        exports = ''
          /mnt/storage 192.168.1.1(rw,sync,no_subtree_check,all_squash,anonuid=1000,anongid=100)
        '';
      };
      networking.firewall.allowedTCPPorts = [2049];
    })

    # --- Configuration CLIENT (grospc) ---
    (lib.mkIf cfg.client {
      fileSystems."/mnt/storage" = {
        device = "192.168.1.10:/mnt/storage";
        fsType = "nfs";
        # x-systemd.automount évite de bloquer le boot si le serveur est éteint
        options = ["x-systemd.automount" "noauto"];
      };
    })
  ];
}
