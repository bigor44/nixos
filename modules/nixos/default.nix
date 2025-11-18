{...}: {
  imports = [
    ./options.nix
    ./adguard.nix
    ./desktop.nix
    ./fonts.nix
    ./sshd.nix
    ./system.nix
    ./users.nix
    ./packages.nix
    ./nixvim
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
}
