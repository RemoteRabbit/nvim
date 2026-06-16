return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "mason-org/mason.nvim" },
  event = { "VeryLazy" },
  config = function()
    require("mason-tool-installer").setup({
      ensure_installed = {
        -- Go
        "gofumpt",
        "goimports",
        "golangci-lint",
        "delve",
        "gomodifytags",
        "impl",
        "iferr",
        "gotests",

        -- Python
        "ruff",
        "black",

        -- Lua
        "stylua",
        "luacheck",

        -- Shell
        "shfmt",
        "shellcheck",

        -- Web / config
        "prettier",
        "yamlfmt",
        "yamllint",
        "jsonlint",
        "markdownlint",

        -- Terraform
        "tflint",
        "tfsec",

        -- Misc
        "hadolint",
        "codespell",
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 24,
    })
  end,
}
