# ============================================================================
# File: homes/x86_64-linux/bigor@grospc/default.nix
# Description: Home Manager configuration for 'bigor' on 'grospc'.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
_: {
  # Set the Home Manager state version.
  home.stateVersion = "25.11";

  # User-specific settings for 'bigor' on this host.
  bigor.home = {
    # Enable the graphical user interface and related applications.
    features.gui.enable = true;
  };
}
