# Feature: hardware-bluetooth
# Purpose: Bluetooth hardware support
{
  config,
  lib,
  ...
}:
let
  cfg = config.bigor.features.hardware.bluetooth;
in
{
  options.bigor.features.hardware.bluetooth = {
    enable = lib.mkEnableOption "enable bluetooth";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
