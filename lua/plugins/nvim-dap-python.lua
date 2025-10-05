return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      require("dap-python").setup("python3")

      -- Python-specific configurations
      local dap = require("dap")

      -- Add pytest runner
      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Run pytest",
        module = "pytest",
        args = { "${workspaceFolder}" },
        console = "integratedTerminal",
        justMyCode = false,
      })

      -- Add Flask debug config
      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Flask Debug",
        program = "${workspaceFolder}/app.py",
        env = { FLASK_ENV = "development" },
        console = "integratedTerminal",
        justMyCode = false,
      })

      vim.keymap.set("n", "<leader>dpr", function()
        require("dap-python").test_method()
      end, { desc = "Debug Python test method" })
    end,
  },
}
