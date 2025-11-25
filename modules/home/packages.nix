{
  pkgs,
  osConfig,
  lib,
  ...
}:
let
  isDesktop = osConfig.system.role == "desktop" || osConfig.system.role == "hybrid";
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 0.95;
      font = {
        normal.family = "JetBrainsMono Nerd Font";
        size = 12;
      };
    };
  };
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
    ++ lib.optionals isDesktop [
      discord
      brave
      onedrive
      youtube-music
      whatsapp-electron
      antigravity-fhs
    ];
}
