{
  home = {
    username = "bigor";
    homeDirectory = "/home/bigor";
    stateVersion = "25.05";
  };
  imports = [
    ./dotfiles.nix
    ./packages.nix
    ./shell.nix
    ./git.nix
    ./nixvim.nix
  ];
}
