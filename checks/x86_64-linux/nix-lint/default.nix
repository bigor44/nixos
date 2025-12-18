# ============================================================================
# File: /home/bigor/nixos/checks/x86_64-linux/nix-lint/default.nix
# Description: Nix-lint check for the flake.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{
  pkgs,
  inputs,
  ...
}:
pkgs.runCommand "nix-lint"
  {
    nativeBuildInputs = [
      pkgs.statix
      pkgs.deadnix
    ];
  }
  ''
    # Retrieve the source path via the "self" input
    src="${inputs.self}"

    echo "Running statix on $src..."
    statix check "$src"

    echo "Running deadnix on $src..."
    deadnix -f "$src"

    touch $out
  ''
