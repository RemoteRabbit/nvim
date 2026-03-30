return {
  "dhruvasagar/vim-table-mode",
  ft = { "markdown", "text", "org" },
  config = function()
    -- Use markdown-compatible corners
    vim.g.table_mode_corner = "|"
    vim.g.table_mode_corner_corner = "|"
    vim.g.table_mode_header_fillchar = "-"

    -- Enable table mode for markdown files by default
    vim.g.table_mode_map_prefix = "<Leader>m"

    -- Disable default mappings to avoid conflicts
    vim.g.table_mode_disable_mappings = 0

    -- Auto format tables when typing
    vim.g.table_mode_auto_align = 1

    -- Syntax for tables
    vim.g.table_mode_syntax = 1

    -- Motion mappings for tables
    vim.g.table_mode_motion_up_map = "<Bar><Up>"
    vim.g.table_mode_motion_down_map = "<Bar><Down>"
    vim.g.table_mode_motion_left_map = "<Bar><Left>"
    vim.g.table_mode_motion_right_map = "<Bar><Right>"

    vim.keymap.set("n", "<leader>mt", ":TableModeToggle<CR>", { desc = "Toggle Table Mode" })
  end,
}
