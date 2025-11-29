-- modules/home/dotfiles/nvim/lua/plugins/mini.lua
return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    -- === ICONS (Doit être chargé en premier) ===
    local mini_icons = require("mini.icons")
    mini_icons.setup()
    mini_icons.mock_nvim_web_devicons()

    -- === EXPLORATEUR (avec preview automatique) ===
    local minifiles = require("mini.files")
    minifiles.setup({
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 50, -- Plus large pour mieux voir
      },
      options = {
        use_as_default_explorer = true, -- ✅ Remplace netrw
      },
    })

    -- Keymaps améliorés
    vim.keymap.set("n", "<leader>e", function()
      if not minifiles.close() then
        minifiles.open(vim.api.nvim_buf_get_name(0), true)
      end
    end, { desc = "File Explorer (toggle)" })

    -- ✅ NOUVEAU : Ouvrir dans le répertoire courant
    vim.keymap.set("n", "<leader>E", function()
      minifiles.open(vim.loop.cwd(), true)
    end, { desc = "File Explorer (cwd)" })

    -- === MINI.PICK : Recherche améliorée ===
    local minipick = require("mini.pick")
    minipick.setup({
      window = {
        config = function()
          local height = math.floor(0.618 * vim.o.lines)
          local width = math.floor(0.618 * vim.o.columns)
          return {
            anchor = "NW",
            height = height,
            width = width,
            row = math.floor(0.5 * (vim.o.lines - height)),
            col = math.floor(0.5 * (vim.o.columns - width)),
            border = "rounded",
          }
        end,
      },
    })

    -- ✅ Raccourcis avec descriptions améliorées
    local builtin = minipick.builtin
    vim.keymap.set("n", "<leader>ff", builtin.files, { desc = "Find Files" })
    vim.keymap.set("n", "<leader>fg", builtin.grep_live, { desc = "Live Grep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help, { desc = "Help Tags" })
    vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Resume Last Pick" })
    vim.keymap.set("n", "<leader>/", builtin.grep_live, { desc = "Search in Project" })

    -- === MINI.DIFF : Configuration Git améliorée ===
    require("mini.diff").setup({
      view = {
        style = "sign",
        signs = { add = "│", change = "│", delete = "_" }, -- Plus discret
      },
      -- ✅ Source overlay pour voir les diff inline
      source = require("mini.diff").gen_source.git(),
      delay = {
        text_change = 200,
      },
    })

    -- ✅ Keymaps Git (comme Gitsigns)
    vim.keymap.set("n", "]h", function()
      require("mini.diff").goto_hunk("next")
    end, { desc = "Next Hunk" })

    vim.keymap.set("n", "[h", function()
      require("mini.diff").goto_hunk("prev")
    end, { desc = "Previous Hunk" })

    -- === MINI.HIPATTERNS : Couleurs et TODOs ===
    local hipatterns = require("mini.hipatterns")
    hipatterns.setup({
      highlighters = {
        hex_color = hipatterns.gen_highlighter.hex_color(),

        -- ✅ TODOs avec priorités
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
        warning = { pattern = "%f[%w]()WARNING()%f[%W]", group = "DiagnosticWarn" },
      },
    })

    -- === MODULES DE BASE (déjà bons) ===
    require("mini.pairs").setup()
    require("mini.comment").setup()
    require("mini.surround").setup()
    require("mini.cursorword").setup({ delay = 200 }) -- Petit délai pour éviter le flicker
    require("mini.indentscope").setup({
      symbol = "│",
      options = { try_as_border = true },
      draw = {
        delay = 100,
        animation = require("mini.indentscope").gen_animation.none(), -- Plus rapide
      },
    })

    -- === STATUSLINE ===
    require("mini.statusline").setup({
      use_icons = true,
      set_vim_settings = false, -- Garde vos settings Neovim
    })

    -- === MINI.CLUE (Which-key replacement) ===
    local miniclue = require("mini.clue")
    miniclue.setup({
      triggers = {
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },
        { mode = "n", keys = "'" },
        { mode = "n", keys = "`" },
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },
        { mode = "n", keys = "<C-w>" },
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
        { mode = "n", keys = "[" },
        { mode = "n", keys = "]" },
      },
      clues = {
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),

        -- ✅ Groupes personnalisés améliorés
        { mode = "n", keys = "<leader>f", desc = "+Find" },
        { mode = "n", keys = "<leader>c", desc = "+Code" },
        { mode = "n", keys = "<leader>d", desc = "+Debug" },
        { mode = "n", keys = "<leader>x", desc = "+Diagnostics" },
        { mode = "n", keys = "<leader>b", desc = "+Buffer" },
        { mode = "n", keys = "<leader>g", desc = "+Git" },
        { mode = "n", keys = "[", desc = "+Previous" },
        { mode = "n", keys = "]", desc = "+Next" },
      },
      window = {
        delay = 300,
        config = {
          width = "auto",
          border = "rounded",
        },
      },
    })
  end,
}
