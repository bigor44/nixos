{pkgs, ...}: {
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
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
    nixpkgs-fmt
    nil
    pciutils
    sl
    sysstat
    lm_sensors
  ];
}
