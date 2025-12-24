# Module: alertmanager
# Purpose: Alert routing and notification management
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
  options.bigor.services.monitoring.alertmanager.enable = mkEnableOption "Alertmanager";

  config = mkIf cfg.enable {
    services.prometheus.alertmanager = {
      enable = true;
      port = 9093;
      configuration = {
        global.resolve_timeout = "5m";
        route = {
          group_by = [ "alertname" ];
          group_wait = "30s";
          group_interval = "5m";
          repeat_interval = "3h";
          receiver = "default-receiver";
        };
        receivers = [ { name = "default-receiver"; } ];
      };
    };
  };
}
