# modules/nixos/services/monitoring/prometheus.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.monitoring;
in {
  services.prometheus = {
    enable = true;
    inherit (cfg.prometheus) port; # Access through Caddy reverse proxy

    globalConfig = {
      scrape_interval = cfg.prometheus.scrapeInterval;
      evaluation_interval = "15s";
      external_labels = {
        monitor = "nixos-homelab";
        hostname = config.networking.hostName;
      };
    };

    retentionTime = cfg.prometheus.retention;

    ruleFiles = [
      (pkgs.writeText "alert-rules.yml" ''
        groups:
        - name: system_alerts
          interval: 30s
          rules:
          - alert: HighCPUUsage
            expr: 100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
            for: 5m
            labels:
              severity: warning
            annotations:
              summary: "High CPU usage detected"
              description: "CPU usage is above 80% (current value: {{ $value }}%)"

          - alert: HighMemoryUsage
            expr: (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 85
            for: 5m
            labels:
              severity: warning
            annotations:
              summary: "High memory usage detected"
              description: "Memory usage is above 85% (current value: {{ $value }}%)"

          - alert: DiskSpaceWarning
            expr: (1 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"})) * 100 > 80
            for: 5m
            labels:
              severity: warning
            annotations:
              summary: "Low disk space"
              description: "Disk usage is above 80% (current value: {{ $value }}%)"

          - alert: DiskSpaceCritical
            expr: (1 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"})) * 100 > 90
            for: 2m
            labels:
              severity: critical
            annotations:
              summary: "Critical disk space"
              description: "Disk usage is above 90% (current value: {{ $value }}%)"

          - alert: ServiceDown
            expr: up == 0
            for: 2m
            labels:
              severity: critical
            annotations:
              summary: "Service is down"
              description: "{{ $labels.job }} service is down"

          - alert: HighLoadAverage
            expr: node_load1 > 2
            for: 5m
            labels:
              severity: warning
            annotations:
              summary: "High load average"
              description: "Load average is above 2 (current value: {{ $value }})"
      '')
    ];

    scrapeConfigs = [
      # Prometheus self-monitoring
      {
        job_name = "prometheus";
        static_configs = [
          {
            targets = ["localhost:${toString cfg.prometheus.port}"];
          }
        ];
      }

      # Node exporter - system metrics
      (lib.mkIf cfg.exporters.node {
        job_name = "node";
        static_configs = [
          {
            targets = ["localhost:9100"];
            labels = {
              hostname = config.networking.hostName;
              role =
                if config.roles.homelab_master
                then "server"
                else "desktop";
            };
          }
        ];
      })

      # Blackbox exporter - endpoint monitoring
      (lib.mkIf cfg.exporters.blackbox {
        job_name = "blackbox";
        metrics_path = "/probe";
        params = {
          module = ["http_2xx"];
        };
        static_configs = [
          {
            targets = [
              "http://localhost:${toString cfg.grafana.port}/api/health"
              "http://localhost:${toString cfg.prometheus.port}/-/healthy"
              "http://localhost:${toString config.services.adguardhome.port}/control/status"
            ];
          }
        ];
        relabel_configs = [
          {
            source_labels = ["__address__"];
            target_label = "__param_target";
          }
          {
            source_labels = ["__param_target"];
            target_label = "instance";
          }
          {
            target_label = "__address__";
            replacement = "localhost:9115";
          }
        ];
      })

      # cAdvisor - container metrics
      (lib.mkIf cfg.exporters.cadvisor {
        job_name = "cadvisor";
        static_configs = [
          {
            targets = ["localhost:8080"];
          }
        ];
      })

      # NFS monitoring
      (lib.mkIf config.nfs.server {
        job_name = "nfs";
        static_configs = [
          {
            targets = ["localhost:9100"];
            labels = {
              service = "nfs";
            };
          }
        ];
      })
    ];
  };
}
