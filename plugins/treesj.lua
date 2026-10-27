return {
  src = "https://github.com/Wansmer/treesj",
  config = function()
    require("treesj").setup({})
  end,
  vim.api.nvim_set_keymap("n", "<LEADER>ts", "<CMD>TSJToggle<CR>", { desc = "Toggle split/join on cursor line." }),
}
