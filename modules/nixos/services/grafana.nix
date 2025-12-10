{
  config,
  lib,
  ...
}:
lib.mkIf config.bigor.roles.homelab_master {
  services = {
    grafana = {
      enable = true;
      settings.server.http_port = 3000;

      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            url = "http://127.0.0.1:9090";
            isDefault = true;
          }
        ];
      };
    };

    caddy.virtualHosts."grafana.bigor.lan" = {
      extraConfig = ''
        reverse_proxy :3000
        tls internal
      '';
    };

    adguardhome.settings.filtering.rewrites = [
      {
        domain = "grafana.bigor.lan";
        answer = config.bigor.network.ips.minipc;
        enabled = true;
      }
    ];
  };
}
