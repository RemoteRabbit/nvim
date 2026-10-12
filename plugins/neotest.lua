--- Test runner UI. neotest-golang understands table tests and subtests via
--- treesitter, streams results, and puts failures inline as diagnostics.
---
--- Uses `gotestsum` (installed by mason, see plugins/mason.lua) when present for
--- more reliable output parsing, falling back to plain `go test`. Debugging a
--- test (<leader>tD) goes through nvim-dap-go (plugins/dap.lua).
return {
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/fredrikaverpil/neotest-golang", version = vim.version.range("2.*") },
  {
    src = "https://github.com/nvim-neotest/neotest",
    config = function()
      local neotest = require("neotest")
      neotest.setup({
        adapters = {
          require("neotest-golang")({
            runner = vim.fn.executable("gotestsum") == 1 and "gotestsum" or "go",
          }),
        },
        output = { open_on_run = false },
        quickfix = { open = false },
      })

      local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { desc = desc })
      end

      map("<leader>tt", function()
        neotest.run.run()
      end, "Test nearest")
      map("<leader>tf", function()
        neotest.run.run(vim.fn.expand("%"))
      end, "Test file")
      map("<leader>ta", function()
        neotest.run.run(vim.uv.cwd())
      end, "Test all (cwd)")
      map("<leader>tl", function()
        neotest.run.run_last()
      end, "Test last")
      map("<leader>tD", function()
        neotest.run.run({ strategy = "dap" })
      end, "Debug nearest test")
      map("<leader>tS", function()
        neotest.run.stop()
      end, "Stop tests")
      map("<leader>tw", function()
        neotest.watch.toggle(vim.fn.expand("%"))
      end, "Toggle watch (file)")
      map("<leader>ts", function()
        neotest.summary.toggle()
      end, "Toggle test summary")
      map("<leader>to", function()
        neotest.output.open({ enter = true, auto_close = true })
      end, "Test output")
      map("<leader>tO", function()
        neotest.output_panel.toggle()
      end, "Toggle test output panel")
      map("]t", function()
        neotest.jump.next({ status = "failed" })
      end, "Next failed test")
      map("[t", function()
        neotest.jump.prev({ status = "failed" })
      end, "Previous failed test")
    end,
  },
}
