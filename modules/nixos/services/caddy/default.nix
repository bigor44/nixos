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
  # ============================================================================
  # File: modules/nixos/services/caddy/default.nix
  # Description: Caddy Web Server Configuration
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Configures Caddy as a reverse proxy for internal services.
  #          Virtual hosts are defined dynamically in other service modules.
  # ============================================================================

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
