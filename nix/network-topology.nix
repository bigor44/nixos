# Module: nix/network-topology.nix
# Purpose: Network topology data (hosts, IPs, interfaces, subnet)
# This file is pure data and should not contain NixOS module logic
let
  mkNode = ip: interface: { inherit ip interface; };
in
{
  # Network subnet in CIDR notation
  subnet = "192.168.1.0/24";

  # Local domain name for all hosts
  domain = "bigor.lan";

  # All hosts in the network with their static IPs and interfaces
  hosts = {
    minipc = mkNode "192.168.1.10" "enp2s0";
    grospc = mkNode "192.168.1.11" "enp14s0";
    minidesk = mkNode null "enp2s0"; # DHCP
  };

  # Standard port numbers grouped by service type
  ports = {
    web = {
      http = 80;
      https = 443;
    };
    dns = {
      main = 53;
      metrics = 4000;
    };
    monitoring = {
      gatus = 8080;
    };
    storage = {
      nfs = [
        111
        2049
      ];
    };
    remote = {
      ssh = 22;
    };
  };
}
