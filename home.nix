{pkgs, ...}: {
  home.username = "bigor";
  home.homeDirectory = "/home/bigor";
  home.stateVersion = "25.11";
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  home.packages = with pkgs; [
  ];
  imports = [
    ./home/git.nix
    ./home/zsh.nix
  ];
}
