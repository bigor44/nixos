# Module: nix/network-topology.nix
# Purpose: Network topology data (hosts, IPs, interfaces, subnet)
# This file is pure data and should not contain NixOS module logic
{
  # Network subnet in CIDR notation
  subnet = "192.168.1.0/24";

  # Local domain name for all hosts
  domain = "bigor.lan";

  # All hosts in the network with their static IPs and interfaces
  hosts = {
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

  # Standard port numbers for all network services
  ports = {
    blocky = {
      dns = 53;
      http = 4000; # Metrics endpoint
    };
    caddy = {
      http = 80;
      https = 443;
    };
    nfs.ports = [
      111
      2049
    ];
    gatus = 8080;
    ssh = 22;
  };
}
