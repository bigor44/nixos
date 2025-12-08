# modules/nixos/services/monitoring/alertmanager.nix
{
  config,
  lib,
  ...
}: let
  cfg = config.services.monitoring;
in {
  services.prometheus.alertmanager = lib.mkIf cfg.enable {
    enable = true;
    inherit (cfg.prometheus.alertmanager) port;
    openFirewall = false;

    configuration = {
      global = {
        smtp_smarthost = "localhost:25";
        smtp_from = "alertmanager@bigor.lan";
      };

      route = {
        group_by = ["alertname"];
        group_wait = "10s";
        group_interval = "10s";
        repeat_interval = "1h";
        receiver = "default";
      };

      receivers = [
        {
          name = "default";
          webhook_configs = [
            {
              url = "http://localhost:8082/api/webhook/alertmanager"; # Homepage dashboard webhook
              send_resolved = true;
            }
          ];
        }
      ];

      inhibit_rules = [
        {
          source_match = {
            severity = "critical";
          };
          target_match = {
            severity = "warning";
          };
          equal = ["alertname"];
        }
      ];
    };
  };
}
