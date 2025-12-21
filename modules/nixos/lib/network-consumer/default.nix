# Module: network-consumer
# Purpose: Consumes network topology to configure DNS, Caddy, and firewall
{ lib, config, ... }:
let
  inherit (config.bigor.network) topology mainInterface;
  inherit (config.networking) hostName;

  # Services hosted on THIS machine
  localServices = lib.filterAttrs (_name: svc: svc.host == hostName) topology.services;

  # All services with domains (for DNS, regardless of host)
  servicesWithDomains = lib.filterAttrs (
    _name: svc: svc.domain != null && svc.expose.dns
  ) topology.services;

  # Local services that need reverse proxy
  localReverseProxyServices = lib.filterAttrs (
    _name: svc: svc.expose.reverseProxy && svc.port != 0
  ) localServices;

  # Local services that need firewall TCP ports opened
  localFirewallTCPServices = lib.filterAttrs (
    _name: svc: svc.expose.firewall && svc.port != 0
  ) localServices;

  # Local services that need firewall UDP ports opened
  localFirewallUDPServices = lib.filterAttrs (
    _name: svc: svc.expose.firewallUDP && svc.port != 0
  ) localServices;

  # Generate Caddy virtual hosts for local services
  caddyVirtualHosts = lib.mapAttrs' (
    _name: svc:
    lib.nameValuePair svc.domain {
      extraConfig = ''
        reverse_proxy ${svc.proxyProtocol}://127.0.0.1:${toString svc.port}
        tls internal
      '';
    }
  ) (lib.filterAttrs (_: svc: svc.domain != null) localReverseProxyServices);

  # Generate AdGuard rewrites for ALL services (SSOT benefit)
  adguardRewrites = lib.mapAttrsToList (_name: svc: {
    inherit (svc) domain;
    answer = topology.hosts.${svc.host}.ip;
    enabled = true;
  }) (lib.filterAttrs (_name: svc: topology.hosts.${svc.host}.ip != null) servicesWithDomains);

  # Firewall ports
  firewallTCPPorts = lib.mapAttrsToList (_name: svc: svc.port) localFirewallTCPServices;
  firewallUDPPorts = lib.mapAttrsToList (_name: svc: svc.port) localFirewallUDPServices;

in
{
  config = lib.mkMerge [
    # Assertions to validate the topology
    {
      assertions = [
        {
          assertion = lib.all (svc: topology.hosts ? ${svc.host}) (lib.attrValues topology.services);
          message = "network-topology: A service references a host that doesn't exist in topology.hosts";
        }
        {
          assertion = lib.all (svc: svc.port >= 0 && svc.port < 65536) (lib.attrValues topology.services);
          message = "network-topology: Invalid port in a service (must be 0-65535)";
        }
        {
          assertion =
            let
              domains = lib.filter (d: d != null) (map (s: s.domain) (lib.attrValues topology.services));
            in
            domains == lib.unique domains;
          message = "network-topology: Domain collision detected! Multiple services use the same domain.";
        }
      ];

      # Security warnings for services exposed via both Caddy and direct firewall
      warnings = lib.concatMap (
        svc:
        lib.optional (svc.domain != null && svc.expose.reverseProxy && svc.expose.firewall)
          "network-topology: SECURITY - Service '${svc.domain}' is exposed via Caddy AND direct firewall (port ${toString svc.port}), allowing proxy bypass."
      ) (lib.attrValues localServices);
    }

    # Caddy reverse proxy configuration (only for local services)
    (lib.mkIf (config.services.caddy.enable or false) {
      services.caddy.virtualHosts = caddyVirtualHosts;
    })

    # AdGuard DNS rewrites (for ALL services - SSOT)
    (lib.mkIf (config.services.adguardhome.enable or false) {
      services.adguardhome.settings.filtering.rewrites = adguardRewrites;
    })

    # Firewall configuration (only for local services)
    (lib.mkIf (mainInterface != null && (firewallTCPPorts != [ ] || firewallUDPPorts != [ ])) {
      networking.firewall.interfaces.${mainInterface} = {
        allowedTCPPorts = firewallTCPPorts;
        allowedUDPPorts = firewallUDPPorts;
      };
    })

    # Note: bigor.network.ips is defined in modules/nixos/features/system/network
    # The topology.hosts serves as the SSOT, that module should be updated to read from it
  ];
}
