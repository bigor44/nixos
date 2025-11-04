/*
  Title: Desktop Environment Configuration
  Description: Enables the Cosmic desktop environment and greeter.
*/
{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.desktop.enable {
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;
}
