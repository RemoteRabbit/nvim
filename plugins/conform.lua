return {
  src = "https://github.com/stevearc/conform.nvim",
  version = "v9.1.0",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        ["_"] = { "trim_whitespace" },
        bash = { "shfmt" },
        elixir = { "mix" },
        go = { "goimports", "gofumpt" },
        json = { "jq" },
        lua = { "stylua" },
        markdown = { "markdownlint" },
        python = { "ruff_format", "ruff_organize_imports" },
        sh = { "shfmt" },
        terraform = { "terraform_fmt" },
        toml = { "taplo" },
        yaml = { "yamlfmt" },
      },
      format_on_save = function(bufnr)
        -- Don't format .norg files (Neorg handles its own formatting)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("%.norg$") then
          return nil
        end
        return {
          lsp_format = "fallback",
          timeout_ms = 500,
        }
      end,
      notify_on_error = true,
    })
  end,
}
