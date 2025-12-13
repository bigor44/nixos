{...}: {
  # ============================================================================
  # Home Manager Entry Point
  # ============================================================================
  # Defines the user environment for 'bigor', including shell configuration,
  # GUI applications, git settings, and dotfiles management.
  # ============================================================================
  home = {
    username = "bigor";
    homeDirectory = "/home/bigor";
    stateVersion = "25.05";
  };
  imports = [
    ./packages.nix
    ./shell.nix
    ./git.nix
    ./dotfiles.nix
  ];
}
