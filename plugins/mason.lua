-- mason + mason-lspconfig. mason must be set up before mason-lspconfig, so
-- both are configured here in a single, ordered config function.
return {
  {
    src = "https://github.com/mason-org/mason.nvim",
  },
  {
    src = "https://github.com/mason-org/mason-lspconfig.nvim",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      require("mason-lspconfig").setup({
        automatic_enable = {
          exclude = {
            "rust_analyzer",
            "ts_ls",
          },
        },
        -- These are lspconfig server names (NOT mason package names, e.g.
        -- `lua_ls` not `lua-language-server`). Browse all available servers:
        --   https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
        -- Or in Neovim run `:checkhealth mason-lspconfig` / `:Mason`.
        ensure_installed = {
          "codebook",
          "golangci_lint_ls",
          "gopls",
          "lua_ls",
          "pyright",
          "terraformls",
          "tflint",
          "tofu_ls",
        },
      })

      -- Non-LSP tools (formatters, linters, debuggers, codegen). These are
      -- mason package names, installed in the background if missing.
      local tools = {
        "delve", -- Go debugger (nvim-dap-go, plugins/dap.lua)
        "gofumpt", -- Go formatter (conform)
        "goimports", -- Go import fixer (conform)
        "golangci-lint", -- Go linter (driven by golangci_lint_ls)
        "gomodifytags", -- Go struct tags (gopher.nvim)
        "gotests", -- Go test generation (gopher.nvim)
        "gotestsum", -- Go test runner (neotest-golang)
        "iferr", -- Go `if err != nil` generation (gopher.nvim)
        "impl", -- Go interface stubs (gopher.nvim)
      }
      local registry = require("mason-registry")
      registry.refresh(function()
        for _, name in ipairs(tools) do
          local ok, pkg = pcall(registry.get_package, name)
          if ok and not pkg:is_installed() and not pkg:is_installing() then
            pkg:install()
          end
        end
      end)
    end,
  },
}
