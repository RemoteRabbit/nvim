return {
  src = "https://github.com/folke/which-key.nvim",
  version = "v3.17.0",
  config = function()
    local wk = require("which-key")
    wk.setup({
      preset = "modern",
    })

    -- Group labels only. Individual mappings stay co-located with their
    -- plugins (see plugins/*.lua) and in lua/keymaps.lua; which-key reads
    -- their `desc` automatically. Register only the <leader> prefixes here.
    wk.add({
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>d", group = "delete (no yank)" },
      { "<leader>D", group = "debug" },
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>G", group = "go" },
      { "<leader>l", group = "lsp" },
      { "<leader>p", group = "paste/path" },
      { "<leader>s", group = "split/scratch" },
      { "<leader>t", group = "test/toggle" },
      { "<leader>x", group = "trouble/diagnostics" },
    })
  end,
}
