# Feature: desktop.tuning
# Purpose: Quiet boot with Plymouth splash screen
{ lib, config, ... }:
with lib;
let
  cfg = config.bigor.features.desktop.tuning;
in
{
  options.bigor.features.desktop.tuning.enable = mkEnableOption "Desktop tuning";

  config = mkIf cfg.enable {
    boot = {
      kernelParams = [
        "quiet"
        "splash"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
        "boot.shell_on_fail"
      ];
      plymouth = {
        enable = true;
        theme = "spinner";
      };
      consoleLogLevel = 0;
      initrd.verbose = false;
    };
  };
}
