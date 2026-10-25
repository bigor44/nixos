# Platform: desktop
# Purpose: COSMIC desktop, graphics, NetworkManager, Firefox, PipeWire, Bluetooth and gaming (Steam, GameMode)
_: {
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
