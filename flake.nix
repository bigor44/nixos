{
  description = "Bigor's Simplified NixOS Configuration";

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
  };
  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      snowfall = {
        namespace = "bigor";
        meta = {
          name = "bigor-nixos";
          title = "Bigor's NixOS";
        };
      };

      channels-config = {
        allowUnfree = true;
      };
      overlays = [];

      systems.modules.nixos = with inputs; [
        nixvim.nixosModules.nixvim
      ];
    };
}
