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
  # ============================================================================
  # File: modules/nixos/services/adguard/default.nix
  # Description: AdGuard Home Configuration
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Sets up AdGuard Home for network-wide ad blocking and local DNS
  #          resolution when the homelab role is active.
  # ============================================================================

  options.bigor.services.adguard = {
    enable = mkEnableOption "Enable AdGuard Home for network-wide ad blocking and local DNS resolution";
  };

  config = mkIf cfg.enable {

    # ==========================================================================
    # Caddy Integration
    # ==========================================================================
    services.caddy.virtualHosts."adguard.bigor.lan" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:3003
        tls internal
      '';
    };

    # ==========================================================================
    # AdGuard Home Service
    # ==========================================================================
    services.adguardhome = {
      enable = true;
      port = 3003;
      host = "127.0.0.1";
      mutableSettings = false; # Enforce declarative configuration via Nix

      settings = {
        language = "fr";
        log = {
          enabled = true;
          compress = true; # Save disk space
        };
        querylog = {
          enabled = true;
        };
        dns = {
          bind_hosts = [ "0.0.0.0" ];
          port = 53;
          # Upstream DNS providers (Privacy focused + Google as backup)
          upstream_dns = [
            "https://dns.cloudflare.com/dns-query"
            "https://dns.quad9.net/dns-query"
            "https://ns0.fdn.fr/dns-query" # French non-profit ISP
            "https://ns1.fdn.fr/dns-query"
          ];
          bootstrap_dns = [
            "1.1.1.1"
            "8.8.8.8"
          ];
          upstream_mode = "load_balance"; # Distribute queries for speed
          cache_enabled = true;
          cache_size = 4194304;
          cache_ttl_min = 60;
          cache_ttl_max = 86400;
          anonymize_client_ip = false; # Useful for internal logging
          use_http3_upstreams = true; # Modern protocol for better performance
          use_private_ptr_resolvers = true; # Resolve local IP hostnames
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

          # Local DNS rewrites
          # Maps local domain names to static IPs of machines in the network.
          rewrites = [
            {
              domain = "grospc.bigor.lan";
              answer = config.bigor.network.ips.grospc;
              enabled = true;
            }
            {
              domain = "minipc.bigor.lan";
              answer = config.bigor.network.ips.minipc;
              enabled = true;
            }
            {
              domain = "bigor.lan";
              answer = config.bigor.network.ips.minipc;
              enabled = true;
            }
            {
              domain = "adguard.bigor.lan";
              answer = config.bigor.network.ips.minipc;
              enabled = true;
            }
          ];
        };

        # Blocklists
        filters =
          map
            (url: {
              enabled = true;
              inherit url;
            })
            [
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # Malicious URL Blocklist (URLHaus)
              "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/multi.txt" # Hagezi Multi Normal
              "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/tif.txt" # Hagezi Threat Intelligence Feed
            ];
      };
    };

    # Open DNS ports for local network clients
    networking.firewall.interfaces.${config.bigor.network.mainInterface} = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
    };
  };
}
