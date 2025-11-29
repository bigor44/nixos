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
      eza
      fd
      ripgrep
      jq
      lazygit
      gemini-cli

      nodePackages.prettier
      nixfmt-rfc-style
      yamlfmt
      stylua
      shfmt
      isort
      black
      taplo
    ]
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
