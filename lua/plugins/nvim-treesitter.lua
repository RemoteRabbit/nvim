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
      autotag = { enable = true },
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
        "vim",
        "yaml",
      },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      auto_install = true,
    })
  end,
}
