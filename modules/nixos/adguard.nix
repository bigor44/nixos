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
    mutableSettings = false;
    settings = {
      language = "fr";
      log = {
        enabled = false;
        compress = false;
      };
      dns = {
        upstream_dns = [
          "https://one.one.one.one/dns-query"
          "https://dns.cloudflare.com/dns-query"
          "https://dns.quad9.net/dns-query"
          "https://ns0.fdn.fr/dns-query"
          "https://ns1.fdn.fr/dns-query"
        ];
        bootstrap_dns = [
          "192.168.1.254"
          "1.1.1.1"
        ];
        upstream_mode = "load_balance";
        cache_enabled = true;
        anonymize_client_ip = true;
        use_http3_upstreams = true;
        enable_dnssec = true;
        edns_client_subnet = {
          enabled = false; # Privacy enhancement
        };
        rewrites = [
          {
            domain = "grospc.bigor.lan";
            answer = "192.168.1.1";
          }
          {
            domain = "*.grospc.bigor.lan";
            answer = "192.168.1.1";
          }
          {
            domain = "minipc.bigor.lan";
            answer = "192.168.1.10";
          }
          {
            domain = "*.minipc.bigor.lan";
            answer = "192.168.1.10";
          }
          {
            domain = "bigor.lan";
            answer = "192.168.1.10";
          }
          {
            domain = "*.bigor.lan";
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
