{
  description = "Bigor's Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      # Logic that runs "per system" (e.g. for your devShell)
      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: {
        # 1. Define the Pre-commit checks
        checks = {
          pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              alejandra.enable = true;
              statix.enable = true;
              deadnix.enable = true;
            };
          };
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            statix
            deadnix
          ];

          inherit (config.checks.pre-commit-check) shellHook;
        };
      };

      flake = {
        nixosConfigurations = let
          # Helper function (adapted from your original file)
          mkNixosSystem = hostName:
            inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = {inherit inputs;};
              modules = [
                ./modules/nixos
                ./hosts/${hostName}
                inputs.nixvim.nixosModules.nixvim
                inputs.home-manager.nixosModules.home-manager
                # inputs.stylix.nixosModules.stylix # If using Stylix
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users.bigor = import ./modules/home;
                    backupFileExtension = "backup";
                  };
                }
              ];
            };
        in {
          grospc = mkNixosSystem "grospc";
          minipc = mkNixosSystem "minipc";
        };
      };
    };
}
