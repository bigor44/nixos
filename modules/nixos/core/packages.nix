{pkgs, ...}: {
  programs = {
    fish.enable = true;
    tmux.enable = true;
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/bigor/nixos";
    };
  };
  environment.systemPackages = with pkgs; [
    # Nix
    statix
    alejandra
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
