{ pkgs, ... }: {
  fonts = {
    packages = with pkgs; [
      # Your existing fonts
      nerd-fonts.jetbrains-mono
      terminus_font
      powerline-fonts

      # Japanese fonts
      noto-fonts-cjk-sans # Google Noto Sans CJK (Sans-serif)
      noto-fonts-cjk-serif # Google Noto Serif CJK (Serif)
      ipafont # IPA fonts (Japanese)
      hanazono # Hanazono Mincho (comprehensive)

      # Optional: emoji support
      noto-fonts-color-emoji
    ];

    # Font configuration for better CJK rendering
    fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif CJK JP"
          "Noto Serif"
        ];
        sansSerif = [
          "Noto Sans CJK JP"
          "Noto Sans"
        ];
        monospace = [
          "JetBrainsMono Nerd Font"
          "Noto Sans Mono CJK JP"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };

  # Ensure proper locale support for Japanese
  i18n.supportedLocales = [
    "fr_FR.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "ja_JP.UTF-8/UTF-8"
  ];
}
