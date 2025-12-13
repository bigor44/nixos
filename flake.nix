{
  description = "Bigor's Simplified NixOS Configuration";

  # ============================================================================
  # Flake Inputs
  # ============================================================================
  # Defines external dependencies:
  # - nixpkgs: Core system packages (Branch: 25.11)
  # - snowfall-lib: Flake structure helper
  # - home-manager: User environment manager
  # - nixvim: Neovim configuration via Nix
  # ============================================================================
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # ============================================================================
  # Flake Outputs
  # ============================================================================
  # Builds the system configurations using Snowfall Lib.
  # ============================================================================
  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      # Snowfall Configuration
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
      systems.modules.nixos = with inputs; [
        nixvim.nixosModules.nixvim
      ];
    };
}
