# Platform: dev
# Purpose: Git, GitHub CLI, toolchains, Neovim and Claude Code (QA tooling lives in the flake formatter, nix/checks.nix)
{ pkgs, ... }:
{
  programs = {
    git = {
      enable = true;
      # Same hosts Home Manager's gh module registered; the user identity stays in Home Manager
      config.credential = {
        "https://github.com".helper = "${pkgs.gh}/bin/gh auth git-credential";
        "https://gist.github.com".helper = "${pkgs.gh}/bin/gh auth git-credential";
      };
    };

    fish.shellAliases = {
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

  environment = {
    systemPackages = with pkgs; [
      gh
      claude-code
      gcc
      gnumake
      # Plain package: the whole config comes from the dotfiles/nvim symlink
      neovim
      python3
      # Global pip installs fail on NixOS; uv manages per-project venvs instead
      uv
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
