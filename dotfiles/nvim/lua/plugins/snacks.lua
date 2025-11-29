-- luacheck: globals Snacks

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- 1. Optimisations de base
    bigfile = { enabled = true }, -- Désactive les trucs lourds sur les gros fichiers
    quickfile = { enabled = true }, -- Accélère l'ouverture des petits fichiers

    -- 2. Interface Utilisateur
    dashboard = { enabled = true }, -- Un bel écran d'accueil (remplace Alpha/Dashboard)
    notifier = { enabled = true }, -- Remplace nvim-notify
    statuscolumn = { enabled = true }, -- Git signs et diagnostics dans la marge de gauche

    -- 3. Utilitaires
    bufdelete = { enabled = true }, -- Pour supprimer les buffers sans casser le layout
    terminal = { enabled = true }, -- Remplace ToggleTerm
    lazygit = { enabled = true }, -- Interface flottante pour LazyGit
  },
  keys = {
    -- Top Pickers & Explorer
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>gf",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "Lazygit Current File History",
    },
    {
      "<leader>gl",
      function()
        Snacks.lazygit.log()
      end,
      desc = "Lazygit Log (Cwd)",
    },

    -- Terminal (Remplace ToggleTerm)
    {
      "<c-t>",
      function()
        Snacks.terminal.toggle()
      end,
      desc = "Toggle Terminal",
    },
    {
      "<c-_>",
      function()
        Snacks.terminal.toggle()
      end,
      desc = "Toggle Terminal",
    }, -- Ctrl+/

    -- Buffer managment
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },

    -- Notifications
    {
      "<leader>n",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss All Notifications",
    },
  },
  init = function()
    -- Création de commandes utilisateur pratiques
    vim.api.nvim_create_user_command("Bd", function()
      Snacks.bufdelete()
    end, {})
    vim.api.nvim_create_user_command("Lg", function()
      Snacks.lazygit()
    end, {})
  end,
}
