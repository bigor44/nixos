/*
  Title: Monitoring Configuration
  Description: Configures the Prometheus node exporter for system monitoring.
*/
{
  lib,
  config,
  ...
}:
lib.mkIf config.monitoring.enable {
  services.prometheus.exporters.node = {
    enable = true;
    openFirewall = true;
    enabledCollectors = [ "systemd" ];
  };
}
