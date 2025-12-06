{
  config,
  lib,
  ...
}:
lib.mkIf config.roles.homelab_master {
  services.homepage-dashboard = {
    enable = true;
    listenPort = 8082;
    allowedHosts = "localhost:8082,home.bigor.lan";

    # Global UI Settings
    settings = {
      title = "Bigor Home";
      background = {
        image = "https://images.unsplash.com/photo-1477346611705-65d1883cee1e?auto=format&fit=crop&w=2000&q=80";
      };
      layout = {
        "My Services" = {
          style = "row";
          columns = 2;
        };
      };
    };

    # System Resource Widgets (CPU, RAM, Disk)
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

    # Service Links & API Integrations
    services = [
      {
        "Infrastructure" = [
          {
            "AdGuard Home" = {
              icon = "adguard-home.png";
              href = "https://adguard.bigor.lan";
              description = "DNS & AdBlocker";
              # API Integration for live stats on the dashboard
              widget = {
                type = "adguard";
                url = "http://127.0.0.1:3003";
              };
            };
          }
          {
            "Glances" = {
              icon = "glances.png";
              href = "https://glances.bigor.lan";
              description = "System Monitoring";
            };
          }
        ];
      }
    ];
  };
}
