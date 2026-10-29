# Platform: desktop
# Purpose: COSMIC desktop, graphics, NetworkManager, PipeWire, Bluetooth, desktop apps and gaming (Steam, Lutris, CurseForge, Proton-GE, GameMode, gamescope, MangoHud, LACT, DualSense)
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
  services = {
    displayManager.cosmic-greeter.enable = true;
    desktopManager.cosmic.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      # 32-bit games under Steam/Proton
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # GPU fan curves, power limit and undervolt (LACT GUI)
    lact.enable = true;
  };

  networking = {
    networkmanager = {
      enable = true;
      # insertNameservers only re-applies on link up, so DHCPv6/RA updates dropped Pi-hole from resolv.conf
      dns = "none";
    };
    # Pi-hole first, router as fallback; IPv4 only since Pi-hole's IPv6 addresses are SLAAC-dynamic
    nameservers = [
      "192.168.1.10"
      "192.168.1.1"
    ];
    # glibc waits 5 s per query before falling back; Pi-hole answers in ms when it is up
    resolvconf.extraOptions = [ "timeout:1" ];
  };

  programs = {
    firefox = {
      enable = true;
      # The French UI ships as a language pack, not in the base build
      languagePacks = [ "fr" ];
      preferences."intl.locale.requested" = "fr";
    };
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
    brave
    discord
    whatsapp-electron
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

  hardware = {
    graphics = {
      enable = true;
      # 32-bit Vulkan/GL drivers for Steam and Proton
      enable32Bit = true;
    };

    # Unlocks the voltage/clock tables the driver hides by default, needed for LACT's undervolt
    amdgpu.overdrive.enable = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # Lets PipeWire acquire realtime scheduling without running as root (avoids audio crackling under load)
  security.rtkit.enable = true;

  # GameMode's polkit rule only lets this group switch the CPU governor and split-lock mitigation
  users.users.bigor.extraGroups = [ "gamemode" ];
}
