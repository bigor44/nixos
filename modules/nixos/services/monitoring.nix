{
  config,
  lib,
  ...
}: let
  cfg = config.monitoring;
  inherit (config.myNetwork) ips;
in {
  config = lib.mkMerge [
    # ---------------------------------------------------------
    # Partie AGENT (Installé partout où monitoring.enable = true)
    # ---------------------------------------------------------
    (lib.mkIf cfg.enable {
      services.prometheus.exporters.node = {
        enable = true;
        enabledCollectors = ["systemd"];
        port = 9100;
      };

      # Ouvrir le port pour que Prometheus puisse venir lire les données
      networking.firewall.allowedTCPPorts = [9100];
    })

    # ---------------------------------------------------------
    # Partie SERVEUR (Installé uniquement sur le minipc)
    # ---------------------------------------------------------
    (lib.mkIf (cfg.enable && cfg.isServer) {
      # --- Prometheus ---
      services.prometheus = {
        enable = true;
        port = 9090;
        checkConfig = "syntax-only";

        scrapeConfigs = [
          {
            job_name = "node";
            static_configs = [
              {
                targets = [
                  "127.0.0.1:9100" # Le minipc lui-même
                  "${ips.grospc}:9100" # Le grospc (IP déduite de ton adguard.nix)
                ];
                labels = {
                  type = "node";
                };
              }
            ];
          }
        ];
      };

      # --- Grafana ---
      services.grafana = {
        enable = true;
        settings = {
          server = {
            http_port = 3000;
            http_addr = "0.0.0.0"; # Accessible depuis le réseau
          };
        };

        # Provisioning automatique de la source de données Prometheus
        provision.enable = true;
        provision.datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://127.0.0.1:9090";
          }
        ];
      };

      networking.firewall.allowedTCPPorts = [3000];
    })
  ];
}
