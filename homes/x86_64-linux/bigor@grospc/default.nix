{
  # ============================================================================
  # Home Manager Configuration (bigor@grospc)
  # ============================================================================
  # Entry point for the 'bigor' user on the 'grospc' host.
  # Enables full desktop environment, GUI apps, and development tools.
  # ============================================================================
  home.stateVersion = "25.11";
  bigor.home = {
    gui-packages.enable = true;
  };
}
