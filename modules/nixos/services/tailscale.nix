{
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf config.roles.homelab_master {
  services.tailscale.enable = true;

  # ----------------------------------------------------------------------------
  # Exit Node & Routing Configuration
  # ----------------------------------------------------------------------------
  # Enable IP forwarding to allow this machine to route traffic for other devices
  # (Exit Node functionality).
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking.firewall = {
    # "loose" allows reverse path filtering to pass Tailscale traffic
    checkReversePath = "loose";
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [41641]; # Tailscale randomized port
  };

  environment.systemPackages = [pkgs.tailscale];
}
