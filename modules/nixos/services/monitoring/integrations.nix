# modules/nixos/services/monitoring/integrations.nix
{config, ...}: let
  cfg = config.services.monitoring;
in {
  # Add monitoring endpoints to Caddy reverse proxy
  services.caddy.virtualHosts = {
    "${cfg.grafana.domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.grafana.port}
      tls internal
      basic_auth bigor admin
    '';
    "prometheus.bigor.lan".extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.prometheus.port}
      tls internal
      basic_auth bigor admin
    '';
    "alertmanager.bigor.lan".extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.prometheus.alertmanager.port}
      tls internal
      basic_auth bigor admin
    '';
  };

  # Add monitoring services to Homepage dashboard
  services.homepage-dashboard.services = [
    {
      "Monitoring" = [
        {
          "Grafana" = {
            icon = "grafana.png";
            href = "https://${cfg.grafana.domain}";
            description = "Metrics Visualization";
            widget = {
              type = "grafana";
              url = "http://127.0.0.1:${toString cfg.grafana.port}";
            };
          };
        }
        {
          "Prometheus" = {
            icon = "prometheus.png";
            href = "https://prometheus.bigor.lan";
            description = "Metrics Collection";
          };
        }
        {
          "Alertmanager" = {
            icon = "alertmanager.png";
            href = "https://alertmanager.bigor.lan";
            description = "Alert Management";
            widget = {
              type = "alertmanager";
              url = "http://127.0.0.1:${toString cfg.prometheus.alertmanager.port}";
            };
          };
        }
      ];
    }
  ];
}
