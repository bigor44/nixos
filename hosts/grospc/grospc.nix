{
  services.ollama.rocmOverrideGfx = "11.0.0";
  networking.hostName = "grospc";
  desktop.enable = true;
  server.enable = false;
  adblocker.enable = true;
  llm.enable = true;

  # Kubernetes configuration for grospc (desktop workstation)
  kubernetes = {
    enable = true;
    role = "single-node"; # Run as a single-node cluster for development
    clusterName = "grospc-dev";
    apiServerAddress = "192.168.1.1";
    enableMetricsServer = true;
    enableDashboard = true; # Enable dashboard for desktop use
    cni = "flannel";
  };
}
