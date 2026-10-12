--- Debugging via the Debug Adapter Protocol.
---
---   nvim-dap              core DAP client
---   nvim-dap-ui           scopes/stacks/watches/repl panels (opens on session start)
---   nvim-dap-virtual-text variable values shown inline while stepping
---   nvim-dap-go           delve adapter + Go launch configs (debug test under cursor, etc.)
---
--- `delve` is installed by mason (plugins/mason.lua). Debug a test from the
--- test runner with <leader>tD (plugins/neotest.lua), or with <leader>Dg here.
---
--- Per-project launch configs can go in .vscode/launch.json; nvim-dap reads
--- it automatically when you start a session.
return {
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
  { src = "https://github.com/leoluz/nvim-dap-go" },
  {
    src = "https://github.com/mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      require("nvim-dap-virtual-text").setup({})
      require("dap-go").setup()

      -- Open the UI when a session starts. It stays open after the program
      -- exits so its output and errors stay readable; close it with <leader>Du.
      dap.listeners.after.event_initialized["dapui"] = dapui.open

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticOk", linehl = "Visual" })

      local map = function(lhs, rhs, desc, mode)
        vim.keymap.set(mode or "n", lhs, rhs, { desc = desc })
      end

      map("<leader>Dc", dap.continue, "Start/continue")
      map("<leader>Db", dap.toggle_breakpoint, "Toggle breakpoint")
      map("<leader>DB", function()
        dap.set_breakpoint(vim.fn.input("Condition: "))
      end, "Conditional breakpoint")
      map("<leader>Dl", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
      end, "Log point")
      map("<leader>Dx", dap.clear_breakpoints, "Clear breakpoints")
      map("<leader>Do", dap.step_over, "Step over")
      map("<leader>Di", dap.step_into, "Step into")
      map("<leader>DO", dap.step_out, "Step out")
      map("<leader>DC", dap.run_to_cursor, "Run to cursor")
      map("<leader>DL", dap.run_last, "Run last")
      map("<leader>Dt", dap.terminate, "Terminate")
      map("<leader>Dr", dap.repl.toggle, "Toggle REPL")
      map("<leader>Du", dapui.toggle, "Toggle UI")
      map("<leader>De", dapui.eval, "Eval expression", { "n", "v" })
      map("<leader>Dg", function()
        require("dap-go").debug_test()
      end, "Debug Go test under cursor")
      map("<leader>DG", function()
        require("dap-go").debug_last_test()
      end, "Debug last Go test")
    end,
  },
}
