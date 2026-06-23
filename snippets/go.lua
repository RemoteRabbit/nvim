--- Native LuaSnip snippets for Go.
--- See snippets/all.lua for the format.

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- if err != nil { return ... }
  s(
    "iferr",
    fmt(
      [[
        if err != nil {{
          return {}
        }}
      ]],
      { i(1, "err") }
    )
  ),

  -- Assign + error check.
  s(
    "ife",
    fmt(
      [[
        {}, err := {}
        if err != nil {{
          return {}
        }}
      ]],
      { i(1, "val"), i(2, "f()"), i(3, "err") }
    )
  ),

  -- Wrap an error with context.
  s("errf", fmt([[fmt.Errorf("{}: %w", {})]], { i(1, "context"), i(2, "err") })),

  -- func main.
  s(
    "main",
    fmt(
      [[
        func main() {{
          {}
        }}
      ]],
      { i(0) }
    )
  ),

  -- Function definition.
  s(
    "func",
    fmt(
      [[
        func {}({}) {} {{
          {}
        }}
      ]],
      { i(1, "name"), i(2), i(3), i(4) }
    )
  ),

  -- Method on a receiver.
  s(
    "meth",
    fmt(
      [[
        func ({} {}) {}({}) {} {{
          {}
        }}
      ]],
      { i(1, "r"), i(2, "Type"), i(3, "Name"), i(4), i(5), i(6) }
    )
  ),

  -- Struct type.
  s(
    "struct",
    fmt(
      [[
        type {} struct {{
          {}
        }}
      ]],
      { i(1, "Name"), i(2) }
    )
  ),

  -- Interface type.
  s(
    "interface",
    fmt(
      [[
        type {} interface {{
          {}
        }}
      ]],
      { i(1, "Name"), i(2) }
    )
  ),

  -- Table-driven test.
  s(
    "tt",
    fmt(
      [[
        func Test{}(t *testing.T) {{
          tests := []struct {{
            name string
            {}
          }}{{
            {}
          }}
          for _, tt := range tests {{
            t.Run(tt.name, func(t *testing.T) {{
              {}
            }})
          }}
        }}
      ]],
      { i(1, "Name"), i(2), i(3), i(4) }
    )
  ),

  -- Goroutine.
  s(
    "go",
    fmt(
      [[
        go func() {{
          {}
        }}()
      ]],
      { i(0) }
    )
  ),
}
