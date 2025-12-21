# Module: blocky
# Purpose: DNS proxy with ad/tracker blocking and local DNS rewrites
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.services.blocky;
  inherit (config.bigor.network) topology;

  # Auto-generate DNS rewrites from network-topology (SSOT)
  # Only include services with:
  # - domain != null
  # - expose.dns == true
  # - host has a static IP (not DHCP)
  customDNSMapping = lib.listToAttrs (
    lib.mapAttrsToList
      (_: svc: {
        name = svc.domain;
        value = topology.hosts.${svc.host}.ip;
      })
      (
        lib.filterAttrs (
          _: s: s.domain != null && s.expose.dns && topology.hosts.${s.host}.ip != null
        ) topology.services
      )
  );
in
{
  options.bigor.services.blocky.enable = mkEnableOption "Blocky DNS proxy with ad blocking";

  config = mkIf cfg.enable {
    # Exposure configured in modules/nixos/lib/network-topology (SSOT)

    services.blocky = {
      enable = true;

      settings = {
        # Ports configuration
        ports = {
          dns = 53; # Standard DNS port (Phase 2: production)
          http = 4000; # Web interface and metrics
        };

        # Upstream DNS servers (forward to Unbound for recursive resolution)
        upstreams = {
          groups = {
            default = [ "127.0.0.1:5335" ]; # Unbound local resolver
          };
        };

        # Bootstrap DNS (used to resolve upstream DoH/DoT hostnames if needed)
        bootstrapDns = {
          upstream = "1.1.1.1";
          ips = [
            "1.1.1.1"
            "1.0.0.1"
          ];
        };

        # Custom DNS mappings (auto-generated from network-topology SSOT)
        customDNS = {
          customTTL = "1h";
          filterUnmappedTypes = true;
          mapping = customDNSMapping;
        };

        # Ad and tracker blocking
        blocking = {
          # Blocklists by category
          denylists = {
            # Ads blocking
            ads = [
              # Steven Black's unified hosts (ads + malware)
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
              # AdGuard DNS filter
              "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt"
            ];

            # Tracking blocking
            tracking = [
              # EasyList
              "https://easylist.to/easylist/easylist.txt"
              # EasyPrivacy
              "https://easylist.to/easylist/easyprivacy.txt"
            ];

            # Malware protection
            malware = [
              # Hagezi's Threat Intelligence Feeds
              "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/tif.txt"
            ];
          };

          # Allowlist for false positives (can be customized)
          allowlists = {
            essential = [
              # Add domains that should never be blocked
              # Example: "/path/to/allowlist.txt"
            ];
          };

          # Client groups (which blocklists to apply to which clients)
          clientGroupsBlock = {
            default = [
              "ads"
              "tracking"
              "malware"
            ];
          };

          # Block type (what to return for blocked domains)
          blockType = "zeroIp"; # Return 0.0.0.0 for IPv4, :: for IPv6
          blockTTL = "1m";

          # Download behavior
          refreshPeriod = "4h"; # Update blocklists every 4 hours
          downloadTimeout = "5m";
          downloadAttempts = 3;
          downloadCooldown = "10s";
        };

        # Caching (in addition to Unbound's cache)
        caching = {
          minTime = "5m"; # Minimum cache time
          maxTime = "24h"; # Maximum cache time
          prefetching = true; # Prefetch before expiration
          prefetchExpires = "2h";
          prefetchThreshold = 5; # Prefetch if accessed 5+ times
        };

        # Conditional forwarding (for future use with other local domains)
        conditional = {
          # mapping = {
          #   "other.local" = "192.168.1.1";
          # };
        };

        # Prometheus metrics
        prometheus = {
          enable = true;
          path = "/metrics";
        };

        # Query logging (disabled for privacy and performance)
        queryLog = {
          type = "none"; # Can be "console" or "mysql" for debugging
        };

        # Logging configuration
        log = {
          level = "info";
          format = "text";
          timestamp = true;
          privacy = true; # Anonymize client IPs in logs
        };
      };
    };

    # Ensure Blocky starts after Unbound (dependency)
    systemd.services.blocky = {
      after = [ "unbound.service" ];
      requires = [ "unbound.service" ];
    };
  };
}
