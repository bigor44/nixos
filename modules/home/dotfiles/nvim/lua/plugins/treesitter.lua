return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = { "nvim-treesitter/nvim-treesitter-context" },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "nix",
        "lua",
        "vim",
        "vimdoc",
        "bash",
        "markdown",
        "markdown_inline",
        "json",
        "yaml",
        "python",
        "html",
        "css",
        "javascript",
        "typescript",
        "toml",
        "diff",
        "git_config",
        "gitignore",
      },
      -- Enable auto_install so if you open a file without a parser, it downloads it
      auto_install = true,

      highlight = { enable = true },
      indent = { enable = true },
    })
    require("treesitter-context").setup({ max_lines = 3 })
  end,
}
