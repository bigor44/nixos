{
  pkgs,
  inputs,
  ...
}:
pkgs.runCommand "nix-lint" {
  nativeBuildInputs = [pkgs.statix pkgs.deadnix];
} ''
  # On récupère le chemin propre des sources via l'input "self"
  src="${inputs.self}"

  echo "Running statix on $src..."
  statix check "$src"

  echo "Running deadnix on $src..."
  deadnix -f "$src"

  touch $out
''
