# Platform: dns
# Purpose: Core DNS platform module (Interface + Policy + Assertions + Resolver)
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.bigor.platform.dns;
  networkCfg = config.bigor.network;
  hostname = config.networking.hostName;
  minipcIp = networkCfg.hosts.minipc.ip;
  blockyPort = toString networkCfg.ports.blocky.dns;
in
{
  imports = [
    ./drivers/blocky.nix
  ];

  options.bigor.platform.dns = {
    # ===========================================================================
    # Interface (Public API)
    # ===========================================================================
    mode = mkOption {
      type = types.enum [
        "server"
        "client"
        "standalone"
      ];
      default = "standalone";
      description = ''
        DNS resolution strategy for this host.
        - `server`: Host runs Blocky and serves DNS to the LAN (requires static IP). Upstreams are DoH.
        - `client`: Host uses the LAN DNS server (minipc) as upstream.
        - `standalone`: Host uses DoH upstreams directly (for laptops/roaming).
      '';
    };

    upstreamServers = mkOption {
      type = types.listOf types.str;
      default = [
        # Quad9 (DoH) - Privacy & Security
        "https://dns.quad9.net/dns-query"
        # Cloudflare (DoH) - Speed
        "https://cloudflare-dns.com/dns-query"
        # AdGuard (DoH) - Backup filtering
        "https://dns.adguard-dns.com/dns-query"
      ];
      description = "List of DoH/DoT upstream servers used in 'server' and 'standalone' modes.";
    };

    # ===========================================================================
    # Computed Policy (Internal Logic)
    # ===========================================================================
    computed = {
      shouldRunBlocky = mkOption {
        type = types.bool;
        readOnly = true;
        default = true;
        description = "Platform guarantee: Blocky always runs as local proxy";
      };

      blockyUpstreams = mkOption {
        type = types.listOf types.str;
        readOnly = true;
        default =
          if cfg.mode == "client" then
            [ "${minipcIp}:${blockyPort}" ] ++ cfg.upstreamServers # LAN primary + DoH fallbacks
          else
            cfg.upstreamServers; # Use DoH upstreams directly
        description = "Computed upstream list. Client mode: LAN server + DoH fallbacks for resilience.";
      };

      blockyStrategy = mkOption {
        type = types.str;
        readOnly = true;
        default = "parallel_best"; # Always race for speed
      };

      # Firewall logic
      needsPort53OnLan = mkOption {
        type = types.bool;
        readOnly = true;
        default = cfg.mode == "server";
        description = "Whether to open port 53 on LAN (Server role only)";
      };
    };
  };

  config = {
    # ===========================================================================
    # Assertions (Validation)
    # ===========================================================================
    assertions = [
      {
        assertion = cfg.mode == "server" -> networkCfg.hosts.${hostname}.ip != null;
        message = "DNS mode 'server' requires ${hostname} to have a static IP defined in network-topology.";
      }
      {
        assertion = cfg.mode == "client" -> networkCfg.hosts.minipc.ip != null;
        message = "DNS mode 'client' requires minipc to have a static IP defined in network-topology.";
      }
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
          FallbackDNS = [ "127.0.0.1" ];
        };
      };
    };

    # Ensure Blocky starts properly
    systemd.services.blocky = {
      wantedBy = [ "multi-user.target" ];
    };
  };
}
