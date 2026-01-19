# Platform: firewall
# Purpose: Centralized firewall configuration based on enabled features and network topology
{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkMerge
    mkOption
    types
    ;

  hostConfig = config.bigor.network.hosts.${config.networking.hostName};
  mainInterface = hostConfig.interface;

  cfg = config.bigor.platform.firewall;

  portType = types.addCheck types.int (p: p > 0 && p < 65536) // {
    name = "port";
    description = "port number (1-65535)";
  };
in
{
  options.bigor.platform.firewall = {
    openPorts = {
      tcp = mkOption {
        type = types.listOf portType;
        default = [ ];
        description = "TCP ports to open on the main interface.";
      };
      udp = mkOption {
        type = types.listOf portType;
        default = [ ];
        description = "UDP ports to open on the main interface.";
      };
    };
  };

  config = mkMerge [
    # Default firewall settings
    {
      networking.firewall = {
        enable = true;
        # Allow ping from LAN
        allowPing = true;
        # Log refused connections for debugging
        logRefusedConnections = false;
      };
    }

    # Open ports on the main interface for enabled services
    (mkIf (cfg.openPorts.tcp != [ ] || cfg.openPorts.udp != [ ]) {
      networking.firewall.interfaces.${mainInterface} = mkMerge [
        (mkIf (cfg.openPorts.tcp != [ ]) { allowedTCPPorts = lib.unique cfg.openPorts.tcp; })
        (mkIf (cfg.openPorts.udp != [ ]) { allowedUDPPorts = lib.unique cfg.openPorts.udp; })
      ];
    })
  ];
}
