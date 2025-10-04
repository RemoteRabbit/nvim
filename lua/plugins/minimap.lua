-- Minimap
return {
  "wfxr/minimap.vim",
  build = "cargo install --locked code-minimap",
  config = function()
    vim.g.minimap_width = 10
    vim.g.minimap_auto_start = 1
    vim.g.minimap_auto_start_win_enter = 1
    vim.g.minimap_block_filetypes = { "fugitive", "nerdtree", "tagbar", "NvimTree" }
    vim.g.minimap_close_filetypes = { "startify", "netrw", "vim-plug" }
    vim.g.minimap_highlight_range = 1
    vim.g.minimap_highlight_search = 1
    vim.g.minimap_git_colors = 1

    -- Keymaps
    vim.keymap.set("n", "<leader>mm", "<cmd>MinimapToggle<cr>", { desc = "Toggle minimap" })
    vim.keymap.set("n", "<leader>mr", "<cmd>MinimapRefresh<cr>", { desc = "Refresh minimap" })
    vim.keymap.set("n", "<leader>mc", "<cmd>MinimapClose<cr>", { desc = "Close minimap" })
  end,
}
