{pkgs, ...}: let
  sharedAliases = {
    ll = "exa -l";
    la = "exa -lah";
    nrs = "sudo nixos-rebuild switch --flake ~/nixos";
    nrb = "sudo nixos-rebuild boot --flake ~/nixos";
    nfu = "nix flake update";
    nfc = "nix flake check";
    gaa = "git add -A";
    gc = "git commit";
    gcm = "git commit -m";
    gd = "git diff";
    gl = "git pull";
    gp = "git push";
    gst = "git status";
  };
in {
  home.username = "bigor";
  home.homeDirectory = "/home/bigor";
  home.stateVersion = "25.11";
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  home.packages = with pkgs; [
    eza
  ];
  programs.git = {
    enable = true;
    settings.user = {
      name = "Yoann Bigor";
      email = "bigor44@gmail.com";
    };
  };
  programs.bash = {
    enable = true;
    shellAliases = sharedAliases;
  };
  programs.zsh = {
    enable = true;
    shellAliases = sharedAliases;
  };
}
