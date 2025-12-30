# Module: nix-lint
# Purpose: Lint check running statix and deadnix on the flake
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
    statix check --ignore .* "$src"

    echo "Running deadnix on $src..."
    deadnix --fail "$src"

    touch $out
  ''
