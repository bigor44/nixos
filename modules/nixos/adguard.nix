/*
Title: AdGuard Home Configuration
Description: Configures AdGuard Home for network-wide ad blocking and DNS filtering.
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
      };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;

        parental_enabled = false;
        safe_search = {
          enabled = false;
        };
      };
      filters =
        map
        (url: {
          enabled = true;
          url = url;
        })
        [
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
          "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/multi.txt"
          "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/tif.txt"
        ];

      custom_dns_entries = [
        {
          domain = "bigor.lan";
          answer = "192.168.1.10";
        }
        {
          domain = "grospc.bigor.lan";
          answer = "192.168.1.1";
        }
        {
          domain = "minipc.bigor.lan";
          answer = "192.168.1.10";
        }
        {
          domain = "*.bigor.lan";
          answer = "192.168.1.10";
        }
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
  };
  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];
}
