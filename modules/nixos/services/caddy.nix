{
  config,
  lib,
  ...
}:
lib.mkIf config.reverse_proxy.enable {
  services.caddy = {
    enable = true;

    # Virtual Hosts Configuration
    # Maps domain names to internal service ports.
    virtualHosts = {
      # Dashboard (Homepage)
      "home.bigor.lan" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8082
          tls internal # Use Caddy's internal CA for local HTTPS
        '';
      };

      # Vaultwarden (Password Manager)
      "vault.bigor.lan" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8222
          tls internal
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

  # Open HTTP/HTTPS ports
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
