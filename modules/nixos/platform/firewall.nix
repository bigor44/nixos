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
  hostname = config.networking.hostName;
  networkCfg = config.bigor.network;
  hostConfig = networkCfg.hosts.${hostname};
  inherit (networkCfg) ports;

  # Check if this host has a static IP (required for services that listen on LAN)
  hasStaticIp = hostConfig.ip != null;
  mainInterface = hostConfig.interface;

  # Features that require firewall openings
  dnsMode = config.bigor.platform.policies.dns.mode;
  # Blocky only needs firewall opening in local-recursive mode (serving LAN)
  # In portable/cloud modes, it only serves localhost
  blockyEnabled = cfg.blocky.enable && dnsMode == "local-recursive";
  unboundEnabled = cfg.unbound.enable;
  unboundListenOnLan = cfg.unbound.listenOnLan;
  caddyEnabled = cfg.caddy.enable;
  nfsServerEnabled = cfg.nfs-server.enable;

  # Compute required ports based on enabled features
  tcpPorts =
    optional blockyEnabled ports.blocky.dns
    ++ optional (unboundEnabled && unboundListenOnLan) ports.unbound
    ++ optional caddyEnabled ports.caddy.http
    ++ optional caddyEnabled ports.caddy.https
    ++ optional nfsServerEnabled ports.nfs.rpc
    ++ optional nfsServerEnabled ports.nfs.server;

  udpPorts =
    optional blockyEnabled ports.blocky.dns
    ++ optional (unboundEnabled && unboundListenOnLan) ports.unbound
    ++ optional nfsServerEnabled ports.nfs.rpc
    ++ optional nfsServerEnabled ports.nfs.server;

  # Services that require static IP (only when serving LAN)
  servicesRequiringStaticIp = [
    {
      name = "blocky (local-recursive mode)";
      enabled = blockyEnabled; # Already filtered for local-recursive mode
    }
    {
      name = "caddy";
      enabled = caddyEnabled;
    }
    {
      name = "nfs-server";
      enabled = nfsServerEnabled;
    }
    {
      name = "unbound (listenOnLan)";
      enabled = unboundEnabled && unboundListenOnLan;
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
