{
  home.username = "bigor";
  home.homeDirectory = "/home/bigor";
  home.stateVersion = "25.05";
  imports = [
    ./modules/home/packages.nix
    ./modules/home/shell.nix
    ./modules/home/git.nix
    ./modules/home/vscode.nix
  ];
}
