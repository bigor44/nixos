# Flake: bigor-nixos
# Purpose: Main entry point for NixOS configuration (flake-parts)
{
  description = "Bigor's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        inputs.git-hooks.flakeModule
        ./nix/checks.nix
      ];

      flake.nixosConfigurations.grospc = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.nixvim.nixosModules.nixvim
          ./hosts/grospc/configuration.nix
        ];
      };

      # Standalone so `nh home switch` applies user config without a new NixOS generation
      flake.homeConfigurations."bigor@grospc" = inputs.home-manager.lib.homeManagerConfiguration {
        # Reuse the system's nixpkgs instance (same config/overlays as the old useGlobalPkgs)
        inherit (self.nixosConfigurations.grospc) pkgs;
        extraSpecialArgs.osConfig = self.nixosConfigurations.grospc.config;
        modules = [ ./modules/home ];
      };
    };
}
