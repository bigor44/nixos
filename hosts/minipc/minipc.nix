{
  networking.hostName = "minipc";
  desktop.enable = false;
  server.enable = true;
  adblocker.enable = true;
  llm.enable = true;

  # Kubernetes configuration for minipc (server)
  kubernetes = {
    enable = true;
    role = "control-plane"; # Or "single-node" if you want standalone
    clusterName = "homelab-cluster";
    apiServerAddress = "192.168.1.10";
    enableMetricsServer = true;
    enableDashboard = true;
    cni = "flannel";
  };
}
