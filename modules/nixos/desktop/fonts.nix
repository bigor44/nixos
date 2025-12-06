{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkIf config.system.features.desktop {
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      terminus_font
      powerline-fonts

      # CJK & Unicode Fonts (for better multilingual support)
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      ipafont
      hanazono

      # Emojis
      noto-fonts-color-emoji
    ];

    # Fontconfig Fallback Strategy
    fontconfig = {
      defaultFonts = {
        # 1. Nerd Font first for Dev/System icons
        # 2. Main font (Noto)
        # 3. CJK for Asian support
        # 4. Color Emoji as last resort to force color
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
