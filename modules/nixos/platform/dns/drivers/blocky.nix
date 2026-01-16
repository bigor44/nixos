# Platform: dns/drivers/blocky
# Purpose: Internal Blocky service driver - auto-enabled based on DNS policy
{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    filterAttrs
    mapAttrs'
    nameValuePair
    ;
  cfg = config.bigor.platform.dns;
  networkCfg = config.bigor.network;
  inherit (networkCfg) ports domain;

  # Auto-generate DNS rewrites from bigor.network.hosts
  customDNSMapping = filterAttrs (_: ip: ip != null) (
    mapAttrs' (name: host: nameValuePair "${name}.${domain}" host.ip) config.bigor.network.hosts
    // {
      # Alias for main domain
      ${domain} = networkCfg.hosts.minipc.ip;
    }
  );
in
{
  config = mkIf cfg.computed.shouldRunBlocky {
    services.blocky = {
      enable = true;

      settings = {
        # =======================================================================
        # Ports
        # =======================================================================
        ports = {
          inherit (ports.blocky) dns http;
        };

        # =======================================================================
        # Upstream DNS with automatic failover
        # =======================================================================
        upstreams = {
          # Upstreams and strategy computed by DNS policy module
          groups.default = cfg.computed.blockyUpstreams;
          strategy = cfg.computed.blockyStrategy;
          timeout = "2s";
        };

        # Bootstrap DNS (Critical for resolving DoH hostnames)
        bootstrapDns = {
          upstream = "https://1.1.1.1/dns-query"; # Use Cloudflare DoH as primary bootstrap
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
    systemd.services.blocky = {
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
