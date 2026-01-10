# Module: caddy
# Purpose: Reverse proxy with automatic HTTPS
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.services.caddy;
  inherit (config.bigor.network) mainInterface;
in
{
  options.bigor.services.caddy.enable = mkEnableOption "Caddy reverse proxy";

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
    };

    # Open Caddy ports
    networking.firewall.interfaces.${mainInterface} = {
      allowedTCPPorts = [
        80
        443
      ];
    };
  };
}
