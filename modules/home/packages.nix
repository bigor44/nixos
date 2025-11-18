{pkgs, ...}: {
  home.packages = with pkgs; [
    eza
    fd
    ripgrep
    jq
    alejandra
    statix
    deadnix
    gemini-cli
  ];
}
