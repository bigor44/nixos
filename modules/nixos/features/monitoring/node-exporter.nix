# Feature: monitoring-node-exporter
# Purpose: Prometheus node exporter
{
  config,
  lib,
  ...
}:
let
  cfg = config.bigor.features.monitoring.node-exporter;
in
{
  options.bigor.features.monitoring.node-exporter.enable =
    lib.mkEnableOption "Prometheus node exporter";

  config = lib.mkIf cfg.enable {
    services.prometheus.exporters.node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
      port = 9100;
    };

    networking.firewall.allowedTCPPorts = [ 9100 ];
  };
}
