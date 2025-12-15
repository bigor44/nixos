{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.services.monitoring.prometheus;
  serverIP = config.bigor.network.ips.minipc;
  domain = "prometheus.bigor.lan";
in
{
  # ============================================================================
  # File: modules/nixos/services/monitoring/prometheus/default.nix
  # Description: Prometheus Monitoring Service
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Deploys Prometheus for metrics collection.
  # ============================================================================

  options.bigor.services.monitoring.prometheus = {
    enable = mkEnableOption "Enable Prometheus monitoring service";
  };

  config = mkIf cfg.enable {
    services = {
      prometheus = {
        enable = true;
        port = 9090;
        alertmanagers = [
          {
            scheme = "http";
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
                  "127.0.0.1:9100"
                  "${config.bigor.network.ips.grospc}:9100"
                ];
              }
            ];
          }
        ];
      };

      caddy.virtualHosts."${domain}" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:9090
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
