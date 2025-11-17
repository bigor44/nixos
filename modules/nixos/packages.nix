{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.fish.enable = true;
  programs.tmux.enable = true;
  programs.firefox.enable = lib.mkIf config.desktop.enable true;
  programs.gamemode.enable = true;
  programs.steam = lib.mkIf config.desktop.enable {
    enable = true;
    remotePlay.openFirewall = true;
  };
  # Base CLI packages (always installed)
  environment.systemPackages = with pkgs;
    [
      # Nix tooling
      alejandra
      deadnix
      statix

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
      youtube-music
      whatsapp-electron
    ];
}
