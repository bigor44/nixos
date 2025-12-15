{
  config,
  pkgs,
  lib,
  ...
}:
{
  # ============================================================================
  # File: modules/nixos/services/tailscale/default.nix
  # Description: Tailscale VPN Configuration
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Configures Tailscale for secure mesh networking and optimizes
  #          Exit Node functionality on the homelab master.
  # ============================================================================

  config = lib.mkIf config.bigor.roles.homelab_master {
    services.tailscale.enable = true;

    # ==========================================================================
    # Exit Node & Routing Configuration
    # ==========================================================================
    # Enable IP forwarding to allow this machine to route traffic for other devices
    # (Exit Node functionality).
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };

    networking.firewall = {
      # "loose" allows reverse path filtering to pass Tailscale traffic
      checkReversePath = "loose";
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ 41641 ]; # Tailscale randomized port
    };

    environment.systemPackages = [ pkgs.tailscale ];
  };
}
