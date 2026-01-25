# Platform: dns
# Purpose: Core DNS platform module (Interface + Policy + Assertions + Resolver)
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.bigor.platform.dns;
  networkCfg = config.bigor.network;
in
{
  imports = [
    ./drivers/blocky.nix
  ];

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

    # Ensure Blocky starts properly
    systemd.services.blocky = {
      wantedBy = [ "multi-user.target" ];
    };
  };
}
