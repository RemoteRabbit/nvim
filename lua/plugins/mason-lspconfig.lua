return {
  "williamboman/mason-lspconfig.nvim",
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "pyright", -- Python
        "terraformls", -- Terraform
        "lua_ls", -- Lua
        "elixirls", -- Elixir
        "erlangls", -- Erlang (requires rebar3)
        "jsonls", -- JSON
        "yamlls", -- YAML
        "marksman", -- Markdown
        "bashls", -- Bash
      },
      handlers = {
        function(server_name)
          local capabilities = require("cmp_nvim_lsp").default_capabilities()
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,
        ["terraformls"] = function()
          require("lspconfig").terraformls.setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            settings = {
              terraformls = {
                ignoreSingleFileWarning = true,
              },
            },
          })
        end,
      },
    })
  end,
}
