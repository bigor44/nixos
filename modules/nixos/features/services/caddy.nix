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

    # Declare network needs
    bigor.network.firewall.ports.tcp = [
      config.bigor.network.ports.caddy.http
      config.bigor.network.ports.caddy.https
    ];
    bigor.network.requiredStaticIpServices = [ "caddy" ];

    # Required for Caddy's local CA management (certutil)
    environment.systemPackages = [ pkgs.nss ];
  };
}
