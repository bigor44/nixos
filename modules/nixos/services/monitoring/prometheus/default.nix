# Module: prometheus
# Purpose: Metrics collection and time-series database
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
  options.bigor.services.monitoring.prometheus.enable = mkEnableOption "Prometheus monitoring";

  config = mkIf cfg.enable {
    services.prometheus = {
      enable = true;
      port = 9090;
      alertmanagers = [
        {
          scheme = "http";
          static_configs = [ { targets = [ "127.0.0.1:9093" ]; } ];
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
        {
          job_name = "blocky";
          static_configs = [
            {
              targets = [ "127.0.0.1:4000" ];
            }
          ];
        }
      ];
    };

    # Exposure configured in modules/nixos/lib/network-topology (SSOT)
  };
}
