# ============================================================================
# File: modules/nixos/lib/exposed-services/default.nix
# Description: Manages exposed services through Caddy, AdGuard, and firewall.
#              Includes safety checks for collisions and security risks.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================

{ lib, config, ... }:
let
  cfg = config.bigor.lib.exposedService;
  targetIP = config.bigor.network.ips.minipc;

  # Transform the services attribute set into a list of values for reuse
  servicesList = lib.attrValues cfg;

  # Generate Caddy virtual hosts
  # We filter out services that have no domain OR have a port of 0 (pure DNS)
  caddyVirtualHosts = lib.mapAttrs' (
    _name: svc:
    lib.nameValuePair svc.domain {
      extraConfig = ''
        reverse_proxy ${svc.proxyProtocol}://127.0.0.1:${toString svc.port}
        tls internal
      '';
    }
  ) (lib.filterAttrs (_: svc: svc.domain != null && svc.port != 0) cfg);

  # Generate AdGuard DNS rewrites
  adguardRewrites = lib.concatMap (
    svc:
    lib.optional (config.services.adguardhome.enable && svc.domain != null) {
      inherit (svc) domain;
      answer = targetIP;
      enabled = true;
    }
  ) servicesList;

  # Open Firewall Ports
  firewallTCPPorts = lib.concatMap (svc: lib.optional svc.openFirewall svc.port) servicesList;
  firewallUDPPorts = lib.concatMap (svc: lib.optional svc.openUDPFirewall svc.port) servicesList;

in
{
  options.bigor.lib.exposedService = lib.mkOption {
    description = "Helper to expose local services via Caddy and register them in AdGuard Home";
    default = { };
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          port = lib.mkOption {
            type = lib.types.int;
            description = "Internal port of the service. Use 0 for DNS-only entries.";
          };
          domain = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Domain name to expose (e.g. grafana.bigor.lan)";
          };
          openFirewall = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to open the port directly in the firewall (bypass Caddy)";
          };
          openUDPFirewall = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to open the UDP port directly in the firewall";
          };
          proxyProtocol = lib.mkOption {
            type = lib.types.str;
            default = "http";
            description = "Protocol for the reverse proxy (http or https)";
          };
        };
      }
    );
  };

  config = {
    # ============================================================================
    # Validations & Security
    # ============================================================================

    # 1. Assertions: Block the build in case of critical errors
    assertions = [
      {
        # Check for unique ports (for non-zero ports)
        assertion =
          let
            ports = map (s: toString s.port) (lib.filter (s: s.port != 0) servicesList);
          in
          ports == lib.unique ports;
        message = "exposed-services: Collision detected! Multiple services are trying to use the same port number.";
      }
      {
        # Check for unique domains
        assertion =
          let
            domains = map (s: s.domain) (lib.filter (s: s.domain != null) servicesList);
          in
          domains == lib.unique domains;
        message = "exposed-services: Collision detected! Multiple services are trying to use the same domain name.";
      }
    ];

    # 2. Warnings: Warn about potentially dangerous configurations
    warnings = lib.concatMap (
      svc:
      lib.optional (svc.domain != null && svc.openFirewall)
        "exposed-services: SECURITY - The service '${svc.domain}' is exposed via Caddy (Reverse Proxy) BUT its port ${toString svc.port} is also open directly on the firewall (openFirewall = true). This allows bypassing the proxy and its security features."
    ) servicesList;

    # ============================================================================
    # System Configuration
    # ============================================================================

    # 1. Caddy Configuration
    services.caddy.virtualHosts = caddyVirtualHosts;

    # 2. Firewall Opening
    networking.firewall.interfaces.${config.bigor.network.mainInterface} = {
      allowedTCPPorts = firewallTCPPorts;
      allowedUDPPorts = firewallUDPPorts;
    };

    # 3. DNS Rewrite (AdGuard)
    services.adguardhome.settings.filtering.rewrites = adguardRewrites;
  };
}
