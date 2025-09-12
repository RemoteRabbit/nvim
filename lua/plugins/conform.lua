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
      format_on_save = function(bufnr)
        -- Don't format .norg files (Neorg handles its own formatting)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("%.norg$") then
          return nil
        end
        return {
          lsp_fallback = true,
          timeout_ms = 500,
        }
      end,
      notify_on_error = true,
    })
  end,
}
