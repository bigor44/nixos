# Feature: Services - Blocky
# Purpose: DNS proxy and ad-blocker (Blocky) configuration
{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    mapAttrs'
    nameValuePair
    ;

  cfg = config.bigor.features.services.blocky;
  inherit (config.bigor.network) domain hosts;
in
{
  options.bigor.features.services.blocky = {
    enable = mkEnableOption "Blocky DNS service";

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open port 53 on the firewall (for serving DNS to other devices)";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
    };

    # Configure systemd-resolved to use Blocky for local domain
    services.resolved = {
      enable = true;
      settings = {
        Resolve = {
          DNS = [ "127.0.0.1" ];
          FallbackDNS = [
            "1.1.1.1"
            "9.9.9.9"
          ];
          Domains = [ "~${domain}" ]; # Route .bigor.lan queries to Blocky
          DNSStubListener = "no";
        };
      };
    };

    # Ensure /etc/resolv.conf points to systemd-resolved
    networking.nameservers = lib.mkForce [ ];

    services.blocky = {
      enable = true;

      settings = {
        ports = {
          dns = 53;
          http = 4000;
        };

        upstreams = {
          groups.default = [
            "https://ns0.fdn.fr/dns-query"
            "https://dns.quad9.net/dns-query"
            "https://cloudflare-dns.com/dns-query"
            "https://dns.adguard-dns.com/dns-query"
            "https://dns.google/dns-query"
            "https://doh.opendns.com/dns-query"
          ];
          strategy = "parallel_best";
          timeout = "2s";
        };

        bootstrapDns = {
          upstream = "1.1.1.1";
        };

        customDNS = {
          customTTL = "1h";
          filterUnmappedTypes = true;
          mapping = (mapAttrs' (name: ip: nameValuePair "${name}.${domain}" ip) hosts) // {
            "${domain}" = "192.168.1.10";
          };
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
      };
    };

    systemd.services.blocky = {
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
