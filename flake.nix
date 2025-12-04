{
  description = "Bigor's NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      flake-parts,
      treefmt-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
      ];

      imports = [
        treefmt-nix.flakeModule
      ];

      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        {
          # --------------------------------------------------------------------
          # Treefmt Configuration
          # --------------------------------------------------------------------
          # The single source of truth for formatting across devShell, CI, and Editor.
          treefmt = {
            projectRootFile = "flake.nix";

            programs = {
              nixfmt.enable = true;
              stylua.enable = true;
              shfmt.enable = true;
              yamlfmt.enable = true;
              taplo.enable = true;
              prettier.enable = true;
              black.enable = true;
              isort.enable = true;
            };

            settings = {
              formatter = {
                prettier = {
                  excludes = [
                    "*.yaml"
                    "*.yml"
                  ];
                };
                shfmt = {
                  includes = [ "*.sh" ];
                  options = [
                    "-i"
                    "2"
                    "-s"
                    "-w"
                  ];
                };
              };
            };
          };

          # --------------------------------------------------------------------
          # Pre-commit Checks
          # --------------------------------------------------------------------
          checks = {
            formatting = config.treefmt.build.check self;

            # Note: Formatters are removed from here as treefmt handles them now.
            pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                statix.enable = true;
                deadnix.enable = true;
                luacheck.enable = true;

                detect-secrets = {
                  enable = true;
                  entry = "${pkgs.detect-secrets}/bin/detect-secrets-hook --baseline .secrets.baseline";
                  excludes = [ "^secrets/secrets\.yaml$" ];
                };
              };
            };
          };

          formatter = config.treefmt.build.wrapper;

          # --------------------------------------------------------------------
          # Development Shell
          # --------------------------------------------------------------------
          devShells.default = pkgs.mkShell {
            # Inherit inputs from treefmt and pre-commit-check to add tools to PATH.
            inputsFrom = [
              config.treefmt.build.devShell
              config.checks.pre-commit-check
            ];

            packages = with pkgs; [
              nixd
            ];

            inherit (config.checks.pre-commit-check) shellHook;
          };
        };

      flake = {
        # ----------------------------------------------------------------------
        # NixOS Configurations
        # ----------------------------------------------------------------------
        nixosConfigurations =
          let
            sharedModules = [
              ./modules/nixos
              inputs.home-manager.nixosModules.home-manager
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
