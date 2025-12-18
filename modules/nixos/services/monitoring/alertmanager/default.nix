{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.services.monitoring.alertmanager;
in
{
  # ============================================================================
  # File: modules/nixos/services/monitoring/alertmanager/default.nix
  # Description: Alertmanager Service
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Deploys Alertmanager for handling Prometheus alerts.
  # ============================================================================

  options.bigor.services.monitoring.alertmanager = {
    enable = mkEnableOption "Enable Alertmanager service";
  };

  config = mkIf cfg.enable {
    services = {
      prometheus.alertmanager = {
        enable = true;
        port = 9093;
        configuration = {
          global = {
            resolve_timeout = "5m";
          };
          route = {
            group_by = [ "alertname" ];
            group_wait = "30s";
            group_interval = "5m";
            repeat_interval = "3h";
            receiver = "default-receiver";
          };
          receivers = [
            {
              name = "default-receiver";
            }
          ];
        };
      };
    };

    bigor.lib.exposedService.alertmanager = {
      port = 9093;
      domain = "alertmanager.bigor.lan";
    };
  };
}
