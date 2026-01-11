# Module: blocky
# Purpose: DNS proxy with ad/tracker blocking and automatic failover
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkMerge
    types
    filterAttrs
    mapAttrs'
    nameValuePair
    ;
  cfg = config.bigor.services.blocky;
  networkCfg = config.bigor.network;
  inherit (networkCfg) mainInterface ports;
  minipcIp = networkCfg.hosts.minipc.ip;

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

    followDnsPolicy = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to use DNS policy (bigor.policies.dns) for upstream configuration.
        When true (default), upstreams are automatically configured based on the DNS policy mode.
        When false, allows manual upstream configuration via the upstreams option.
      '';
    };

    upstreams = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Manual DNS upstream servers (only used when followDnsPolicy = false).
        When followDnsPolicy is true, this option is ignored and upstreams are determined by bigor.policies.dns.
        Fallback upstreams are configured via bigor.policies.dns.fallbackUpstreams.
      '';
      example = [
        "127.0.0.1:5335"
        "1.1.1.1"
        "9.9.9.9"
      ];
    };

    upstreamTimeout = mkOption {
      type = types.str;
      default = "2s";
      description = "Timeout before falling back to next upstream";
    };
  };

  config = mkIf cfg.enable {
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
          # Use policy-based upstreams by default, or manual config if disabled
          groups.default =
            if cfg.followDnsPolicy then config.bigor.policies.dns.computed.blockyUpstreams else cfg.upstreams;

          # Strict: try upstreams in order, failover on timeout/error
          strategy = "parallel_best";
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
      allowedTCPPorts = [ ports.blocky.dns ];
      allowedUDPPorts = [ ports.blocky.dns ];
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
          # Wait for network to be truly ready (dhcpcd race condition)
          ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
        };
      }
      (mkIf (cfg.followDnsPolicy && config.bigor.policies.dns.computed.shouldRunUnbound) {
        after = [
          "unbound.service"
          "network-online.target"
        ];
        wants = [ "unbound.service" ];
      })
    ];
  };
}
