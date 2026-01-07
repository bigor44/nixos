# Module: blocky
# Purpose: DNS proxy with ad/tracker blocking and automatic failover
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.services.blocky;
  inherit (config.bigor.network) mainInterface;
  minipcIp = config.bigor.network.hosts.minipc.ip;

  # Auto-generate DNS rewrites from bigor.network.hosts
  customDNSMapping = filterAttrs (_: ip: ip != null) (
    mapAttrs' (name: host: nameValuePair "${name}.bigor.lan" host.ip) config.bigor.network.hosts
    // {
      # Alias for main domain
      "bigor.lan" = minipcIp;
    }
  );
in
{
  options.bigor.services.blocky = {
    enable = mkEnableOption "Blocky DNS proxy with ad blocking";

    useLocalUnbound = mkEnableOption ''
      Use local Unbound (127.0.0.1:5335) instead of remote minipc.
      Enable this on the DNS server (minipc) itself.
    '';

    portableMode = mkEnableOption ''
      Portable mode: skip minipc upstream, use fallback DNS directly.
      Enable this on portable hosts that are often outside the local network.
    '';

    fallbackUpstreams = mkOption {
      type = types.listOf types.str;
      default = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      description = "Fallback DNS servers when primary (minipc) is unreachable";
      example = [
        "9.9.9.9"
        "149.112.112.112"
      ];
    };

    upstreamTimeout = mkOption {
      type = types.str;
      default = "2s";
      description = "Timeout before falling back to next upstream";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.useLocalUnbound -> config.bigor.services.unbound.enable;
        message = "blocky.useLocalUnbound requires unbound.enable";
      }
    ];

    services.blocky = {
      enable = true;

      settings = {
        # =======================================================================
        # Ports
        # =======================================================================
        ports = {
          dns = 53;
          http = 4000; # Metrics endpoint
        };

        # =======================================================================
        # Upstream DNS with automatic failover
        # =======================================================================
        upstreams = {
          groups.default =
            if cfg.useLocalUnbound then
              # DNS server (minipc): local Unbound only
              [ "127.0.0.1:5335" ]
            else if cfg.portableMode then
              # Portable mode: external DNS only (no minipc dependency)
              cfg.fallbackUpstreams
            else
              # Other hosts: minipc first, then failover to external
              [ "${minipcIp}:5335" ] ++ cfg.fallbackUpstreams;

          # Strict: try upstreams in order, failover on timeout/error
          strategy = "strict";
          timeout = cfg.upstreamTimeout;
        };

        # Bootstrap DNS (for resolving DoH/DoT hostnames if ever needed)
        bootstrapDns = {
          upstream = "1.1.1.1";
          ips = [
            "1.1.1.1"
            "1.0.0.1"
          ];
        };

        # =======================================================================
        # Custom DNS (auto-generated from network topology)
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
    # Firewall
    # ===========================================================================
    networking.firewall.interfaces.${mainInterface} = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
    };

    # ===========================================================================
    # Systemd dependencies
    # ===========================================================================
    systemd.services.blocky = mkMerge [
      {
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        serviceConfig = {
          # Auto-restart on failure (all hosts)
          Restart = "on-failure";
          RestartSec = "1s";
        };
      }
      (mkIf cfg.useLocalUnbound {
        after = [
          "unbound.service"
          "network-online.target"
        ];
        requires = [ "unbound.service" ];
      })
    ];
  };
}
