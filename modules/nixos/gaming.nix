# Platform: gaming
# Purpose: Steam with Proton-GE, Wine/Lutris, Minecraft launchers, GameMode, gamescope, MangoHud, DualSense
{ pkgs, ... }:
let
  # Launcher wrapper: CurseForge publishes only a "latest" AppImage with no pinned
  # version, so it cannot be fetched at build time and is downloaded on each launch
  curseforge = pkgs.writeShellApplication {
    name = "curseforge";
    runtimeInputs = [
      pkgs.curl
      pkgs.appimage-run
    ];
    # `''$` escapes Nix interpolation so the shell sees ${XDG_CACHE_HOME:-…}.
    # The download goes to a .part file and replaces the cached copy only on success,
    # so an offline launch still runs the previous version
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
  # Menu entry for the wrapper; the AppImage's own icon is unavailable before the first download
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
    # Used per game through Steam launch options
    gamescope.enable = true;
    steam = {
      enable = true;
      # Forces the client language at launch; Steam rewrites its own settings file
      package = pkgs.steam.override { extraArgs = "-language french"; };
      # Shows up as a compatibility tool in each game's properties
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };
  environment.systemPackages = with pkgs; [
    prismlauncher
    lutris
    # WoW64 build runs both 32- and 64-bit Windows binaries from one Wine
    wineWow64Packages.staging
    winetricks
    protonup-qt
    curseforge
    curseforgeDesktop
    mangohud
    dualsensectl
  ];
  # GameMode's polkit rules only allow this group to change the CPU governor
  users.users.bigor.extraGroups = [ "gamemode" ];
}
