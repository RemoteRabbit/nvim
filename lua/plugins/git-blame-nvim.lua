return {
  "f-person/git-blame.nvim",
  config = function()
    vim.g.gitblame_enabled = 0
    vim.g.gitblame_message_template = "<summary> • <date> • <author>"
    vim.g.gitblame_highlight_group = "LineNr"
    vim.g.gitblame_date_format = "%r"
    vim.g.gitblame_message_when_not_committed = "Oh please, commit this !"
    vim.g.gitblame_display_virtual_text = 1
    vim.g.gitblame_ignored_filetypes = { "lua" }

    vim.keymap.set("n", "<leader>gb", "<cmd>GitBlameToggle<cr>", { desc = "Toggle git blame" })
    vim.keymap.set("n", "<leader>gB", "<cmd>GitBlameOpenCommitURL<cr>", { desc = "Open commit URL" })
  end,
}
