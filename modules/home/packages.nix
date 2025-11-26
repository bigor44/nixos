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
      gemini-cli
      age
      sops
      ssh-to-age
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
