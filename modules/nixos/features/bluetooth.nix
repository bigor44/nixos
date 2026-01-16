# Feature: bluetooth
# Purpose: Bluetooth hardware support
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.features.bluetooth;
in
{
  options.bigor.features.bluetooth = {
    enable = mkEnableOption "enable bluetooth";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
