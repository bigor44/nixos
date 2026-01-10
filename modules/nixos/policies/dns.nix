{ config, lib, ... }:
let
  inherit (lib) mkOption mkIf types;
  cfg = config.bigor.policies.dns;
  hostname = config.networking.hostName;
  networkCfg = config.bigor.network;
  minipcIp = networkCfg.hosts.minipc.ip;
  fallbackUpstreams = [
    "1.1.1.1"
    "9.9.9.9"
  ];
in
{
  options.bigor.policies.dns = {
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
          {
            local-recursive = [ "127.0.0.1:5335" ] ++ fallbackUpstreams;
            lan-recursive = [ "${minipcIp}:5335" ] ++ fallbackUpstreams;
            portable = fallbackUpstreams;
            # Note: "cloud" currently identical to "portable" (reserved for future use)
            cloud = fallbackUpstreams;
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
    bigor.services.unbound = mkIf cfg.computed.shouldRunUnbound {
      enable = lib.mkDefault true;
      listenOnLan = lib.mkDefault true;
    };
  };
}
