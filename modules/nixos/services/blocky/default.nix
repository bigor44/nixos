# Module: blocky
# Purpose: DNS proxy with ad/tracker blocking and local DNS rewrites
#
# Features:
# - Multiple deployment modes (unbound-local, unbound-lan, external)
# - Robust health check for Unbound dependency with DNSSEC validation
# - Explicit DNS rewrites from network topology
# - Ad/tracker blocking with curated blocklists
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
                set -euo pipefail

                UNBOUND_HOST="127.0.0.1"
                UNBOUND_PORT="5335"
                TIMEOUT_SECONDS=30
                INTERVAL=0.5
                MAX_ATTEMPTS=$((TIMEOUT_SECONDS * 2))  # 30s / 0.5s = 60 attempts

                echo "Waiting for Unbound at $UNBOUND_HOST:$UNBOUND_PORT..."

                attempt=0
                while [ $attempt -lt $MAX_ATTEMPTS ]; do
                  # Test if Unbound is accepting connections using nc (netcat)
                  if ${pkgs.netcat}/bin/nc -z -w 1 "$UNBOUND_HOST" "$UNBOUND_PORT" 2>/dev/null; then
                    # Calculate actual elapsed time (attempt * 0.5s)
                    elapsed_ms=$((attempt * 500))
                    elapsed_s=$((elapsed_ms / 1000))
                    elapsed_decimal=$((elapsed_ms % 1000 / 100))
                    echo "Unbound is ready after ''${elapsed_s}.''${elapsed_decimal}s"

                    # Additional validation: try a DNS query
                    if ${pkgs.ldns}/bin/drill @"$UNBOUND_HOST" -p "$UNBOUND_PORT" example.com A >/dev/null 2>&1; then
                      echo "Unbound DNS resolution working"

                      # Verify DNSSEC validation is active
                      if ${pkgs.ldns}/bin/drill @"$UNBOUND_HOST" -p "$UNBOUND_PORT" -D sigok.verteiltesysteme.net A 2>&1 | grep -q " ad "; then
                        echo "Unbound DNSSEC validation active"
                        echo "Unbound health check passed"
                        exit 0
                      else
                        echo "Warning: DNSSEC validation not confirmed, waiting..."
                      fi
                    else
                      echo "Warning: Unbound port open but not responding to queries, waiting..."
                    fi
                  fi

                  sleep "$INTERVAL"
                  attempt=$((attempt + 1))
                done

                echo "ERROR: Unbound did not become ready within ''${TIMEOUT_SECONDS}s"
                exit 1
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
