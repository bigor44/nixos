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

  # DNS servers are LAN-specific and set by the host
  networking.networkmanager.enable = true;

  programs.firefox = {
    enable = true;
    # The French UI ships as a language pack, not in the base build
    languagePacks = [ "fr" ];
    preferences = {
      "intl.locale.requested" = "fr";
      # WebGPU is still off by default on Linux release builds
      "dom.webgpu.enabled" = true;
      "gfx.webgpu.ignore-blocklist" = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # Chromium blocklists WebGPU on Linux; Dawn needs the Vulkan feature to present to canvas
    (brave.override {
      enableVulkan = true;
      commandLineArgs = "--enable-unsafe-webgpu";
    })
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
