return {
  "andythigpen/nvim-coverage",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("coverage").setup({
      commands = true,
      highlights = {
        covered = { fg = "#C3E88D" },
        uncovered = { fg = "#F07178" },
        partial = { fg = "#AA71FF" },
      },
      signs = {
        covered = { hl = "CoverageCovered", text = "▎" },
        uncovered = { hl = "CoverageUncovered", text = "▎" },
        partial = { hl = "CoveragePartial", text = "▎" },
      },
      summary = {
        min_coverage = 80.0,
      },
      lang = {
        python = {
          coverage_command = "coverage json --fail-under=0 -q -o -",
          coverage_file = "coverage.json",
        },
        go = {
          coverage_command = "go test -coverprofile=coverage.out ./... && go tool cover -func=coverage.out",
        },
        javascript = {
          coverage_command = "cat coverage/lcov-report/index.html | grep -o '\\\"decimal\\\">[^<]*' | head -n 4",
        },
      },
      auto_reload = true,
      load_coverage_cb = function(ftype)
        vim.notify("Loaded " .. ftype .. " coverage")
      end,
    })

    vim.keymap.set("n", "<leader>cov", "<cmd>Coverage<cr>", { desc = "Show coverage" })
    vim.keymap.set("n", "<leader>coh", "<cmd>CoverageHide<cr>", { desc = "Hide coverage" })
    vim.keymap.set("n", "<leader>cos", "<cmd>CoverageSummary<cr>", { desc = "Coverage summary" })
    vim.keymap.set("n", "<leader>cot", "<cmd>CoverageToggle<cr>", { desc = "Toggle coverage" })
    vim.keymap.set("n", "<leader>col", "<cmd>CoverageLoad<cr>", { desc = "Load coverage" })
  end,
}
