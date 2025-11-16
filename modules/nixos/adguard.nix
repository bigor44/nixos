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
        use_private_ptr_resolvers = false;
        enable_dnssec = true;
        edns_client_subnet.enabled = false;
        local_domain_name = "bigor.lan";
        resolve_clients = true;
      };
      filtering = {
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
        protection_enabled = true;
        filtering_enabled = true;
        parental_enabled = false;
        safe_search.enabled = false;
      };
      filters =
        map (url: {
          enabled = true;
          inherit url;
        }) [
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
          "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/multi.txt"
          "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/tif.txt"
        ];
    };
  };

  networking.firewall = {
    allowedTCPPorts = [53];
    allowedUDPPorts = [53];
  };
}
