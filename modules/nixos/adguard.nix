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
        bind_hosts = ["0.0.0.0"];
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
        anonymize_client_ip = false; # Changed: may interfere with local resolution
        use_http3_upstreams = true;
        use_private_ptr_resolvers = true; # Changed: better for local domains
        enable_dnssec = false; # Changed: can cause issues with local domains
        edns_client_subnet.enabled = false;
        local_domain_name = "lan"; # Simplified
        resolve_clients = true;
      };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
        parental_enabled = false;
        safe_search.enabled = false;
        rewrites = [
          # Exact domain matches
          {
            domain = "grospc.bigor.lan";
            answer = "192.168.1.1";
            enabled = true;
          }
          {
            domain = "minipc.bigor.lan";
            answer = "192.168.1.10";
            enabled = true;
          }
          {
            domain = "bigor.lan";
            answer = "192.168.1.10";
            enabled = true;
          }
          # Wildcard matches
          {
            domain = "*.grospc.bigor.lan";
            answer = "192.168.1.1";
            enabled = true;
          }
          {
            domain = "*.minipc.bigor.lan";
            answer = "192.168.1.10";
            enabled = true;
          }
          {
            domain = "*.bigor.lan";
            answer = "192.168.1.10";
            enabled = true;
          }
        ];
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
