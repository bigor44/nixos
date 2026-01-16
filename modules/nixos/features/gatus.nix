# Feature: gatus
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
    mapAttrsToList
    filterAttrs
    optional
    ;
  cfg = config.bigor.features.gatus;
  networkCfg = config.bigor.network;
in
{
  options.bigor.features.gatus.enable = mkEnableOption "Gatus status page";

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = cfg.enable -> config.bigor.features.caddy.enable;
          message = "Gatus status page requires Caddy to be enabled for HTTPS";
        }
      ];
    }
    {
      services.gatus = {
        enable = true;
        settings = {
          web.port = networkCfg.ports.gatus;
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
            # Dynamic: Ping other known hosts in the topology
            (mapAttrsToList (name: host: {
              name = "Host: ${name}";
              group = "Infrastructure";
              url = "icmp://${if host.ip != null then host.ip else name}";
              interval = "1m";
              conditions = [ "[CONNECTED] == true" ];
            }) (filterAttrs (n: h: n != config.networking.hostName && h.ip != null) networkCfg.hosts))
          ++
            # Dynamic: Check local Blocky DNS if enabled
            (optional config.bigor.features.blocky.enable {
              name = "Service: Blocky DNS";
              group = "Local Services";
              url = "127.0.0.1:${toString networkCfg.ports.blocky.dns}";
              dns = {
                query-name = "google.com";
                query-type = "A";
              };
              interval = "30s";
              conditions = [ "[DNS_RCODE] == NOERROR" ];
            })
          ++
            # Dynamic: Check local Unbound DNS if enabled
            (optional config.bigor.features.unbound.enable {
              name = "Service: Unbound DNS";
              group = "Local Services";
              url = "127.0.0.1:${toString networkCfg.ports.unbound}";
              dns = {
                query-name = "google.com";
                query-type = "A";
              };
              interval = "30s";
              conditions = [ "[DNS_RCODE] == NOERROR" ];
            })
          ++
            # Dynamic: Check Caddy HTTPS if enabled
            (optional config.bigor.features.caddy.enable {
              name = "Service: Caddy HTTPS";
              group = "Local Services";
              url = "https://status.${networkCfg.domain}";
              interval = "1m";
              conditions = [ "[STATUS] == 200" ];
            });
        };
      };

      services.caddy.virtualHosts."status.${networkCfg.domain}".extraConfig = ''
        tls internal
        reverse_proxy 127.0.0.1:${toString networkCfg.ports.gatus}
      '';
    }
  ]);
}
