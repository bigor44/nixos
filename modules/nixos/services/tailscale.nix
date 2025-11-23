{
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf config.tailscale.enable {
  # Activer le service
  services.tailscale.enable = true;

  # Optimisations réseau pour le rôle de "routeur" (accès au LAN)
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # Configuration du pare-feu indispensable pour Tailscale
  networking.firewall = {
    # "loose" est nécessaire pour que le trafic VPN puisse sortir correctement
    checkReversePath = "loose";
    # Interface de confiance
    trustedInterfaces = ["tailscale0"];
    # Port UDP optionnel mais recommandé pour les connexions directes (P2P)
    allowedUDPPorts = [41641];
  };

  environment.systemPackages = [pkgs.tailscale];
}
