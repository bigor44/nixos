{
  config,
  lib,
  ...
}:
lib.mkIf config.dashboard.enable {
  services.homepage-dashboard = {
    enable = true;
    listenPort = 8082; # Standard Homepage port
    openFirewall = true; # Opens port 8082

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
            "AdGuard Home (minipc)" = {
              icon = "adguard-home.png";
              href = "http://minipc.bigor.lan:3003";
              description = "DNS & AdBlocker";
              widget = {
                type = "adguard";
                url = "http://127.0.0.1:3003";
              };
            };
          }
          {
            "AdGuard Home (grospc)" = {
              icon = "adguard-home.png";
              href = "http://grospc.bigor.lan:3003";
              description = "DNS & AdBlocker";
              widget = {
                type = "adguard";
                url = "http://grospc.bigor.lan:3003";
              };
            };
          }
          {
            "Grafana" = {
              icon = "grafana.png";
              href = "http://minipc.bigor.lan:3000";
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
      "HOMEPAGE_ALLOWED_HOSTS=192.168.1.10,192.168.1.10:8082,minipc.bigor.lan,minipc.bigor.lan:8082,minipc,minipc:8082,localhost,127.0.0.1,minipc.bigor.lan:8082"
    ];
  };
}
