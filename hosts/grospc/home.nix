# Home: bigor@grospc
# Purpose: Desktop user config with GUI applications
{
  home.stateVersion = "25.11";

  bigor.home = {
    # Optional features
    nixvim.enable = true;
    dev-tools.enable = true;
    dev-scripts.enable = true;

    # Desktop
    gui.enable = true;
    wallpapers.enable = true;
  };
}
