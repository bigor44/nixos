{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.bigor.home.nixvim;
in {
  imports = [
    ./opts.nix
    ./keymaps.nix
    ./autocmds.nix
    ./plugins
  ];

  options.bigor.home.nixvim = {
    enable = lib.mkEnableOption "Enable NixVim configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      extraPackages = with pkgs; [
        wl-clipboard

        # LSP
        nodePackages.bash-language-server
        marksman
        pyright
        vscode-langservers-extracted
        yaml-language-server
        lua-language-server
        nil

        # Formatters / Linters
        alejandra
        stylua
        selene
        shfmt
        prettier
        isort
        black
        taplo
      ];
    };
  };
}
