{...}: {
  imports = [
    ./core
    ./desktop
    ./services
    ./nixvim
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
}
