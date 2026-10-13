--- Treesitter text objects + motions (any language with textobject queries).
---   select (visual/operator): af/if function · ac/ic class (Go: struct /
---     interface) · aa/ia parameter/argument      e.g. daf, vic, cia
---   move: ]f/[f next/prev function start · ]F/[F next/prev function end
return {
  src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  version = "main",
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = { lookahead = true },
      move = { set_jumps = true },
    })

    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")

    for lhs, spec in pairs({
      af = { "@function.outer", "Around function" },
      ["if"] = { "@function.inner", "Inside function" },
      ac = { "@class.outer", "Around class/struct" },
      ic = { "@class.inner", "Inside class/struct" },
      aa = { "@parameter.outer", "Around parameter" },
      ia = { "@parameter.inner", "Inside parameter" },
    }) do
      vim.keymap.set({ "x", "o" }, lhs, function()
        select.select_textobject(spec[1], "textobjects")
      end, { desc = spec[2] })
    end

    local nxo = { "n", "x", "o" }
    vim.keymap.set(nxo, "]f", function()
      move.goto_next_start("@function.outer", "textobjects")
    end, { desc = "Next function start" })
    vim.keymap.set(nxo, "[f", function()
      move.goto_previous_start("@function.outer", "textobjects")
    end, { desc = "Previous function start" })
    vim.keymap.set(nxo, "]F", function()
      move.goto_next_end("@function.outer", "textobjects")
    end, { desc = "Next function end" })
    vim.keymap.set(nxo, "[F", function()
      move.goto_previous_end("@function.outer", "textobjects")
    end, { desc = "Previous function end" })
  end,
}
