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
  # ============================================================================
  # File: modules/nixos/services/monitoring/node-exporter/default.nix
  # Description: Node Exporter Service
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Deploys Node Exporter to expose system metrics.
  # ============================================================================

  options.bigor.services.monitoring.node-exporter = {
    enable = mkEnableOption "Enable Node Exporter";
  };

  config = mkIf cfg.enable {
    services.prometheus.exporters.node = {
      enable = true;
      port = 9100;
      enabledCollectors = [ "systemd" ];
    };

    networking.firewall.interfaces.${config.bigor.network.mainInterface} = {
      allowedTCPPorts = [ 9100 ];
    };
  };
}
