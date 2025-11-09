/*
Title: AdGuard Home Configuration
Description: Configures AdGuard Home for network-wide ad blocking and DNS filtering with custom local domain records.
*/
{
  config,
  lib,
  ...
}:
lib.mkIf config.adblocker.enable {
  services.adguardhome = {
    enable = true;
    openFirewall = true;
    port = 3003;
    mutableSettings = false; # CRITICAL: Must be false for rewrites to work
    settings = {
      language = "fr";
      dns = {
        upstream_dns = [
          "https://unfiltered.adguard-dns.com/dns-query"
          "https://one.one.one.one/dns-query"
          "https://doh.opendns.com/dns-query"
          "https://dns.adguard.com/dns-query"
          "https://dns.cloudflare.com/dns-query"
          "https://dns64.dns.google/dns-query"
          "https://doh.libredns.gr/dns-query"
          "https://dns.quad9.net/dns-query"
          "https://noads.joindns4.eu/dns-query"
          "https://ns0.fdn.fr/dns-query"
          "https://ns1.fdn.fr/dns-query"
        ];
        bootstrap_dns = ["192.168.1.254"];
        upstream_mode = "load_balance";
        cache_enabled = true;
        anonymize_client_ip = true;

        # Custom DNS rewrites for local domain
        rewrites = [
          # Main domain
          {
            domain = "bigor.lan";
            answer = "192.168.1.10";
          }
          # Specific subdomains
          {
            domain = "grospc.bigor.lan";
            answer = "192.168.1.1";
          }
          {
            domain = "minipc.bigor.lan";
            answer = "192.168.1.10";
          }
          # Wildcard domains (note: AdGuard uses *.domain syntax)
          {
            domain = "*.grospc.bigor.lan";
            answer = "192.168.1.1";
          }
          {
            domain = "*.minipc.bigor.lan";
            answer = "192.168.1.10";
          }
        ];
      };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;

        parental_enabled = false; # Parental control-based DNS requests filtering.
        safe_search = {
          enabled = false; # Enforcing "Safe search" option for search engines, when possible.
        };
      };
      # The following notation uses map
      # to not have to manually create {enabled = true; url = "";} for every filter
      # This is, however, fully optional
      filters =
        map
        (url: {
          enabled = true;
          url = url;
        })
        [
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
          "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/multi.txt" # HaGeZi's Normal DNS Blocklist
          "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/tif.txt" # HaGeZi's Threat Intelligence Feeds DNS Blocklist
        ];
    };
  };
  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];
}
