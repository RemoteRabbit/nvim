--- Native LuaSnip snippets for Terraform / OpenTofu (filetype `terraform`).
--- `.tofu` files are mapped to this filetype in lua/autocmds.lua, so these
--- snippets work for both. See snippets/all.lua for the format.

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Resource block.
  s(
    "resource",
    fmt(
      [[
        resource "{}" "{}" {{
          {}
        }}
      ]],
      { i(1, "type"), i(2, "name"), i(3) }
    )
  ),

  -- Data source block.
  s(
    "data",
    fmt(
      [[
        data "{}" "{}" {{
          {}
        }}
      ]],
      { i(1, "type"), i(2, "name"), i(3) }
    )
  ),

  -- Input variable.
  s(
    "variable",
    fmt(
      [[
        variable "{}" {{
          type        = {}
          description = "{}"
          default     = {}
        }}
      ]],
      { i(1, "name"), i(2, "string"), i(3), i(4, "null") }
    )
  ),

  -- Output value.
  s(
    "output",
    fmt(
      [[
        output "{}" {{
          description = "{}"
          value       = {}
        }}
      ]],
      { i(1, "name"), i(2), i(3) }
    )
  ),

  -- Module call.
  s(
    "module",
    fmt(
      [[
        module "{}" {{
          source = "{}"
          {}
        }}
      ]],
      { i(1, "name"), i(2, "./modules/example"), i(3) }
    )
  ),

  -- Provider block.
  s(
    "provider",
    fmt(
      [[
        provider "{}" {{
          {}
        }}
      ]],
      { i(1, "name"), i(2) }
    )
  ),

  -- Local values.
  s(
    "locals",
    fmt(
      [[
        locals {{
          {}
        }}
      ]],
      { i(1) }
    )
  ),

  -- terraform settings + required_providers.
  s(
    "terraform",
    fmt(
      [[
        terraform {{
          required_version = ">= {}"
          required_providers {{
            {} = {{
              source  = "{}"
              version = "{}"
            }}
          }}
        }}
      ]],
      { i(1, "1.6.0"), i(2, "aws"), i(3, "hashicorp/aws"), i(4, "~> 5.0") }
    )
  ),
}
