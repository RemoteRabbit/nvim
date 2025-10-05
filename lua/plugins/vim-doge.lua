return {
  "kkoomen/vim-doge",
  build = ":call doge#install()",
  config = function()
    vim.g.doge_enable_mappings = 0
    vim.g.doge_doc_standard_python = "google"
    vim.g.doge_doc_standard_go = "godoc"
    vim.g.doge_doc_standard_javascript = "jsdoc"
    vim.g.doge_doc_standard_typescript = "jsdoc"
    vim.g.doge_buffer_mappings = 1
    vim.g.doge_comment_jump_modes = { "n", "s" }

    vim.keymap.set("n", "<leader>dg", "<Plug>(doge-generate)", { desc = "Generate docs" })
    vim.keymap.set("n", "<leader>dc", "<Plug>(doge-comment-jump-forward)", { desc = "Jump to next comment" })
    vim.keymap.set("n", "<leader>dC", "<Plug>(doge-comment-jump-backward)", { desc = "Jump to prev comment" })
  end,
}
