# ============================================================================
# File: homes/x86_64-linux/bigor/default.nix
# Description: Default Home Manager configuration for 'bigor'.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{ config, ... }:
{
  home = {
    username = "bigor";
    homeDirectory = "/home/bigor";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
  bigor.home = {
    git.enable = true;
    shell.enable = true;
    cli-packages.enable = true;
    nixvim.enable = true;
    sops.enable = true;
  };

  # Export ANTHROPIC_API_KEY from sops secret for avante.nvim
  programs.fish.interactiveShellInit = ''
    if test -f ${config.sops.secrets.anthropic_api_key.path}
      set -gx ANTHROPIC_API_KEY (cat ${config.sops.secrets.anthropic_api_key.path})
    end
  '';
}
