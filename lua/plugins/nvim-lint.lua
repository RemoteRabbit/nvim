return {
  {
    -- Code metrics and complexity analysis
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        python = { "ruff", "mypy" },
        javascript = { "eslint" },
        typescript = { "eslint" },
        go = { "golangcilint", "staticcheck" },
        terraform = { "tflint", "tfsec" },
        yaml = { "yamllint" },
        json = { "jsonlint" },
        lua = { "luacheck" },
        bash = { "shellcheck" },
        sh = { "shellcheck" },
        dockerfile = { "hadolint" },
        elixir = { "credo" },
      }

      -- Auto-run linting
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })

      vim.keymap.set("n", "<leader>cl", function()
        require("lint").try_lint()
      end, { desc = "Run linting" })
    end,
  },
}
