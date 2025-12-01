{
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.enable {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Enable dual mode to support both LE (Low Energy) and Classic Bluetooth devices.
        ControllerMode = "dual";
        # Enable experimental features for better compatibility (e.g. Battery info).
        Experimental = true;
        # Improves connection speed for some devices.
        FastConnectable = true;
        Enable = "Source,Sink,Media,Socket";
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
}
