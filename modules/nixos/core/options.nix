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
    monitoring = {
      enable = lib.mkEnableOption "Enable Monitoring (Node Exporter)";
      isServer = lib.mkEnableOption "Enable Monitoring Server (Prometheus + Grafana)";
    };
    nfs = {
      server = lib.mkEnableOption "Enable NFS Server Share";
      client = lib.mkEnableOption "Enable NFS Client Mount";
    };
  };
}
