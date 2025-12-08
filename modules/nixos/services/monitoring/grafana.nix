# modules/nixos/services/monitoring/grafana.nix
{config, ...}: let
  cfg = config.services.monitoring;
in {
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_port = cfg.grafana.port;
        inherit (cfg.grafana) domain;
      };

      security = {
        admin_password = "$2a$12$R9h/rHRQoWQy3dLWn4pTou1Rx0O4tUwBSR7H1e4nP8rLcNuUoTq."; # "admin" bcrypt
        disable_gravatar = true;
      };

      users = {
        allow_sign_up = false;
        allow_org_create = false;
        auto_assign_org = true;
        auto_assign_org_role = "Viewer";
      };

      auth.anonymous = true;
    };

    provision = {
      enable = true;
      datasources.settings = {
        datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            url = "http://localhost:${toString cfg.prometheus.port}";
            access = "proxy";
            isDefault = true;
          }
        ];
      };

      dashboards.settings.providers = [
        {
          name = "nixos";
          type = "file";
          options = {
            path = "/etc/grafana-dashboards";
          };
        }
      ];
    };
  };
}
