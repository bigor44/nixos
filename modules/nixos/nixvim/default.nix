{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Import modularized configuration
    imports = [
      ./options.nix
      ./plugins.nix
    ];

    keymaps = import ./keymaps.nix;
  };
}
