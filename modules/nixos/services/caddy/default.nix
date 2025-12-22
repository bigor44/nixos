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
  inherit (config.networking) hostName;

  # Services hosted on THIS machine that need reverse proxy
  localReverseProxyServices = lib.filterAttrs (
    _name: svc: svc.hostName == hostName && svc.domain != null && svc.reverseProxy && svc.port != 0
  ) config.bigor.registry.services;

  # Generate Caddy virtual hosts from registry
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
    # Register Caddy's own ports in registry
    bigor.registry.services.caddy-http = {
      inherit (config.networking) hostName;
      port = 80;
      domain = null;
      reverseProxy = false;
      openFirewall = true;
      openFirewallUDP = false;
      proxyProtocol = "http";
    };

    bigor.registry.services.caddy-https = {
      inherit (config.networking) hostName;
      port = 443;
      domain = null;
      reverseProxy = false;
      openFirewall = true;
      openFirewallUDP = false;
      proxyProtocol = "http";
    };

    services.caddy = {
      enable = true;
      virtualHosts = caddyVirtualHosts;
    };

    # Security warnings for services exposed via both Caddy and direct firewall
    warnings = lib.concatMap (
      svc:
      lib.optional svc.openFirewall "SECURITY - Service '${svc.domain}' is exposed via Caddy AND direct firewall (port ${toString svc.port}), allowing proxy bypass."
    ) (lib.attrValues localReverseProxyServices);
  };
}
