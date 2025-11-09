/*
  Title: Homepage Dashboard Configuration
  Description: Configures the homepage-dashboard service with dynamic links to other enabled services.
*/
{ config, lib, ... }:
with lib;
let
  cfg = config.dashboard;
in
mkIf cfg.enable {
  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    settings = {
      title = "HomeLab Dashboard";
      services = (
        optional config.adblocker.enable {
          "Network" = [
            { "AdGuard Home" = {
                icon = "adguard-home.png";
                href = "http://${config.networking.hostName}:${toString config.services.adguardhome.port}";
                description = "Network-wide ad blocking";
              };
            }
          ];
        }
      ) ++ (
        optional config.server.enable {
          "Monitoring" = [
            { "Grafana" = {
                icon = "grafana.png";
                href = "http://${config.networking.hostName}:${toString config.services.grafana.settings.server.http_port}";
                description = "Monitoring Dashboards";
              };
            }
          ];
        }
      ) ++ (
        optional config.llm.enable {
          "AI" = [
            { "Open WebUI" = {
                icon = "ollama.png";
                href = "http://${config.networking.hostName}:${toString config.services.open-webui.port}";
                description = "Web UI for Ollama";
              };
            }
          ];
        }
      );
    };
  };
}
