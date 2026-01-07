# Feature: system.network
# Purpose: Network configuration, static /etc/hosts entries, and network topology
{
  lib,
  config,
  ...
}:
let
  cfg = config.bigor.network;
  hostname = config.networking.hostName;
  hostsWithIPs = lib.filterAttrs (_: host: host.ip != null) cfg.hosts;
  knownInterfaces = lib.unique (lib.mapAttrsToList (_: host: host.interface) cfg.hosts);
in
{
  options.bigor.network = {
    subnet = lib.mkOption {
      type = lib.types.strMatching "^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$";
      default = "192.168.1.0/24";
      description = "Network subnet in CIDR notation (e.g., 192.168.1.0/24)";
    };

    mainInterface = lib.mkOption {
      type = lib.types.str;
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

  config = lib.mkMerge [
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
    }

    # Assertions to validate network configuration
    {
      assertions = [
        {
          assertion = hostname != "" -> cfg.hosts ? ${hostname};
          message = "Host '${hostname}' is not defined in bigor.network.hosts. Add it to the network topology.";
        }
        {
          assertion = cfg.mainInterface != "" -> lib.elem cfg.mainInterface knownInterfaces;
          message = "Interface '${cfg.mainInterface}' is not defined in any bigor.network.hosts entry. Known interfaces: ${lib.concatStringsSep ", " knownInterfaces}";
        }
        {
          assertion =
            (hostname != "" && cfg.hosts ? ${hostname}) -> cfg.mainInterface == cfg.hosts.${hostname}.interface;
          message = "mainInterface '${cfg.mainInterface}' does not match the interface defined for '${hostname}' in bigor.network.hosts (expected: '${
            cfg.hosts.${hostname}.interface or "undefined"
          }')";
        }
      ]
      ++ lib.mapAttrsToList (name: host: {
        assertion = host.ip != null -> host.interface != null;
        message = "Host '${name}' has a static IP but no interface defined. Static IP requires an interface.";
      }) cfg.hosts;
    }

    # Generate /etc/hosts from hosts registry
    {
      networking.extraHosts = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: host: "${host.ip} ${name}") hostsWithIPs
      );
    }

    # Enable nftables (modern firewall backend)
    { networking.nftables.enable = true; }

    # Configure DNS servers when Blocky is enabled locally
    (lib.mkIf config.bigor.services.blocky.enable (
      let
        fallbackDNS = [
          "127.0.0.1" # Blocky (primary)
          "1.1.1.1" # Cloudflare (fallback)
          "9.9.9.9" # Quad9 (fallback)
        ];
      in
      {
        # For non-NetworkManager hosts (minipc)
        networking.nameservers = fallbackDNS;
        # For NetworkManager hosts (grospc, minidesk) - overrides nameservers
        networking.networkmanager.insertNameservers = fallbackDNS;
      }
    ))
  ];
}
