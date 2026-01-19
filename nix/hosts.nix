# Flake: hosts
# Purpose: Flake-parts module defining all NixOS configurations
{ inputs, ... }:
let
  modules = import ./modules.nix;

  networkTopology = import ./network-topology.nix;

  # Common NixOS modules for all hosts
  commonNixosModules = modules.nixosModules ++ [
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    inputs.nixvim.nixosModules.nixvim
  ];

  # Common Home Manager modules for all users
  commonHomeModules = modules.homeModules;

  mkHost =
    hostname:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs networkTopology;
      };
      modules = commonNixosModules ++ [
        ../hosts/${hostname}
        {
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
