{
  description = "Bigor's Simplified NixOS Configuration";

  # Flake Inputs
  #
  # Defines external dependencies for the system.
  inputs = {
    # Core NixOS package repository (Branch: 25.11)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Snowfall Lib: Opinionated library for structuring NixOS flakes
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager: User environment manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixvim: Neovim configuration via Nix modules
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  # Flake Outputs
  #
  # Builds the system configurations using Snowfall Lib.
  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      # Snowfall Configuration
      # - namespace: Prefix for custom options (e.g., bigor.services...)
      snowfall = {
        namespace = "bigor";
        meta = {
          name = "bigor-nixos";
          title = "Bigor's NixOS";
        };
      };

      # Global Nixpkgs Configuration
      channels-config = {
        allowUnfree = true;
      };
      overlays = [];

      # Shared System Modules
      # Injects modules available to all NixOS systems defined in 'systems/'
      systems.modules.nixos = with inputs; [
        nixvim.nixosModules.nixvim
      ];
    };
}
