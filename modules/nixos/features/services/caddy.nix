# Feature: services-caddy
# Purpose: Reverse proxy with automatic HTTPS
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bigor.features.services.caddy;
in
{
  options.bigor.features.services.caddy.enable = lib.mkEnableOption "Caddy reverse proxy";

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    # Required for Caddy's local CA management (certutil)
    environment.systemPackages = [ pkgs.nss ];
  };
}
