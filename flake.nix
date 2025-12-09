{
  description = "Bigor's NixOS Configuration Flake";

  # ============================================================================
  # Bigor's NixOS Flake
  # ============================================================================
  # This flake manages the system configurations for 'grospc' (Desktop) and
  # 'minipc' (Server). It integrates NixOS for system-level management and
  # Home Manager for user environment configuration.
  #
  # Highlights:
  # - Reproducible builds via Flakes.
  # - Unified formatting with Treefmt.
  # - Automated checks via Git hooks.
  # ============================================================================

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
    # --- Utils ---
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    flake-parts,
    treefmt-nix,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      # Importation des modules flake-parts pour treefmt et git-hooks
      imports = [
        treefmt-nix.flakeModule
        inputs.git-hooks-nix.flakeModule
      ];

      perSystem = {
        config,
        pkgs,
        ...
      }: {
        # --------------------------------------------------------------------
        # Treefmt Configuration
        # --------------------------------------------------------------------
        # The single source of truth for formatting across devShell, CI, and Editor.
        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
            stylua.enable = true;
            shfmt.enable = true;
            taplo.enable = true;
            prettier.enable = true;
            black.enable = true;
            isort.enable = true;
          };
          settings = {
            formatter = {
              prettier = {
                includes = [
                  "*.css"
                  "*.html"
                  "*.js"
                  "*.json"
                  "*.md"
                  "*.ts"
                  "*.yaml"
                  "*.yml"
                ];
              };
              shfmt = {
                includes = ["*.sh"];
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
        # Git Hooks Checks (Pre-commit Module)
        # --------------------------------------------------------------------
        # Configuration déclarative via le module git-hooks.nix
        pre-commit = {
          check.enable = true;
          settings = {
            src = ./.;
            hooks = {
              statix.enable = true;
              deadnix.enable = true;
              typos.enable = true;
              commitizen.enable = true;
              shellcheck.enable = true;
              detect-private-keys.enable = true;
              trim-trailing-whitespace.enable = true;
              end-of-file-fixer.enable = true;
              check-merge-conflicts.enable = true;
            };
          };
        };

        # --------------------------------------------------------------------
        # Checks
        # --------------------------------------------------------------------
        checks = {
          formatting = config.treefmt.build.check self;
          # Note: Le module pre-commit ajoute automatiquement son check ici
        };

        formatter = config.treefmt.build.wrapper;

        # --------------------------------------------------------------------
        # Development Shell
        # --------------------------------------------------------------------
        devShells.default = pkgs.mkShell {
          # Inherit inputs from treefmt and pre-commit to add tools to PATH.
          inputsFrom = [
            config.treefmt.build.devShell
            config.pre-commit.devShell
          ];
          packages = with pkgs; [nixd];
        };
      };

      flake = {
        # ----------------------------------------------------------------------
        # NixOS Configurations
        # ----------------------------------------------------------------------
        nixosConfigurations = let
          # Base NixOS modules (shared by all hosts)
          coreModules = [./modules/nixos];
          # Helper to generate Home Manager configuration
          mkHomeManagerConfig = {
            inputs,
            config,
          }: {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.bigor = import ./modules/home;
            backupFileExtension = "backup";
            extraSpecialArgs = {
              inherit inputs;
              osConfig = config;
            };
          };

          # System builder helper
          mkSystem = {
            hostname,
            system ? "x86_64-linux",
          }:
            inputs.nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = {inherit inputs;};
              modules =
                coreModules
                ++ [
                  inputs.nixvim.nixosModules.nixvim
                  inputs.home-manager.nixosModules.home-manager
                  (
                    {config, ...}: {
                      home-manager = mkHomeManagerConfig {inherit inputs config;};
                    }
                  )
                  ./hosts/${hostname}
                ];
            };
        in {
          # --- GROSPC (Stable 25.11) ---
          grospc = mkSystem {hostname = "grospc";};
          # --- MINIPC (Stable 25.11) ---
          minipc = mkSystem {hostname = "minipc";};
        };
      };
    };
}
