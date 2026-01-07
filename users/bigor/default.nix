# User: bigor
# Purpose: Base user configuration (shell, git, nvim, CLI tools)
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
  };
}
