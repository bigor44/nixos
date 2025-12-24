# Module: caddy
# Purpose: Reverse proxy with automatic HTTPS
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.services.caddy;
  inherit (config.bigor.network) mainInterface;
in
{
  options.bigor.services.caddy.enable = mkEnableOption "Caddy reverse proxy";

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      virtualHosts = {
        "prometheus.bigor.lan" = {
          extraConfig = ''
            reverse_proxy http://127.0.0.1:9090
            tls internal
          '';
        };
        "grafana.bigor.lan" = {
          extraConfig = ''
            reverse_proxy http://127.0.0.1:3000
            tls internal
          '';
        };
        "alertmanager.bigor.lan" = {
          extraConfig = ''
            reverse_proxy http://127.0.0.1:9093
            tls internal
          '';
        };
      };
    };

    # Open Caddy ports
    networking.firewall.interfaces.${mainInterface} = {
      allowedTCPPorts = [
        80
        443
      ];
    };
  };
}
