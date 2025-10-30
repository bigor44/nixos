{ lib, config, ... }:

lib.mkIf config.monitoring.enable {
  services.prometheus.exporters.node = {
    enable = true;
    openFirewall = true;
    enabledCollectors = [ "systemd" ];
  };
}
