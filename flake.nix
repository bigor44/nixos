# Flake: bigor-nixos
# Purpose: Pins every input and exposes the grospc system plus the fmt/check tooling
{
  description = "Bigor's NixOS Configuration";
  # Every input `follows` this nixpkgs (or flake-parts) so the lock holds a
  # single copy of each, and modules are evaluated against the same package set
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    # master tracks nixos-unstable; release branches would lag behind nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    # Only used for its hook definitions (nix/checks.nix); no git hook is installed
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    # `inputs@` keeps the full attrset so mkFlake and the modules below can reach every input
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # Only drives perSystem outputs (formatter, checks); the host sets its own platform
      systems = [ "x86_64-linux" ];
      imports = [
        inputs.git-hooks.flakeModule
        ./nix/checks.nix
      ];
      # Plain nixosSystem: the nixvim and Home Manager modules only declare options,
      # the host configuration decides what they do
      flake.nixosConfigurations.grospc = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.nixvim.nixosModules.nixvim
          inputs.home-manager.nixosModules.home-manager
          ./hosts/grospc/configuration.nix
        ];
      };
    };
}
