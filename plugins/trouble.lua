-- =============================================================================
-- KEYMAPDOC:START (auto-generated, do not edit)
-- n <leader>xx Diagnostics (Trouble)
-- n <leader>xA All views (Trouble)
-- n <leader>xX Buffer diagnostics (Trouble)
-- n <leader>xs Symbols (Trouble)
-- n <leader>xr LSP references/defs (Trouble)
-- n <leader>xl Location list (Trouble)
-- n <leader>xq Quickfix list (Trouble)
-- n <leader>xt Todos (Trouble)
-- KEYMAPDOC:END
-- =============================================================================

return {
  src = "https://github.com/folke/trouble.nvim",
  -- `main`, not the v3.7.1 tag: the tag's treesitter view calls the internal
  -- highlighter `_on_line`, which Neovim 0.12 removed (renamed to `_on_range`).
  -- main checks for `_on_range` and is compatible.
  version = "main",
  config = function()
    require("trouble").setup({})

    vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })

    --- The right-hand info column: todo-comments on top, document symbols below.
    ---@type table|nil the open todo view, used to detect/close the column
    local info_column = nil

    -- TODO: Adjust this to not open on dashboard

    --- Open the right-hand info column (todo + symbols).
    local function open_info_column()
      ---@module 'trouble' Load trouble module
      local trouble = require("trouble")

      --- Open Trouble.todo first as a window split.
      ---@class todo function
      ---@field mode string
      ---@field focus boolean
      ---@field win table
      ---@return function wait
      local todo = trouble.open({
        mode = "todo",
        focus = false,
        win = {
          type = "split",
          relative = "editor",
          position = "right",
          size = 0.15,
        },
      })
      info_column = todo

      todo:wait(function()
        trouble.open({
          mode = "symbols",
          focus = false,
          win = {
            type = "split",
            relative = "win",
            position = "bottom",
            win = todo.win.win,
          },
        })
      end)
    end

    --- Toggle the right-hand info column. Defaulted on (see autocmd below).
    local function toggle_info_column()
      local trouble = require("trouble")
      if info_column then
        trouble.close({ mode = "todo" })
        trouble.close({ mode = "symbols" })
        info_column = nil
      else
        open_info_column()
      end
    end

    vim.keymap.set("n", "<leader>xA", toggle_info_column, { desc = "All views (Trouble)" })

    -- Open the info column by default once the UI is ready.
    vim.api.nvim_create_autocmd("VimEnter", {
      once = true,
      callback = function()
        vim.schedule(open_info_column)
      end,
    })

    -- When quitting a normal window (e.g. `:q` in the editor), tear down the
    -- info column too so the trouble splits don't keep Neovim open.
    vim.api.nvim_create_autocmd("QuitPre", {
      callback = function()
        if not info_column then
          return
        end
        if vim.bo.filetype == "trouble" then
          return
        end
        local trouble = require("trouble")
        trouble.close({ mode = "todo" })
        trouble.close({ mode = "symbols" })
        info_column = nil
      end,
    })
    vim.keymap.set(
      "n",
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      { desc = "Buffer diagnostics (Trouble)" }
    )
    vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
    vim.keymap.set(
      "n",
      "<leader>xr",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      { desc = "LSP references/defs (Trouble)" }
    )
    vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list (Trouble)" })
    vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix list (Trouble)" })
    vim.keymap.set("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>", { desc = "Todos (Trouble)" })
  end,
}
