{
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.enable {
  programs = {
    firefox.enable = true;
    gamemode.enable = true; # Optimizes system performance when running games
    steam.enable = true;
  };
}
