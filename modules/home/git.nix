# Home: git
# Purpose: Per-user git identity; git, gh and the shell abbreviations are system-wide (modules/nixos/dev.nix)
{
  programs.git = {
    enable = true;
    settings.user = {
      name = "Yoann Bigor";
      email = "bigor44@gmail.com";
    };
  };
}
