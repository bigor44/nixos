# Platform: desktop
# Purpose: COSMIC desktop, graphics, NetworkManager, PipeWire, Bluetooth, desktop apps and gaming (Steam, Proton-GE, GameMode, gamescope, MangoHud, LACT)
{ pkgs, ... }:
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

  networking.networkmanager = {
    enable = true;
    # Local DNS server, placed ahead of the DHCP-provided ones in resolv.conf
    insertNameservers = [ "192.168.1.10" ];
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
    # FPS/frametime overlay, per-game launch option: `mangohud %command%`
    mangohud
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
}
