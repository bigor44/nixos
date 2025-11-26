return {
  "echasnovski/mini.nvim",
  version = false, -- Utiliser la version main (recommandé par l'auteur)
  config = function()
    -- Remplace nvim-autopairs
    require("mini.pairs").setup()

    -- Remplace Comment.nvim
    require("mini.comment").setup()

    -- Remplace nvim-surround
    require("mini.surround").setup()

    -- Remplace indent-blankline (optionnel, mini.indentscope est un peu différent mais très léger)
    require("mini.indentscope").setup({
      symbol = "│",
      options = { try_as_border = true },
    })

    -- Remplace vim-illuminate (surbrillance du mot sous le curseur)
    require("mini.cursorword").setup()

    -- Remplace which-key
    local miniclue = require("mini.clue")
    miniclue.setup({
      triggers = {
        -- Leader triggers
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },
        -- Built-in completion
        { mode = "i", keys = "<C-x>" },
        -- G marks
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },
        -- Registers
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },
        -- Window commands
        { mode = "n", keys = "<C-w>" },
        -- z commands
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
      },

      clues = {
        -- Descriptions automatiques intégrées
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),

        -- Tes groupes personnalisés (adaptés de ton ancien which-key)
        { mode = "n", keys = "<leader>f", desc = "+Find" },
        { mode = "n", keys = "<leader>c", desc = "+Code" },
        { mode = "n", keys = "<leader>d", desc = "+Debug" },
        { mode = "n", keys = "<leader>x", desc = "+Trouble" },
      },

      window = {
        delay = 300,
        config = { width = "auto" },
      },
    })

    --  Remplace lualine ---
    require("mini.statusline").setup({
      use_icons = true, -- Utilise les icônes (nécessite une Nerd Font)
    })
  end,
}
