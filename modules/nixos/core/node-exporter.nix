{
  # ============================================================================
  # Node Exporter
  # ============================================================================
  # Exports system metrics (CPU, RAM, Disk, etc.) for Prometheus to scrape.
  # Exposed on port 9100.
  # ============================================================================
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = ["systemd"];
    port = 9100;
  };

  networking.firewall.allowedTCPPorts = [9100];
}
