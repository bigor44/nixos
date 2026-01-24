# Profile: desktop
# Purpose: Interactive graphical machine
{ lib, config, ... }:
let
  enabled = builtins.elem "desktop" config.bigor.profiles;
in
{
  config = lib.mkIf enabled {
    bigor.features = {
      graphics = {
        desktop.enable = true;
        flatpak.enable = true;
      };
      hardware = {
        audio.enable = true;
        bluetooth.enable = true;
      };
    };
  };
}
