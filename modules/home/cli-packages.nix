# Module: cli-packages
# Purpose: Essential CLI tools for development and system monitoring
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Modern CLI tools
    sl
    eza
    fd
    ripgrep
    jq
    lazygit

    # Code quality & development
    nix-health
    statix
    deadnix
    treefmt
    prettier
    nixfmt
    shfmt
    taplo

    # Network utilities
    dig

    # Monitoring & performance
    btop
    sysstat
    inxi
    pciutils
    usbutils
    mesa-demos
    lm_sensors
    fastfetch

    claude-code
  ];
}
