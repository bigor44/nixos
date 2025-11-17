{
  lib,
  config,
  pkgs,
  ...
}: {
  programs = {
    fish.enable = true;
    tmux.enable = true;
    firefox.enable = lib.mkIf (config.role == "desktop") true;
    gamemode.enable = true;
    steam = lib.mkIf (config.role == "desktop") {
      enable = true;
      remotePlay.openFirewall = true;
    };
  };
  # Base CLI packages (always installed)
  environment.systemPackages = with pkgs;
    [
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
      zip
      unzip

      # Misc
      fastfetch
      sl
    ]
    ++ lib.optionals (config.role == "desktop") [
      # Desktop applications (only when desktop is enabled)
      discord
      brave
      onedrive
      youtube-music
      whatsapp-electron
    ];
}
