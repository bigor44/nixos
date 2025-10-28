{
  description = "Bigor's Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.grospc = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
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
          ./hosts/minipc/hardware-configuration.nix
          ./hosts/minipc/minipc.nix
          ./configuration.nix
	  ./modules/grafprom.nix
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

