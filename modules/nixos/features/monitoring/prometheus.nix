# Feature: monitoring-prometheus
# Purpose: Prometheus monitoring system
{
  config,
  lib,
  ...
}:
let
  cfg = config.bigor.features.monitoring.prometheus;
in
{
  options.bigor.features.monitoring.prometheus.enable =
    lib.mkEnableOption "Prometheus monitoring system";

  config = lib.mkIf cfg.enable {
    services.prometheus = {
      enable = true;
      port = 9090;

      # Default scrape config for local node-exporter if it's enabled
      scrapeConfigs =
        (lib.optional config.bigor.features.monitoring.node-exporter.enable {
          job_name = "node";
          static_configs = [
            {
              targets = lib.mapAttrsToList (
                _: ip: "${ip}:${toString config.services.prometheus.exporters.node.port}"
              ) config.bigor.network.hosts;
            }
          ];
        })
        ++ (lib.optional config.bigor.features.services.blocky.enable {
          job_name = "blocky";
          static_configs = [
            {
              targets = [
                "127.0.0.1:${toString config.services.blocky.settings.ports.http}"
              ];
            }
          ];
        });
    };

    networking.firewall.allowedTCPPorts = [ 9090 ];
  };
}
