{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./options.nix
    ./keymaps.nix
    ./plugins/ui.nix
    ./plugins/lsp.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # ========================================================================== #
    #  EXTRA DEPENDENCIES
    # ========================================================================== #
    extraPackages = with pkgs; [
      wl-clipboard
      gcc
    ];
  };
}
