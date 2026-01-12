# Module: nix/hosts.nix
# Purpose: Flake-parts module defining all NixOS configurations
{ inputs, ... }:
let
  # Import the module lists
  modules = import ./modules.nix;

  # Import network topology data
  networkTopology = import ./network-topology.nix;

  # Common NixOS modules for all hosts
  commonNixosModules = modules.nixosModules ++ [
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
  ];

  # Common Home Manager modules for all users
  commonHomeModules = modules.homeModules ++ [
    inputs.nixvim.homeModules.nixvim
  ];

  # Helper function to create a NixOS configuration
  mkHost =
    hostname:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs networkTopology;
      };
      modules = commonNixosModules ++ [
        ../hosts/${hostname}
        {
          # Core Nix configuration (caches, flakes, internal CA trust)
          nixpkgs.config.allowUnfree = true;

          # Trust internal CA for local services (HTTPS via Caddy)
          security.pki.certificateFiles = [ "${inputs.self}/certs/minipc-ca.pem" ];

          nix = {
            settings = {
              auto-optimise-store = true;
              experimental-features = [
                "nix-command"
                "flakes"
              ];
              trusted-users = [
                "root"
                "bigor"
              ];
              max-jobs = "auto";

              substituters = [
                "https://cache.nixos.org"
                "https://nix-community.cachix.org"
                "https://cosmic.cachix.org"
              ];

              trusted-public-keys = [
                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
              ];
            };

            optimise.automatic = true;
          };

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = { inherit inputs; };
            sharedModules = commonHomeModules;
            users.bigor = {
              imports = [
                ../users/bigor
                ../hosts/${hostname}/home.nix
              ];
            };
          };
        }
      ];
    };
in
{
  flake.nixosConfigurations = {
    grospc = mkHost "grospc";
    minipc = mkHost "minipc";
    minidesk = mkHost "minidesk";
  };
}
