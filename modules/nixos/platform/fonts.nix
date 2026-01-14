# Feature: system.fonts
# Purpose: System-wide font configuration (Nerd Fonts, CJK, Emoji)
{
  pkgs,
  ...
}:
{
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
}
