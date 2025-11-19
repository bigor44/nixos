{
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.enable {
  #Network Manager
  networking.networkmanager = {
    enable = true;
    insertNameservers = ["::1" "127.0.0.1"];
  };
  # Desktop environment
  services = {
    displayManager.cosmic-greeter.enable = true;
    desktopManager.cosmic.enable = true;
  };
}
