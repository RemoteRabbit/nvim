--- Native LuaSnip snippets for Lua. See snippets/all.lua for the format.
--- Type a `trig` then expand from the blink.cmp menu; Tab jumps tabstops.

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

return {
  -- Local function.
  s(
    "lf",
    fmt(
      [[
        local function {}({})
          {}
        end
      ]],
      { i(1, "name"), i(2), i(3) }
    )
  ),

  -- Anonymous/assigned function.
  s(
    "fn",
    fmt(
      [[
        function {}({})
          {}
        end
      ]],
      { i(1, "name"), i(2), i(3) }
    )
  ),

  -- for ipairs loop.
  s(
    "fori",
    fmt(
      [[
        for {}, {} in ipairs({}) do
          {}
        end
      ]],
      { i(1, "idx"), i(2, "value"), i(3, "tbl"), i(4) }
    )
  ),

  -- for pairs loop.
  s(
    "forp",
    fmt(
      [[
        for {}, {} in pairs({}) do
          {}
        end
      ]],
      { i(1, "key"), i(2, "value"), i(3, "tbl"), i(4) }
    )
  ),

  -- pcall wrapper.
  s("pcall", fmt("local ok, {} = pcall({})", { i(1, "res"), i(2, "fn") })),

  -- require assignment.
  s("req", fmt([[local {} = require("{}")]], { i(1, "mod"), i(2, "module") })),

  -- if statement.
  s(
    "if",
    fmt(
      [[
        if {} then
          {}
        end
      ]],
      { i(1, "cond"), i(2) }
    )
  ),

  -- Buffer-local autocmd.
  s(
    "aucmd",
    fmt(
      [[
        vim.api.nvim_create_autocmd("{}", {{
          group = {},
          callback = function({})
            {}
          end,
        }})
      ]],
      { i(1, "Event"), i(2, "group"), i(3, "args"), i(4) }
    )
  ),

  -- Keymap.
  s(
    "map",
    fmta([[vim.keymap.set("<mode>", "<lhs>", <rhs>, { desc = "<desc>" })]], {
      mode = i(1, "n"),
      lhs = i(2),
      rhs = i(3, "function() end"),
      desc = i(4),
    })
  ),

  -- Module skeleton (M table + return).
  s(
    "mod",
    fmt(
      [[
        local M = {{}}

        {}

        return M
      ]],
      { i(1) }
    )
  ),
}
