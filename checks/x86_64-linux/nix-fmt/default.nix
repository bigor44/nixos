# ============================================================================
# File: checks/x86_64-linux/nix-fmt/default.nix
# Description: Formatting check for the flake.
# Author: Bigor
# Date: 2025-12-19
# ============================================================================
{
  pkgs,
  inputs,
  ...
}:
pkgs.runCommand "nix-fmt"
  {
    nativeBuildInputs = [
      pkgs.treefmt
      pkgs.nixfmt-rfc-style
      pkgs.shfmt
      pkgs.nodePackages.prettier
      pkgs.taplo
    ];
  }
  ''
    src="${inputs.self}"

    # Copy source to a writable location
    cp -r "$src" ./source
    chmod -R u+w ./source

    echo "Checking formatting with treefmt..."
    treefmt --no-cache --fail-on-change -C ./source

    touch $out
  ''
