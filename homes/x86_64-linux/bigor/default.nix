# ============================================================================
# File: homes/x86_64-linux/bigor/default.nix
# Description: Default Home Manager configuration for 'bigor'.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
_: {
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
  };
}
