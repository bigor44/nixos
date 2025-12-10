{
  config,
  lib,
  ...
}:
lib.mkIf config.bigor.roles.desktop {
  programs = {
    gamemode.enable = true;
    steam.enable = true;
  };
}
