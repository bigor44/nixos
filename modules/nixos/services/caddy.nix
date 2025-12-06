{
  config,
  lib,
  ...
}:
lib.mkIf config.roles.homelab_master {
  services.caddy = {
    enable = true;

    # Virtual Hosts Configuration
    virtualHosts = {
      # Dashboard (Homepage)
      "home.bigor.lan" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8082
          tls internal # Use Caddy's internal CA for local HTTPS
        '';
      };

      # AdGuard Home (DNS Admin)
      "adguard.bigor.lan" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:3003
          tls internal
        '';
      };

      # Glances (System Monitoring)
      "glances.bigor.lan" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:61208
          tls internal
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
