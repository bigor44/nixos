{
  config,
  lib,
  ...
}:
lib.mkIf config.roles.homelab_master {
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
        answer = config.myNetwork.ips.minipc;
        enabled = true;
      }
    ];
  };
}
