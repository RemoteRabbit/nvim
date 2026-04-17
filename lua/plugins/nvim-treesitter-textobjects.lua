return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  init = function()
    vim.g.no_plugin_maps = true
  end,
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
        selection_modes = {
          ["@parameter.outer"] = "v",
          ["@function.outer"] = "V",
          ["@class.outer"] = "<c-v>",
        },
        include_surrounding_whitespace = true,
      },
      move = {
        set_jumps = true,
      },
    })

    -- Select keymaps
    local select = require("nvim-treesitter-textobjects.select")
    vim.keymap.set({ "x", "o" }, "af", function()
      select.select_textobject("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "if", function()
      select.select_textobject("@function.inner", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "ac", function()
      select.select_textobject("@class.outer", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "ic", function()
      select.select_textobject("@class.inner", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "aa", function()
      select.select_textobject("@parameter.outer", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "ia", function()
      select.select_textobject("@parameter.inner", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "ab", function()
      select.select_textobject("@block.outer", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "ib", function()
      select.select_textobject("@block.inner", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "al", function()
      select.select_textobject("@loop.outer", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "il", function()
      select.select_textobject("@loop.inner", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "ai", function()
      select.select_textobject("@conditional.outer", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "ii", function()
      select.select_textobject("@conditional.inner", "textobjects")
    end)

    -- Move keymaps
    local move = require("nvim-treesitter-textobjects.move")
    vim.keymap.set({ "n", "x", "o" }, "]m", function()
      move.goto_next_start("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "]]", function()
      move.goto_next_start("@class.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "]a", function()
      move.goto_next_start("@parameter.inner", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "]M", function()
      move.goto_next_end("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "][", function()
      move.goto_next_end("@class.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "]A", function()
      move.goto_next_end("@parameter.inner", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[m", function()
      move.goto_previous_start("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[[", function()
      move.goto_previous_start("@class.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[a", function()
      move.goto_previous_start("@parameter.inner", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[M", function()
      move.goto_previous_end("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[]", function()
      move.goto_previous_end("@class.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[A", function()
      move.goto_previous_end("@parameter.inner", "textobjects")
    end)

    -- Swap keymaps
    local swap = require("nvim-treesitter-textobjects.swap")
    vim.keymap.set("n", "]p", function()
      swap.swap_next("@parameter.inner")
    end)
    vim.keymap.set("n", "]s", function()
      swap.swap_next("@function.outer")
    end)
    vim.keymap.set("n", "[p", function()
      swap.swap_previous("@parameter.inner")
    end)
    vim.keymap.set("n", "[s", function()
      swap.swap_previous("@function.outer")
    end)
  end,
}
