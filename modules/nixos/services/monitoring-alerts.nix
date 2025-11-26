# modules/nixos/services/monitoring-alerts.nix
{ config, lib, ... }:
lib.mkIf (config.monitoring.enable && config.monitoring.isServer) {
  services.prometheus.rules = [
    (builtins.toJSON {
      groups = [
        {
          name = "homelab_critical";
          interval = "30s";
          rules = [
            {
              alert = "HostDown";
              expr = "up{job=\"node\"} == 0";
              for = "2m";
              labels.severity = "critical";
              annotations = {
                summary = "🔴 Host {{ $labels.instance }} is DOWN";
                description = "Target has been unreachable for 2 minutes";
              };
            }
            {
              alert = "DiskSpaceLow";
              expr = "(node_filesystem_avail_bytes{mountpoint=\"/\"} / node_filesystem_size_bytes{mountpoint=\"/\"}) * 100 < 10";
              for = "5m";
              labels.severity = "critical";
              annotations = {
                summary = "💾 Disk space critical on {{ $labels.instance }}";
                description = "Only {{ $value | humanize }}% free space remaining";
              };
            }
            {
              alert = "MemoryPressure";
              expr = "(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 90";
              for = "5m";
              labels.severity = "warning";
              annotations = {
                summary = "🧠 High memory usage on {{ $labels.instance }}";
                description = "Memory usage: {{ $value | humanize }}%";
              };
            }
            {
              alert = "HighCPULoad";
              expr = "100 - (avg by (instance) (rate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100) > 80";
              for = "10m";
              labels.severity = "warning";
              annotations = {
                summary = "⚡ High CPU load on {{ $labels.instance }}";
                description = "CPU usage: {{ $value | humanize }}%";
              };
            }
          ];
        }
      ];
    })
  ];
}
