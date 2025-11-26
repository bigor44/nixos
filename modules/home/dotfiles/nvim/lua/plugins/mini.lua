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
  end,
}
