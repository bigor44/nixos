{
  lib,
  config,
  ...
}: let
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
  };

  config = lib.mkMerge [
    # --- Configuration pour le rôle SERVEUR ---
    (lib.mkIf (config.system.role == "server") {
      desktop.enable = lib.mkDefault false;
      sshd.enable = lib.mkDefault true;
      dashboard.enable = lib.mkDefault true;
      monitoring.isServer = lib.mkDefault true;
    })

    # --- Configuration pour le rôle DESKTOP ---
    (lib.mkIf (config.system.role == "desktop") {
      desktop.enable = lib.mkDefault true; # Cosmic activé
      sshd.enable = lib.mkDefault false; # Pas de SSH par défaut (sécurité)
      dashboard.enable = lib.mkDefault false;
      monitoring.isServer = lib.mkDefault false;
    })

    # --- Configuration pour le rôle HYBRID (Optionnel) ---
    (lib.mkIf (config.system.role == "hybrid") {
      desktop.enable = lib.mkDefault true;
      sshd.enable = lib.mkDefault true;
    })
  ];
}
