/*
  Title: Bluetooth Configuration
  Description: Enables and configures Bluetooth services.
*/
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
        ControllerMode = "bredr";
        Experimental = true;
        FastConnectable = true;
        Enable = "Source,Sink,Media,Socket";
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
}
