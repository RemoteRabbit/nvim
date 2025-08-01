return {
  "folke/twilight.nvim",
  opts = {
    dimming = {
      alpha = 0.25, -- amount of dimming
      color = { "Normal", "#ffffff" },
      term_bg = "#000000", -- if guibg=NONE, this will be used as fallback
      inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
    },
    context = 10, -- amount of lines we will try to show around the current line
    treesitter = true, -- use treesitter when available for the filetype
    expand = { -- for which nodes to always include the entire expanded tree
      "function",
      "method",
      "table",
      "if_statement",
    },
    exclude = {}, -- exclude these filetypes
  },
  config = function(_, opts)
    require("twilight").setup(opts)
    
    -- Keymap for manual toggle
    vim.keymap.set("n", "<leader>tw", ":Twilight<CR>", { desc = "Toggle Twilight" })
  end,
}
