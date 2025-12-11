{...}: {
  # ============================================================================
  # Core System Modules
  # ============================================================================
  # These modules form the base system configuration shared by all hosts.
  # It includes options, system defaults, locale, users, and core packages.
  # ============================================================================
  imports = [
    ./options.nix
    ./system.nix
    ./locale.nix
    ./users.nix
    ./packages.nix
    ./nixvim
  ];
}
