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
    mapAttrs'
    nameValuePair
    ;
  cfg = config.bigor.platform.dns;
  inherit (config.bigor.network) domain hosts;

  # Generate records from hosts definition
  hostRecords = mapAttrs' (name: ip: nameValuePair "${name}.${domain}" ip) hosts;
in
{
  options.bigor.platform.dns = {
    extraRecords = mkOption {
      type = types.attrsOf types.str;
      default = {
        "${domain}" = "192.168.1.10"; # Default root to minipc
      };
      description = "Additional DNS records to serve via Blocky";
    };

    defaultDohUpstreams = mkOption {
      type = types.listOf types.str;
      readOnly = true;
      default = [
        "https://dns.quad9.net/dns-query"
        "https://cloudflare-dns.com/dns-query"
        "https://dns.adguard-dns.com/dns-query"
      ];
      description = "Standard list of DoH upstreams";
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
    networking.firewall = mkIf cfg.server.enable {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
    };

    networking.nameservers = [ "127.0.0.1" ];

    services.resolved = {
      enable = true;
      settings = {
        Resolve = {
          DNSStubListener = "no";
          FallbackDNS = [
            "1.1.1.1"
            "9.9.9.9"
          ];
        };
      };
    };

    services.blocky = mkIf cfg.blocky.enable {
      enable = true;

      settings = {
        ports = {
          dns = 53;
          http = 4000;
        };

        upstreams = {
          groups.default = cfg.upstreamServers;
          inherit (cfg.blocky) strategy;
          timeout = "2s";
        };

        bootstrapDns = {
          upstream = "1.1.1.1";
          ips = [
            "1.1.1.1"
            "9.9.9.9"
            "8.8.8.8"
          ];
        };

        customDNS = {
          customTTL = "1h";
          filterUnmappedTypes = true;
          mapping = hostRecords // cfg.extraRecords;
        };

        blocking = {
          denylists = {
            ads = [
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
              "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/hosts/multi.txt"
            ];
            threats = [
              "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/hosts/tif.txt"
            ];
          };

          allowlists = {
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

        caching = {
          minTime = "5m";
          maxTime = "24h";
          prefetching = true;
          prefetchExpires = "2h";
          prefetchThreshold = 5;
        };

        queryLog.type = "none";

        log = {
          level = "info";
          format = "text";
          timestamp = true;
          privacy = true;
        };
      };
    };

    systemd.services.blocky = mkIf cfg.blocky.enable {
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "1s";
      };
    };
  };
}
