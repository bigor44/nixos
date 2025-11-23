{
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.enable {
  #Network Manager
  networking.networkmanager.enable = true;
  # Desktop environment
  services = {
    displayManager.cosmic-greeter.enable = true;
    desktopManager.cosmic.enable = true;
  };
}
