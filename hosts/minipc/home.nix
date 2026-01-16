# Home: bigor@minipc
# Purpose: Server user config (minimal, no GUI)
{
  home.stateVersion = "25.11";

  bigor.home = {
    # Optional features
    nixvim.enable = true;
    dev-tools.enable = true;
    dev-scripts.enable = true;
  };
}
