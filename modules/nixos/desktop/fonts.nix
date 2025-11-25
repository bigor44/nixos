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

      # Polices CJK & Unicode
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      ipafont
      hanazono

      # Emojis
      noto-fonts-color-emoji
    ];

    fontconfig = {
      defaultFonts = {
        # 1. Nerd Font en premier pour les icônes Dev/Système
        # 2. Police principale (Noto)
        # 3. CJK pour le support asiatique
        # 4. Color Emoji en dernier recours pour forcer la couleur
        serif = [
          "JetBrainsMono Nerd Font"
          "Noto Serif"
          "Noto Serif CJK JP"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "JetBrainsMono Nerd Font"
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
