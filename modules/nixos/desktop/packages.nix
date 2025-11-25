{
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.enable {
  programs = {
    firefox.enable = true;
    gamemode.enable = true;
    steam.enable = true;
  };
}
