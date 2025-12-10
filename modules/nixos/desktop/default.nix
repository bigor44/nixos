{...}: {
  # ============================================================================
  # Desktop Environment Modules
  # ============================================================================
  # Aggregates configuration for the graphical user interface, including
  # the COSMIC desktop environment, fonts, audio subsystems, and gaming setup.
  # ============================================================================
  imports = [
    ./base.nix
    ./desktop-env.nix
    ./fonts.nix
    ./gaming.nix
  ];
}
