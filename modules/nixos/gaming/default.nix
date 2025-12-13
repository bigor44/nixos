{
  config,
  lib,
  ...
}: {
  # ============================================================================
  # Gaming Configuration
  # ============================================================================
  # Enables Steam and GameMode optimizations for gaming performance.
  # ============================================================================
  config = lib.mkIf config.bigor.roles.desktop {
    programs = {
      gamemode.enable = true;
      steam.enable = true;
    };
  };
}
