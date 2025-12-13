{...}: {
  # ============================================================================
  # Common System Modules
  # ============================================================================
  # Imports standard modules shared across all NixOS systems.
  # ============================================================================
  imports = [
    ./options.nix
    ./system.nix
    ./locales.nix
    ./users.nix
    ./packages.nix
  ];
}
