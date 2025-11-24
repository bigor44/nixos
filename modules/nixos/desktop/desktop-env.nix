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
    displayManager = {
      ly.enable = true;
      cosmic-greeter.enable = false;
      gdm.enable = false;
    };
    desktopManager = {
      cosmic.enable = true;
      gnome.enable = true;
    };
  };
}
