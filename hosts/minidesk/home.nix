# Home: bigor@minidesk
# Purpose: Portable desktop user config with GUI applications
{ ... }:
{
  imports = [ ../../users/bigor ];

  home.stateVersion = "25.11";

  bigor.home.features = {
    dev-scripts.enable = true;
    gui.enable = true;
  };
}
