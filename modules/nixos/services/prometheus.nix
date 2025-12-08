{
  config,
  lib,
  ...
}:
lib.mkIf config.roles.homelab_master {
  services = {
    prometheus = {
      enable = true;
      port = 9090;

      scrapeConfigs = [
        {
          job_name = "minipc";
          static_configs = [
            {
              targets = ["127.0.0.1:9100"];
            }
          ];
        }
        {
          job_name = "grospc";
          static_configs = [
            {
              targets = ["${config.myNetwork.ips.grospc}:9100"];
            }
          ];
        }
      ];
    };

    caddy.virtualHosts."prometheus.bigor.lan" = {
      extraConfig = ''
        reverse_proxy :9090
        tls internal
      '';
    };

    adguardhome.settings.filtering.rewrites = [
      {
        domain = "prometheus.bigor.lan";
        answer = config.myNetwork.ips.minipc;
        enabled = true;
      }
    ];
  };
}
