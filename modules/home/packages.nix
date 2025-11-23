{pkgs, ...}: {
  home.packages = with pkgs; [
    eza
    fd
    ripgrep
    jq
    gemini-cli
    age
    sops
    ssh-to-age
  ];
}
