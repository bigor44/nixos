{pkgs, ...}: {
  imports = [./plugins];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    globals = {
      mapleader = " ";
      maplocalleader = "\\";
    };

    opts = import ./opts.nix;
    keymaps = import ./keymaps.nix;

    extraConfigLua = ''
      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function() vim.highlight.on_yank{timeout=250} end,
      })
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*", callback = function()
          vim.opt_local.formatoptions:remove{"r","o"}
        end,
      })
    '';

    /*
    ↓  binaries for LSP, formatters, telescope
    */
    extraPackages = with pkgs; [
      nixd
      alejandra
      bash-language-server
      marksman
      shfmt
      ripgrep
      fd
      statix
      deadnix
    ];
  };
}
