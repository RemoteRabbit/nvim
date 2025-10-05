return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-go",
    "jfpedroza/neotest-elixir",
    "nvim-neotest/neotest-jest",
    "rouge8/neotest-rust",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = false },
          args = { "--log-level", "DEBUG" },
          runner = "pytest",
          python = "python3",
        }),
        require("neotest-go")({
          experimental = {
            test_table = true,
          },
          args = { "-count=1", "-timeout=60s" },
        }),
        require("neotest-elixir")({
          mix_task = "test",
        }),
        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "jest.config.js",
          env = { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
        }),
        require("neotest-rust")({
          args = { "--no-capture" },
          dap_adapter = "lldb",
        }),
      },
      discovery = {
        concurrent = 1,
        enabled = true,
      },
      diagnostic = {
        enabled = true,
        severity = 1,
      },
      floating = {
        border = "rounded",
        max_height = 0.6,
        max_width = 0.6,
        options = {},
      },
      highlights = {
        adapter_name = "NeotestAdapterName",
        border = "NeotestBorder",
        dir = "NeotestDir",
        expand_marker = "NeotestExpandMarker",
        failed = "NeotestFailed",
        file = "NeotestFile",
        focused = "NeotestFocused",
        indent = "NeotestIndent",
        marked = "NeotestMarked",
        namespace = "NeotestNamespace",
        passed = "NeotestPassed",
        running = "NeotestRunning",
        select_win = "NeotestWinSelect",
        skipped = "NeotestSkipped",
        target = "NeotestTarget",
        test = "NeotestTest",
        unknown = "NeotestUnknown",
      },
      icons = {
        child_indent = "│",
        child_prefix = "├",
        collapsed = "─",
        expanded = "╮",
        failed = "",
        final_child_indent = " ",
        final_child_prefix = "╰",
        non_collapsible = "─",
        passed = "",
        running = "",
        running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
        skipped = "",
        unknown = "",
      },
      output = {
        enabled = true,
        open_on_run = "short",
      },
      output_panel = {
        enabled = true,
        open = "botright split | resize 15",
      },
      run = {
        enabled = true,
      },
      running = {
        concurrent = true,
      },
      summary = {
        enabled = true,
        animated = true,
        follow = true,
        expand_errors = true,
        mappings = {
          attach = "a",
          clear_marked = "M",
          clear_target = "T",
          debug = "d",
          debug_marked = "D",
          expand = { "<CR>", "<2-LeftMouse>" },
          expand_all = "e",
          help = "?",
          jumpto = "i",
          mark = "m",
          next_failed = "J",
          output = "o",
          prev_failed = "K",
          run = "r",
          run_marked = "R",
          short = "O",
          stop = "u",
          target = "t",
          watch = "w",
        },
        open = "botright vsplit | vertical resize 50",
      },
      watch = {
        enabled = true,
        symbol_queries = {
          python = "class",
          go = "(method_declaration) @symbol",
          elixir = "(call) @symbol",
          javascript = "(function_declaration) @symbol",
        },
      },
    })

    vim.keymap.set("n", "<leader>tn", function()
      require("neotest").run.run()
    end, { desc = "Run nearest test" })
    vim.keymap.set("n", "<leader>tF", function()
      require("neotest").run.run(vim.fn.expand("%"))
    end, { desc = "Run tests in file" })
    vim.keymap.set("n", "<leader>ta", function()
      require("neotest").run.run(vim.fn.getcwd())
    end, { desc = "Run all tests" })
    vim.keymap.set("n", "<leader>ts", function()
      require("neotest").summary.toggle()
    end, { desc = "Toggle test summary" })
    vim.keymap.set("n", "<leader>to", function()
      require("neotest").output.open({ enter = true, auto_close = true })
    end, { desc = "Show test output" })
    vim.keymap.set("n", "<leader>tO", function()
      require("neotest").output_panel.toggle()
    end, { desc = "Toggle test output panel" })
    vim.keymap.set("n", "<leader>tw", function()
      require("neotest").watch.toggle(vim.fn.expand("%"))
    end, { desc = "Watch tests" })
    vim.keymap.set("n", "<leader>td", function()
      require("neotest").run.run({ strategy = "dap" })
    end, { desc = "Debug nearest test" })
  end,
}
