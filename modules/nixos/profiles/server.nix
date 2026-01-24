# Profile: server
# Purpose: Headless machine with remote access
{ lib, config, ... }:
let
  enabled = builtins.elem "server" config.bigor.profiles;
in
{
  config = lib.mkIf enabled {
    bigor.features = {
      dev.tools.enable = true;
      dev.scripts.enable = true;

      hardware.cpu-power-management.enable = true;

      services.sshd = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
