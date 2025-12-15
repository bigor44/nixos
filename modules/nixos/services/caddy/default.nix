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

    networking.firewall.interfaces.${config.bigor.network.mainInterface} = {
      allowedTCPPorts = [
        80
        443
      ];
    };
  };
}
