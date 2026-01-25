# Profile: desktop
# Purpose: Interactive graphical machine
{
  pkgs,
  lib,
  config,
  ...
}:
let
  enabled = builtins.elem "desktop" config.bigor.profiles;
in
{
  config = lib.mkIf enabled {
    boot.kernelPackages = pkgs.linuxPackages_latest;

    assertions = [
      {
        assertion = !(builtins.elem "server" config.bigor.profiles);
        message = "Profile 'desktop' and 'server' cannot be enabled simultaneously.";
      }
    ];

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
