# Profile: homelab
# Purpose: Self-hosted infrastructure services
{ lib, config, ... }:
let
  enabled = builtins.elem "homelab-master" config.bigor.profiles;
in
{
  config = lib.mkIf enabled {
    bigor.platform.dns.server.enable = true;

    bigor.features.services = {
      nfs-server.enable = true;
      caddy.enable = true;
      gatus.enable = true;
    };
  };
}
