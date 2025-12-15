{
  config,
  lib,
  ...
}:
{
  # ============================================================================
  # File: modules/nixos/services/caddy/default.nix
  # Description: Caddy Web Server Configuration
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Configures Caddy as a reverse proxy for internal services.
  #          Virtual hosts are defined dynamically in other service modules.
  # ============================================================================

  config = lib.mkIf config.bigor.roles.homelab_master {
    services.caddy = {
      enable = true;
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
