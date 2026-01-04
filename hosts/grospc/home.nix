# Home: bigor@grospc
# Purpose: Desktop user config with GUI applications
{ ... }:
{
  imports = [ ../../users/bigor ];

  home.stateVersion = "25.11";

  bigor.home.features.gui.enable = true;
}
