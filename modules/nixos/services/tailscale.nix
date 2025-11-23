{
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf config.tailscale.enable {
  services.tailscale.enable = true;

  # --- CRITIQUE POUR EXIT NODE ---
  # Ces lignes permettent au minipc de rediriger le trafic internet
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ 41641 ];
  };

  environment.systemPackages = [ pkgs.tailscale ];
}
