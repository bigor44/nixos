{ config
, lib
, pkgs
, ...
}:
lib.mkIf config.desktop.enable {
  services.preload.enable = true;
  programs.firefox.enable = true;
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    discord
    brave
    onedrive
    whatsapp-electron
  ];
}
