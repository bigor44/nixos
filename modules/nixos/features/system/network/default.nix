# Feature: system.network
# Purpose: Network configuration options, static /etc/hosts entries, and firewall rules
{ lib, config, ... }:
let
  inherit (config.bigor.network) topology mainInterface;
  inherit (config.networking) hostName;

  hostsWithIPs = lib.filterAttrs (_: host: host.ip != null) topology.hosts;

  # Services hosted on THIS machine
  localServices = lib.filterAttrs (_name: svc: svc.host == hostName) topology.services;

  # Local services that need firewall TCP ports opened
  localFirewallTCPServices = lib.filterAttrs (
    _name: svc: svc.expose.firewall && svc.port != 0
  ) localServices;

  # Local services that need firewall UDP ports opened
  localFirewallUDPServices = lib.filterAttrs (
    _name: svc: svc.expose.firewallUDP && svc.port != 0
  ) localServices;

  # Extract port numbers
  firewallTCPPorts = lib.mapAttrsToList (_name: svc: svc.port) localFirewallTCPServices;
  firewallUDPPorts = lib.mapAttrsToList (_name: svc: svc.port) localFirewallUDPServices;
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

  config = lib.mkMerge [
    # Generate /etc/hosts from topology
    {
      networking.extraHosts = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: host: "${host.ip} ${name}") hostsWithIPs
      );
    }

    # Firewall configuration from topology (only for local services)
    (lib.mkIf (mainInterface != null && (firewallTCPPorts != [ ] || firewallUDPPorts != [ ])) {
      networking.firewall.interfaces.${mainInterface} = {
        allowedTCPPorts = firewallTCPPorts;
        allowedUDPPorts = firewallUDPPorts;
      };
    })
  ];
}
