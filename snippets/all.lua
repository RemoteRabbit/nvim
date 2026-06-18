--- Native LuaSnip snippets available in *every* filetype.
---
--- File naming: <config>/snippets/<filetype>.lua  (this one is `all`, the
--- pseudo-filetype LuaSnip applies everywhere). Create e.g. `lua.lua`,
--- `python.lua`, `go.lua` for language-specific snippets. Loaded by the
--- from_lua loader configured in plugins/luasnip.lua.
---
--- A file returns a list of snippets. Type the snippet `trig` then expand it
--- from the blink.cmp menu (or with your accept key); jump tabstops with Tab.

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Static text: type `hi` -> expands to a greeting.
  s("hi", { f(function()
    return "Hello from LuaSnip!"
  end) }),

  -- Dynamic: inserts today's date. Demonstrates a function_node.
  s("date", {
    f(function()
      return os.date("%Y-%m-%d")
    end),
  }),

  -- Tabstops + placeholders: `${1} -> ${2}`. Tab jumps between them.
  s(
    "todo",
    fmt("TODO({}): {}", {
      i(1, "you"),
      i(2, "describe the task"),
    })
  ),
}
