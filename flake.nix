{
  description = "Bigor's NixOS Configuration Flake";

  inputs = {
    # Stable/Unstable NixOS package sets
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
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
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
          # Pre-commit Checks
          # --------------------------------------------------------------------
          # Ensures code quality before committing changes.
          # Runs linters and formatters for Nix, Lua, Shell, etc.
          checks = {
            pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                statix.enable = true; # Lints Nix code for anti-patterns
                deadnix.enable = true; # Scans Nix code for dead code
                nixfmt-rfc-style.enable = true; # Formats Nix code
                prettier.enable = true; # Formats various file types
                shfmt = {
                  enable = true;
                  entry = "${pkgs.shfmt}/bin/shfmt -i 2 -s -w"; # Formats Shell scripts
                };
                detect-secrets = {
                  enable = true;
                  entry = "${pkgs.detect-secrets}/bin/detect-secrets-hook --baseline .secrets.baseline";
                  excludes = [ "^secrets/secrets\.yaml$" ];
                };
              };
            };
          };

          # Formatter to be used with 'nix fmt'
          formatter = pkgs.nixfmt-rfc-style;

          # --------------------------------------------------------------------
          # Development Shell
          # --------------------------------------------------------------------
          # Shell environment with all necessary tools for working on this configuration.
          # Includes linters, formatters, and pre-commit hooks.
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              detect-secrets
              nixd
              nixfmt-rfc-style
              shfmt
              yamlfmt
              nodePackages.prettier
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
            # Optimized for daily usage, gaming, and development.
            grospc = inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = { inherit inputs; };
              modules = sharedModules ++ [ ./hosts/grospc ];
            };

            # Server Machine
            # Headless setup for hosting services (AdGuard, Dashboard, etc.).
            minipc = inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = { inherit inputs; };
              modules = sharedModules ++ [ ./hosts/minipc ];
            };
          };
      };
    };
}
