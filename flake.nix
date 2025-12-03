{
  description = "Bigor's NixOS Configuration Flake";

  inputs = {
    # Unstable NixOS package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Flake Parts for modular flake structure
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Home Manager for user-level configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pre-commit hooks for code quality
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Treefmt for unified formatting
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

      # Import the treefmt module
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

            # Enable the tools
            programs = {
              nixfmt.enable = true; # Nix
              stylua.enable = true; # Lua
              shfmt.enable = true; # Shell
              yamlfmt.enable = true; # YAML
              taplo.enable = true; # TOML
              prettier.enable = true; # General (JSON, MD, etc.)
              black.enable = true; # Python
              isort.enable = true; # Python imports
            };

            # Grouped settings to satisfy statix and configure tools
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
          # Runs linters and checks formatting before committing.
          checks = {
            # Treefmt Check (Ensures everything is formatted according to above config)
            formatting = config.treefmt.build.check self;

            # Linters (Security & Code quality)
            # Note: Formatters are removed from here as treefmt handles them now.
            pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                statix.enable = true; # Lints Nix code for anti-patterns
                deadnix.enable = true; # Scans Nix code for dead code
                luacheck.enable = true; # Lints Lua code

                detect-secrets = {
                  enable = true;
                  entry = "${pkgs.detect-secrets}/bin/detect-secrets-hook --baseline .secrets.baseline";
                  excludes = [ "^secrets/secrets\.yaml$" ];
                };
              };
            };
          };

          # --------------------------------------------------------------------
          # Formatter
          # --------------------------------------------------------------------
          # Default formatter command `nix fmt`
          formatter = config.treefmt.build.wrapper;

          # --------------------------------------------------------------------
          # Development Shell
          # --------------------------------------------------------------------
          # Shell environment with all necessary tools.
          devShells.default = pkgs.mkShell {
            # Inherit inputs from treefmt and pre-commit-check
            # This automatically adds treefmt, all enabled formatters, and linters to PATH.
            inputsFrom = [
              config.treefmt.build.devShell
              config.checks.pre-commit-check
            ];

            packages = with pkgs; [
              nixd # Nix Language Server
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
            # Common modules shared across all systems
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
            # Desktop Machine
            grospc = inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = { inherit inputs; };
              modules = sharedModules ++ [ ./hosts/grospc ];
            };
            # Server Machine
            minipc = inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = { inherit inputs; };
              modules = sharedModules ++ [ ./hosts/minipc ];
            };
          };
      };
    };
}
