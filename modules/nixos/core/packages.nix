{pkgs, ...}: {
  programs = {
    fish.enable = true;
    tmux.enable = true;
  };
  environment.systemPackages = with pkgs; [
    # Nix
    alejandra
    statix
    deadnix

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
  ];
}
