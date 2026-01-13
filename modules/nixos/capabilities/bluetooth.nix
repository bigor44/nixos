{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.capabilities.bluetooth;
in
{
  options.bigor.capabilities.bluetooth = {
    enable = mkEnableOption "enable bluetooth";
  };

  config = mkIf cfg.enable {

    # Bluetooth configuration
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
