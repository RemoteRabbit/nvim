return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    -- Auto open/close dapui
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue/Start Debugging" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
    vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
    vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
    vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
    vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last" })
    vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
    vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })

    -- Basic Python configuration (modify as needed)
    dap.adapters.python = {
      type = "executable",
      command = "python",
      args = { "-m", "debugpy.adapter" },
    }

    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
          return "/usr/bin/python3"
        end,
      },
    }
  end,
}
