# Feature: caddy
# Purpose: Reverse proxy with automatic HTTPS
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.features.caddy;
  networkCfg = config.bigor.network;
  inherit (networkCfg) mainInterface ports;
in
{
  options.bigor.features.caddy.enable = mkEnableOption "Caddy reverse proxy";

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
    };

    # Required for Caddy's local CA management (certutil)
    environment.systemPackages = [ pkgs.nss ];

    # Open Caddy ports
    networking.firewall.interfaces.${mainInterface} = {
      allowedTCPPorts = [
        ports.caddy.http
        ports.caddy.https
      ];
    };
  };
}
