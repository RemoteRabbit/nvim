--- Native LuaSnip snippets for Python.
--- See snippets/all.lua for the format.

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- if __name__ == "__main__":
  s(
    "main",
    fmt(
      [[
        def main() -> None:
            {}


        if __name__ == "__main__":
            main()
      ]],
      { i(0, "pass") }
    )
  ),

  -- Function with type hints.
  s(
    "def",
    fmt(
      [[
        def {}({}) -> {}:
            {}
      ]],
      { i(1, "name"), i(2), i(3, "None"), i(4, "pass") }
    )
  ),

  -- Class definition.
  s(
    "class",
    fmt(
      [[
        class {}({}):
            def __init__(self{}) -> None:
                {}
      ]],
      { i(1, "Name"), i(2), i(3), i(4, "pass") }
    )
  ),

  -- Dataclass.
  s(
    "dataclass",
    fmt(
      [[
        @dataclass
        class {}:
            {}
      ]],
      { i(1, "Name"), i(2, "pass") }
    )
  ),

  -- try/except.
  s(
    "try",
    fmt(
      [[
        try:
            {}
        except {} as exc:
            {}
      ]],
      { i(1, "pass"), i(2, "Exception"), i(3, "raise") }
    )
  ),

  -- with context manager.
  s(
    "with",
    fmt(
      [[
        with {} as {}:
            {}
      ]],
      { i(1, "open(path)"), i(2, "f"), i(3, "pass") }
    )
  ),

  -- for loop.
  s(
    "for",
    fmt(
      [[
        for {} in {}:
            {}
      ]],
      { i(1, "item"), i(2, "iterable"), i(3, "pass") }
    )
  ),

  -- pytest test function.
  s(
    "test",
    fmt(
      [[
        def test_{}() -> None:
            {}
      ]],
      { i(1, "name"), i(2, "assert True") }
    )
  ),
}
