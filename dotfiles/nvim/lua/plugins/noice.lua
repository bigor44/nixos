return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = { bottom_search = true, command_palette = true, long_message_to_split = true },
    notify = {
      enabled = false, -- On désactive le module interne de notification de Noice
      view = "notify", -- On laisse Snacks capturer vim.notify
    },
  },
}
