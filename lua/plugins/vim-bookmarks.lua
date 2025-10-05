return {
  "MattesGroeger/vim-bookmarks",
  config = function()
    vim.g.bookmark_sign = "♥"
    vim.g.bookmark_annotation_sign = "♥"
    vim.g.bookmark_highlight_lines = 1
    vim.g.bookmark_auto_save = 1
    vim.g.bookmark_manage_per_buffer = 0
    vim.g.bookmark_save_per_working_dir = 1
    vim.g.bookmark_center = 1
    vim.g.bookmark_auto_close = 1
    vim.g.bookmark_location_list = 1

    vim.keymap.set("n", "<leader>bt", "<cmd>BookmarkToggle<cr>", { desc = "Toggle bookmark" })
    vim.keymap.set("n", "<leader>ba", "<cmd>BookmarkAnnotate<cr>", { desc = "Annotate bookmark" })
    vim.keymap.set("n", "<leader>bs", "<cmd>BookmarkShowAll<cr>", { desc = "Show all bookmarks" })
    vim.keymap.set("n", "<leader>bn", "<cmd>BookmarkNext<cr>", { desc = "Next bookmark" })
    vim.keymap.set("n", "<leader>bp", "<cmd>BookmarkPrev<cr>", { desc = "Previous bookmark" })
    vim.keymap.set("n", "<leader>bc", "<cmd>BookmarkClear<cr>", { desc = "Clear bookmarks in buffer" })
    vim.keymap.set("n", "<leader>bx", "<cmd>BookmarkClearAll<cr>", { desc = "Clear all bookmarks" })
  end,
}
