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
    unique
    ;

  hostConfig = config.bigor.network.hosts.${config.networking.hostName};
  mainInterface = hostConfig.interface;

  cfg = config.bigor.network.firewall;

  allTcpPorts = unique cfg.ports.tcp;
  allUdpPorts = unique cfg.ports.udp;
  hasPorts = allTcpPorts != [ ] || allUdpPorts != [ ];

  portType = types.addCheck types.int (p: p > 0 && p < 65536) // {
    name = "port";
    description = "port number (1-65535)";
  };
in
{
  options.bigor.network.firewall = {
    ports = {
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
      assertions = [
        {
          assertion = hasPorts -> mainInterface != "";
          message = "Firewall: Open ports are requested but no main network interface is defined for this host.";
        }
      ];

      networking.firewall = {
        enable = true;
        # Allow ping from LAN
        allowPing = true;
        # Log refused connections for debugging
        logRefusedConnections = false;
      };
    }

    # Open ports on the main interface for enabled services
    (mkIf hasPorts {
      networking.firewall.interfaces.${mainInterface} = mkMerge [
        (mkIf (allTcpPorts != [ ]) { allowedTCPPorts = allTcpPorts; })
        (mkIf (allUdpPorts != [ ]) { allowedUDPPorts = allUdpPorts; })
      ];
    })
  ];
}
