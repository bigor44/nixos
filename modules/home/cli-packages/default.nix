{
  config,
  lib,
  pkgs,
  ...
}:
# ============================================================================
# File: modules/home/cli-packages/default.nix
# Description: CLI Tools & Packages
# Author: Bigor
# Date: 2025-12-15
# Purpose: Installs a suite of modern command-line utilities and code quality
#          tools (formatters, linters) for development and system monitoring.
# ============================================================================

with lib;
let
  cfg = config.bigor.home.cli-packages;
in
{
  options.bigor.home.cli-packages = {
    enable = mkEnableOption "Enable user cli packages";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # ========================================================================
      # Modern CLI Replacements
      # ========================================================================
      eza # Modern replacement for ls
      fd # Fast and user-friendly alternative to find
      ripgrep # Line-oriented search tool that recursively searches the current directory
      jq # Command-line JSON processor
      lazygit # Simple terminal UI for git commands

      # ========================================================================
      # Code Quality & Development
      # ========================================================================
      statix # Lints and suggestions for the nix programming language
      deadnix # Find and remove unused code in .nix files
      treefmt # One CLI to format the code tree
      prettier # Opinionated code formatter
      nixfmt-rfc-style # Official Nix formatter

      stylua # An opinionated Lua code formatter
      shfmt # A shell parser, formatter, and interpreter
      isort # Library to sort imports in Python files
      black # The uncompromising Python code formatter
      taplo # A TOML toolkit

      # ========================================================================
      # Network Utilities
      # ========================================================================
      dig # DNS lookup utility

      # ========================================================================
      # Monitoring & Performance
      # ========================================================================
      btop # Resource monitor that shows usage and stats for processor, memory, disks, network and processes
      sysstat # Performance monitoring tools for Linux
      inxi # A full featured CLI system information tool
      pciutils # Collection of programs for inspecting and manipulating configuration of PCI devices
      usbutils # USB device analysis tools
      mesa-demos # Collection of demos and test programs for Mesa
      lm_sensors # Tools for reading hardware sensors
      fastfetch # Like neofetch, but faster because it's written in C

      gemini-cli
    ];
  };
}
