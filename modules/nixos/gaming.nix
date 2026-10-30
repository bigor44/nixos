{ pkgs, ... }:
let
  curseforge = pkgs.writeShellApplication {
    name = "curseforge";
    runtimeInputs = [
      pkgs.curl
      pkgs.appimage-run
    ];
    text = ''
      dir="''${XDG_CACHE_HOME:-$HOME/.cache}/curseforge"
      app="$dir/curseforge.AppImage"
      mkdir -p "$dir"
      if curl -4 -fL https://curseforge.overwolf.com/downloads/curseforge-latest-linux.AppImage -o "$app.part"; then
        mv "$app.part" "$app"
      fi
      DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 \
        DOTNET_SYSTEM_GLOBALIZATION_PREDEFINED_CULTURES_ONLY=false \
        exec appimage-run "$app" "$@"
    '';
  };
  curseforgeDesktop = pkgs.makeDesktopItem {
    name = "curseforge";
    desktopName = "CurseForge";
    exec = "${curseforge}/bin/curseforge";
    icon = pkgs.fetchurl {
      url = "https://gist.githubusercontent.com/thecodewarrior/110057b210551c4ecf2c9be6d58ff824/raw/38748511ca1eb5677f009092fb3fcd71cc76cdf0/logo.svg";
      hash = "sha256-cC28JBXZ/4HzlQc6wukMoaE0Tp9H6EDxV2mAs7DeRgA=";
    };
    categories = [ "Game" ];
  };
in
{
  programs = {
    gamemode.enable = true;
    gamescope.enable = true;
    steam = {
      enable = true;
      package = pkgs.steam.override { extraArgs = "-language french"; };
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };
  environment.systemPackages = with pkgs; [
    prismlauncher
    lutris
    wineWow64Packages.staging
    winetricks
    protonup-qt
    curseforge
    curseforgeDesktop
    mangohud
    dualsensectl
  ];
  users.users.bigor.extraGroups = [ "gamemode" ];
}
