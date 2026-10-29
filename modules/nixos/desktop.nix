# Platform: desktop
# Purpose: COSMIC desktop, graphics, NetworkManager, PipeWire, Bluetooth and desktop apps
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

  programs.firefox = {
    enable = true;
    # The French UI ships as a language pack, not in the base build
    languagePacks = [ "fr" ];
    preferences."intl.locale.requested" = "fr";
  };

  environment.systemPackages = with pkgs; [
    brave
    discord
    whatsapp-electron
  ];

  hardware = {
    graphics = {
      enable = true;
      # 32-bit Vulkan/GL drivers for Steam and Proton (gaming.nix)
      enable32Bit = true;
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # Lets PipeWire acquire realtime scheduling without running as root (avoids audio crackling under load)
  security.rtkit.enable = true;
}
