# Module: features.keyboardVIA
# Purpose: VIA keyboard configurator with udev rules for USB HID access
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.capabilities.keyboardVIA;
in
{
  options.bigor.capabilities.keyboardVIA.enable = mkEnableOption "VIA keyboard configurator";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.via ];

    # Udev rules for USB HID keyboard access
    services.udev.extraRules = ''
      # VIA/QMK keyboard access - generic hidraw rule
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    '';
  };
}
