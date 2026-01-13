# Complete desktop environment bundle
# Includes: desktop, audio, flatpak, bluetooth, and comprehensive fonts
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.capabilities.desktopFull;
in
{
  options.bigor.capabilities.desktopFull = {
    enable = mkEnableOption "complete desktop environment bundle (COSMIC + audio + flatpak + bluetooth + fonts)";
  };

  config = mkIf cfg.enable {
    # Compose other capabilities
    bigor.capabilities = {
      desktop.enable = true;
      audio.enable = true;
      flatpak.enable = true;
    };

    # Bluetooth configuration
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # Comprehensive font configuration
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
  };
}
