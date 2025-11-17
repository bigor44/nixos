{pkgs, ...}: {
  home.packages = with pkgs; [
    eza
    fd
    ripgrep
    alejandra
    statix
    deadnix
  ];
}
