{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraConfigLua = ''
      vim.g.sonokai_style = "andromeda"
      vim.g.sonokai_better_performance = 1
      vim.cmd("colorscheme sonokai")
    '';

    extraPlugins = with pkgs.vimPlugins; [
      sonokai
    ];

    globals.mapleader = " ";

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      ignorecase = true;
      smartcase = true;
      termguicolors = true;
      scrolloff = 8;
      sidescrolloff = 8;
      updatetime = 50;
    };

    plugins = {
      # UI Plugins
      lualine.enable = true;
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
        };
      };
      neo-tree = {
        enable = true;
        settings.close_if_last_window = true;
      };
      which-key.enable = true;
      web-devicons.enable = true;

      # Treesitter
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      # LSP
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          pyright.enable = true;
          lua_ls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          gopls.enable = true;
        };
      };

      # Completion
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "luasnip"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };
      cmp-nvim-lsp.enable = true;
      luasnip.enable = true;

      # Formatting
      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            lspFallback = true;
            timeoutMs = 500;
          };
          formatters_by_ft = {
            nix = [ "nixfmt" ];
            python = [
              "isort"
              "black"
            ];
            lua = [ "stylua" ];
            rust = [ "rustfmt" ];
            go = [ "gofmt" ];
            "_" = [ "trim_whitespace" ];
          };
        };
      };
    };

    # Extra packages required for tools not automatically installed by plugins
    extraPackages = with pkgs; [
      ripgrep
      fd
      nixfmt-rfc-style
      stylua
      isort
      black
    ];
  };
}
