# Platform: nixvim
# Purpose: Neovim built by nixvim: tokyonight night, mini.nvim suite, LSP + completion for Nix and shell
{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    # Reuse the system pkgs instead of a second nixpkgs evaluation
    nixpkgs.useGlobalPackages = true;
    viAlias = true;
    vimAlias = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    opts = {
      number = true;
      relativenumber = true;
      signcolumn = "yes";
      cursorline = true;
      scrolloff = 8;

      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;

      wrap = false;
      ignorecase = true;
      smartcase = true;
      splitright = true;
      splitbelow = true;
      undofile = true;
      updatetime = 250;
      # mini.completion drives the popup; noselect avoids inserting the first item on its own
      completeopt = "menuone,noselect,fuzzy";
    };
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    colorschemes.tokyonight = {
      enable = true;
      settings.style = "night";
    };

    diagnostic.settings = {
      virtual_text = true;
      severity_sort = true;
      float.border = "rounded";
    };

    plugins = {
      # --- mini.nvim: UI ---
      mini-icons = {
        enable = true;
        mockDevIcons = true;
      };
      mini-statusline.enable = true;
      mini-tabline.enable = true;
      mini-notify.enable = true;
      mini-indentscope.enable = true;
      mini-cursorword.enable = true;
      mini-trailspace.enable = true;
      mini-starter.enable = true;
      mini-hipatterns = {
        enable = true;
        settings.highlighters = {
          fixme.__raw = "{ pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' }";
          todo.__raw = "{ pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' }";
          note.__raw = "{ pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' }";
          hex_color.__raw = "require('mini.hipatterns').gen_highlighter.hex_color()";
        };
      };

      # --- mini.nvim: editing ---
      mini-ai.enable = true;
      mini-surround.enable = true;
      mini-pairs.enable = true;
      mini-move.enable = true;
      mini-splitjoin.enable = true;
      mini-bracketed.enable = true;
      mini-bufremove.enable = true;

      # --- mini.nvim: navigation and git ---
      mini-files.enable = true;
      mini-pick.enable = true;
      mini-extra.enable = true;
      mini-diff.enable = true;
      mini-git.enable = true;
      mini-clue = {
        enable = true;
        settings = {
          triggers = [
            {
              mode = "n";
              keys = "<Leader>";
            }
            {
              mode = "x";
              keys = "<Leader>";
            }
            {
              mode = "n";
              keys = "g";
            }
            {
              mode = "n";
              keys = "[";
            }
            {
              mode = "n";
              keys = "]";
            }
            {
              mode = "n";
              keys = "<C-w>";
            }
            {
              mode = "n";
              keys = "z";
            }
          ];
          clues.__raw = ''
            {
              { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
              { mode = "n", keys = "<Leader>c", desc = "+Code" },
              { mode = "n", keys = "<Leader>f", desc = "+Find" },
              { mode = "n", keys = "<Leader>g", desc = "+Git" },
              require("mini.clue").gen_clues.builtin_completion(),
              require("mini.clue").gen_clues.g(),
              require("mini.clue").gen_clues.windows(),
              require("mini.clue").gen_clues.z(),
            }
          '';
          window.delay = 300;
        };
      };

      # --- mini.nvim: completion ---
      # LSP items via completefunc, buffer words as fallback; snippets expand through mini.snippets
      mini-completion.enable = true;
      mini-snippets = {
        enable = true;
        settings.snippets.__raw = ''{ require("mini.snippets").gen_loader.from_lang() }'';
      };
      friendly-snippets.enable = true;

      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      lspconfig.enable = true;

      # Not part of mini.nvim: formatting by external tools is out of its scope
      conform-nvim = {
        enable = true;
        autoInstall.enable = true;
        settings = {
          formatters_by_ft = {
            nix = [ "nixfmt" ];
            sh = [ "shfmt" ];
            bash = [ "shfmt" ];
            fish = [ "fish_indent" ];
          };
          format_on_save = {
            timeout_ms = 1000;
            lsp_format = "fallback";
          };
        };
      };
    };

    lsp = {
      servers = {
        # Advertise mini.completion's capabilities (snippets, resolve) to every server
        "*".config.capabilities.__raw = "MiniCompletion.get_lsp_capabilities()";

        nil_ls = {
          enable = true;
          config.settings.nil.formatting.command = [ "nixfmt" ];
        };
        # bash-language-server runs shellcheck for diagnostics when found on PATH
        bashls = {
          enable = true;
          packages.suffix = [ pkgs.shellcheck ];
        };
        fish_lsp.enable = true;
      };

      # Neovim 0.11 already maps K, grn, gra, grr, gri, gO and <C-s>
      keymaps = [
        {
          key = "gd";
          lspBufAction = "definition";
          options.desc = "Go to definition";
        }
        {
          key = "gD";
          lspBufAction = "declaration";
          options.desc = "Go to declaration";
        }
        {
          key = "<leader>cr";
          lspBufAction = "rename";
          options.desc = "Rename symbol";
        }
        {
          key = "<leader>ca";
          lspBufAction = "code_action";
          options.desc = "Code action";
        }
      ];
    };

    keymaps = [
      # Windows
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
      }
      {
        mode = "n";
        key = "<C-Up>";
        action = "<cmd>resize -2<CR>";
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = "<cmd>resize +2<CR>";
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = "<cmd>vertical resize -2<CR>";
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = "<cmd>vertical resize +2<CR>";
      }
      {
        mode = "v";
        key = "<";
        action = "<gv";
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
      }
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
      }

      # Files and pickers
      {
        mode = "n";
        key = "<leader>e";
        action.__raw = "function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end";
        options.desc = "File explorer";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Pick files<CR>";
        options.desc = "Files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Pick grep_live<CR>";
        options.desc = "Live grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Pick buffers<CR>";
        options.desc = "Buffers";
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>Pick help<CR>";
        options.desc = "Help";
      }
      {
        mode = "n";
        key = "<leader>fr";
        action = "<cmd>Pick resume<CR>";
        options.desc = "Resume picker";
      }
      {
        mode = "n";
        key = "<leader>fd";
        action = "<cmd>Pick diagnostic<CR>";
        options.desc = "Diagnostics";
      }
      {
        mode = "n";
        key = "<leader>fs";
        action = "<cmd>Pick lsp scope='document_symbol'<CR>";
        options.desc = "Document symbols";
      }

      # Buffers
      {
        mode = "n";
        key = "<leader>bd";
        action.__raw = "function() MiniBufremove.delete() end";
        options.desc = "Delete buffer";
      }

      # Code
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>cf";
        action.__raw = "function() require('conform').format({ lsp_format = 'fallback' }) end";
        options.desc = "Format";
      }
      {
        mode = "n";
        key = "<leader>cd";
        action.__raw = "vim.diagnostic.open_float";
        options.desc = "Line diagnostics";
      }
      {
        mode = "n";
        key = "<leader>cw";
        action.__raw = "function() MiniTrailspace.trim() end";
        options.desc = "Trim trailing whitespace";
      }

      # Git
      {
        mode = "n";
        key = "<leader>go";
        action.__raw = "function() MiniDiff.toggle_overlay() end";
        options.desc = "Toggle diff overlay";
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>gs";
        action.__raw = "function() MiniGit.show_at_cursor() end";
        options.desc = "Show at cursor";
      }
    ];
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
