# ============================================================================
# File: modules/nixos/services/caddy/default.nix
# Description: Configures the Caddy web server.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.services.caddy;
in
{
  options.bigor.services.caddy = {
    enable = mkEnableOption "Enable Caddy web server as a reverse proxy";
  };

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
    };

    bigor.lib.exposedService.caddy-http = {
      port = 80;
      openFirewall = true;
    };

    bigor.lib.exposedService.caddy-https = {
      port = 443;
      openFirewall = true;
    };
  };
}
