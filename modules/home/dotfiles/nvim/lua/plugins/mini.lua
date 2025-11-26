return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    -- === MODULES DE BASE ===
    require("mini.pairs").setup()
    require("mini.comment").setup()
    require("mini.surround").setup()
    require("mini.cursorword").setup()
    require("mini.indentscope").setup({
      symbol = "│",
      options = { try_as_border = true },
    })

    -- === EXPLORATEUR (Remplace Neo-tree) ===
    require("mini.files").setup({
      windows = { preview = true, width_focus = 30, width_preview = 30 },
    })
    vim.keymap.set("n", "<leader>e", function()
      if not require("mini.files").close() then
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end
    end, { desc = "File Explorer" })

    -- === 1. HIGHLIGHTS (Remplace Todo-comments & Colorizer) ===
    local hipatterns = require("mini.hipatterns")
    hipatterns.setup({
      highlighters = {
        -- Gestion des couleurs hexadécimales
        hex_color = hipatterns.gen_highlighter.hex_color(),

        -- Gestion des TODOs
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
      },
    })

    -- === 2. FUZZY FINDER (Remplace Telescope) ===
    local minipick = require("mini.pick")
    minipick.setup()
    -- Raccourcis style Telescope (Utilisation de la variable locale 'minipick' au lieu du global 'MiniPick')
    vim.keymap.set("n", "<leader>ff", minipick.builtin.files, { desc = "Find Files" })
    vim.keymap.set("n", "<leader>fg", minipick.builtin.grep_live, { desc = "Find Grep" })
    vim.keymap.set("n", "<leader>fb", minipick.builtin.buffers, { desc = "Find Buffers" })
    vim.keymap.set("n", "<leader>fh", minipick.builtin.help, { desc = "Find Help" })

    -- === 3. GIT (Remplace Gitsigns) ===
    require("mini.diff").setup({
      view = {
        style = "sign",
        signs = { add = "+", change = "~", delete = "_" },
      },
    })

    -- === STATUSLINE & CLUE ===
    require("mini.statusline").setup({ use_icons = true })

    local miniclue = require("mini.clue")
    miniclue.setup({
      triggers = {
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },
        { mode = "i", keys = "<C-x>" },
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },
        { mode = "n", keys = "<C-w>" },
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
      },
      clues = {
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
        -- Groupes personnalisés
        { mode = "n", keys = "<leader>f", desc = "+Find" },
        { mode = "n", keys = "<leader>c", desc = "+Code" },
        { mode = "n", keys = "<leader>d", desc = "+Debug" },
        { mode = "n", keys = "<leader>x", desc = "+Trouble" },
        { mode = "n", keys = "<leader>e", desc = "Explorer" },
      },
      window = { delay = 300, config = { width = "auto" } },
    })
  end,
}
