return {
  "junegunn/gv.vim",
  dependencies = { "tpope/vim-fugitive" },
  config = function()
    vim.keymap.set("n", "<leader>gv", "<cmd>GV<cr>", { desc = "Git log" })
    vim.keymap.set("n", "<leader>gV", "<cmd>GV!<cr>", { desc = "Git log (current file)" })
    vim.keymap.set("n", "<leader>g?", "<cmd>GV?<cr>", { desc = "Git log (current line)" })
  end,
}
