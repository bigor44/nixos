# Module: uptime-kuma
# Purpose: Uptime monitoring service with Caddy reverse proxy
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.capabilities.uptime-kuma;
  networkCfg = config.bigor.network;
in
{
  options.bigor.capabilities.uptime-kuma.enable = mkEnableOption "Uptime Kuma monitoring service";

  config = mkIf cfg.enable {
    services.uptime-kuma = {
      enable = true;
    };

    systemd.services.uptime-kuma.environment.PORT = toString networkCfg.ports.uptime-kuma;

    services.caddy.virtualHosts."kuma.${networkCfg.domain}".extraConfig = ''
      tls internal
      reverse_proxy 127.0.0.1:${toString networkCfg.ports.uptime-kuma}
    '';
  };
}
