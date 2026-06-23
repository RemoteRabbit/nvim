--- todo-comments — highlights and lists TODO / FIXME / HACK / WARN / NOTE / etc.
--- comments in your code.
---
--- Integrations:
---   * Listing/searching uses the snacks picker (Snacks.picker.todo_comments).
---   * The full list also opens in Trouble via `:Trouble todo` (see
---     plugins/trouble.lua, <leader>xt).
---
--- Keymaps:
---   ]t / [t      jump to next / previous todo comment
---   <leader>ft   find todos (snacks picker)
---   <leader>fT   find todos limited to TODO/FIX/FIXME (snacks picker)
return {
  src = "https://github.com/folke/todo-comments.nvim",
  version = "v1.5.0",
  config = function()
    ---@module 'todo-comments' todo
    local todo = require("todo-comments")
    -- `signs = false` keeps the sign column free for gitsigns/diagnostics;
    -- highlighting of the comment keywords stays on.
    todo.setup({ signs = false })

    vim.keymap.set("n", "]t", function()
      todo.jump_next()
    end, { desc = "Next todo comment" })
    vim.keymap.set("n", "[t", function()
      todo.jump_prev()
    end, { desc = "Previous todo comment" })

    vim.keymap.set("n", "<leader>ft", function()
      Snacks.picker.todo_comments()
    end, { desc = "Find todos" })
    vim.keymap.set("n", "<leader>fT", function()
      Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
    end, { desc = "Find todos (TODO/FIX/FIXME)" })
  end,
}
