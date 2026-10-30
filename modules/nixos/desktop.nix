{ pkgs, ... }:
{
  services = {
    displayManager.cosmic-greeter.enable = true;
    desktopManager.cosmic.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
  networking.networkmanager.enable = true;
  programs.firefox = {
    enable = true;
    languagePacks = [ "fr" ];
    preferences = {
      "intl.locale.requested" = "fr";
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
      enable32Bit = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
  security.rtkit.enable = true;
}
