--- Native LuaSnip snippets for Go.
--- See snippets/all.lua for the format.
---
--- `iferr`/`ife` read the enclosing function's result types with treesitter and
--- fill in matching zero values, e.g. inside `func f() (*T, int, error)` they
--- expand to `return nil, 0, err`. The error slot is a choice node: cycle
--- between `err` and `fmt.Errorf("...: %w", err)` with <C-l> (plugins/luasnip.lua).

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
--- fmt with each 2-space indent in the template turned into a real indent unit,
--- so expansions use tabs in Go buffers (noexpandtab) instead of literal spaces.
local function fmt(str, nodes)
  return require("luasnip.extras.fmt").fmt(str, nodes, { indent_string = "  " })
end
local rep = require("luasnip.extras").rep

local FUNC_NODES = { function_declaration = true, method_declaration = true, func_literal = true }

local NUMERIC = {}
for _, ty in ipairs({
  "int",
  "int8",
  "int16",
  "int32",
  "int64",
  "uint",
  "uint8",
  "uint16",
  "uint32",
  "uint64",
  "uintptr",
  "float32",
  "float64",
  "complex64",
  "complex128",
  "byte",
  "rune",
}) do
  NUMERIC[ty] = true
end

local NIL_KINDS = {
  pointer_type = true,
  slice_type = true,
  map_type = true,
  channel_type = true,
  function_type = true,
  interface_type = true,
}

--- Names of generic type parameters visible in `fn`, from its own type
--- parameter list and (for methods) the receiver, e.g. `func (s *Stack[T])`.
---@param fn TSNode
---@return table<string, true>
local function type_params(fn)
  local names = {}
  local function collect(node, in_params)
    for child in node:iter_children() do
      local kind = child:type()
      if in_params and (kind == "identifier" or kind == "type_identifier") then
        names[vim.treesitter.get_node_text(child, 0)] = true
      end
      collect(child, in_params or kind == "type_parameter_declaration" or kind == "type_arguments")
    end
  end
  for _, field in ipairs({ "type_parameters", "receiver" }) do
    local node = fn:field(field)[1]
    if node then
      collect(node, false)
    end
  end
  return names
end

