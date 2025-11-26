#!/usr/bin/env bash
#
# concat_config.sh
#
# Parcourt ~/nixos/ et construit un document *Markdown* contenant :
#     * un titre de niveau 2 avec le chemin relatif du fichier
#     * un bloc de code (fenced code block) avec le contenu du fichier
#
# Extensions gérées : .nix, .lock, .lua, .md
#
# Usage :
#   ./concat_nix_md.sh            # affiche le Markdown sur STDOUT
#   ./concat_nix_md.sh /tmp/all.md   # écrit le Markdown dans /tmp/all.md

set -euo pipefail

# ------------------------------------------------------------------
# CONFIGURATION
# ------------------------------------------------------------------
BASE_DIR="$HOME/nixos" # répertoire à parcourir

# ------------------------------------------------------------------
# ARGUMENTS
# ------------------------------------------------------------------
OUT_FILE=${1:-} # vide → stdout

# Si on écrit dans un fichier, on le tronque/crée et on redirige stdout
if [[ -n $OUT_FILE ]]; then
  # On s'assure d'avoir le chemin absolu pour la comparaison plus tard
  # (au cas où OUT_FILE est relatif et qu'on change de dossier, bien que ce script ne cd pas)
  touch "$OUT_FILE"
  OUT_FILE="$(realpath "$OUT_FILE")"

  exec >"$OUT_FILE" # redirection de stdout vers le fichier
fi

# Progression – envoyée sur stderr pour ne pas polluer le Markdown
echo "Écriture de la concaténation Markdown vers : ${OUT_FILE:-STDOUT}" >&2
echo "Recherche des fichiers *.nix, *.lock, *.lua, *.md sous : $BASE_DIR" >&2
echo >&2

# ------------------------------------------------------------------
# BOUCLE PRINCIPALE
# ------------------------------------------------------------------
# find avec une clause OR (\( ... -o ... \)) pour les multiples extensions
find "$BASE_DIR" -type f \
  \( -name '*.nix' -o -name '*.lock' -o -name '*.lua' -o -name '*.md' -o -name '*.toml' -o -name '*.yml' -o -name '*.yaml' \) \
  -print0 | sort -z |
  while IFS= read -r -d '' file; do

    # Ignorer le fichier de sortie lui-même s'il se trouve dans le dossier scanné
    # (Crucial maintenant qu'on scanne les .md !)
    if [[ -n $OUT_FILE && $file == "$OUT_FILE" ]]; then
      continue
    fi

    # Chemin relatif – utilisé pour le titre
    rel_path="${file#$BASE_DIR/}"

    # Extraction de l'extension pour la coloration syntaxique (nix, lua, md...)
    ext="${file##*.}"

    # Émettre un titre niveau 2 et le bloc de code avec le bon langage
    printf '## %s\n\n```%s\n' "$rel_path" "$ext"
    cat -- "$file"
    printf '\n```\n\n'

  done

# ------------------------------------------------------------------
# FIN
# ------------------------------------------------------------------
