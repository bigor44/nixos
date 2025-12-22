# Feature: system.network
# Purpose: Network configuration, service registry, static /etc/hosts entries, and firewall rules
{ lib, config, ... }:
let
  inherit (config.bigor.network) mainInterface;
  inherit (config.networking) hostName;

  hostsWithIPs = lib.filterAttrs (_: host: host.ip != null) config.bigor.network.hosts;

  # Services hosted on THIS machine
  localServices = lib.filterAttrs (
    _name: svc: svc.hostName == hostName
  ) config.bigor.registry.services;

  # Local services that need firewall TCP ports opened
  localFirewallTCPServices = lib.filterAttrs (
    _name: svc: svc.openFirewall && svc.port != 0
  ) localServices;

  # Local services that need firewall UDP ports opened
  localFirewallUDPServices = lib.filterAttrs (
    _name: svc: svc.openFirewallUDP && svc.port != 0
  ) localServices;

  # Extract port numbers
  firewallTCPPorts = lib.mapAttrsToList (_name: svc: svc.port) localFirewallTCPServices;
  firewallUDPPorts = lib.mapAttrsToList (_name: svc: svc.port) localFirewallUDPServices;
in
{
  options.bigor = {
    # Service registry - populated automatically by service modules
    registry.services = lib.mkOption {
      description = "Service registry - automatically populated by service modules when enabled";
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            hostName = lib.mkOption {
              type = lib.types.str;
              description = "Hostname where this service runs";
            };
            port = lib.mkOption {
              type = lib.types.int;
              default = 0;
              description = "Service port (0 for services without ports)";
            };
            domain = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Domain name (e.g., grafana.bigor.lan)";
            };
            reverseProxy = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Expose via Caddy reverse proxy";
            };
            openFirewall = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Open TCP port in firewall";
            };
            openFirewallUDP = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Open UDP port in firewall";
            };
            proxyProtocol = lib.mkOption {
              type = lib.types.str;
              default = "http";
              description = "Protocol for reverse proxy (http or https)";
            };
          };
        }
      );
    };

    network = {
      mainInterface = lib.mkOption {
        type = lib.types.str;
        default = null;
        description = "Primary network interface name";
      };

      hosts = lib.mkOption {
        description = "All hosts in the network with their static IPs and interfaces";
        default = { };
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              ip = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Static IP address (null for DHCP hosts)";
              };
              interface = lib.mkOption {
                type = lib.types.str;
                description = "Primary network interface";
              };
            };
          }
        );
      };

      dnsEntries = lib.mkOption {
        description = "DNS-only entries for hosts without services (used by Blocky)";
        default = { };
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              hostName = lib.mkOption {
                type = lib.types.str;
                description = "Hostname (must exist in bigor.network.hosts)";
              };
              domain = lib.mkOption {
                type = lib.types.str;
                description = "Domain name (e.g., minipc.bigor.lan)";
              };
            };
          }
        );
      };

      # Derive IPs from hosts for backward compatibility
      ips = lib.mapAttrs (
        name: _:
        lib.mkOption {
          type = lib.types.str;
          default = config.bigor.network.hosts.${name}.ip;
          description = "Static IP for ${name}";
        }
      ) hostsWithIPs;
    };
  };

  config = lib.mkMerge [
    # Registry validations
    {
      assertions = [
        # Domain uniqueness across services and DNS entries
        {
          assertion =
            let
              serviceDomains = lib.filter (d: d != null) (
                lib.mapAttrsToList (_: svc: svc.domain) config.bigor.registry.services
              );
              dnsDomains = lib.mapAttrsToList (_: e: e.domain) config.bigor.network.dnsEntries;
              allDomains = serviceDomains ++ dnsDomains;
            in
            allDomains == lib.unique allDomains;
          message = "Registry: Domain collision detected! Multiple services/DNS entries use the same domain.";
        }

        # Port range validation
        {
          assertion = lib.all (svc: svc.port >= 0 && svc.port < 65536) (
            lib.attrValues config.bigor.registry.services
          );
          message = "Registry: Invalid port in a service (must be 0-65535)";
        }

        # Host existence validation
        {
          assertion = lib.all (svc: config.bigor.network.hosts ? ${svc.hostName}) (
            lib.attrValues config.bigor.registry.services
          );
          message = "Registry: A service references a host that doesn't exist in bigor.network.hosts";
        }
      ];
    }

    # Define hosts
    {
      bigor.network.hosts = {
        minipc = {
          ip = "192.168.1.10";
          interface = "enp2s0";
        };
        grospc = {
          ip = "192.168.1.11";
          interface = "enp14s0";
        };
        minidesk = {
          ip = null; # DHCP
          interface = "enp2s0";
        };
      };

      # Define DNS-only entries (hosts without services)
      bigor.network.dnsEntries = {
        minipc-host = {
          hostName = "minipc";
          domain = "minipc.bigor.lan";
        };
        grospc-host = {
          hostName = "grospc";
          domain = "grospc.bigor.lan";
        };
        bigor-root = {
          hostName = "minipc";
          domain = "bigor.lan";
        };
      };
    }

    # Generate /etc/hosts from hosts registry
    {
      networking.extraHosts = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: host: "${host.ip} ${name}") hostsWithIPs
      );
    }

    # Firewall configuration from service registry (only for local services)
    (lib.mkIf (mainInterface != null && (firewallTCPPorts != [ ] || firewallUDPPorts != [ ])) {
      networking.firewall.interfaces.${mainInterface} = {
        allowedTCPPorts = firewallTCPPorts;
        allowedUDPPorts = firewallUDPPorts;
      };
    })
  ];
}
