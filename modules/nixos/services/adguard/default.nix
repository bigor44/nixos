# Module: adguard
# Purpose: Network-wide ad blocking and local DNS resolution
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.services.adguard;
in
{
  options.bigor.services.adguard.enable = mkEnableOption "AdGuard Home DNS and ad blocker";

  config = mkIf cfg.enable {
    services.adguardhome = {
      enable = true;
      port = 3003;
      host = "127.0.0.1";
      mutableSettings = false;

      settings = {
        language = "en";
        log = {
          enabled = true;
          compress = true;
        };
        querylog.enabled = true;
        dns = {
          bind_hosts = [ "0.0.0.0" ];
          port = 53;
          upstream_dns = [
            "https://dns.cloudflare.com/dns-query"
            "https://dns.quad9.net/dns-query"
            "https://ns0.fdn.fr/dns-query"
            "https://ns1.fdn.fr/dns-query"
          ];
          bootstrap_dns = [
            "1.1.1.1"
            "8.8.8.8"
          ];
          upstream_mode = "load_balance";
          cache_enabled = true;
          cache_size = 4194304;
          cache_ttl_min = 60;
          cache_ttl_max = 86400;
          anonymize_client_ip = false;
          use_http3_upstreams = true;
          use_private_ptr_resolvers = true;
          enable_dnssec = true;
          edns_client_subnet.enabled = false;
          local_domain_name = "lan";
          resolve_clients = true;
        };
        filtering = {
          protection_enabled = true;
          filtering_enabled = true;
          parental_enabled = false;
          safe_search.enabled = false;
        };

        user_rules = [ "@@||anthropic.com^" ];

        filters =
          map
            (url: {
              enabled = true;
              inherit url;
            })
            [
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
              "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/multi.txt"
              "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/tif.txt"
            ];
      };
    };
  };
}
