# Platform: system.network
# Purpose: Network configuration, static /etc/hosts entries, and network topology
# Topology data is imported from nix/network-topology.nix via specialArgs
{
  lib,
  config,
  networkTopology,
  ...
}:
let
  inherit (lib)
    mkOption
    mkMerge
    types
    filterAttrs
    mapAttrsToList
    concatStringsSep
    ;
  cfg = config.bigor.network;
  hostname = config.networking.hostName;
  hostsWithIPs = filterAttrs (_: host: host.ip != null) cfg.hosts;
in
{
  options.bigor.network = {
    subnet = mkOption {
      type = types.strMatching "^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$";
      default = networkTopology.subnet;
      description = "Network subnet in CIDR notation (e.g., 192.168.1.0/24)";
    };

    domain = mkOption {
      type = types.str;
      default = networkTopology.domain;
      description = "Local domain name for all hosts (e.g., bigor.lan)";
      readOnly = true;
    };

    mainInterface = mkOption {
      type = types.str;
      description = "Primary network interface name (derived from hosts topology)";
      default = cfg.hosts.${hostname}.interface or "";
      readOnly = true;
    };

    hosts = mkOption {
      description = "All hosts in the network with their static IPs and interfaces";
      default = networkTopology.hosts;
      type = types.attrsOf (
        types.submodule {
          options = {
            ip = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Static IP address (null for DHCP hosts)";
            };
            interface = mkOption {
              type = types.str;
              description = "Primary network interface";
            };
          };
        }
      );
    };

    ports = mkOption {
      description = "Standard port numbers for all network services";
      readOnly = true;
      default = networkTopology.ports;
    };

    requiredStaticIpServices = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of services enabled on this host that require a static IP.";
    };
  };

  config = mkMerge [
    # Base network configuration (always applied)
    {
      assertions = [
        {
          assertion = hostname != "" -> cfg.hosts ? ${hostname};
          message = "Host '${hostname}' is not defined in bigor.network.hosts. Add it to the network topology.";
        }
        {
          assertion = cfg.requiredStaticIpServices != [ ] -> (cfg.hosts.${hostname}.ip or null) != null;
          message = ''
            The following services require a static IP but ${hostname} has no static IP configured:
            ${lib.concatMapStringsSep "\n" (s: "  - ${s}") cfg.requiredStaticIpServices}

            To fix:
            1. Add static IP in nix/network-topology.nix:
               hosts.${hostname}.ip = "192.168.1.XX";

            2. OR disable services in hosts/${hostname}/default.nix:
               bigor.features.<service>.enable = false;
          '';
        }
      ]
      ++ mapAttrsToList (name: host: {
        assertion = host.ip != null -> host.interface != null;
        message = "Host '${name}' has a static IP but no interface defined. Static IP requires an interface.";
      }) cfg.hosts;

      warnings = lib.optional (cfg.domain == "") "bigor.network.domain is not set";

      # Generate /etc/hosts from hosts registry
      networking.extraHosts = concatStringsSep "\n" (
        mapAttrsToList (name: host: "${host.ip} ${name}") hostsWithIPs
      );

      # Enable nftables (modern firewall backend)
      networking.nftables.enable = true;
    }

    # DNS configuration is now handled by modules/nixos/platform/dns/resolver.nix
    # (DNS is a platform guarantee - always present)
  ];
}
