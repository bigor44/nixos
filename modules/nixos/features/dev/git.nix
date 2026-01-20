# Feature: dev-git
# Purpose: Git configuration and Zsh shell aliases
{ config, lib, ... }:
let
  cfg = config.bigor.features.dev.git;
in
{
  options.bigor.features.dev.git.enable = lib.mkEnableOption "Git configuration";

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      config = {
        user = {
          name = "Yoann Bigor";
          email = "bigor44@gmail.com";
        };
      };
    };

    programs.zsh.shellAliases = {
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
