# Module: shell.starship
# Purpose: Starship prompt configuration
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
    };
  };
}
