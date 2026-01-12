# Profile: workstation
# Purpose: Desktop environment with COSMIC DE, audio, gaming, and monitoring
{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.bigor.profiles.workstation;
in
{
  options.bigor.profiles.workstation.enable = mkEnableOption "Desktop workstation profile";

  config = mkIf cfg.enable {
    # Bluetooth: Direct configuration (no abstraction needed)
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # Fonts: Direct configuration (no abstraction needed)
    fonts = {
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        terminus_font
        powerline-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        ipafont
        hanazono
        noto-fonts-color-emoji
      ];

      fontconfig.defaultFonts = {
        serif = [
          "Noto Serif"
          "Noto Serif CJK JP"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Noto Sans"
          "Noto Sans CJK JP"
          "Noto Color Emoji"
        ];
        monospace = [
          "JetBrainsMono Nerd Font"
          "Noto Sans Mono CJK JP"
          "Noto Color Emoji"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };

    # Features that warrant abstraction
    bigor.features = {
      audio.enable = mkDefault true;
      flatpak.enable = mkDefault true;
      gaming.enable = mkDefault true;
      desktop.enable = mkDefault true;
    };

    bigor.services = {
      blocky.enable = mkDefault true;
    };
  };
}
