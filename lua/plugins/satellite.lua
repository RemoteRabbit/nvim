return {
  "lewis6991/satellite.nvim",
  event = "VeryLazy",
  opts = {
    current_only = false,
    winblend = 50,
    zindex = 40,
    excluded_filetypes = {
      "prompt",
      "TelescopePrompt",
      "noice",
      "notify",
      "neo-tree",
    },
    width = 2,
    handlers = {
      cursor = {
        enable = true,
        overlap = true,
        priority = 1000,
        symbols = { "⎺", "⎻", "⎼", "⎽" },
      },
      search = {
        enable = true,
        overlap = true,
        priority = 1000,
        symbols = { "󰍉" },
      },
      diagnostic = {
        enable = true,
        overlap = true,
        priority = 1000,
        min_severity = vim.diagnostic.severity.HINT,
        symbols = {
          [vim.diagnostic.severity.ERROR] = "●",
          [vim.diagnostic.severity.WARN] = "●",
          [vim.diagnostic.severity.INFO] = "●",
          [vim.diagnostic.severity.HINT] = "●",
        },
      },
      gitsigns = {
        enable = true,
        overlap = true,
        priority = 1000,
        symbols = {
          add = "│",
          change = "│",
          delete = "-",
        },
      },
      marks = {
        enable = true,
        overlap = true,
        priority = 1000,
        key = "m",
        symbols = { "⚫" },
      },
    },
  },
  config = function(_, opts)
    require("satellite").setup(opts)
  end,
}
