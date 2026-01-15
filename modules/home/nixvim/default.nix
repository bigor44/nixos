# Home: nixvim
# Purpose: Neovim configuration with LSP, treesitter, and completion
{ pkgs, ... }:
{
  imports = [
    ./opts.nix
    ./keymaps.nix
    ./autocmds.nix
    ./plugins
  ];

  programs.nixvim = {
    enable = true;
    extraPackages = with pkgs; [
      wl-clipboard
      gcc

      # Language servers
      nodePackages.bash-language-server
      marksman
      yaml-language-server
      nixd

      # Formatters & linters
      nixfmt
      shfmt
      prettier
      taplo
    ];
  };
}
