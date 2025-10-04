-- Database browser
return {
  {
    -- Database browser
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_messages = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 40

      -- Keymaps
      vim.keymap.set("n", "<leader>Du", "<cmd>DBUIToggle<cr>", { desc = "Toggle DBUI" })
      vim.keymap.set("n", "<leader>Df", "<cmd>DBUIFindBuffer<cr>", { desc = "Find DB buffer" })
      vim.keymap.set("n", "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", { desc = "Rename DB buffer" })
      vim.keymap.set("n", "<leader>Dq", "<cmd>DBUILastQueryInfo<cr>", { desc = "Last query info" })
    end,
  },
}
