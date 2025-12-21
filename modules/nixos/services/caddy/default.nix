# Module: caddy
# Purpose: Reverse proxy with automatic HTTPS
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.services.caddy;
in
{
  options.bigor.services.caddy.enable = mkEnableOption "Caddy reverse proxy";

  config = mkIf cfg.enable {
    services.caddy.enable = true;
    # Exposure configured in modules/nixos/lib/network-topology (SSOT)
  };
}
