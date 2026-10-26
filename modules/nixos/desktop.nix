# Platform: desktop
# Purpose: COSMIC desktop, graphics, NetworkManager, PipeWire, Bluetooth, desktop apps and gaming (Steam, GameMode)
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
  };

  networking.networkmanager = {
    enable = true;
    # Local DNS server, placed ahead of the DHCP-provided ones in resolv.conf
    insertNameservers = [ "192.168.1.10" ];
  };

  programs = {
    firefox.enable = true;
    gamemode.enable = true;
    steam.enable = true;
  };

  environment.systemPackages = with pkgs; [
    brave
    discord
    whatsapp-electron
    prismlauncher
  ];

  hardware.graphics = {
    enable = true;
    # 32-bit Vulkan/GL drivers for Steam and Proton
    enable32Bit = true;
  };

  # Lets PipeWire acquire realtime scheduling without running as root (avoids audio crackling under load)
  security.rtkit.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}
