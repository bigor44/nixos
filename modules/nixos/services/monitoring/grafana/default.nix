# Module: grafana
# Purpose: Metrics visualization and dashboards
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.services.monitoring.grafana;
in
{
  options.bigor.services.monitoring.grafana.enable = mkEnableOption "Grafana visualization";

  config = mkIf cfg.enable {
    services.grafana = {
      enable = true;
      settings.server.http_port = 3000;
      settings.server.domain = "grafana.bigor.lan";

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
  };
}
