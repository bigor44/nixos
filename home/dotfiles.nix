{
  config,
  lib,
  ...
}: {
  # ============================================================================
  # Dotfiles Management
  # ============================================================================
  # Manages symbolic links for configuration files stored in the 'dotfiles' directory.
  # Uses 'mkOutOfStoreSymlink' to point directly to the git repository for live editing.
  # ============================================================================
  xdg.configFile = {
    cosmic.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/cosmic";
    autostart.source = lib.mkForce ../dotfiles/autostart;
  };
}
