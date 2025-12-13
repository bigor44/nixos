{
  # ============================================================================
  # Home Manager Configuration (bigor@minipc)
  # ============================================================================
  # Entry point for the 'bigor' user on the 'minipc' host.
  # Enables only core shell and CLI tools (headless environment).
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
  };
}
