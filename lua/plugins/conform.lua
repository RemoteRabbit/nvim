return {
  "stevearc/conform.nvim",
  opts = {},
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        go = { "gofmt", "goimports" },
        terraform = { "terraform_fmt" },
        elixir = { "mix" },
        json = { "jq" },
        yaml = { "yamlfmt" },
        markdown = { "markdownlint" },
        ["_"] = { "trim_whitespace" },
        ["*"] = { "codespell" },
      },
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 500,
      },
      notify_on_error = true,
    })
  end,
}
