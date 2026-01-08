# Module: features.git
# Purpose: Git configuration and Zsh shell aliases
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.home.features.git;
in
{
  options.bigor.home.features.git.enable = mkEnableOption "Git configuration";

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings.user = {
        name = "Yoann Bigor";
        email = "bigor44@gmail.com";
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
