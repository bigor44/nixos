# Feature: monitoring-grafana
# Purpose: Grafana analytics and visualization
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.bigor.features.monitoring.grafana;
  networkCfg = config.bigor.network;
in
{
  options.bigor.features.monitoring.grafana.enable =
    mkEnableOption "Grafana analytics and visualization";

  config = mkIf cfg.enable (mkMerge [
    {
      services.grafana = {
        enable = true;
        settings = {
          server = {
            http_port = 3000;
            http_addr = "0.0.0.0";
            domain = "grafana.${networkCfg.domain}";
            root_url = "https://grafana.${networkCfg.domain}/";
          };
        };
      };

      networking.firewall.allowedTCPPorts = [ 3000 ];
    }
    {
      bigor.network.serviceRecords = {
        grafana = networkCfg.hosts.${config.networking.hostName};
      };
    }
    (mkIf config.bigor.features.services.caddy.enable {
      services.caddy.virtualHosts."grafana.${networkCfg.domain}".extraConfig = ''
        tls internal
        reverse_proxy 127.0.0.1:3000
      '';
    })
  ]);
}
