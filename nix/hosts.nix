# Module: nix/hosts.nix
# Purpose: Flake-parts module defining all NixOS configurations
{ inputs, ... }:
let
  # Import the module lists
  modules = import ./modules.nix;

  # Common NixOS modules for all hosts
  commonNixosModules = modules.nixosModules ++ [
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
  ];

  # Common Home Manager modules for all users
  commonHomeModules = modules.homeModules ++ [
    inputs.nixvim.homeModules.nixvim
  ];

  # Helper function to create a NixOS configuration
  mkHost =
    hostname:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = commonNixosModules ++ [
        ../hosts/${hostname}
        {
          nixpkgs.config.allowUnfree = true;

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = { inherit inputs; };
            sharedModules = commonHomeModules;
            users.bigor = {
              imports = [
                ../users/bigor
                ../hosts/${hostname}/home.nix
              ];
            };
          };
        }
      ];
    };
in
{
  flake.nixosConfigurations = {
    grospc = mkHost "grospc";
    minipc = mkHost "minipc";
    minidesk = mkHost "minidesk";
  };
}
