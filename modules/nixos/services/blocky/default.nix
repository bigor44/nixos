# Module: blocky
# Purpose: DNS proxy with ad/tracker blocking and local DNS rewrites
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.bigor.services.blocky;
  inherit (config.bigor.network) mainInterface;

  # Explicit DNS rewrites - filter out null IPs (DHCP hosts like minidesk)
  customDNSMapping = lib.filterAttrs (_: ip: ip != null) {
    # Service domains
    "prometheus.bigor.lan" = config.bigor.network.hosts.minipc.ip;
    "grafana.bigor.lan" = config.bigor.network.hosts.minipc.ip;
    "alertmanager.bigor.lan" = config.bigor.network.hosts.minipc.ip;

    # DNS-only entries (moved from bigor.network.dnsEntries)
    "minipc.bigor.lan" = config.bigor.network.hosts.minipc.ip;
    "grospc.bigor.lan" = config.bigor.network.hosts.grospc.ip;
    "bigor.lan" = config.bigor.network.hosts.minipc.ip;
  };
in
{
  options.bigor.services.blocky = {
    enable = mkEnableOption "Blocky DNS proxy with ad blocking";

    upstreamMode = mkOption {
      type = types.enum [
        "unbound-local"
        "unbound-lan"
        "external"
      ];
      default = "unbound-local";
      description = ''
        DNS upstream resolver mode:
        - unbound-local: Forward to local Unbound (127.0.0.1:5335)
        - unbound-lan: Forward to Unbound on LAN (requires upstreamHost)
        - external: Forward to external DNS (Cloudflare, Quad9, etc.)
      '';
    };

    upstreamHost = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Hostname of Unbound server (only used with upstreamMode = unbound-lan)";
      example = "minipc";
    };

    externalUpstreams = mkOption {
      type = types.listOf types.str;
      default = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      description = "External DNS servers (only used with upstreamMode = external)";
    };
  };

  config = mkIf cfg.enable (
    let
      # Determine upstream DNS servers based on mode
      upstreamServers =
        if cfg.upstreamMode == "unbound-local" then
          [ "127.0.0.1:5335" ]
        else if cfg.upstreamMode == "unbound-lan" then
          (
            assert cfg.upstreamHost != null;
            [ "${config.bigor.network.hosts.${cfg.upstreamHost}.ip}:5335" ]
          )
        else
          cfg.externalUpstreams;
    in
    {
      services.blocky = {
        enable = true;

        settings = {
          # Ports configuration
          ports = {
            dns = 53;
            http = 4000;
          };

          # Upstream DNS servers (dynamic based on upstreamMode)
          upstreams = {
            groups = {
              default = upstreamServers;
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
            # Blocklists by category (hosts format only)
            denylists = {
              # Ads and malware blocking
              ads = [
                # Steven Black's unified hosts (ads + malware)
                "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
                # Hagezi's Multi Normal (ads + tracking + malware) - hosts format
                "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/hosts/multi.txt"
              ];

              # Additional threat protection
              threats = [
                # Hagezi's Threat Intelligence Feeds - hosts format
                "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/hosts/tif.txt"
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
                "threats"
              ];
            };

            # Block type (what to return for blocked domains)
            blockType = "zeroIp"; # Return 0.0.0.0 for IPv4, :: for IPv6
            blockTTL = "1m";

            # Loading behavior
            loading = {
              refreshPeriod = "4h"; # Update blocklists every 4 hours
              downloads = {
                timeout = "5m";
                attempts = 3;
                cooldown = "10s";
              };
            };
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

      # Open Blocky ports
      networking.firewall.interfaces.${mainInterface} = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
      };

      # Systemd dependencies (conditional based on upstreamMode)
      systemd.services.blocky = {
        wants = [ "network-online.target" ];
      }
      // (
        if cfg.upstreamMode == "unbound-local" then
          {
            # Only depend on local Unbound service
            after = [
              "unbound.service"
              "network-online.target"
            ];
            requires = [ "unbound.service" ];

            # Wait for Unbound to be ready before starting Blocky
            serviceConfig = {
              ExecStartPre = pkgs.writeShellScript "wait-for-unbound" ''
                # Simple delay to let Unbound finish initialization
                # Unbound starts quickly (~1s) but needs a moment before accepting queries
                echo "Waiting 3 seconds for Unbound to initialize..."
                sleep 3
                echo "Proceeding with Blocky startup"
              '';
            };
          }
        else
          {
            # No Unbound dependency for LAN or external modes
            after = [ "network-online.target" ];
          }
      );
    }
  );
}
