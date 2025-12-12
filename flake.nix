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
      src = ./.; # Dit à Snowfall de scanner le répertoire courant

      # Configuration globale pour Snowfall
      snowfall = {
        namespace = "bigor"; # Vos options deviendront bigor.<module>

        # Configuration des métadonnées (optionnel mais recommandé)
        meta = {
          name = "bigor-nixos";
          title = "Bigor's NixOS";
        };
      };

      # Canaux (Channels) configurés
      channels-config = {
        allowUnfree = true;
      };

      # Overlays globaux si vous en avez (sinon liste vide)
      overlays = [];

      # Modules partagés entre tous les systèmes
      systems.modules.nixos = with inputs; [
        nixvim.nixosModules.nixvim
        # Votre configuration Home Manager actuelle intégrée au système
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.bigor = import ./home; # Voir étape 4 pour améliorer ça
          home-manager.extraSpecialArgs = {inherit inputs;};
        }
      ];
    };
}
