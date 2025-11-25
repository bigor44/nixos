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
      # cosmic-greeter.enable = true;
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
    desktopManager = {
      # cosmic.enable = true;
      plasma6.enable = true;
    };
  };
}
