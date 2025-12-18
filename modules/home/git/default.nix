# ============================================================================
# File: /home/bigor/nixos/modules/home/git/default.nix
# Description: Configures Git for the user.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{
  config,
  lib,
  ...
}:
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
