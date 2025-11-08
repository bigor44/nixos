/*
Title: Homepage Dashboard Configuration
Description: Configures the homepage-dashboard service with dynamic links to other enabled services.
*/
{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.dashboard;
in
  mkIf cfg.enable {
    services.homepage-dashboard = {
      enable = true;
      allowedHosts = "localhost:8082,127.0.0.1:8082,minipc.lan:8082,192.168.1.10:8082";
      openFirewall = true;
      settings = {
        title = "HomeLab Dashboard";
        services = let
          serviceDefinitions = [
            {
              group = "Network";
              enable = config.adblocker.enable;
              services = [
                {
                  name = "AdGuard Home";
                  icon = "adguard-home.png";
                  href = "http://${config.networking.hostName}:${toString config.services.adguardhome.port}";
                  description = "Network-wide ad blocking";
                }
              ];
            }
            {
              group = "Monitoring";
              enable = config.server.enable;
              services = [
                {
                  name = "Grafana";
                  icon = "grafana.png";
                  href = "http://${config.networking.hostName}:${toString config.services.grafana.settings.server.http_port}";
                  description = "Monitoring Dashboards";
                }
              ];
            }
            {
              group = "AI";
              enable = config.llm.enable;
              services = [
                {
                  name = "Open WebUI";
                  icon = "ollama.png";
                  href = "http://${config.networking.hostName}:${toString config.services.open-webui.port}";
                  description = "Web UI for Ollama";
                }
              ];
            }
          ];
        in
          builtins.map (def: {
            ${def.group} = builtins.map (service: {
              ${service.name} = {
                icon = service.icon;
                href = service.href;
                description = service.description;
              };
            }) def.services;
          }) (builtins.filter (def: def.enable) serviceDefinitions);
      };
    };
  }
