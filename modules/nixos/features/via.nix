# Module: features.via
# Purpose: VIA keyboard configurator with udev rules for USB HID access
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.bigor.features.via;
in
{
  options.bigor.features.via.enable = mkEnableOption "VIA keyboard configurator";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.via ];

    # Udev rules for USB HID keyboard access
    services.udev.extraRules = ''
      # VIA/QMK keyboard access - generic hidraw rule
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    '';
  };
}
