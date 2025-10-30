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
    { nixpkgs, home-manager, nixvim, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.grospc = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixvim.nixosModules.nixvim
          ./hosts/grospc/hardware-configuration.nix
          ./hosts/grospc/grospc.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bigor = import ./home.nix;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
      nixosConfigurations.minipc = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixvim.nixosModules.nixvim
          ./hosts/minipc/hardware-configuration.nix
          ./hosts/minipc/minipc.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bigor = import ./home.nix;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    };
}
