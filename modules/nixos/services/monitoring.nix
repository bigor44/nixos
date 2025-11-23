{
  config,
  lib,
  ...
}:
let
  cfg = config.monitoring;
  inherit (config.myNetwork) ips;
in
{
  config = lib.mkMerge [
    # ---------------------------------------------------------
    # Partie AGENT (Installé partout où monitoring.enable = true)
    # ---------------------------------------------------------
    (lib.mkIf cfg.enable {
      services.prometheus.exporters.node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9100;
      };

      # Ouvrir le port pour que Prometheus puisse venir lire les données
      networking.firewall.allowedTCPPorts = [ 9100 ];
    })

    # ---------------------------------------------------------
    # Partie SERVEUR (Installé uniquement sur le minipc)
    # ---------------------------------------------------------
    (lib.mkIf (cfg.enable && cfg.isServer) {
      # --- Prometheus, Grafana, Alertmanager ---
      services = {
        prometheus = {
          enable = true;
          port = 9090;
          checkConfig = "syntax-only";

          alertmanagers = [
            {
              static_configs = [
                {
                  targets = [ "127.0.0.1:9093" ];
                }
              ];
            }
          ];

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

          alertmanager = {
            enable = true;
            port = 9093;
            webExternalUrl = "https://alerts.bigor.lan";
            configuration = {
              global = {
                # smtp_smarthost = "smtp.example.org:587";
                # ... configuration SMTP ...
              };
              route = {
                group_by = [ "alertname" ];
                group_wait = "30s";
                group_interval = "5m";
                repeat_interval = "1h";
                receiver = "default-receiver";
              };
              receivers = [
                {
                  name = "default-receiver";
                  # email_configs = ...
                }
              ];
            };
          };
        };

        grafana = {
          enable = true;
          settings = {
            server = {
              http_port = 3000;
              http_addr = "127.0.0.1";
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
            {
              name = "Alertmanager";
              type = "alertmanager";
              access = "proxy";
              url = "http://127.0.0.1:9093";
              jsonData = {
                implementation = "prometheus";
              };
            }
          ];
        };
      };
    })
  ];
}
