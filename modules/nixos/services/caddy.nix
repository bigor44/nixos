{
  config,
  lib,
  ...
}:
lib.mkIf config.roles.homelab_master {
  services.caddy = {
    enable = true;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
