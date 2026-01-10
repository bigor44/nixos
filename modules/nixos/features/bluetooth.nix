# Feature: bluetooth
# Purpose: Bluetooth hardware support with auto power-on
{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.features.bluetooth;
in
{
  options.bigor.features.bluetooth.enable = mkEnableOption "Bluetooth support";

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
