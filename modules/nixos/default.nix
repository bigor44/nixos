{...}: {
  # ============================================================================
  # NixOS Modules Entry Point
  # ============================================================================
  # This module aggregates all core configurations, roles, desktop environments,
  # and system services into a single importable unit.
  # ============================================================================
  imports = [
    ./core
    ./desktop
    ./services
  ];
}
