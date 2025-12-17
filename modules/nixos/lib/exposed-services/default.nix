{ lib, config, ... }:
let
  cfg = config.bigor.lib.exposedService;
  targetIP = config.bigor.network.ips.minipc;

  # Create a set of caddy virtual hosts from the exposed services
  caddyVirtualHosts = lib.foldr lib.recursiveUpdate { } (
    map (
      svc:
      lib.optionalAttrs (svc.domain != null) {
        "${svc.domain}" = {
          extraConfig = ''
            reverse_proxy ${svc.proxyProtocol}://127.0.0.1:${toString svc.port}
            tls internal
          '';
        };
      }
    ) (lib.attrValues cfg)
  );

  # Create a list of adguard rewrites from the exposed services
  adguardRewrites = lib.concatMap (
    svc:
    lib.optional (config.services.adguardhome.enable && svc.domain != null) {
      inherit (svc) domain;
      answer = targetIP;
      enabled = true;
    }
  ) (lib.attrValues cfg);

  # Create a list of firewall TCP ports to open
  firewallTCPPorts = lib.concatMap (svc: lib.optional svc.openFirewall svc.port) (lib.attrValues cfg);

  # Create a list of firewall UDP ports to open
  firewallUDPPorts = lib.concatMap (svc: lib.optional svc.openUDPFirewall svc.port) (
    lib.attrValues cfg
  );
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
    # 1. Configuration Caddy
    services.caddy.virtualHosts = caddyVirtualHosts;

    # 2. Ouverture Firewall (Optionnel)
    networking.firewall.interfaces.${config.bigor.network.mainInterface} = {
      allowedTCPPorts = firewallTCPPorts;
      allowedUDPPorts = firewallUDPPorts;
    };

    # 3. DNS Rewrite (AdGuard)
    # On n'applique ceci que si AdGuard est activé sur la machine pour éviter des erreurs
    services.adguardhome.settings.filtering.rewrites = adguardRewrites;
  };
}
