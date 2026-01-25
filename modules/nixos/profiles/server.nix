# Profile: server
# Purpose: Headless machine with remote access
{
  pkgs,
  lib,
  config,
  ...
}:
let
  enabled = builtins.elem "server" config.bigor.profiles;
in
{
  config = lib.mkIf enabled {
    boot.kernelPackages = pkgs.linuxPackages;

    assertions = [
      {
        assertion = !(builtins.elem "desktop" config.bigor.profiles);
        message = "Profile 'server' and 'desktop' cannot be enabled simultaneously.";
      }
    ];

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
