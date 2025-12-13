{
  # ============================================================================
  # Home Manager Configuration (bigor@grospc)
  # ============================================================================
  # Entry point for the 'bigor' user on the 'grospc' host.
  # Enables full desktop environment, GUI apps, and development tools.
  # ============================================================================
  home = {
    username = "bigor";
    homeDirectory = "/home/bigor";
    stateVersion = "25.05";
  };
  bigor.home = {
    git.enable = true;
    shell.enable = true;
    cli-packages.enable = true;
    nixvim.enable = true;
    gui-packages.enable = true;
  };
}
