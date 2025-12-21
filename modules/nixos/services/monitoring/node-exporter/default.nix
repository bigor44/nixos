# Module: node-exporter
# Purpose: System metrics exporter for Prometheus
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.services.monitoring.node-exporter;
in
{
  options.bigor.services.monitoring.node-exporter.enable = mkEnableOption "Node Exporter";

  config = mkIf cfg.enable {
    services.prometheus.exporters.node = {
      enable = true;
      port = 9100;
      enabledCollectors = [ "systemd" ];
    };

    bigor.lib.exposedService.node-exporter = {
      port = 9100;
      openFirewall = true;
    };
  };
}
