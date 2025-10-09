return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "🤯" },
        change = { text = "🫣" },
        delete = { text = "❌" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "⏰" },
      },
      signcolumn = true,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "right_align",
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
      current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
      watch_gitdir = {
        follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = false,
      sign_priority = 6,
      update_debounce = 100,
    })
  end,
}
