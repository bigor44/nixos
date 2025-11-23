{
  config,
  lib,
  ...
}:
lib.mkIf config.dashboard.enable {
  services.homepage-dashboard = {
    enable = true;
    listenPort = 8082; # Standard Homepage port

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
  systemd.services.homepage-dashboard.serviceConfig = {
    # List every IP and Domain you use to access the dashboard
    Environment = [
      "HOMEPAGE_ALLOWED_HOSTS=home.bigor.lan"
    ];
  };
}
