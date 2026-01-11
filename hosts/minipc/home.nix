# Home: bigor@minipc
# Purpose: Server user config (minimal, no GUI)
{ ... }:
{
  imports = [ ../../users/bigor ];

  home.stateVersion = "25.11";

  bigor.home.features.dev-scripts.enable = true;
}
