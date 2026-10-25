# Home: dev
# Purpose: Development tools, Neovim, and Claude Code (QA tooling lives in the flake formatter, nix/checks.nix)
{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      claude-code
      gcc
      gnumake
      # Plain package: programs.neovim would generate an init.lua clashing with the dotfiles/nvim symlink
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
