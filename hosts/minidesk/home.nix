# Home: bigor@minidesk
# Purpose: Portable desktop user config with GUI applications
{
  home.stateVersion = "25.11";

  bigor.home = {
    # gui.enable is now desktop-apps in NixOS, handled there
    dev-tools.enable = true;
    dev-scripts.enable = true;
  };
}
