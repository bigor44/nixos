{
  pkgs,
  inputs,
  ...
}:
pkgs.runCommand "nix-lint" {
  nativeBuildInputs = [pkgs.statix pkgs.deadnix];
} ''
  # Retrieve the source path via the "self" input
  src="${inputs.self}"

  echo "Running statix on $src..."
  statix check "$src"

  echo "Running deadnix on $src..."
  deadnix -f "$src"

  touch $out
''
