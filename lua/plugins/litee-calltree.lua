return {
  "ldelossa/litee-calltree.nvim",
  dependencies = "ldelossa/litee.nvim",
  config = function()
    require("litee.calltree").setup({
      resolve_symbols = true,
      jump_mode = "invoking",
      hide_cursor = false,
      keymaps = {
        expand = "o",
        collapse = "zc",
        collapse_all = "zM",
        jump = "<CR>",
        jump_split = "s",
        jump_vsplit = "v",
        jump_tab = "t",
        hover = "i",
        details = "d",
        close = "X",
        close_panel_pop_out = "<Esc>",
        help = "?",
        hide = "H",
        switch = "S",
        focus = "f",
      },
    })

    vim.keymap.set("n", "<leader>ci", "<cmd>LTOpenToCalltreeIncoming<cr>", { desc = "Incoming calls" })
    vim.keymap.set("n", "<leader>co", "<cmd>LTOpenToCalltreeOutgoing<cr>", { desc = "Outgoing calls" })
  end,
}
