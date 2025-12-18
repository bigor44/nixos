# ============================================================================
# File: /home/bigor/nixos/modules/nixos/lib/exposed-services/default.nix
# Description: Manages exposed services through Caddy, AdGuard, and firewall.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================

{ lib, config, ... }:
let
  cfg = config.bigor.lib.exposedService;
  targetIP = config.bigor.network.ips.minipc;

  # Liste des services transformée en liste de valeurs pour réutilisation
  servicesList = lib.attrValues cfg;

  # Génération des hôtes virtuels Caddy
  # On filtre les services qui n'ont pas de domaine OU qui ont un port à 0 (DNS pur)
  caddyVirtualHosts = lib.mapAttrs' (
    _name: svc:
    lib.nameValuePair svc.domain {
      extraConfig = ''
        reverse_proxy ${svc.proxyProtocol}://127.0.0.1:${toString svc.port}
        tls internal
      '';
    }
  ) (lib.filterAttrs (_: svc: svc.domain != null && svc.port != 0) cfg);

  # Génération des réécritures DNS AdGuard
  adguardRewrites = lib.concatMap (
    svc:
    lib.optional (config.services.adguardhome.enable && svc.domain != null) {
      inherit (svc) domain;
      answer = targetIP;
      enabled = true;
    }
  ) servicesList;

  # Ouverture des ports du Firewall
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
    # 1. Configuration Caddy
    services.caddy.virtualHosts = caddyVirtualHosts;

    # 2. Ouverture Firewall
    networking.firewall.interfaces.${config.bigor.network.mainInterface} = {
      allowedTCPPorts = firewallTCPPorts;
      allowedUDPPorts = firewallUDPPorts;
    };

    # 3. DNS Rewrite (AdGuard)
    services.adguardhome.settings.filtering.rewrites = adguardRewrites;
  };
}
