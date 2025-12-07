{ config, lib, ... }:
lib.mkIf config.roles.desktop {
  programs = {
    gamemode.enable = true;
    steam.enable = true;
  };
}
