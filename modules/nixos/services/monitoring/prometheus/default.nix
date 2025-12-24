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

  # Find all hosts with node-exporter enabled from centralized host list
  hostsWithNodeExporter = lib.filterAttrs (_: host: host.hasNodeExporter) config.bigor.network.hosts;

  # Node exporter port (standard)
  nodeExporterPort = 9100;

  # Build scrape targets for node exporters
  nodeTargets = lib.filter (t: t != null) (
    lib.mapAttrsToList (
      hostName: host:
      if hostName == config.networking.hostName then
        "127.0.0.1:${toString nodeExporterPort}"
      else if host.ip != null then
        # Remote host with static IP
        "${host.ip}:${toString nodeExporterPort}"
      else
        # Skip DHCP hosts (unreliable for scraping)
        null
    ) hostsWithNodeExporter
  );

  # Blocky metrics on port 4000
  blockyMetricsPort = 4000;

  # Alertmanager port (hardcoded)
  alertmanagerPort = 9093;
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
          static_configs = [ { targets = [ "127.0.0.1:${toString alertmanagerPort}" ]; } ];
        }
      ];
      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [ { targets = nodeTargets; } ];
        }
        {
          job_name = "blocky";
          static_configs = [ { targets = [ "127.0.0.1:${toString blockyMetricsPort}" ]; } ];
        }
      ];
    };
  };
}
