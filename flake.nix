{
  description = "Bigor's Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      mkNixosSystem =
        hostName:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            nixvim.nixosModules.nixvim
            ./hosts/${hostName}/hardware-configuration.nix
            ./hosts/${hostName}/${hostName}.nix
            ./configuration.nix
            home-manager.nixosModules.home-manager
            (
              { config, ... }:
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.bigor = import ./home.nix;
                home-manager.backupFileExtension = "backup";
                home-manager.extraSpecialArgs = {
                  desktop = config.desktop;
                };
              }
            )
          ];
        };
    in
    {
      nixosConfigurations = {
        grospc = mkNixosSystem "grospc";
        minipc = mkNixosSystem "minipc";
      };
    };
}
