{
  description = "Bigor's Flake";

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
          checks = {
            pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                statix.enable = true;
                deadnix.enable = true;
                nixfmt-rfc-style.enable = true;
                prettier.enable = true;
                stylua.enable = true;
                luacheck.enable = true;
                shfmt = {
                  enable = true;
                  entry = "${pkgs.shfmt}/bin/shfmt -i 2 -s -w";
                };
                detect-secrets = {
                  enable = true;
                  entry = "${pkgs.detect-secrets}/bin/detect-secrets-hook --baseline .secrets.baseline";
                  excludes = [ "^secrets/secrets\\.yaml$" ];
                };
              };
            };
          };

          formatter = pkgs.nixfmt-rfc-style;

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              detect-secrets
              nixd
              nixfmt-rfc-style
              shfmt
              stylua
              luaPackages.luacheck
              yamlfmt
              nodePackages.prettier
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
