--- Native LuaSnip snippets for Markdown.
--- See snippets/all.lua for the format.

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

return {
  -- Fenced code block.
  s(
    "code",
    fmt(
      [[
        ```{}
        {}
        ```
      ]],
      { i(1, "lang"), i(2) }
    )
  ),

  -- Link.
  s("link", fmta("[<text>](<url>)", { text = i(1, "text"), url = i(2, "https://") })),

  -- Image.
  s("img", fmta("![<alt>](<src>)", { alt = i(1, "alt"), src = i(2, "path") })),

  -- Table (2 columns).
  s(
    "table",
    fmt(
      [[
        | {} | {} |
        | --- | --- |
        | {} | {} |
      ]],
      { i(1, "Col1"), i(2, "Col2"), i(3), i(4) }
    )
  ),

  -- Collapsible details block.
  s(
    "details",
    fmt(
      [[
        <details>
        <summary>{}</summary>

        {}

        </details>
      ]],
      { i(1, "Summary"), i(2) }
    )
  ),

  -- YAML frontmatter.
  s(
    "frontmatter",
    fmt(
      [[
        ---
        title: {}
        date: {}
        ---
        {}
      ]],
      { i(1, "Title"), i(2, os.date("%Y-%m-%d")), i(0) }
    )
  ),

  -- Task list item.
  s("todo", fmt("- [ ] {}", { i(1) })),
}
