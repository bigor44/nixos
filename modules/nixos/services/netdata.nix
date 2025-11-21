{
  config,
  lib,
  ...
}:
lib.mkIf config.monitoring.enable {
  services.netdata = {
    enable = true;
    # Configuration optionnelle pour optimiser sur le minipc
    config = {
      global = {
        "memory mode" = "ram"; # Garde l'historique en RAM pour épargner le disque
        "history" = 3600; # 1 heure d'historique (ajustable)
      };
      web = {
        "bind to" = "0.0.0.0"; # Autorise l'accès depuis le réseau local
      };
    };
  };

  # Ouverture du port dans le pare-feu
  networking.firewall.allowedTCPPorts = [19999];
}
