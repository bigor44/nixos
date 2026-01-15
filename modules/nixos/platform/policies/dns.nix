# Policy: dns
# Purpose: Strategic DNS configuration (local-recursive, lan-recursive, portable)
{ config, lib, ... }:
let
  inherit (lib) mkOption mkIf types;
  cfg = config.bigor.platform.policies.dns;
  hostname = config.networking.hostName;
  networkCfg = config.bigor.network;
  minipcIp = networkCfg.hosts.minipc.ip;
in
{
  options.bigor.platform.policies.dns = {
    mode = mkOption {
      type = types.enum [
        "local-recursive"
        "lan-recursive"
        "portable"
        "cloud"
      ];
      default = "cloud";
      description = ''
        DNS resolution strategy:
        - "local-recursive": Run Unbound + Blocky locally (server role)
        - "lan-recursive": Use LAN recursive resolver (workstation pointing to minipc)
        - "portable": Blocky with cloud DNS upstreams (ad-blocking, no LAN dependency)
        - "cloud": Direct cloud DNS (reserved for future: bypass Blocky entirely)

        Note: Currently "portable" and "cloud" behave identically (both use Blocky with cloud upstreams).
        The "cloud" mode is reserved for future use when bypassing Blocky is desired.
        To disable DNS filtering entirely, you must manually disable Blocky service.
      '';
    };

    fallbackUpstreams = mkOption {
      type = types.listOf types.str;
      default = [
        "1.1.1.1"
        "9.9.9.9"
      ];
      description = ''
        Fallback cloud DNS servers used when local/LAN recursive resolvers are unreachable.
        These are used in lan-recursive mode as failover, and as primary upstreams in portable/cloud modes.
      '';
      example = [
        "9.9.9.9"
        "149.112.112.112"
      ];
    };

    computed = {
      shouldRunUnbound = mkOption {
        type = types.bool;
        readOnly = true;
        default = cfg.mode == "local-recursive";
        description = "Whether this host should run Unbound recursive resolver";
      };

      blockyUpstreams = mkOption {
        type = types.listOf types.str;
        readOnly = true;
        default =
          let
            unboundPort = toString networkCfg.ports.unbound;
          in
          {
            local-recursive = [ "127.0.0.1:${unboundPort}" ] ++ cfg.fallbackUpstreams;
            lan-recursive = [ "${minipcIp}:${unboundPort}" ] ++ cfg.fallbackUpstreams;
            portable = cfg.fallbackUpstreams;
            # Note: "cloud" currently identical to "portable" (reserved for future use)
            cloud = cfg.fallbackUpstreams;
          }
          .${cfg.mode};
        description = "Computed Blocky upstream servers based on DNS policy";
      };

      isPortable = mkOption {
        type = types.bool;
        readOnly = true;
        default = cfg.mode == "portable";
        description = "Whether this is a portable host (no LAN dependencies)";
      };
    };
  };

  config = {
    # Strategic assertions: validate prerequisites for DNS modes
    # This is the authoritative validation layer for DNS configuration
    assertions = [
      {
        assertion = cfg.mode == "local-recursive" -> networkCfg.hosts.${hostname}.ip != null;
        message = "DNS policy 'local-recursive' requires a static IP for ${hostname}";
      }
      {
        assertion = cfg.mode == "lan-recursive" -> networkCfg.hosts.minipc.ip != null;
        message = "DNS policy 'lan-recursive' requires minipc to have a static IP";
      }
    ];

    # Auto-enable Unbound based on policy
    bigor.features.unbound = mkIf cfg.computed.shouldRunUnbound {
      enable = lib.mkDefault true;
      listenOnLan = lib.mkDefault true;
    };
  };
}
