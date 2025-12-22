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

  # Find all node-exporter instances from registry
  nodeExporters = lib.filterAttrs (
    name: _: lib.hasPrefix "node-exporter-" name
  ) config.bigor.registry.services;

  # Build scrape targets for node exporters
  nodeTargets = lib.mapAttrsToList (
    _: svc:
    if svc.hostName == config.networking.hostName then
      "127.0.0.1:${toString svc.port}"
    else
      "${config.bigor.network.hosts.${svc.hostName}.ip}:${toString svc.port}"
  ) nodeExporters;

  # Blocky metrics on port 4000
  blockyMetricsPort = 4000;

  # Find Alertmanager port from registry
  alertmanagerPort = config.bigor.registry.services.alertmanager.port or 9093;
in
{
  options.bigor.services.monitoring.prometheus.enable = mkEnableOption "Prometheus monitoring";

  config = mkIf cfg.enable {
    # Register Prometheus in registry
    bigor.registry.services.prometheus = {
      inherit (config.networking) hostName;
      port = 9090;
      domain = "prometheus.bigor.lan";
      reverseProxy = true;
      openFirewall = false;
      openFirewallUDP = false;
      proxyProtocol = "http";
    };

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
