-- ===============================Keymaps Start=================================
-- n <leader>xx Diagnostics (Trouble)
-- n <leader>xX Buffer diagnostics (Trouble)
-- n <leader>xs Symbols (Trouble)
-- n <leader>xr LSP references/defs (Trouble)
-- n <leader>xl Location list (Trouble)
-- n <leader>xq Quickfix list (Trouble)
-- n <leader>xt Todos (Trouble)
-- =================================Keymaps End=================================

return {
  src = "https://github.com/folke/trouble.nvim",
  version = "main",
  config = function()
    require("trouble").setup({})
    vim.api.nvim_set_keymap("n", "<leader>xx", ":Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
    vim.api.nvim_set_keymap(
      "n",
      "<leader>xX",
      ":Trouble diagnostics toggle filter.buf=0<cr>",
      { desc = "Buffer diagnostics (Trouble)" }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<leader>xs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      { desc = "Symbols (Trouble)" }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<leader>xr",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      { desc = "LSP references/defs (Trouble)" }
    )
    vim.api.nvim_set_keymap("n", "<leader>xl", ":Trouble loclist toggle<cr>", { desc = "Location list (Trouble)" })
    vim.api.nvim_set_keymap("n", "<leader>xq", ":Trouble qflist toggle<cr>", { desc = "Quickfix list (Trouble)" })
    vim.api.nvim_set_keymap(
      "n",
      "<leader>xt",
      ":Trouble todo toggle focue=false win.type=split win.relative=editor win.position=right win.size=0.15<cr>",
      { desc = "Todos (Trouble)" }
    )
  end,
}
