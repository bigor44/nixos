{ ... }:

{
  networking.firewall.allowedTCPPorts = [9090 3000];
  services.grafana = {
    enable = true;
    settings.server = {
      domain = "minipc.lan";
      http_port = 3000;
      http_addr = "0.0.0.0";
    };
  };

  services.prometheus = {
    enable = true;
    port = 9090;
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
