{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.services.monitoring.grafana;
  serverIP = config.bigor.network.ips.minipc;
  domain = "grafana.bigor.lan";
in
{
  # ============================================================================
  # File: modules/nixos/services/monitoring/grafana/default.nix
  # Description: Grafana Visualization Service
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Deploys Grafana for visualizing metrics.
  # ============================================================================

  options.bigor.services.monitoring.grafana = {
    enable = mkEnableOption "Enable Grafana visualization service";
  };

  config = mkIf cfg.enable {
    services = {
      grafana = {
        enable = true;
        settings.server.http_port = 3000;
        settings.server.domain = domain;

        provision = {
          enable = true;
          datasources.settings.datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              url = "http://127.0.0.1:9090";
            }
          ];
          dashboards.settings.providers = [
            {
              name = "Node Exporter";
              options.path = ./dashboards;
            }
          ];
        };
      };

      caddy.virtualHosts."${domain}" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:3000
          tls internal
        '';
      };

      adguardhome.settings.filtering.rewrites = [
        {
          inherit domain;
          answer = serverIP;
          enabled = true;
        }
      ];
    };
  };
}
