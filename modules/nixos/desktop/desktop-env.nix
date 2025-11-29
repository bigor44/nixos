{
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.enable {
  # Boot
  boot = {
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
    ];
  };

  # Network Manager
  networking.networkmanager.enable = true;

  # Desktop environment
  services = {
    displayManager = {
      sddm.enable = true;
    };
    desktopManager = {
      plasma6.enable = true;
    };
  };
}
