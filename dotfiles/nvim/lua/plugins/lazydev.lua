return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- Ne charger que sur les fichiers Lua
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        "lazy.nvim",
      },
    },
  },
}
