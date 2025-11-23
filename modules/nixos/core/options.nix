{lib, ...}: let
  roleEnum = ["desktop" "server" "hybrid"];
in {
  options = {
    system.role = lib.mkOption {
      type = lib.types.enum roleEnum;
      default = "server";
      description = "Définit le profil global de la machine (desktop, server, etc.)";
    };

    desktop.enable = lib.mkEnableOption "Enable Cosmic Desktop";
    sshd.enable = lib.mkEnableOption "Enable SSH Server";
    dashboard.enable = lib.mkEnableOption "Enable Homepage Dashboard";
    reverse_proxy.enable = lib.mkEnableOption "Enable Caddy Reverse Proxy";
    monitoring = {
      enable = lib.mkEnableOption "Enable Monitoring (Node Exporter)";
      isServer = lib.mkEnableOption "Enable Monitoring Server (Prometheus + Grafana)";
    };
    nfs = {
      server = lib.mkEnableOption "Enable NFS Server Share";
      client = lib.mkEnableOption "Enable NFS Client Mount";
    };
    myNetwork.ips = {
      grospc = lib.mkOption {
        type = lib.types.str;
        default = "192.168.1.1"; #
        description = "Adresse IP statique du Desktop (grospc)";
      };
      minipc = lib.mkOption {
        type = lib.types.str;
        default = "192.168.1.10"; #
        description = "Adresse IP statique du Serveur (minipc)";
      };
    };
  };
}
