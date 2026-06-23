--- Native LuaSnip snippets for shell/bash (filetype `sh`).
--- See snippets/all.lua for the format.

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Safe bash header: shebang + strict mode.
  s(
    "shebang",
    fmt(
      [[
        #!/usr/bin/env bash
        set -euo pipefail
        {}
      ]],
      { i(0) }
    )
  ),

  -- Strict mode line on its own.
  s("strict", { ls.text_node("set -euo pipefail") }),

  -- if statement.
  s(
    "if",
    fmt(
      [[
        if {}; then
          {}
        fi
      ]],
      { i(1, '[[ -n "$var" ]]'), i(2, ":") }
    )
  ),

  -- if/else statement.
  s(
    "ife",
    fmt(
      [[
        if {}; then
          {}
        else
          {}
        fi
      ]],
      { i(1, '[[ -n "$var" ]]'), i(2, ":"), i(3, ":") }
    )
  ),

  -- for loop.
  s(
    "for",
    fmt(
      [[
        for {} in {}; do
          {}
        done
      ]],
      { i(1, "item"), i(2, '"${arr[@]}"'), i(3, ":") }
    )
  ),

  -- while loop.
  s(
    "while",
    fmt(
      [[
        while {}; do
          {}
        done
      ]],
      { i(1, "true"), i(2, ":") }
    )
  ),

  -- case statement.
  s(
    "case",
    fmt(
      [[
        case "{}" in
          {})
            {}
            ;;
          *)
            {}
            ;;
        esac
      ]],
      { i(1, "$1"), i(2, "pattern"), i(3, ":"), i(4, ":") }
    )
  ),

  -- Function definition.
  s(
    "func",
    fmt(
      [[
        {}() {{
          {}
        }}
      ]],
      { i(1, "name"), i(2, ":") }
    )
  ),

  -- Guard: require a command to exist.
  s(
    "need",
    fmt(
      [[command -v {} >/dev/null 2>&1 || {{ echo "{} is required" >&2; exit 1; }}]],
      { i(1, "cmd"), ls.function_node(function(args)
        return args[1][1]
      end, { 1 }) }
    )
  ),
}
