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
        bash = { "shellcheck" },
        sh = { "shellcheck" },
        dockerfile = { "hadolint" },
        elixir = { "credo" },
      }

      -- Conditional Lua linting (skip Love2D projects)
      local function should_lint_lua()
        local cwd = vim.fn.getcwd()
        return not (vim.fn.filereadable(cwd .. "/main.lua") == 1 or vim.fn.filereadable(cwd .. "/conf.lua") == 1)
      end

      -- Auto-run linting
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          if vim.bo.filetype == "lua" and should_lint_lua() then
            require("lint").try_lint("luacheck")
          else
            require("lint").try_lint()
          end
        end,
      })

      vim.keymap.set("n", "<leader>xl", function()
        require("lint").try_lint()
      end, { desc = "Run linting" })
    end,
  },
}
