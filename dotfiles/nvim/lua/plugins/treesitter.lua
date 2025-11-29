return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "nvim-treesitter/nvim-treesitter-context" },
  opts = {
    -- Sur NixOS, on désactive l'installation automatique
    auto_install = false,
    -- On laisse ensure_installed vide ou on met juste ceux qu'on veut vérifier
    -- car Nix gère les paquets.
    ensure_installed = {},
    highlight = { enable = true },
    indent = { enable = true },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
    require("treesitter-context").setup({ max_lines = 3 })
  end,
}
