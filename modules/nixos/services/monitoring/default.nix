# modules/nixos/services/monitoring.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.monitoring;
in {
  imports = [
    ./prometheus.nix
    ./alertmanager.nix
    ./grafana.nix
    ./exporters.nix
    ./integrations.nix
    ./firewall.nix
  ];

  options.services.monitoring = {
    enable = lib.mkEnableOption "monitoring stack (Prometheus, Grafana, Alertmanager)";

    prometheus = {
      port = lib.mkOption {
        type = lib.types.port;
        default = 9090;
        description = "Port for Prometheus web interface";
      };

      retention = lib.mkOption {
        type = lib.types.str;
        default = "15d";
        description = "How long to retain metrics";
      };

      scrapeInterval = lib.mkOption {
        type = lib.types.str;
        default = "15s";
        description = "Default scrape interval";
      };

      alertmanager = {
        port = lib.mkOption {
          type = lib.types.port;
          default = 9093;
          description = "Port for Alertmanager web interface";
        };
      };
    };

    grafana = {
      port = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = "Port for Grafana web interface";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = "grafana.bigor.lan";
        description = "Domain name for Grafana";
      };
    };

    exporters = {
      node = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable node exporter for system metrics";
      };

      blackbox = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable blackbox exporter for endpoint monitoring";
      };

      cadvisor = lib.mkOption {
        type = lib.types.bool;
        default = config.roles.homelab_master or false;
        description = "Enable cAdvisor for container metrics";
      };
    };
  };

  config = lib.mkIf (config.roles.homelab_master && cfg.enable) {
    # This block is now mostly empty, as the configuration is handled by the imported modules.
    # We can still have some top-level configuration here if needed.
    environment.systemPackages = with pkgs; [];

    environment.etc."grafana-dashboards/nixos-system.json".source = ../../grafana-dashboards/nixos-system.json;
  };
}
