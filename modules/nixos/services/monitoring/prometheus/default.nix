# ============================================================================
# File: modules/nixos/services/monitoring/prometheus/default.nix
# Description: Configures the Prometheus monitoring service.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.services.monitoring.prometheus;
in
{
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
    };

    bigor.lib.exposedService.prometheus = {
      port = 9090;
      domain = "prometheus.bigor.lan";
    };
  };
}
