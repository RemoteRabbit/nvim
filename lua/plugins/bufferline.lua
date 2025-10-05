return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("bufferline").setup({
      options = {
        mode = "buffers",
        numbers = "none",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator = {
          icon = "▎",
          style = "icon",
        },
        buffer_close_icon = "󰅖",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 30,
        max_prefix_length = 30,
        truncate_names = true,
        tab_size = 21,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "left",
            separator = true,
          },
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_duplicate_prefix = true,
        persist_buffer_sort = true,
        separator_style = "slant",
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
        sort_by = "insert_after_current",
      },
    })

    vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
    vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
    vim.keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
    vim.keymap.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
    vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Pin buffer" })
    vim.keymap.set("n", "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete non-pinned buffers" })
    vim.keymap.set("n", "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", { desc = "Delete other buffers" })
    vim.keymap.set("n", "<leader>br", "<Cmd>BufferLineCloseRight<CR>", { desc = "Delete buffers to the right" })
    vim.keymap.set("n", "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Delete buffers to the left" })
  end,
}
