# Module: network-topology
# Purpose: Single Source of Truth for all network services and hosts
{ lib, ... }:
{
  options.bigor.network.topology = {
    hosts = lib.mkOption {
      description = "All hosts in the network with their static IPs";
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

    services = lib.mkOption {
      description = "All services in the homelab with their exposure settings";
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            host = lib.mkOption {
              type = lib.types.str;
              description = "Hostname where this service runs";
            };
            port = lib.mkOption {
              type = lib.types.int;
              default = 0;
              description = "Service port (0 for DNS-only entries)";
            };
            domain = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Domain name (e.g., grafana.bigor.lan)";
            };
            expose = {
              dns = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Create DNS rewrite for this service";
              };
              reverseProxy = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Expose via Caddy reverse proxy";
              };
              firewall = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Open TCP port in firewall";
              };
              firewallUDP = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Open UDP port in firewall";
              };
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
  };

  # Define the SSOT topology
  config.bigor.network.topology = {
    # All hosts in the network
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
        ip = null; # DHCP in travel mode
        interface = "enp2s0";
      };
    };

    # All services - this is the Single Source of Truth
    services = {
      # DNS-only entries for host resolution
      minipc-host = {
        host = "minipc";
        domain = "minipc.bigor.lan";
        port = 0;
        expose.reverseProxy = false;
      };
      grospc-host = {
        host = "grospc";
        domain = "grospc.bigor.lan";
        port = 0;
        expose.reverseProxy = false;
      };
      bigor-root = {
        host = "minipc";
        domain = "bigor.lan";
        port = 0;
        expose.reverseProxy = false;
      };

      # Monitoring stack
      prometheus = {
        host = "minipc";
        port = 9090;
        domain = "prometheus.bigor.lan";
        expose.reverseProxy = true;
      };
      grafana = {
        host = "minipc";
        port = 3000;
        domain = "grafana.bigor.lan";
        expose.reverseProxy = true;
      };
      alertmanager = {
        host = "minipc";
        port = 9093;
        domain = "alertmanager.bigor.lan";
        expose.reverseProxy = true;
      };
      node-exporter-minipc = {
        host = "minipc";
        port = 9100;
        expose.firewall = true;
      };
      node-exporter-grospc = {
        host = "grospc";
        port = 9100;
        expose.firewall = true;
      };

      # AdGuard DNS
      adguard = {
        host = "minipc";
        port = 3003;
        domain = "adguard.bigor.lan";
        expose.reverseProxy = true;
      };
      adguard-dns = {
        host = "minipc";
        port = 53;
        expose = {
          dns = false; # DNS service itself doesn't need DNS rewrite
          reverseProxy = false;
          firewall = true;
          firewallUDP = true;
        };
      };

      # Caddy ports
      caddy-http = {
        host = "minipc";
        port = 80;
        expose = {
          dns = false;
          reverseProxy = false;
          firewall = true;
        };
      };
      caddy-https = {
        host = "minipc";
        port = 443;
        expose = {
          dns = false;
          reverseProxy = false;
          firewall = true;
        };
      };

      # LLM service
      ollama = {
        host = "minipc";
        port = 8080;
        domain = "ai.bigor.lan";
        expose.reverseProxy = true;
      };
    };
  };
}
