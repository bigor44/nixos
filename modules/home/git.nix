# Home: git
# Purpose: Git identity (git itself, gh and the git abbreviations live in modules/nixos/dev.nix)
{
  programs.git = {
    enable = true;
    settings.user = {
      name = "Yoann Bigor";
      email = "bigor44@gmail.com";
    };
  };
}
