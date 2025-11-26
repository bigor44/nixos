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
      python3
      gemini-cli
      age
      sops
      ssh-to-age

      yamlfmt
      stylua
      nodePackages.prettier
      nixfmt-rfc-style
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
