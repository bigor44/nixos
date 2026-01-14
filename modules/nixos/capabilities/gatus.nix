# Module: gatus
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
    mapAttrsToList
    filterAttrs
    optional
    ;
  cfg = config.bigor.capabilities.gatus;
  networkCfg = config.bigor.network;
in
{
  options.bigor.capabilities.gatus.enable = mkEnableOption "Gatus status page";

  config = mkIf cfg.enable {
    services.gatus = {
      enable = true;
      settings = {
        web.port = networkCfg.ports.gatus;
        endpoints = [
          {
            name = "Internet (Cloudflare)";
            group = "External";
            url = "1.1.1.1";
            interval = "30s";
            conditions = [ "[CONNECTED] == true" ];
          }
        ]
        ++
          # Dynamic: Ping other known hosts in the topology
          (mapAttrsToList (name: host: {
            name = "Host: ${name}";
            group = "Infrastructure";
            url = if host.ip != null then host.ip else name;
            interval = "1m";
            conditions = [ "[CONNECTED] == true" ];
          }) (filterAttrs (n: h: n != config.networking.hostName && h.ip != null) networkCfg.hosts))
        ++
          # Dynamic: Check local Blocky DNS if enabled
          (optional config.bigor.capabilities.blocky.enable {
            name = "Service: Blocky DNS";
            group = "Local Services";
            url = "127.0.0.1";
            dns = {
              query-name = "google.com";
              query-type = "A";
            };
            interval = "30s";
            conditions = [ "[DNS_RCODE] == NOERROR" ];
          })
        ++
          # Dynamic: Check local Unbound DNS if enabled
          (optional config.bigor.capabilities.unbound.enable {
            name = "Service: Unbound DNS";
            group = "Local Services";
            url = "127.0.0.1";
            dns = {
              query-name = "google.com";
              query-type = "A";
            };
            interval = "30s";
            conditions = [ "[DNS_RCODE] == NOERROR" ];
          });
      };
    };

    # Reverse proxy setup
    services.caddy.virtualHosts."status.${networkCfg.domain}".extraConfig = ''
      tls internal
      reverse_proxy 127.0.0.1:${toString networkCfg.ports.gatus}
    '';
  };
}
