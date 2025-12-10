{
  config,
  lib,
  ...
}: {
  # ============================================================================
  # Caddy Web Server
  # ============================================================================
  # Configures Caddy as a reverse proxy for internal services.
  # Note: Virtual hosts are defined within individual service modules
  # using 'services.caddy.virtualHosts'.
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
