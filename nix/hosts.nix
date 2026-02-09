# Flake: hosts
# Purpose: Flake-parts module defining all NixOS configurations
{ inputs, ... }:
let
  modules = import ./modules.nix;

  # Common NixOS modules for all hosts
  commonNixosModules = modules.nixosModules ++ [
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
  ];

  mkHost =
    hostname:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = commonNixosModules ++ [
        ../hosts/${hostname}/configuration.nix
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
