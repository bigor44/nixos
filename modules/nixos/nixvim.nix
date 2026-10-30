# Platform: nixvim
# Purpose: Neovim built by nixvim (config baked into the wrapper): mini.nvim, treesitter, LSP for Nix and shell
{ lib, pkgs, ... }:
let
  # Nix expression *text* spliced into nixd's settings; nixd evaluates it at runtime
  # against the live checkout, so option completion follows uncommitted edits
  flake = ''(builtins.getFlake "/home/bigor/nixos")'';
in
{
  programs.nixvim = {
    enable = true;
    # Use the system's nixpkgs instance rather than evaluating a second one
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
      # Fires CursorHold and writes the swap file sooner (default 4 s)
      updatetime = 250;
      # noselect: mini.completion opens the menu without inserting the first match
      completeopt = "menuone,noselect,fuzzy";
    };
    # Yank/paste through the Wayland system clipboard
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
    # mini.nvim covers UI, editing and navigation; other plugins only fill its gaps
    plugins = {
      mini-icons = {
        enable = true;
        # Stand in for nvim-web-devicons so plugins expecting it still get icons
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
        # __raw passes the string through as Lua instead of serializing it.
        # %f[%w]…%f[%W] are Lua frontier patterns: whole words only; the empty () mark the highlighted span
        settings.highlighters = {
          fixme.__raw = "{ pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' }";
          todo.__raw = "{ pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' }";
          note.__raw = "{ pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' }";
          hex_color.__raw = "require('mini.hipatterns').gen_highlighter.hex_color()";
        };
      };
      mini-ai.enable = true;
      mini-surround.enable = true;
      mini-pairs.enable = true;
      mini-move.enable = true;
      mini-splitjoin.enable = true;
      mini-bracketed.enable = true;
      mini-bufremove.enable = true;
      mini-files.enable = true;
      mini-pick.enable = true;
      mini-extra.enable = true;
      mini-diff.enable = true;
      mini-git.enable = true;
      # Which-key style popup: lists the next keys after one of these prefixes
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
          # Group labels for the <Leader> keymaps below, plus mini.clue's generated clues for built-in keys
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
      mini-completion.enable = true;
      mini-snippets = {
        enable = true;
        # Loads snippets by buffer language from friendly-snippets' collection
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
      # Only provides the default server configs; servers are started by nixvim's native `lsp` below
      lspconfig.enable = true;
      # mini.nvim has no formatter runner
      conform-nvim = {
        enable = true;
        # Puts the formatters listed below on Neovim's PATH from nixpkgs
        autoInstall.enable = true;
        settings = {
          formatters_by_ft = {
            nix = [ "nixfmt" ];
            sh = [ "shfmt" ];
            bash = [ "shfmt" ];
            fish = [ "fish_indent" ];
          };
          # Fall back to the LSP formatter for filetypes with no entry above
          format_on_save = {
            timeout_ms = 1000;
            lsp_format = "fallback";
          };
        };
      };
    };
    lsp = {
      servers = {
        # "*" applies to every server: tell them mini.completion handles snippets and item resolve
        "*".config.capabilities.__raw = "MiniCompletion.get_lsp_capabilities()";
        nixd = {
          enable = true;
          # Each expr is evaluated by nixd: pkgs from the flake's own lock, options from
          # grospc. Home Manager options are read from the submodule type of `home-manager.users`
          config.settings.nixd = {
            nixpkgs.expr = "import ${flake}.inputs.nixpkgs { }";
            formatting.command = [ (lib.getExe pkgs.nixfmt) ];
            options = {
              nixos.expr = "${flake}.nixosConfigurations.grospc.options";
              home-manager.expr = "${flake}.nixosConfigurations.grospc.options.home-manager.users.type.getSubOptions [ ]";
            };
          };
        };
        bashls = {
          enable = true;
          # Appended to the server's PATH: bash-language-server lints with shellcheck when it finds it
          packages.suffix = [ pkgs.shellcheck ];
        };
        fish_lsp.enable = true;
      };
      # Buffer-local, set on LspAttach; Neovim 0.11+ already provides K, grn, gra, grr, gri, gO
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
    # Global keymaps; <leader> groups match the mini.clue labels (b, c, f, g)
    keymaps = [
      # Window focus and resize
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
      # Re-select after indenting so repeated < / > keep working on the same lines
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
      {
        mode = "n";
        key = "<leader>e";
        # Opens the explorer on the current file instead of the working directory
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
      {
        mode = "n";
        key = "<leader>bd";
        # Unlike :bdelete, keeps the window layout
        action.__raw = "function() MiniBufremove.delete() end";
        options.desc = "Delete buffer";
      }
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
  # Session-wide so every program, not only fish, opens Neovim as the editor
  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
