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
          "gopls",
          "lua_ls",
          "pyright",
          "terraformls",
          "tflint",
          "tofu_ls",
        },
      })
    end,
  },
}
