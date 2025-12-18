{ lib, config, ... }:
let
  cfg = config.bigor.lib.exposedService;
  targetIP = config.bigor.network.ips.minipc;

  # Utilisation de lib.mapAttrs' pour transformer les services en hôtes virtuels Caddy
  caddyVirtualHosts = lib.mapAttrs' (
    _name: svc:
    lib.nameValuePair svc.domain {
      extraConfig = ''
        reverse_proxy ${svc.proxyProtocol}://127.0.0.1:${toString svc.port}
        tls internal
      '';
    }
  ) (lib.filterAttrs (_: svc: svc.domain != null) cfg);

  # Simplification avec concatMap sur les valeurs directement
  servicesList = lib.attrValues cfg;

  adguardRewrites = lib.concatMap (
    svc:
    lib.optional (config.services.adguardhome.enable && svc.domain != null) {
      inherit (svc) domain;
      answer = targetIP;
      enabled = true;
    }
  ) servicesList;

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
            description = "Internal port of the service";
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
    services.caddy.virtualHosts = caddyVirtualHosts;

    networking.firewall.interfaces.${config.bigor.network.mainInterface} = {
      allowedTCPPorts = firewallTCPPorts;
      allowedUDPPorts = firewallUDPPorts;
    };

    services.adguardhome.settings.filtering.rewrites = adguardRewrites;
  };
}
