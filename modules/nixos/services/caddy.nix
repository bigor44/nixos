{
  config,
  lib,
  ...
}:
lib.mkIf config.reverse_proxy.enable {
  services.caddy = {
    enable = true;

    virtualHosts = {
      # Dashboard (Homepage) - Port 8082
      "home.bigor.lan" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8082
          tls internal
        '';
      };

      "vault.bigor.lan" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8222
          tls internal
        '';
      };

      # AdGuard Home - Port 3003
      "adguard.bigor.lan" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:3003
          tls internal
        '';
      };

      # Alertmanager - Port 9093
      "alerts.bigor.lan" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:9093
          tls internal
        '';
      };

      # Grafana - Port 3000
      "grafana.bigor.lan" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:3000
          tls internal
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
