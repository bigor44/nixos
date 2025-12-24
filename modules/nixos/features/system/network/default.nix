# Feature: system.network
# Purpose: Network configuration, static /etc/hosts entries, and network topology
{ lib, config, ... }:
let
  hostsWithIPs = lib.filterAttrs (_: host: host.ip != null) config.bigor.network.hosts;
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
            hasNodeExporter = lib.mkEnableOption "node-exporter for Prometheus monitoring";
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
          hasNodeExporter = true; # homelab-master profile enables node-exporter
        };
        grospc = {
          ip = "192.168.1.11";
          interface = "enp14s0";
          hasNodeExporter = true; # workstation profile enables node-exporter
        };
        minidesk = {
          ip = null; # DHCP
          interface = "enp2s0";
          hasNodeExporter = true; # workstation profile enables node-exporter
        };
      };
    }

    # Generate /etc/hosts from hosts registry
    {
      networking.extraHosts = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: host: "${host.ip} ${name}") hostsWithIPs
      );
    }

    # Enable nftables (modern firewall backend)
    { networking.nftables.enable = true; }

    # Configure localhost as DNS server when Blocky is enabled locally
    (lib.mkIf config.bigor.services.blocky.enable {
      # NetworkManager: prevent automatic DNS management
      networking.networkmanager.dns = lib.mkDefault "none";

      # Set localhost as primary nameserver (works for both NetworkManager and systemd-resolved)
      networking.nameservers = lib.mkBefore [ "127.0.0.1" ];
    })
  ];
}
