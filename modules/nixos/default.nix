{...}: {
  imports = [
    ./options.nix
    ./adguard.nix
    ./desktop.nix
    ./sshd.nix
    ./system.nix
    ./network.nix
    ./users.nix
    ./packages.nix
    ./llm.nix
    ./nixvim
    ./nfs
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
}
