# Feature: hardware-keyboardVIA
# Purpose: VIA keyboard configurator with udev rules for USB HID access
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bigor.features.hardware.keyboardVIA;
in
{
  options.bigor.features.hardware.keyboardVIA.enable = lib.mkEnableOption "VIA keyboard configurator";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.via ];

    # Udev rules for USB HID keyboard access
    services.udev.extraRules = ''
      # VIA/QMK keyboard access - generic hidraw rule
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    '';
  };
}
