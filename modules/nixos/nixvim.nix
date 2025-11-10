/*
  Title: Neovim Configuration
  Description: Configures Neovim with various plugins and settings using NixVim.
*/
{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Global options
    opts = {
      number = true;
      relativenumber = true;
      autoindent = true;
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      smartindent = true;
      mouse = "a";
      clipboard = "unnamedplus";
      ignorecase = true;
      smartcase = true;
      termguicolors = true;
      signcolumn = "yes";
      updatetime = 250;
      timeoutlen = 300;
      completeopt = "menu,menuone,noselect";
      undofile = true;
      cursorline = true;
    };

    # Global settings
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # Color scheme
    colorschemes.tokyonight = {
      enable = true;
      settings = {
        style = "moon";
        transparent = false;
      };
    };

    # Plugins
    plugins = {
      # LSP
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true; # Nix LSP
          bashls.enable = true; # Bash LSP
          marksman.enable = true; # Markdown LSP
        };
        keymaps = {
          diagnostic = {
            "<leader>e" = "open_float";
            "[d" = "goto_prev";
            "]d" = "goto_next";
            "<leader>q" = "setloclist";
          };
          lspBuf = {
            "gD" = "declaration";
            "gd" = "definition";
            "K" = "hover";
            "gi" = "implementation";
            "<C-k>" = "signature_help";
            "<leader>wa" = "add_workspace_folder";
            "<leader>wr" = "remove_workspace_folder";
            "<leader>D" = "type_definition";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
            "gr" = "references";
          };
        };
      };

      # Auto-formatting
      lsp-format.enable = true;

      # Autocompletion
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          mapping = {
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
      };

      # Snippet engine
      luasnip.enable = true;
      cmp_luasnip.enable = true;

      # Treesitter
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          incremental_selection.enable = true;
        };
      };

      treesitter-context = {
        enable = true;
        settings = {
          max_lines = 3;
        };
      };

      # Status line
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "tokyonight";
            icons_enabled = true;
            component_separators = {
              left = "|";
              right = "|";
            };
            section_separators = {
              left = "";
              right = "";
            };
          };
        };
      };

      # File explorer
      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
          window = {
            width = 30;
          };
        };
      };

      # Telescope - Fuzzy finder
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = {
            action = "find_files";
            options.desc = "Find files";
          };
          "<leader>fg" = {
            action = "live_grep";
            options.desc = "Live grep";
          };
          "<leader>fb" = {
            action = "buffers";
            options.desc = "Find buffers";
          };
          "<leader>fh" = {
            action = "help_tags";
            options.desc = "Help tags";
          };
        };
        extensions = {
          fzf-native.enable = true;
        };
      };

      # Git integration
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
          signs = {
            add.text = "│";
            change.text = "│";
            delete.text = "_";
            topdelete.text = "‾";
            changedelete.text = "~";
            untracked.text = "┆";
          };
        };
      };

      # UI enhancements
      noice = {
        enable = true;
      };

      web-devicons.enable = true;

      # Indent guides
      indent-blankline = {
        enable = true;
        settings = {
          scope.enabled = true;
        };
      };

      # Highlight current word
      illuminate = {
        enable = true;
        settings = {
          under_cursor = false;
          filetypes_denylist = [
            "neo-tree"
            "TelescopePrompt"
          ];
        };
      };

      # Auto pairs
      nvim-autopairs.enable = true;

      # Comments
      comment.enable = true;

      # Better navigation
      which-key = {
        enable = true;
        settings = {
          delay = 500;
          spec = [
            {
              __unkeyed-1 = "<leader>f";
              group = "Find";
            }
            {
              __unkeyed-1 = "<leader>w";
              group = "Workspace";
            }
            {
              __unkeyed-1 = "<leader>c";
              group = "Code";
            }
          ];
        };
      };

      # Breadcrumbs
      navbuddy = {
        enable = true;
        settings = {
          lsp.auto_attach = true;
        };
      };

      # Colorizer for color codes
      colorizer = {
        enable = true;
        settings = {
          user_default_options = {
            names = false;
          };
        };
      };

      # Spell checking
      # Note: NixVim doesn't have a spell plugin, it's built into vim
    };

    # Additional vim options for spell checking
    extraConfigVim = ''
      set spell
      set spelllang=en,fr
    '';

    # Key mappings
    keymaps = [
      # File explorer
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<cr>";
        options.desc = "Toggle file explorer";
      }

      # Better window navigation
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options.desc = "Move to left window";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options.desc = "Move to bottom window";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options.desc = "Move to top window";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Move to right window";
      }

      # Resize windows
      {
        mode = "n";
        key = "<C-Up>";
        action = "<cmd>resize +2<cr>";
        options.desc = "Increase window height";
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = "<cmd>resize -2<cr>";
        options.desc = "Decrease window height";
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = "<cmd>vertical resize -2<cr>";
        options.desc = "Decrease window width";
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = "<cmd>vertical resize +2<cr>";
        options.desc = "Increase window width";
      }

      # Better indenting
      {
        mode = "v";
        key = "<";
        action = "<gv";
        options.desc = "Indent left";
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
        options.desc = "Indent right";
      }

      # Move text up and down
      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
        options.desc = "Move text down";
      }
      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
        options.desc = "Move text up";
      }

      # Clear search highlighting
      {
        mode = "n";
        key = "<leader>h";
        action = "<cmd>nohlsearch<cr>";
        options.desc = "Clear search highlights";
      }

      # Buffer navigation
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<cr>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprevious<cr>";
        options.desc = "Previous buffer";
      }
    ];

    # Extra packages needed
    extraPackages = with pkgs; [
      # LSP servers
      nil
      bash-language-server
      marksman

      # Formatters
      nixfmt-rfc-style
      shfmt

      # Ripgrep for telescope
      ripgrep
      fd
    ];
  };
}
