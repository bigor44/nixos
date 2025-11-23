{
  config,
  lib,
  ...
}:
lib.mkIf config.dashboard.enable {
  services.homepage-dashboard = {
    enable = true;
    listenPort = 8082;
    allowedHosts = "localhost:8082,home.bigor.lan";

    # Global settings
    settings = {
      title = "Bigor Home";
      background = {
        # Use a nice Unsplash image or a local path
        image = "https://images.unsplash.com/photo-1477346611705-65d1883cee1e?auto=format&fit=crop&w=2000&q=80";
      };
      layout = {
        "My Services" = {
          style = "row";
          columns = 2;
        };
      };
    };

    # System Widgets (CPU, RAM, Disk)
    widgets = [
      {
        resources = {
          cpu = true;
          memory = true;
          disk = "/";
        };
      }
      {
        search = {
          provider = "duckduckgo";
          target = "_blank";
        };
      }
      {
        datetime = {
          format = {
            timeStyle = "short";
            hour12 = false;
          };
        };
      }
    ];

    # Your Apps
    services = [
      {
        "Infrastructure" = [
          {
            "Vaultwarden" = {
              icon = "bitwarden.png";
              href = "https://vault.bigor.lan";
              description = "Password Manager";
            };
          }
          {
            "Alertmanager" = {
              icon = "alertmanager.png";
              href = "https://alerts.bigor.lan";
              description = "Gestion des alertes";
              widget = {
                type = "customapi";
                url = "http://127.0.0.1:9093/api/v2/alerts";
                refreshInterval = 10000; # Rafraîchir toutes les 10s
                mappings = [
                  {
                    field = "";
                    label = "Alertes";
                    format = "size"; # Compte le nombre d'éléments dans la liste 'data'
                    state_map = [
                      {
                        value = 0;
                        color = "green";
                      }
                      {
                        operator = ">";
                        value = 0;
                        color = "red";
                      }
                    ];
                  }
                ];
              };
            };
          }
          {
            "AdGuard Home" = {
              icon = "adguard-home.png";
              href = "https://adguard.bigor.lan";
              description = "DNS & AdBlocker";
              widget = {
                type = "adguard";
                url = "http://127.0.0.1:3003";
              };
            };
          }
          {
            "Grafana" = {
              icon = "grafana.png";
              href = "https://grafana.bigor.lan";
              description = "Monitoring & Logs";
            };
          }
        ];
      }
    ];
  };
}
