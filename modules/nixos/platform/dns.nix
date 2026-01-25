# Platform: dns
# Purpose: Core DNS platform module (Interface + Policy + Assertions + Resolver + Blocky Driver)
{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    filterAttrs
    mapAttrs'
    nameValuePair
    ;
  cfg = config.bigor.platform.dns;
  networkCfg = config.bigor.network;
  inherit (networkCfg) ports domain;

  # Auto-generate DNS rewrites from bigor.network.hosts
  customDNSMapping =
    # Hosts with static IPs
    mapAttrs' (name: host: nameValuePair "${name}.${domain}" host.ip) (
      filterAttrs (_: h: h.ip != null) networkCfg.hosts
    )
    # Alias for main domain
    // {
      ${domain} = networkCfg.hosts.minipc.ip;
    };
in
{
  options.bigor.platform.dns = {
    # ===========================================================================
    # Interface (Public API)
    # ===========================================================================
    defaultDohUpstreams = mkOption {
      type = types.listOf types.str;
      readOnly = true;
      default = [
        # Quad9 (DoH) - Privacy & Security
        "https://dns.quad9.net/dns-query"
        # Cloudflare (DoH) - Speed
        "https://cloudflare-dns.com/dns-query"
        # AdGuard (DoH) - Backup filtering
        "https://dns.adguard-dns.com/dns-query"
      ];
      description = "Standard list of DoH upstreams (for reuse in configuration)";
    };

    upstreamServers = mkOption {
      type = types.listOf types.str;
      default = cfg.defaultDohUpstreams;
      description = "List of upstream servers used by Blocky.";
    };

    server = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to open port 53 on LAN (Server role)";
      };
    };

    blocky = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Platform guarantee: Blocky always runs as local proxy";
      };

      strategy = mkOption {
        type = types.str;
        default = "parallel_best";
        description = "Blocky upstream strategy";
      };
    };
  };

  config = {
    # ===========================================================================
    # Network Configuration (Firewall)
    # ===========================================================================
    bigor.network.firewall.ports = mkIf cfg.server.enable {
      tcp = [ networkCfg.ports.dns.main ];
      udp = [ networkCfg.ports.dns.main ];
    };

    bigor.network.requiredStaticIpServices = mkIf cfg.server.enable [
      "DNS server (Blocky serving LAN)"
    ];

    # ===========================================================================
    # Resolver Configuration (System Integration)
    # ===========================================================================

    # Point system DNS to local Blocky
    networking.nameservers = [ "127.0.0.1" ];

    # Disable systemd-resolved stub listener to let Blocky use port 53
    services.resolved = {
      enable = true;
      settings = {
        Resolve = {
          DNSStubListener = "no";
          # External fallbacks if Blocky crashes (Cloudflare + Quad9)
          FallbackDNS = [
            "1.1.1.1"
            "9.9.9.9"
          ];
        };
      };
    };

    # ===========================================================================
    # Blocky Service Configuration
    # ===========================================================================
    services.blocky = mkIf cfg.blocky.enable {
      enable = true;

      settings = {
        # =======================================================================
        # Ports
        # =======================================================================
        ports = {
          dns = ports.dns.main;
          http = ports.dns.metrics;
        };

        # =======================================================================
        # Upstream DNS with automatic failover
        # =======================================================================
        upstreams = {
          # Upstreams and strategy computed by DNS policy module
          groups.default = cfg.upstreamServers;
          inherit (cfg.blocky) strategy;
          timeout = "2s";
        };

        # Bootstrap DNS (Critical for resolving DoH hostnames)
        bootstrapDns = {
          upstream = "1.1.1.1"; # Use standard DNS for bootstrapping to avoid circular loops
          ips = [
            "1.1.1.1" # Cloudflare
            "9.9.9.9" # Quad9
            "8.8.8.8" # Google
          ];
        };

        # =======================================================================
        # Custom DNS
        # =======================================================================
        customDNS = {
          customTTL = "1h";
          filterUnmappedTypes = true;
          mapping = customDNSMapping;
        };

        # =======================================================================
        # Ad/Tracker Blocking
        # =======================================================================
        blocking = {
          denylists = {
            ads = [
              # Steven Black's unified hosts (ads + malware)
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
              # Hagezi's Multi Normal (ads + tracking + malware)
              "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/hosts/multi.txt"
            ];
            threats = [
              # Hagezi's Threat Intelligence Feeds
              "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/hosts/tif.txt"
            ];
          };

          allowlists = {
            # Add domains that should never be blocked
            essential = [ ];
          };

          clientGroupsBlock = {
            default = [
              "ads"
              "threats"
            ];
          };

          blockType = "zeroIp";
          blockTTL = "1m";

          loading = {
            strategy = "fast";
            refreshPeriod = "4h";
            downloads = {
              timeout = "5m";
              attempts = 3;
              cooldown = "10s";
            };
          };
        };

        # =======================================================================
        # Caching
        # =======================================================================
        caching = {
          minTime = "5m";
          maxTime = "24h";
          prefetching = true;
          prefetchExpires = "2h";
          prefetchThreshold = 5;
        };

        # =======================================================================
        # Logging
        # =======================================================================
        queryLog.type = "none"; # Disable for privacy

        log = {
          level = "info";
          format = "text";
          timestamp = true;
          privacy = true;
        };
      };
    };

    # ===========================================================================
    # Systemd dependencies
    # ===========================================================================
    systemd.services.blocky = mkIf cfg.blocky.enable {
      # Start after network is online to ensure upstream connectivity
      # (Avoids "network unreachable" errors during boot)
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        # Auto-restart on failure (all hosts)
        Restart = "on-failure";
        RestartSec = "1s";
      };
    };
  };
}
