{
  description = "Bigor's NixOS Configuration Flake";

  inputs = {
    # --- Unstable Inputs (Pour Desktop/Gaming) ---
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Stable Inputs (Pour Serveur/MiniPC - Version 25.11) ---
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # --- Utils ---
    flake-parts.url = "github:hercules-ci/flake-parts";

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
            # Modules de base NixOS (partagés par tous les hôtes)
            coreModules = [
              ./modules/nixos
            ];

            # Configuration Home Manager factorisée
            # Cette fonction génère le bloc de configuration HM
            hmConfig =
              { inputs, ... }:
              {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.bigor = import ./modules/home;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit inputs;
                  # 'osConfig' est injecté automatiquement par le module HM
                };
              };
          in
          {
            # --- GROSPC (Unstable / Rolling Release) ---
            grospc = inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = { inherit inputs; };
              modules = coreModules ++ [
                # Module HM Unstable
                inputs.home-manager.nixosModules.home-manager
                (
                  { config, ... }:
                  {
                    home-manager = hmConfig { inherit inputs; } // {
                      # On passe osConfig manuellement via extraSpecialArgs si nécessaire
                      # (bien que les versions récentes le fassent souvent auto)
                      extraSpecialArgs = {
                        inherit inputs;
                        osConfig = config;
                      };
                    };
                  }
                )
                ./hosts/grospc
              ];
            };

            # --- MINIPC (Stable 25.11) ---
            minipc = inputs.nixpkgs-stable.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = { inherit inputs; };
              modules = coreModules ++ [
                # Module HM Stable
                inputs.home-manager-stable.nixosModules.home-manager
                (
                  { config, ... }:
                  {
                    home-manager = hmConfig { inherit inputs; } // {
                      extraSpecialArgs = {
                        inherit inputs;
                        osConfig = config;
                      };
                    };
                  }
                )
                ./hosts/minipc
              ];
            };
          };
      };
    };
}
