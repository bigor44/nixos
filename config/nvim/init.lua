-- ========================================================================== --
--  BOOTSTRAP LAZY.NVIM
-- ========================================================================== --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ========================================================================== --
--  OPTIONS GLOBALES & GENERALES (Source: opts.nix & default.nix)
-- ========================================================================== --
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.spelllang = { "en", "fr" }
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.ignorecase = true
opt.smartcase = true
opt.clipboard = "unnamedplus"
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 300
opt.completeopt = "menu,menuone,noselect"
opt.undofile = true
opt.cursorline = true
opt.mouse = "a"

-- Autocommandes (Source: default.nix)
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank({ timeout = 250 }) end,
})
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function() vim.opt_local.formatoptions:remove({ "r", "o" }) end,
})

-- ========================================================================== --
--  KEYMAPS GENERAUX (Source: keymaps.nix)
-- ========================================================================== --
local map = vim.keymap.set

-- General
map("n", "<leader>h", "<cmd>nohl<cr>", { desc = "Clear search highlight" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go left" })
map("n", "<C-j>", "<C-w>j", { desc = "Go down" })
map("n", "<C-k>", "<C-w>k", { desc = "Go up" })
map("n", "<C-l>", "<C-w>l", { desc = "Go right" })

-- Resize
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Height +" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Height -" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Width -" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Width +" })

-- Buffer navigation
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })

-- Text objects / Move Lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- ========================================================================== --
--  PLUGINS
-- ========================================================================== --
require("lazy").setup({

  -- ----------------------------------------------------------------------- --
  -- UI PLUGINS (Source: plugins/ui.nix)
  -- ----------------------------------------------------------------------- --
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        integrations = {
          cmp = true,
          gitsigns = true,
          neotree = true,
          treesitter = true,
          telescope = { enabled = true },
          which_key = true,
          -- Ajout automatique pour les autres plugins standards
          native_lsp = { enabled = true },
          notify = true,
          mini = { enabled = true },
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = true,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- Vous pouvez ajuster les presets ici si besoin
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      scope = { enabled = true },
    },
  },
  { "RRethy/vim-illuminate" },
  { "NvChad/nvim-colorizer.lua", opts = { user_default_options = { names = false } } },

  -- ----------------------------------------------------------------------- --
  -- EDITOR PLUGINS (Source: plugins/editor.nix)
  -- ----------------------------------------------------------------------- --
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-context" },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Comme vous êtes sur NixOS, il est parfois mieux de laisser Nix gérer les grammaires,
        -- mais avec lazy standard, on laisse treesitter faire.
        ensure_installed = { "nix", "lua", "bash", "markdown", "json", "yaml", "vim", "vimdoc", "query" },
        highlight = { enable = true },
        indent = { enable = true },
      })
      require("treesitter-context").setup({ max_lines = 3 })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Explorer" },
    },
    opts = {
      close_if_last_window = true,
      window = { width = 30 },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
        },
      })
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [G]rep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
    end,
  },
  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
    opts = { lsp = { auto_attach = true } },
  },
  {
    "folke/trouble.nvim",
    opts = { auto_open = false, auto_close = true },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  },

-- ----------------------------------------------------------------------- --
  -- LSP & COMPLETION (Syntaxe native Neovim 0.11+)
  -- ----------------------------------------------------------------------- --
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
      "b0o/schemastore.nvim",
    },
    config = function()
      -- On ne fait plus 'require("lspconfig")'
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Liste de vos serveurs
      local servers = { "nixd", "bashls", "marksman", "jsonls", "yamlls" }

      for _, server in ipairs(servers) do
        local opts = { capabilities = capabilities }

        -- Configuration spécifique JSON
        if server == "jsonls" then
          opts.settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          }
        end
        
        -- Configuration spécifique YAML
        if server == "yamlls" then
          opts.settings = {
            yaml = {
              schemaStore = { enable = false, url = "" },
              schemas = require("schemastore").yaml.schemas(),
            },
          }
        end

        -- NOUVELLE SYNTAXE :
        -- 1. On définit la configuration (fusionne avec les défauts de nvim-lspconfig)
        vim.lsp.config(server, opts)
        -- 2. On active le serveur
        vim.lsp.enable(server)
      end

      -- Keymaps LSP (reste inchangé, c'est la bonne méthode)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          local map = vim.keymap.set
          map("n", "gD", vim.lsp.buf.declaration, opts)
          map("n", "gd", vim.lsp.buf.definition, opts)
          map("n", "K", vim.lsp.buf.hover, opts)
          map("n", "gi", vim.lsp.buf.implementation, opts)
          map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          map("n", "gr", vim.lsp.buf.references, opts)
          map("n", "<leader>rn", vim.lsp.buf.rename, opts)
          map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          map("n", "<leader>D", vim.lsp.buf.type_definition, opts)
          -- Diagnostics
          map("n", "<leader>e", vim.diagnostic.open_float, opts)
          map("n", "[d", vim.diagnostic.goto_prev, opts)
          map("n", "]d", vim.diagnostic.goto_next, opts)
          map("n", "<leader>q", vim.diagnostic.setloclist, opts)
        end,
      })
    end,
  },




  -- ----------------------------------------------------------------------- --
  -- DEBUG (Source: plugins/debug.nix)
  -- ----------------------------------------------------------------------- --
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
      })

      vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "BP toggle" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug start" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<leader>du", dap.step_out, { desc = "Step out" })
      vim.keymap.set("n", "<leader>dui", dapui.toggle, { desc = "DAP UI" })
    end,
  },

  -- ----------------------------------------------------------------------- --
  -- UTILS (Source: plugins/utils.nix)
  -- ----------------------------------------------------------------------- --
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = 20,
      open_mapping = [[<C-\>]],
      direction = "float",
      float_opts = { border = "curved" },
    },
  },
  { "kylechui/nvim-surround", version = "*", event = "VeryLazy", config = true },
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
  { "numToStr/Comment.nvim", opts = {} },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = true },
    keys = {
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 500,
      spec = {
        { "<leader>f", group = "Find" },
        { "<leader>c", group = "Code" },
        { "<leader>d", group = "Debug" },
        { "<leader>w", group = "Workspace" },
      },
    },
  },
})
