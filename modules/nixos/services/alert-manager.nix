{
  config,
  lib,
  ...
}: {
  # ============================================================================
  # Prometheus Alertmanager
  # ============================================================================
  # Handles alerts sent by client applications such as the Prometheus server.
  # Exposed internally via Caddy at 'alertmanager.bigor.lan'.
  # ============================================================================
  config = lib.mkIf config.bigor.roles.homelab_master {
    services = {
      prometheus.alertmanager = {
        enable = true;
        port = 9093;
        configuration = {
          route = {
            receiver = "default-receiver";
          };
          receivers = [
            {
              name = "default-receiver";
            }
          ];
        };
      };

      caddy.virtualHosts."alertmanager.bigor.lan" = {
        extraConfig = ''
          reverse_proxy :9093
          tls internal
        '';
      };

      adguardhome.settings.filtering.rewrites = [
        {
          domain = "alertmanager.bigor.lan";
          answer = config.bigor.network.ips.minipc;
          enabled = true;
        }
      ];
    };
  };
}
