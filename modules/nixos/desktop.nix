# Platform: desktop
# Purpose: COSMIC session, PipeWire audio, graphics, Bluetooth, networking and desktop apps
{ pkgs, ... }:
{
  services = {
    displayManager.cosmic-greeter.enable = true;
    desktopManager.cosmic.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      # 32-bit games (Steam/Wine) still talk to ALSA directly
      alsa.support32Bit = true;
      # PulseAudio-compatible server for apps that do not speak PipeWire
      pulse.enable = true;
    };
  };
  # Nameservers are LAN-specific and pinned in the host configuration
  networking.networkmanager.enable = true;
  programs.firefox = {
    enable = true;
    # The French UI is a separate language pack, absent from the default build
    languagePacks = [ "fr" ];
    preferences = {
      "intl.locale.requested" = "fr";
      # WebGPU is still gated off on Linux release builds; the blocklist can disable it per driver
      "dom.webgpu.enabled" = true;
      "gfx.webgpu.ignore-blocklist" = true;
    };
  };
  environment.systemPackages = with pkgs; [
    brave
    discord
    whatsapp-electron
  ];
  hardware = {
    graphics = {
      enable = true;
      # 32-bit Mesa/Vulkan drivers, required by Steam and Proton
      enable32Bit = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
  # Grants PipeWire realtime priority without root, avoiding crackles under CPU load
  security.rtkit.enable = true;
}
