# Module: caddy
# Purpose: Reverse proxy with automatic HTTPS
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.services.caddy;
  inherit (config.bigor.network) topology;
  inherit (config.networking) hostName;

  # Services hosted on THIS machine that need reverse proxy
  localReverseProxyServices = lib.filterAttrs (
    _name: svc:
    svc.host == hostName
    # Service on this host
    && svc.domain != null
    # Has a domain
    && svc.expose.reverseProxy
    # Should be exposed via Caddy
    && svc.port != 0 # Has a valid port
  ) topology.services;

  # Generate Caddy virtual hosts from topology
  caddyVirtualHosts = lib.mapAttrs' (
    _name: svc:
    lib.nameValuePair svc.domain {
      extraConfig = ''
        reverse_proxy ${svc.proxyProtocol}://127.0.0.1:${toString svc.port}
        tls internal
      '';
    }
  ) localReverseProxyServices;
in
{
  options.bigor.services.caddy.enable = mkEnableOption "Caddy reverse proxy";

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      virtualHosts = caddyVirtualHosts;
    };

    # Security warnings for services exposed via both Caddy and direct firewall
    warnings = lib.concatMap (
      svc:
      lib.optional svc.expose.firewall "SECURITY - Service '${svc.domain}' is exposed via Caddy AND direct firewall (port ${toString svc.port}), allowing proxy bypass."
    ) (lib.attrValues localReverseProxyServices);
  };
}
