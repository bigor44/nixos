{
  # ============================================================================
  # File: flake.nix
  # Description: Main entry point for the NixOS configuration using Flakes.
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Defines inputs (dependencies) and outputs (system configurations)
  #          using Snowfall Lib for structure and modularity.
  # ============================================================================

  description = "Bigor's Simplified NixOS Configuration";

  # ============================================================================
  # Flake Inputs
  # ============================================================================
  # Defines external dependencies:
  # - nixpkgs: Core system packages (Branch: 25.11)
  # - snowfall-lib: Helper library for opinionated flake structure
  # - home-manager: Manages user environments (dotfiles, etc.)
  # - nixvim: Neovim configuration framework for Nix
  # ============================================================================
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

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # ============================================================================
  # Flake Outputs
  # ============================================================================
  # Generates the system configurations based on the inputs.
  # Utilizes Snowfall Lib's `mkFlake` to automatically traverse the directory
  # structure (systems/, modules/, etc.) and build the NixOS configurations.
  # ============================================================================
  outputs =
    inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      # Inject Nixvim modules into Home Manager
      homes.modules = [
        inputs.nixvim.homeModules.nixvim
      ];

      systems.modules.nixos = [
        inputs.sops-nix.nixosModules.sops
      ];

      # ------------------------------------------------------------------------
      # Snowfall Configuration
      # ------------------------------------------------------------------------
      snowfall = {
        systems = [ "x86_64-linux" ];
        namespace = "bigor";
        meta = {
          name = "bigor-nixos";
          title = "Bigor's NixOS";
        };
      };

      # ------------------------------------------------------------------------
      # Global Nixpkgs Configuration
      # ------------------------------------------------------------------------
      channels-config = {
        allowUnfree = true;
      };
      overlays = [ ];
    };
}
