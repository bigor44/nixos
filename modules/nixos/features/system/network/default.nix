# Feature: system.network
# Purpose: Network configuration options and static /etc/hosts entries
{ lib, config, ... }:
let
  inherit (config.bigor.network) topology;
  hostsWithIPs = lib.filterAttrs (_: host: host.ip != null) topology.hosts;
in
{
  options.bigor.network = {
    mainInterface = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "Primary network interface name";
    };
    # Derive IPs from topology SSOT
    ips = lib.mapAttrs (
      name: _:
      lib.mkOption {
        type = lib.types.str;
        default = topology.hosts.${name}.ip;
        description = "Static IP for ${name}";
      }
    ) hostsWithIPs;
  };

  config = {
    # Generate /etc/hosts from topology
    networking.extraHosts = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: host: "${host.ip} ${name}") hostsWithIPs
    );
  };
}
