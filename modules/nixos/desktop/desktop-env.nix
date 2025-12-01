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
    displayManager.cosmic-greeter.enable = true;
    desktopManager.cosmic.enable = true;
  };
}
