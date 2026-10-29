# Platform: gaming
# Purpose: Steam, Proton-GE, Lutris/Wine, Minecraft launchers, GameMode, gamescope, MangoHud, LACT, DualSense
{ pkgs, ... }:
let
  # CurseForge only ships a self-updating AppImage with no stable versioned URL, so fetch the latest at launch
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
      # Keep the previous copy when offline or the download fails
      if curl -4 -fL https://curseforge.overwolf.com/downloads/curseforge-latest-linux.AppImage -o "$app.part"; then
        mv "$app.part" "$app"
      fi
      # The bundled .NET runtime crashes without ICU otherwise
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
    # Per-game launch option: `gamescope -f -- %command%`
    gamescope.enable = true;
    steam = {
      enable = true;
      # Client language otherwise lives in ~/.steam/registry.vdf, which Steam rewrites
      package = pkgs.steam.override { extraArgs = "-language french"; };
      # Selectable per game under Properties > Compatibility
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };

  environment.systemPackages = with pkgs; [
    prismlauncher
    # Non-Steam launchers (Battle.net…); system Wine for the "System" runner and winetricks for prefix fixes
    lutris
    wineWow64Packages.staging
    winetricks
    protonup-qt
    curseforge
    curseforgeDesktop
    # FPS/frametime overlay, per-game launch option: `mangohud %command%`
    mangohud
    # DualSense battery, lightbar, mic LED and Bluetooth power-off; hidraw access comes from Steam's udev rules
    dualsensectl
  ];

  # GPU fan curves, power limit and undervolt (LACT GUI)
  services.lact.enable = true;

  # Unlocks the voltage/clock tables the driver hides by default, needed for LACT's undervolt
  hardware.amdgpu.overdrive.enable = true;

  # GameMode's polkit rule only lets this group switch the CPU governor and split-lock mitigation
  users.users.bigor.extraGroups = [ "gamemode" ];
}
