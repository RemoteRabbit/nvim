--- Testing: neotest (runner UI) + neotest-golang (Go adapter) + nvim-coverage
--- (line coverage signs). Language-agnostic keymaps under <leader>T; add more
--- adapters to `adapters` for other languages.
---
--- Go: tests run through gotestsum when installed (falls back to `go test`)
--- and every run writes a coverage profile. Coverage files live in Neovim's
--- cache dir (one per project), not in the repo. Coverage maps files relative
--- to the module root, so run Neovim from the module root.
---
--- Debugging a test (<leader>Td) uses nvim-dap-go (plugins/dap.lua).
return {
  {
    src = "https://github.com/nvim-lua/plenary.nvim",
  },
  {
    src = "https://github.com/nvim-neotest/nvim-nio",
    version = vim.version.range("1.*"),
  },
  {
    src = "https://github.com/fredrikaverpil/neotest-golang",
    version = vim.version.range("2.*"),
  },
  {
    src = "https://github.com/andythigpen/nvim-coverage",
  },
  {
    src = "https://github.com/nvim-neotest/neotest",
    version = vim.version.range("5.*"),
    config = function()
      local neotest = require("neotest")
      local coverage = require("coverage")

      --- Per-project coverage profile path, e.g.
      --- ~/.cache/nvim/coverage/%home%me%proj.out
      ---@return string
      local function coverage_file()
        local dir = vim.fn.stdpath("cache") .. "/coverage"
        vim.fn.mkdir(dir, "p")
        return dir .. "/" .. vim.fn.getcwd():gsub("[/\\:]", "%%") .. ".out"
      end

      neotest.setup({
        adapters = {
          require("neotest-golang")({
            runner = vim.fn.executable("gotestsum") == 1 and "gotestsum" or "go",
            go_test_args = function()
              return { "-v", "-race", "-count=1", "-coverprofile=" .. coverage_file() }
            end,
          }),
        },
      })

      coverage.setup({
        -- Re-read the profile whenever a test run rewrites it.
        auto_reload = true,
        lang = { go = { coverage_file = coverage_file } },
      })

      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { desc = desc })
      end

      map("<leader>Tt", function()
        neotest.run.run()
      end, "Run nearest test")
      map("<leader>Tf", function()
        neotest.run.run(vim.fn.expand("%"))
      end, "Run file")
      map("<leader>Ta", function()
        neotest.run.run(vim.uv.cwd())
      end, "Run all (project)")
      map("<leader>Tl", function()
        neotest.run.run_last()
      end, "Run last")
      map("<leader>Td", function()
        neotest.run.run({ strategy = "dap" })
      end, "Debug nearest test")
      map("<leader>Tx", function()
        neotest.run.stop()
      end, "Stop")
      map("<leader>Ts", function()
        neotest.summary.toggle()
      end, "Toggle summary tree")
      map("<leader>To", function()
        neotest.output.open({ enter = true, auto_close = true })
      end, "Show test output")
      map("<leader>TO", function()
        neotest.output_panel.toggle()
      end, "Toggle output panel")
      map("<leader>Tw", function()
        neotest.watch.toggle(vim.fn.expand("%"))
      end, "Toggle watch (file)")
      map("]T", function()
        neotest.jump.next({ status = "failed" })
      end, "Next failed test")
      map("[T", function()
        neotest.jump.prev({ status = "failed" })
      end, "Previous failed test")

      -- Coverage from the last test run. First press loads + shows it; after
      -- that it toggles, and auto_reload keeps it current as tests re-run.
      local coverage_loaded = false
      map("<leader>Tc", function()
        if coverage_loaded then
          coverage.toggle()
        elseif vim.uv.fs_stat(coverage_file()) then
          coverage.load(true)
          coverage_loaded = true
        else
          vim.notify("No coverage yet; run some tests first (<leader>Tt/Tf/Ta)", vim.log.levels.INFO)
        end
      end, "Toggle coverage")
      map("<leader>TC", function()
        coverage.summary()
      end, "Coverage summary")
    end,
  },
}
