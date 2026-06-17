return {
  src = "https://github.com/christoomey/vim-tmux-navigator",
  config = function()
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { desc = desc })
    end

    map("<C-h>", "<cmd>TmuxNavigateLeft<CR>", "Move to left window/pane")
    map("<C-j>", "<cmd>TmuxNavigateDown<CR>", "Move to bottom window/pane")
    map("<C-k>", "<cmd>TmuxNavigateUp<CR>", "Move to top window/pane")
    map("<C-l>", "<cmd>TmuxNavigateRight<CR>", "Move to right window/pane")
  end,
}
