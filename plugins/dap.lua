--- Debugging: nvim-dap (client) + nvim-dap-go (delve adapter/configs) +
--- nvim-dap-view (UI: scopes, watches, breakpoints, threads, REPL, console).
---
--- Go: requires `dlv` on PATH (mason package `delve`, or `go install
--- github.com/go-delve/delve/cmd/dlv@latest`). Set a breakpoint with
--- <leader>Db, start with <leader>Dc and pick a configuration (Debug / Debug
--- Package / Debug test / Attach ...), or use <leader>Dt to debug the test
--- under the cursor. <leader>Ds enters step mode, where single keys
--- (n/i/o/c) step until <Esc>. The view opens/closes with the session.
---
--- Project-specific launch configs can go in `.vscode/launch.json`; nvim-dap
--- reads it automatically.
return {
  {
    src = "https://github.com/mfussenegger/nvim-dap",
  },
  {
    src = "https://github.com/leoluz/nvim-dap-go",
  },
  {
    src = "https://github.com/igorlfs/nvim-dap-view",
    version = vim.version.range("1.*"),
    config = function()
      local dap = require("dap")

      require("dap-view").setup({
        auto_toggle = true,
        -- Clickable play/step/stop buttons in the view's winbar.
        winbar = { controls = { enabled = true } },
        -- Show variable values inline in the source while stopped.
        -- Long values (structs like *testing.T) are truncated; see the full
        -- value in the Scopes pane or with <leader>Dw.
        virtual_text = {
          enabled = true,
          format = function(variable)
            local value = variable.value:gsub("%s+", " ")
            return " " .. (#value > 50 and value:sub(1, 50) .. "…" or value)
          end,
        },
      })
      require("dap-go").setup()

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })

      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { desc = desc })
      end

      map("<leader>Dc", dap.continue, "Start/continue")
      map("<leader>Dn", dap.step_over, "Step over (next)")
      map("<leader>Di", dap.step_into, "Step into")
      map("<leader>Do", dap.step_out, "Step out")
      -- Step mode: keeps the <leader>D menu open so stepping is one key per
      -- step (n/i/o/c/b/...) until <Esc>.
      map("<leader>Ds", function()
        require("which-key").show({ keys = "<leader>D", loop = true })
      end, "Step mode (repeat keys, <Esc> exits)")
      map("<leader>Db", dap.toggle_breakpoint, "Toggle breakpoint")
      map("<leader>DB", function()
        dap.set_breakpoint(vim.fn.input("Condition: "))
      end, "Conditional breakpoint")
      map("<leader>Dl", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
      end, "Log point")
      map("<leader>DC", dap.run_to_cursor, "Run to cursor")
      map("<leader>Dr", dap.restart, "Restart session")
      map("<leader>DL", dap.run_last, "Run last configuration")
      map("<leader>Dq", dap.terminate, "Terminate session")
      map("<leader>Dx", dap.clear_breakpoints, "Clear all breakpoints")
      map("<leader>Du", function()
        require("dap-view").toggle()
      end, "Toggle debug view")
      map("<leader>Dw", "<cmd>DapViewWatch<cr>", "Watch expression under cursor")
      map("<leader>Dt", function()
        require("dap-go").debug_test()
      end, "Debug nearest Go test")
      map("<leader>DT", function()
        require("dap-go").debug_last_test()
      end, "Debug last Go test")
    end,
  },
}
