{...}: {
  imports = [
    ./options.nix
    ./system.nix
    ./locale.nix
    ./users.nix
    ./sops.nix
    ./packages.nix
  ];
}
