return {
  "dhruvasagar/vim-table-mode",
  ft = { "markdown", "text", "org" },
  config = function()
    -- Use markdown-compatible corners
    vim.g.table_mode_corner = "|"
    vim.g.table_mode_corner_corner = "|"
    vim.g.table_mode_header_fillchar = "-"
    
    -- Enable table mode for markdown files by default
    vim.g.table_mode_map_prefix = "<Leader>t"
    
    -- Disable default mappings to avoid conflicts
    vim.g.table_mode_disable_mappings = 0
    
    -- Auto format tables when typing
    vim.g.table_mode_auto_align = 1
    
    -- Syntax for tables
    vim.g.table_mode_syntax = 1
    
    -- Motion mappings for tables
    vim.g.table_mode_motion_up_map = '<Bar><Up>'
    vim.g.table_mode_motion_down_map = '<Bar><Down>'
    vim.g.table_mode_motion_left_map = '<Bar><Left>'
    vim.g.table_mode_motion_right_map = '<Bar><Right>'
    
    -- Keymaps
    vim.keymap.set("n", "<leader>mt", ":TableModeToggle<CR>", { desc = "Toggle Table Mode" })
    vim.keymap.set("n", "<leader>ma", ":TableModeRealign<CR>", { desc = "Realign Table" })
    
    -- Auto-enable table mode for markdown files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.cmd("TableModeEnable")
      end,
    })
  end,
}
