# Flake: bigor-nixos
# Purpose: Main entry point for NixOS + Home Manager configuration
{
  description = "Bigor's Simplified NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      homes.modules = [
        inputs.nixvim.homeModules.nixvim
      ];

      systems.modules.nixos = [
        inputs.sops-nix.nixosModules.sops
      ];

      outputs-builder = channels: {
        formatter = channels.nixpkgs.treefmt;
      };

      snowfall = {
        systems = [ "x86_64-linux" ];
        namespace = "bigor";
        meta = {
          name = "bigor-nixos";
          title = "Bigor's NixOS";
        };
      };

      channels-config.allowUnfree = true;
      overlays = [ ];
    };
}
