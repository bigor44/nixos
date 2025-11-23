{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.enable {
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      terminus_font
      powerline-fonts

      # Polices japonaises
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      ipafont
      hanazono

      # Emojis
      noto-fonts-color-emoji
    ];

    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif CJK JP" "Noto Serif"];
        sansSerif = ["Noto Sans CJK JP" "Noto Sans"];
        monospace = ["JetBrainsMono Nerd Font" "Noto Sans Mono CJK JP"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
