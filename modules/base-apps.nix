{pkgs, ...}: {
  programs.fish.enable = true;
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    eza
    bat
    dig
    btop
    wget
    curl
    fastfetch
    tree
    zip
    unzip
    htop
    ripgrep
    alejandra
    nixd
    pciutils
    sl
    sysstat
    lm_sensors
  ];
}
