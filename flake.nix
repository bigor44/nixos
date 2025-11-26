{
  description = "Bigor's Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        {
          config,
          pkgs, # Utilise le pkgs par défaut de flake-parts (rapide)
          system,
          ...
        }:
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              stylua.enable = true;
              yamlfmt.enable = true;
              prettier.enable = true;
            };
          };

          checks = {
            pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                # Lint
                statix.enable = true;
                deadnix.enable = true;
                luacheck.enable = true;

                # Format
                treefmt = {
                  enable = true;
                  package = config.treefmt.build.wrapper;
                };
              };
            };
          };

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              nixd
              lua-language-server # LSP Lua
            ];
            inherit (config.checks.pre-commit-check) shellHook;
          };
        };

      flake = {
        nixosConfigurations =
          let
            sharedModules = [
              ./modules/nixos
              inputs.home-manager.nixosModules.home-manager
              inputs.sops-nix.nixosModules.sops
              (
                { config, ... }:
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users.bigor = import ./modules/home;
                    backupFileExtension = "backup";
                    extraSpecialArgs = {
                      inherit inputs;
                      osConfig = config;
                    };
                  };
                }
              )
            ];
          in
          {
            grospc = inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = { inherit inputs; };
              modules = sharedModules ++ [ ./hosts/grospc ];
            };

            minipc = inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = { inherit inputs; };
              modules = sharedModules ++ [ ./hosts/minipc ];
            };
          };
      };
    };
}
