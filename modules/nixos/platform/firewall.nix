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
    optional
    ;

  cfg = config.bigor.features;
  dnsCfg = config.bigor.platform.dns;
  hostname = config.networking.hostName;
  networkCfg = config.bigor.network;
  hostConfig = networkCfg.hosts.${hostname};
  inherit (networkCfg) ports;

  # Check if this host has a static IP (required for services that listen on LAN)
  hasStaticIp = hostConfig.ip != null;
  mainInterface = hostConfig.interface;

  # Features that require firewall openings
  # DNS: Use platform-computed values instead of feature flags
  blockyEnabled = dnsCfg.computed.needsPort53OnLan;
  caddyEnabled = cfg.caddy.enable;
  nfsServerEnabled = cfg.nfs-server.enable;

  # Compute required ports based on enabled features
  tcpPorts =
    optional blockyEnabled ports.blocky.dns
    ++ optional caddyEnabled ports.caddy.http
    ++ optional caddyEnabled ports.caddy.https
    ++ optional nfsServerEnabled ports.nfs.rpc
    ++ optional nfsServerEnabled ports.nfs.server;

  udpPorts =
    optional blockyEnabled ports.blocky.dns
    ++ optional nfsServerEnabled ports.nfs.rpc
    ++ optional nfsServerEnabled ports.nfs.server;

  # Services that require static IP (only when serving LAN)
  servicesRequiringStaticIp = [
    {
      name = "DNS server (Blocky serving LAN)";
      enabled = blockyEnabled;
    }
    {
      name = "caddy";
      enabled = caddyEnabled;
    }
    {
      name = "nfs-server";
      enabled = nfsServerEnabled;
    }
  ];

  enabledServicesWithoutStaticIp = lib.filter (
    s: s.enabled && !hasStaticIp
  ) servicesRequiringStaticIp;

in
{
  config = mkMerge [
    # Assertions
    {
      assertions = [
        {
          assertion = enabledServicesWithoutStaticIp == [ ];
          message = ''
            The following services require a static IP but ${hostname} has no static IP configured:
            ${lib.concatMapStringsSep "\n" (s: "  - ${s.name}") enabledServicesWithoutStaticIp}

            Either:
            1. Configure a static IP in nix/network-topology.nix for ${hostname}
            2. Disable these services on this host
          '';
        }
      ];
    }
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
    (mkIf (tcpPorts != [ ] || udpPorts != [ ]) {
      networking.firewall.interfaces.${mainInterface} = mkMerge [
        (mkIf (tcpPorts != [ ]) { allowedTCPPorts = tcpPorts; })
        (mkIf (udpPorts != [ ]) { allowedUDPPorts = udpPorts; })
      ];
    })
  ];
}
