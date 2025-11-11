/*
  Consolidated packages configuration
  Replaces base-apps.nix and desktop-apps.nix
*/
{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Base programs (always enabled)
  programs.fish.enable = true;
  programs.tmux.enable = true;
  programs.firefox.enable = lib.mkIf config.desktop.enable true;
  programs.steam.enable = lib.mkIf config.desktop.enable true;

  # Base CLI packages (always installed)
  environment.systemPackages =
    with pkgs;
    [
      # Nix tooling
      nixfmt

      # Network tools
      dig
      wget
      curl

      # System monitoring
      btop
      htop
      sysstat
      lm_sensors

      # File utilities
      tree
      zip
      unzip
      ripgrep
      pciutils

      # Misc
      fastfetch
      sl
    ]
    ++ lib.optionals config.desktop.enable [
      # Desktop applications (only when desktop is enabled)
      discord
      brave
      onedrive
      whatsapp-electron
    ];
}
