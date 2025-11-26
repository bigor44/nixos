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

      treefmt
      yamlfmt
      stylua
      nodePackages.prettier
      nixfmt
      shfmt
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
