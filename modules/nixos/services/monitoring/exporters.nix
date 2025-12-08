# modules/nixos/services/monitoring/exporters.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.monitoring;
in {
  services = lib.mkIf cfg.enable {
    # Node Exporter - System metrics
    prometheus.exporters.node = lib.mkIf cfg.exporters.node {
      enable = true;
      port = 9100;
      enabledCollectors = [
        "system"
        "cpu"
        "cpufreq"
        "meminfo"
        "diskstats"
        "filesystem"
        "loadavg"
        "netdev"
        "netstat"
        "stat"
        "time"
        "vmstat"
        "systemd"
      ];
      openFirewall = false; # Only accessible locally
    };

    # Blackbox Exporter - Endpoint monitoring
    prometheus.exporters.blackbox = lib.mkIf cfg.exporters.blackbox {
      enable = true;
      port = 9115;
      configFile = pkgs.writeText "blackbox-config.yml" ''
        modules:
          http_2xx:
            prober: http
            timeout: 5s
            http:
              valid_status_codes: [200, 201, 202, 203, 204, 301, 302]
              follow_redirects: true
              preferred_ip_protocol: "ip4"

          tcp_connect:
            prober: tcp
            timeout: 5s
      '';
      openFirewall = false;
    };

    # cAdvisor - Container metrics
    cadvisor = lib.mkIf cfg.exporters.cadvisor {
      enable = true;
      port = 8080;
      extraOptions = [
        "--housekeeping_interval=30s"
        "--docker_only=false"
        "--disable_metrics=percpu,sched,tcp,udp"
      ];
    };
  };
}
