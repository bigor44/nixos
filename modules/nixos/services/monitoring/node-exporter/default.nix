# ============================================================================
# File: /home/bigor/nixos/modules/nixos/services/monitoring/node-exporter/default.nix
# Description: Configures the Node Exporter service.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.services.monitoring.node-exporter;
in
{
  options.bigor.services.monitoring.node-exporter = {
    enable = mkEnableOption "Enable Node Exporter";
  };

  config = mkIf cfg.enable {
    services.prometheus.exporters.node = {
      enable = true;
      port = 9100;
      enabledCollectors = [ "systemd" ];
    };

    bigor.lib.exposedService.node-exporter = {
      port = 9100;
      openFirewall = true;
    };
  };
}
