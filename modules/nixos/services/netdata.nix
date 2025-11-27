{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.monitoring;
in
{
  config = lib.mkIf cfg.enable {
    services.netdata = {
      enable = true;
      package = pkgs.netdata.override {
        withCloudUi = true;
      };
      config = {
        web = {
          "bind to" = "127.0.0.1";
        };
      };
    };
  };
}
