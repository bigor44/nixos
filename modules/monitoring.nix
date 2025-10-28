{ lib, config, ... }:

lib.mkIf config.monitoring.enable {
  networking.firewall.allowedTCPPorts = [9100];
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
  };
}
