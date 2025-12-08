# modules/nixos/services/monitoring/firewall.nix
{
  config,
  lib,
  ...
}: let
  cfg = config.services.monitoring;
in {
  networking.firewall = lib.mkIf cfg.enable {
    allowedTCPPorts = [
      cfg.prometheus.port
      cfg.grafana.port
      cfg.prometheus.alertmanager.port
    ];
    allowedTCPPortRanges = [
      {
        from = 9100;
        to = 9120;
      } # Exporter ports
    ];
    interfaces."tailscale0".allowedTCPPorts = [
      cfg.prometheus.port
      cfg.grafana.port
      cfg.prometheus.alertmanager.port
    ];
  };
}
