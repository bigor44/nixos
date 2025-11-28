{
  pkgs,
  osConfig,
  lib,
  ...
}: {
  home.packages = with pkgs;
    [
      eza
      fd
      ripgrep
      jq
      python3
      python313Packages.debugpy
      gemini-cli

      yamlfmt
      stylua
      nodePackages.prettier
      alejandra
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
      (callPackage ./turtle-wow.nix {})
    ];
}
