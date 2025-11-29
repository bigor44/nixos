{
  home = {
    username = "bigor";
    homeDirectory = "/home/bigor";
    stateVersion = "25.05";
  };
  imports = [
    ./packages.nix
    ./shell.nix
    ./git.nix
    ./nixvim
  ];
}
