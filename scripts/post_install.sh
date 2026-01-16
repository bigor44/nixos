#!/usr/bin/env bash
# Script: post_install.sh
# Purpose: Automates the initial setup of a new host (hardware config copy, stateVersion update)

set -e

# Ensure we are in the project root
if [ ! -d "hosts" ]; then
  echo "Error: 'hosts' directory not found. Please run this script from the root of the flake repository."
  exit 1
fi

# 1. Hostname Selection
read -rp "Enter target hostname: " HOSTNAME_VAR

if [ -z "$HOSTNAME_VAR" ]; then
  echo "Error: Hostname cannot be empty."
  exit 1
fi

TARGET_DIR="hosts/$HOSTNAME_VAR"
TARGET_CONFIG="$TARGET_DIR/default.nix"

if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Directory '$TARGET_DIR' does not exist."
  echo "Please create the host directory and a basic 'default.nix' first."
  exit 1
fi

# 2. Hardware Configuration
SOURCE_HW_CONFIG="/etc/nixos/hardware-configuration.nix"

if [ -f "$SOURCE_HW_CONFIG" ]; then
  echo "Copying $SOURCE_HW_CONFIG to $TARGET_DIR/"
  cp "$SOURCE_HW_CONFIG" "$TARGET_DIR/hardware-configuration.nix"
else
  echo "Warning: '$SOURCE_HW_CONFIG' not found. Skipping copy."
fi

# 3. State Version Update
if [ -f "$TARGET_CONFIG" ]; then
  if command -v nixos-version &>/dev/null; then
    CURRENT_VERSION=$(nixos-version | cut -d. -f1,2)
    echo "Detected NixOS version: $CURRENT_VERSION"

    echo "Updating system.stateVersion in $TARGET_CONFIG..."
    # Using temp file for sed to ensure atomicity and compatibility
    sed -i "s/system\.stateVersion[[:space:]]*=[[:space:]]*\".*\";/system.stateVersion = \"$CURRENT_VERSION\";/" "$TARGET_CONFIG"

    echo "Done."
  else
    echo "Warning: 'nixos-version' command not found. Cannot automatically update stateVersion."
  fi
else
  echo "Error: '$TARGET_CONFIG' not found. Cannot update stateVersion."
fi

# 4. Home Manager State Version Update
TARGET_HOME_CONFIG="hosts/$HOSTNAME_VAR/home.nix"

if [ -f "$TARGET_HOME_CONFIG" ]; then
  if [ -n "$CURRENT_VERSION" ]; then
    echo "Updating home.stateVersion in $TARGET_HOME_CONFIG..."
    sed -i "s/home\.stateVersion[[:space:]]*=[[:space:]]*\".*\";/home.stateVersion = \"$CURRENT_VERSION\";/" "$TARGET_HOME_CONFIG"
    echo "Done."
  else
    echo "Warning: Cannot update home.stateVersion because system version was not determined."
  fi
else
  echo "Warning: '$TARGET_HOME_CONFIG' not found. Skipping Home Manager stateVersion update."
fi