--- Result type nodes of `fn`, one per returned value (`(a, b int)` -> int, int).
---@param fn TSNode
---@return TSNode[]
local function result_types(fn)
  local result = fn:field("result")[1]
  if not result then
    return {}
  elseif result:type() ~= "parameter_list" then
    return { result }
  end
  local types = {}
  for decl in result:iter_children() do
    if decl:type() == "parameter_declaration" then
      local ty = decl:field("type")[1]
      for _ = 1, math.max(#decl:field("name"), 1) do
        table.insert(types, ty)
      end
    end
  end
  return types
end

--- Zero-value snippet node for one result type.
---@param ty TSNode
---@param idx integer jump index
---@param generics table<string, true>
local function zero_value(ty, idx, generics)
  local text = vim.treesitter.get_node_text(ty, 0)
  if text == "error" then
    return c(idx, {
      t("err"),
      sn(nil, { t('fmt.Errorf("'), i(1, "context"), t(': %w", err)') }),
    })
  end
  local value
  if NUMERIC[text] then
    value = "0"
  elseif text == "string" then
    value = '""'
  elseif text == "bool" then
    value = "false"
  elseif NIL_KINDS[ty:type()] or text == "any" then
    value = "nil"
  elseif generics[text] then
    value = "*new(" .. text .. ")"
  else
    -- Named/qualified type: assume a struct. Tab to it to fix up interfaces.
    value = text .. "{}"
  end
  return i(idx, value)
end

--- Dynamic node producing `return <zero values...>` for the enclosing function.
---@param jump integer jump index of the dynamic node
local function go_return(jump)
  return d(jump, function()
    local fn
    if pcall(function()
      vim.treesitter.get_parser(0, "go"):parse()
    end) then
      local ok, node = pcall(vim.treesitter.get_node, { bufnr = 0, ignore_injections = true })
      fn = ok and node or nil
      while fn and not FUNC_NODES[fn:type()] do
        fn = fn:parent()
      end
    end
    if not fn then
      return sn(nil, { t("return "), i(1, "err") })
    end

    local types = result_types(fn)
    if #types == 0 then
      return sn(nil, { t("return") })
    end
    local generics = type_params(fn)
    local nodes = { t("return ") }
    for idx, ty in ipairs(types) do
      if idx > 1 then
        table.insert(nodes, t(", "))
      end
      table.insert(nodes, zero_value(ty, idx, generics))
    end
    return sn(nil, nodes)
  end)
end

return {
  -- if err != nil { return <zero values>, err }
  s(
    "iferr",
    fmt(
      [[
        if err != nil {{
          {}
        }}
      ]],
      { go_return(1) }
    )
  ),

  -- Assign + error check.
  s(
    "ife",
    fmt(
      [[
        {}, err := {}
        if err != nil {{
          {}
        }}
      ]],
      { i(1, "val"), i(2, "f()"), go_return(3) }
    )
  ),

  -- Error check inside a test.
  s(
    "terr",
    fmt(
      [[
        if err != nil {{
          t.Fatalf("{}: %v", err)
        }}
      ]],
      { i(1, "unexpected error") }
    )
  ),

  -- Wrap an error with context.
  s("errf", fmt([[fmt.Errorf("{}: %w", {})]], { i(1, "context"), i(2, "err") })),

  -- Sentinel error.
  s("errv", fmt([[var Err{} = errors.New("{}")]], { i(1, "NotFound"), i(2, "not found") })),

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

  -- Constructor.
  s(
    "new",
    fmt(
      [[
        func New{}({}) *{} {{
          return &{}{{
            {}
          }}
        }}
      ]],
      { i(1, "Type"), i(2), rep(1), rep(1), i(0) }
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

  -- context.Context parameter.
  s("ctx", t("ctx context.Context")),

  -- Context with timeout.
  s(
    "ctxt",
    fmt(
      [[
        ctx, cancel := context.WithTimeout({}, {})
        defer cancel()
      ]],
      { i(1, "ctx"), i(2, "5*time.Second") }
    )
  ),

  -- Lock + deferred unlock.
  s(
    "lock",
    fmt(
      [[
        {}.Lock()
        defer {}.Unlock()
      ]],
      { i(1, "mu"), rep(1) }
    )
  ),

  -- Select on a channel with context cancellation.
  s(
    "sel",
    fmt(
      [[
        select {{
        case <-ctx.Done():
          return ctx.Err()
        case {} := <-{}:
          {}
        }}
      ]],
      { i(1, "v"), i(2, "ch"), i(0) }
    )
  ),

  -- Type switch.
  s(
    "tsw",
    fmt(
      [[
        switch v := {}.(type) {{
        case {}:
          {}
        default:
          {}
        }}
      ]],
      { i(1, "x"), i(2, "string"), i(3), i(0) }
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

  -- WaitGroup fan-out.
  s(
    "wg",
    fmt(
      [[
        var wg sync.WaitGroup
        for _, {} := range {} {{
          wg.Add(1)
          go func() {{
            defer wg.Done()
            {}
          }}()
        }}
        wg.Wait()
      ]],
      { i(1, "item"), i(2, "items"), i(0) }
    )
  ),

  -- HTTP handler func.
  s(
    "hf",
    fmt(
      [[
        func {}(w http.ResponseWriter, r *http.Request) {{
          {}
        }}
      ]],
      { i(1, "handler"), i(0) }
    )
  ),

  -- Plain test.
  s(
    "test",
    fmt(
      [[
        func Test{}(t *testing.T) {{
          {}
        }}
      ]],
      { i(1, "Name"), i(0) }
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

  -- Benchmark (Go 1.24+ b.Loop).
  s(
    "bench",
    fmt(
      [[
        func Benchmark{}(b *testing.B) {{
          for b.Loop() {{
            {}
          }}
        }}
      ]],
      { i(1, "Name"), i(0) }
    )
  ),

  -- Fuzz test.
  s(
    "fuzz",
    fmt(
      [[
        func Fuzz{}(f *testing.F) {{
          f.Add({})
          f.Fuzz(func(t *testing.T, {}) {{
            {}
          }})
        }}
      ]],
      { i(1, "Name"), i(2, '"seed"'), i(3, "in string"), i(0) }
    )
  ),
}
