--- Formatting on save. Go: goimports (adds/removes imports), then either
--- gofumpt, or `golangci-lint fmt` when the repo's golangci config defines
--- formatters, so saved files match what CI lint expects.

local GOLANGCI_CONFIGS = { ".golangci.yml", ".golangci.yaml", ".golangci.toml", ".golangci.json" }

--- Nearest golangci-lint config above `dirname` that has a (v2) top-level
--- `formatters` section, or nil.
---@param dirname string
---@return string?
local function golangci_fmt_config(dirname)
  local cfg = vim.fs.find(GOLANGCI_CONFIGS, { path = dirname, upward = true })[1]
  if not cfg then
    return nil
  end
  for line in io.lines(cfg) do
    if line:match("^formatters:") or line:match("^%[formatters[%].]") or line:match('^%s*"formatters"%s*:') then
      return cfg
    end
  end
end

return {
  src = "https://github.com/stevearc/conform.nvim",
  version = "v9.1.0",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        ["_"] = { "trim_whitespace" },
        bash = { "shfmt" },
        elixir = { "mix" },
        go = { "goimports", "gofumpt", "golangci-lint" },
        json = { "jq" },
        lua = { "stylua" },
        markdown = { "markdownlint" },
        python = { "ruff_format", "ruff_organize_imports" },
        sh = { "shfmt" },
        terraform = { "terraform_fmt" },
        toml = { "taplo" },
        yaml = { "yamlfmt" },
      },
      formatters = {
        gofumpt = {
          condition = function(_, ctx)
            return golangci_fmt_config(ctx.dirname) == nil
          end,
        },
        ["golangci-lint"] = {
          condition = function(_, ctx)
            return golangci_fmt_config(ctx.dirname) ~= nil
          end,
          -- `fmt --stdin` reads the config from its working directory.
          cwd = function(_, ctx)
            return vim.fs.dirname(golangci_fmt_config(ctx.dirname))
          end,
        },
      },
      format_on_save = function(bufnr)
        -- Don't format .norg files (Neorg handles its own formatting)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("%.norg$") then
          return nil
        end
        return {
          lsp_format = "fallback",
          -- goimports may scan the module cache for missing imports, and Go
          -- runs two formatters in a row; 500ms could skip formatting.
          timeout_ms = vim.bo[bufnr].filetype == "go" and 2000 or 500,
        }
      end,
      notify_on_error = true,
    })
  end,
}
