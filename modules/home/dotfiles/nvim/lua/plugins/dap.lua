return {
  "mfussenegger/nvim-dap",
  -- Only load DAP if we are in a Python or Rust file, or if we type :Dap...
  ft = { "python", "c", "cpp", "rust" },
  keys = {
    { "<leader>dt", desc = "Toggle Breakpoint" },
    { "<leader>dc", desc = "Continue" },
  },
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap-python", -- Add this for Python magic
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    -- Automatically open the Debug UI when debugging starts
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- Python Setup (You will need 'debugpy' in your packages.nix!)
    -- This automatically finds the python debugger if it's in your PATH
    require("dap-python").setup("python3")

    -- Keymaps (Only active when plugin loads)
    vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "BP toggle" })
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug start" })
  end,
}
