{
  description = "Bigor's Simplified NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixvim,
    ...
  } @ inputs: let
    # Shared settings
    system = "x86_64-linux";

    # A simplified shared module list to avoid repeating common imports
    sharedModules = [
      ./modules/nixos # Your core system configuration
      nixvim.nixosModules.nixvim # NixVim module
      home-manager.nixosModules.home-manager # Home Manager module
      {
        # Shared Home Manager settings
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.users.bigor = import ./modules/home;

        # Pass inputs and osConfig to Home Manager modules
        home-manager.extraSpecialArgs = {inherit inputs;};
      }
    ];
  in {
    nixosConfigurations = {
      # --- GROSPC (Desktop) ---
      grospc = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules =
          sharedModules
          ++ [
            ./systems/x86_64-linux/grospc # Host specific config
          ];
      };

      # --- MINIPC (Server) ---
      minipc = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules =
          sharedModules
          ++ [
            ./systems/x86_64-linux/minipc # Host specific config
          ];
      };
    };
  };
}
