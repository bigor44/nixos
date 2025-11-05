/*
  Title: Dashboard Configuration
  Description: Configures Grafana and Prometheus for system monitoring and dashboards.
*/
{
  config,
  lib,
  ...
}:
lib.mkIf config.server.enable {
  networking.firewall.allowedTCPPorts = [ 9090 ];
  services.grafana = {
    enable = true;
    openFirewall = true;
    settings.server = {
      domain = "minipc.lan";
      http_addr = "0.0.0.0";
    };
  };

  services.prometheus = {
    enable = true;
    listenAddress = "127.0.0.1";
    scrapeConfigs = [
      {
        job_name = "exporters";
        static_configs = [
          {
            targets = [
              "127.0.0.1:9100"
            ];
          }
        ];
      }
    ];
  };
  services.prometheus.exporters.node = {
    enable = true;
    openFirewall = true;
    enabledCollectors = [ "systemd" ];
  };
}
