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
    # Register Node Exporter in registry (multi-host: use hostname suffix)
    bigor.registry.services."node-exporter-${config.networking.hostName}" = {
      inherit (config.networking) hostName;
      port = 9100;
      domain = null;
      reverseProxy = false;
      openFirewall = true;
      openFirewallUDP = false;
      proxyProtocol = "http";
    };

    services.prometheus.exporters.node = {
      enable = true;
      port = 9100;
      enabledCollectors = [ "systemd" ];
    };
  };
}
