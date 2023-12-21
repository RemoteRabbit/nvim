return {
  "williamboman/mason.nvim",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mti = require("mason-tool-installer")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mti.setup({
      auto_update = true,
      -- debounce_hours = 5,
      ensure_installed = {
        -- AWS
        "cfn-lint",
        -- Azure
        "azure-pipelines-language-server",
        "bicep-lsp",
        -- Bash
        "bash-debug-adapter",
        "bash-language-server",
        -- Erlang
        "erlang-ls",
        -- General
        "prettier",
        -- Git
        "actionlint",
        -- Golang
        "gci",
        -- JSON
        "fixjson",
        "json-lsp",
        -- lua
        "lua-language-server",
        "luacheck",
        "luaformatter",
        "stylua",
        -- Python
        "pyright",
        "ruff",
        "ruff-lsp",
        -- Terraform
        "terraform-ls",
        "tflint",
        "tfsec",
        -- Text
        "alex",
        "markdown-toc",
        "typos-lsp",
        -- Yaml
        "spectral-language-server",
        "yaml-language-server",
        "yamlfix",
        "yamlfmt",
        "yamllint",
      },
    })
  end,
}
