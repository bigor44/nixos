{
  config,
  lib,
  ...
}:
lib.mkIf config.adblocker.enable {
  services.adguardhome = {
    enable = true;
    port = 3003;
    host = "127.0.0.1";
    mutableSettings = false;

    settings = {
      language = "fr";
      log = {
        enabled = true;
        compress = true;
      };
      querylog = {
        enabled = true;
      };
      dns = {
        bind_hosts = [ "0.0.0.0" ];
        port = 53;
        upstream_dns = [
          "https://dns.cloudflare.com/dns-query"
          "https://dns.quad9.net/dns-query"
          "https://ns0.fdn.fr/dns-query"
          "https://ns1.fdn.fr/dns-query"
          "https://dns.google/dns-query"
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
        rewrites = [
          {
            domain = "grospc.bigor.lan";
            answer = config.myNetwork.ips.grospc;
            enabled = true;
          }
          {
            domain = "minipc.bigor.lan";
            answer = config.myNetwork.ips.minipc;
            enabled = true;
          }
          {
            domain = "bigor.lan";
            answer = config.myNetwork.ips.minipc;
            enabled = true;
          }
          {
            domain = "home.bigor.lan";
            answer = config.myNetwork.ips.minipc;
            enabled = true;
          }
          {
            domain = "adguard.bigor.lan";
            answer = config.myNetwork.ips.minipc;
            enabled = true;
          }
          {
            domain = "monitor.bigor.lan";
            answer = config.myNetwork.ips.minipc;
            enabled = true;
          }
          {
            domain = "vault.bigor.lan";
            answer = config.myNetwork.ips.minipc;
            enabled = true;
          }
        ];
      };
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
  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}
