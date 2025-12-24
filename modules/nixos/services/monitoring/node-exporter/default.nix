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
  inherit (config.bigor.network) mainInterface;
in
{
  options.bigor.services.monitoring.node-exporter.enable = mkEnableOption "Node Exporter";

  config = mkIf cfg.enable {
    services.prometheus.exporters.node = {
      enable = true;
      port = 9100;
      enabledCollectors = [ "systemd" ];
    };

    # Open port for Prometheus scraping from other hosts
    networking.firewall.interfaces.${mainInterface} = {
      allowedTCPPorts = [ 9100 ];
    };
  };
}
