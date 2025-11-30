#!/usr/bin/env bash
#
# concat_config.sh
#
# Scans ~/nixos/ and builds a *Markdown* document containing:
#     * a level 2 heading with the relative path of the file
#     * a code block (fenced code block) with the content of the file
#
# Handled extensions: .nix, .lock, .lua, .md
#
# Usage :
#   ./concat_nix_md.sh            # prints the Markdown to STDOUT
#   ./concat_nix_md.sh /tmp/all.md   # writes the Markdown to /tmp/all.md

set -euo pipefail

# ------------------------------------------------------------------
# CONFIGURATION
# ------------------------------------------------------------------
BASE_DIR="$HOME/nixos" # directory to scan

# ------------------------------------------------------------------
# ARGUMENTS
# ------------------------------------------------------------------
OUT_FILE=${1:-} # empty → stdout

# If writing to a file, truncate/create it and redirect stdout
if [[ -n $OUT_FILE ]]; then
  # Ensure we have the absolute path for later comparison
  # (in case OUT_FILE is relative and we change directory, although this script does not cd)
  touch "$OUT_FILE"
  OUT_FILE="$(realpath "$OUT_FILE")"

  exec >"$OUT_FILE" # redirect stdout to the file
fi

# Progress – sent to stderr to avoid polluting the Markdown
echo "Writing Markdown concatenation to: ${OUT_FILE:-STDOUT}" >&2
echo "Searching for *.nix, *.lock, *.lua, *.md files under: $BASE_DIR" >&2
echo >&2

# ------------------------------------------------------------------
# MAIN LOOP
# ------------------------------------------------------------------
# find with an OR clause (\( ... -o ... \)) for multiple extensions
find "$BASE_DIR" -type f \
  \( -name '*.nix' -o -name '*.lock' -o -name '*.lua' -o -name '*.md' -o -name '*.toml' -o -name '*.yml' -o -name '*.yaml' \) \
  -print0 | sort -z |
  while IFS= read -r -d '' file; do

    # Ignore the output file itself if it is in the scanned folder
    # (Crucial now that we scan .md!)
    if [[ -n $OUT_FILE && $file == "$OUT_FILE" ]]; then
      continue
    fi

    # Relative path – used for the title
    rel_path="${file#$BASE_DIR/}"

    # Extract extension for syntax highlighting (nix, lua, md...)
    ext="${file##*.}"

    # Output a level 2 title and the code block with the correct language
    printf '## %s\n\n```%s\n' "$rel_path" "$ext"
    cat -- "$file"
    printf '\n```\n\n'

  done

# ------------------------------------------------------------------
# END
# ------------------------------------------------------------------
