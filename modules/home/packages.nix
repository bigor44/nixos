{
  pkgs,
  osConfig,
  lib,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      # Modern CLI replacements
      eza # ls replacement
      fd # find replacement
      ripgrep # grep replacement
      jq # JSON processor
      lazygit # Git terminal UI
      gemini-cli

      # Code Quality Tools
      nodePackages.prettier
      nixfmt-rfc-style
      yamlfmt
      stylua
      shfmt
      isort
      black
      taplo
    ]
    # Desktop-only Applications
    # Only install these if the system has a desktop environment enabled.
    ++ lib.optionals osConfig.desktop.enable [
      discord
      brave
      onedrive
      youtube-music
      whatsapp-electron
      antigravity-fhs
      (callPackage ./turtle-wow.nix { })
    ];
}
