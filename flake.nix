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

      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        formatter = pkgs.alejandra;

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
          packages = with pkgs; [alejandra statix deadnix];
          inherit (config.checks.pre-commit-check) shellHook;
        };
      };

      flake = {
        nixosConfigurations = let
          globalConfig = {
            nixpkgs.config.allowUnfree = true;
            nix.settings = {
              substituters = ["https://cache.nixos.org" "https://nix-community.cachix.org"];
              trusted-public-keys = ["cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
            };
          };

          sharedModules = [
            ./modules/nixos
            inputs.nixvim.nixosModules.nixvim
            inputs.home-manager.nixosModules.home-manager
            globalConfig
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.bigor = import ./modules/home;
                backupFileExtension = "backup";
              };
            }
          ];
        in {
          grospc = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {inherit inputs;};
            modules = sharedModules ++ [./hosts/grospc];
          };

          minipc = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {inherit inputs;};
            modules = sharedModules ++ [./hosts/minipc];
          };
        };
      };
    };
}
