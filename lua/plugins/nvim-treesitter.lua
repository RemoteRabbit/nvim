return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local treesitter = require("nvim-treesitter.configs")

    treesitter.setup({
      highlight = {
        enable = true,
      },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "css",
        "dockerfile",
        "elixir",
        "erlang",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "go",
        "gpg",
        "hcl",
        "html",
        "javascript",
        "json",
        "json5",
        "lua",
        "markdown",
        "markdown_inline",
        "puppet",
        "python",
        "sql",
        "ssh_config",
        "terraform",
        "toml",
        "vim",
        "yaml",
      },
      auto_install = true,
    })

    require("nvim-ts-autotag").setup()
  end,
}
