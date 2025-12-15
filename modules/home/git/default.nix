{
  config,
  lib,
  ...
}:
# ============================================================================
# File: modules/home/git/default.nix
# Description: Git Configuration
# Author: Bigor
# Date: 2025-12-15
# Purpose: Configures Git with user identity and defines a comprehensive set
#          of Fish shell abbreviations for common Git workflows.
# ============================================================================

with lib;
let
  cfg = config.bigor.home.git;
in
{
  options.bigor.home.git = {
    enable = mkEnableOption "Enable user git configuration";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings.user = {
        name = "Yoann Bigor";
        email = "bigor44@gmail.com";
      };
    };

    # ==========================================================================
    # Shell Abbreviations
    # ==========================================================================
    programs.fish.shellAbbrs = {
      g = "git";
      gaa = "git add -A";
      gc = "git commit";
      gcm = "git commit -m";
      gca = "git commit --amend";
      gd = "git diff";
      gds = "git diff --staged";
      gl = "git pull";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gst = "git status";
      gco = "git checkout";
      gcb = "git checkout -b";
      gb = "git branch";
      glog = "git log --oneline --graph --decorate";
    };
  };
}
