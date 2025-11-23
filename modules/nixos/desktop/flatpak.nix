{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.enable {
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo";
      Restart = "on-failure";
      RestartSec = 10;
    };
  };
}
