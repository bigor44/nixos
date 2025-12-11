#!/usr/bin/env bash
set -e

# Ensure we are in the project root (simple check)
if [ ! -d "systems" ]; then
  echo "Error: 'systems' directory not found. Please run this script from the root of the flake repository."
  exit 1
fi

# 1. Ask for hostname
read -rp "Enter target hostname: " HOSTNAME_VAR

if [ -z "$HOSTNAME_VAR" ]; then
  echo "Error: Hostname cannot be empty."
  exit 1
fi

TARGET_DIR="systems/x86_64-linux/$HOSTNAME_VAR"
TARGET_CONFIG="$TARGET_DIR/default.nix"

# Check if target directory exists
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Directory '$TARGET_DIR' does not exist."
  echo "Please create the host directory and a basic 'default.nix' first."
  exit 1
fi

# 2. Copy hardware-configuration.nix
SOURCE_HW_CONFIG="/etc/nixos/hardware-configuration.nix"

if [ -f "$SOURCE_HW_CONFIG" ]; then
  echo "Copying $SOURCE_HW_CONFIG to $TARGET_DIR/..."
  cp "$SOURCE_HW_CONFIG" "$TARGET_DIR/hardware-configuration.nix"
  # Ensure it's tracked by git if needed, or just let the user handle it.
  # We won't git add automatically to avoid assuming too much.
else
  echo "Warning: '$SOURCE_HW_CONFIG' not found. Skipping copy."
fi

# 3. Update stateVersion in host configuration
if [ -f "$TARGET_CONFIG" ]; then
  # Detect current NixOS version (Major.Minor)
  if command -v nixos-version &>/dev/null; then
    CURRENT_VERSION=$(nixos-version | cut -d. -f1,2)
    echo "Detected NixOS version: $CURRENT_VERSION"

    echo "Updating system.stateVersion in $TARGET_CONFIG..."
    # Using temp file for sed to ensure atomicity and compatibility (BSD/GNU sed differences mostly avoided this way but standard Linux sed -i is fine)
    sed -i "s/system\.stateVersion[[:space:]]*=[[:space:]]*\".*\";/system.stateVersion = \"$CURRENT_VERSION\";/" "$TARGET_CONFIG"

    echo "Done."
  else
    echo "Warning: 'nixos-version' command not found. Cannot automatically update stateVersion."
  fi
else
  echo "Error: '$TARGET_CONFIG' not found. Cannot update stateVersion."
fi
