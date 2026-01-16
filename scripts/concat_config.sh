#!/usr/bin/env bash
# Script: concat_config.sh
# Purpose: Aggregates configuration files into single Markdown document for sharing

set -euo pipefail

# ==============================================================================
# Configuration
# ==============================================================================
BASE_DIR="$HOME/nixos"

# ==============================================================================
# Argument Parsing
# ==============================================================================
OUT_FILE=${1:-}

# If an output file is specified, prepare it and redirect stdout.
if [[ -n $OUT_FILE ]]; then
  # Create/Touch the file first to ensure realpath works.
  touch "$OUT_FILE"
  OUT_FILE="$(realpath "$OUT_FILE")"

  # Redirect all subsequent standard output to the file.
  exec >"$OUT_FILE"
fi

# Log progress to stderr to keep stdout clean (if not redirected).
echo "Writing Markdown concatenation to: ${OUT_FILE:-STDOUT}" >&2
echo "Searching for configuration files under: $BASE_DIR" >&2
echo >&2

# ==============================================================================
# Directory Tree Overview
# ==============================================================================
printf '# NixOS Configuration\n\n'
printf '## Directory Structure\n\n```\n'
eza --tree --git-ignore --ignore-glob 'dotfiles' "$BASE_DIR"
printf '\n```\n\n'

# ==============================================================================
# Main Processing Loop
# ==============================================================================
# Find relevant files, handle special characters in filenames with print0/read.
find "$BASE_DIR" -type f \
  -not -path '*/dotfiles/*' \
  \( -name '*.nix' -o -name '*.lock' -o -name '*.lua' -o -name '*.sh' -o -name '*.md' -o -name '*.toml' -o -name '*.yml' -o -name '*.yaml' \) \
  -print0 | sort -z |
  while IFS= read -r -d '' file; do

    # Prevent the script from including its own output file if it's in the path.
    if [[ -n $OUT_FILE && $file == "$OUT_FILE" ]]; then
      continue
    fi

    # Exclude files ignored by git (respects .gitignore)
    if git -C "$BASE_DIR" check-ignore -q "$file"; then
      continue
    fi

    # Compute path relative to the base directory for the section header.
    rel_path="${file#"$BASE_DIR"/}"

    # Extract file extension for Markdown code block syntax highlighting.
    ext="${file##*.}"

    # Generate Markdown Section
    printf '### FILE: %s\n\n```%s\n' "$rel_path" "$ext"
    cat -- "$file"
    printf '\n```\n\n'

  done
