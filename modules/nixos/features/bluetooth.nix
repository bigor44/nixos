# Feature: bluetooth
# Purpose: Bluetooth hardware support with auto power-on
{ lib, config, ... }:
with lib;
let
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
