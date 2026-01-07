# Feature: flatpak
# Purpose: Flatpak support with Flathub repository
{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.bigor.features.flatpak;
in
{
  options.bigor.features.flatpak.enable = mkEnableOption "Flatpak with Flathub repository";

  config = mkIf cfg.enable {
    services.flatpak.enable = true;

    # Add Flathub repository on system activation
    system.activationScripts.flatpak-repo = ''
      ${lib.getExe config.services.flatpak.package} remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
