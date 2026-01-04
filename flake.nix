# Flake: bigor-nixos
# Purpose: Main entry point for NixOS + Home Manager configuration (flake-parts)
{
  description = "Bigor's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs =
    inputs@{ flake-parts, self, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        ./nix/hosts.nix
      ];

      perSystem =
        { pkgs, ... }:
        {
          # Formatter for nix fmt
          formatter = pkgs.treefmt;

          # Flake checks (nix flake check)
          checks = {
            # Formatting check with treefmt
            nix-fmt =
              pkgs.runCommand "nix-fmt"
                {
                  nativeBuildInputs = with pkgs; [
                    treefmt
                    nixfmt-rfc-style
                    shfmt
                    nodePackages.prettier
                    taplo
                  ];
                }
                ''
                  src="${self}"

                  # Copy source to a writable location
                  cp -r "$src" ./source
                  chmod -R u+w ./source

                  echo "Checking formatting with treefmt..."
                  treefmt --no-cache --fail-on-change -C ./source

                  touch $out
                '';

            # Linting check with statix and deadnix
            nix-lint =
              pkgs.runCommand "nix-lint"
                {
                  nativeBuildInputs = with pkgs; [
                    statix
                    deadnix
                  ];
                }
                ''
                  src="${self}"

                  echo "Running statix on $src..."
                  statix check --ignore .* "$src"

                  echo "Running deadnix on $src..."
                  deadnix --fail "$src"

                  touch $out
                '';
          };
        };
    };
}
