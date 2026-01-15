# Feature: flatpak
# Purpose: Flatpak support with Flathub repository
{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.bigor.features.flatpak;
in
{
  options.bigor.features.flatpak.enable = mkEnableOption "Flatpak with Flathub repository";

  config = mkIf cfg.enable {
    services.flatpak.enable = true;

    # Add Flathub repository via systemd service (after network is online)
    systemd.services.flatpak-add-flathub = {
      description = "Add Flathub repository to Flatpak";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${getExe config.services.flatpak.package} remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo";
      };
    };
  };
}
