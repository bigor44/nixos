{ ... }:

{
  services.grafana.enable = true;
  services.prometheus.exporters.node.enable = true;

  services.prometheus = {
    enable = true;
    scrapeConfigs = [
      {
        job_name = "grospc";
        static_configs = [
          {targets = ["192.168.1.1:9100"];}
        ];
      }
      {
        job_name = "interbus";
        static_configs = [
          {targets = ["127.0.0.1:9100"];}
        ];
      }
    ];
  };
}
