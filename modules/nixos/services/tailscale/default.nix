# Module: tailscale
# Purpose: Mesh VPN with exit node and subnet routing
{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.services.tailscale;
in
{
  options.bigor.services.tailscale.enable = mkEnableOption "Tailscale VPN mesh networking";

  config = mkIf cfg.enable {
    services.tailscale.enable = true;

    # Enable IP forwarding for exit node functionality
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };

    networking.firewall = {
      checkReversePath = "loose"; # Required for Tailscale routing
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ 41641 ];
    };

    environment.systemPackages = [ pkgs.tailscale ];
  };
}
