-- ===============================Keymaps Start=================================
-- n <leader>gd Generate PR Description from commits.
-- =================================Keymaps End=================================

return {
  src = "https://github.com/remoterabbit/pr-description.nvim",
  config = function()
    require("pr-description").setup({
      foldable_file_changes = true,
    })
    vim.api.nvim_set_keymap(
      "n",
      "<leader>gd",
      ":PRDescription!<cr>",
      { desc = "Generate PR Description from commits." }
    )
  end,
}
