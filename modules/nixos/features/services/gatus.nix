# Feature: services-gatus
# Purpose: Status page and monitoring (Configuration as Code alternative to Uptime Kuma)
{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    optional
    ;
  cfg = config.bigor.features.services.gatus;
  networkCfg = config.bigor.network;
in
{
  options.bigor.features.services.gatus.enable = mkEnableOption "Gatus status page";

  config = mkIf cfg.enable (mkMerge [
    {
      services.gatus = {
        enable = true;
        settings = {
          web.port = 8080;
          endpoints = [
            {
              name = "Internet (Cloudflare)";
              group = "External";
              url = "https://1.1.1.1";
              interval = "30s";
              conditions = [ "[CONNECTED] == true" ];
            }
          ]
          ++
            # Blocky DNS (platform service - always present)
            [
              {
                name = "Service: Blocky DNS";
                group = "Local Services";
                url = "127.0.0.1:53";
                dns = {
                  query-name = "google.com";
                  query-type = "A";
                };
                interval = "30s";
                conditions = [ "[DNS_RCODE] == NOERROR" ];
              }
            ]
          ++
            # Dynamic: Check Caddy HTTPS if enabled
            (optional config.bigor.features.services.caddy.enable {
              name = "Service: Caddy HTTPS";
              group = "Local Services";
              url = "https://status.${networkCfg.domain}";
              interval = "1m";
              conditions = [ "[STATUS] == 200" ];
            });
        };
      };

      networking.firewall.allowedTCPPorts = [ 8080 ];
    }
    (mkIf config.bigor.features.services.caddy.enable {
      services.caddy.virtualHosts."status.${networkCfg.domain}".extraConfig = ''
        tls internal
        reverse_proxy 127.0.0.1:8080
      '';
    })
  ]);
}
