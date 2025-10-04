-- Enhanced snippets
return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local luasnip = require("luasnip")

    luasnip.setup({
      history = true,
      delete_check_events = "TextChanged",
      region_check_events = "CursorMoved",
      enable_autosnippets = true,
      store_selection_keys = "<Tab>",
      ft_func = function()
        return vim.split(vim.bo.filetype, ".", { plain = true })
      end,
    })

    -- Load VSCode snippets
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.config/nvim/snippets" })

    -- Load custom Lua snippets
    require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })

    -- Custom snippets
    local s = luasnip.snippet
    local t = luasnip.text_node
    local i = luasnip.insert_node
    local extras = require("luasnip.extras")
    local rep = extras.rep
    local fmt = require("luasnip.extras.fmt").fmt

    luasnip.add_snippets("python", {
      s(
        "def",
        fmt(
          [[
      def {}({}):
          """{}"""
          {}
      ]],
          { i(1, "function_name"), i(2), i(3, "Description"), i(0) }
        )
      ),

      s(
        "class",
        fmt(
          [[
      class {}({}):
          """{}"""

          def __init__(self{}):
              {}
      ]],
          { i(1, "ClassName"), i(2, "object"), i(3, "Description"), i(4), i(0) }
        )
      ),

      s(
        "ifmain",
        t({
          'if __name__ == "__main__":',
          "    main()",
        })
      ),
    })

    luasnip.add_snippets("go", {
      s(
        "func",
        fmt(
          [[
      func {}({}) {} {{
          {}
      }}
      ]],
          { i(1, "functionName"), i(2), i(3, "returnType"), i(0) }
        )
      ),

      s(
        "struct",
        fmt(
          [[
      type {} struct {{
          {}
      }}
      ]],
          { i(1, "StructName"), i(0) }
        )
      ),

      s(
        "iferr",
        t({
          "if err != nil {",
          "\treturn err",
          "}",
        })
      ),
    })

    luasnip.add_snippets("terraform", {
      s(
        "resource",
        fmt(
          [[
      resource "{}" "{}" {{
          {}
      }}
      ]],
          { i(1, "resource_type"), i(2, "name"), i(0) }
        )
      ),

      s(
        "variable",
        fmt(
          [[
      variable "{}" {{
          description = "{}"
          type        = {}
          default     = {}
      }}
      ]],
          { i(1, "var_name"), i(2, "description"), i(3, "string"), i(0) }
        )
      ),

      s(
        "output",
        fmt(
          [[
      output "{}" {{
          description = "{}"
          value       = {}
      }}
      ]],
          { i(1, "output_name"), i(2, "description"), i(0) }
        )
      ),

      s(
        "module",
        fmt(
          [[
      module "{}" {{
          source = "{}"

          # Required variables:
          {}

          # Optional variables:
          {}
      }}
      ]],
          { i(1, "module_name"), i(2, "./modules/example"), i(3, "# Add required vars"), i(0) }
        )
      ),
    })

    -- Keymaps
    vim.keymap.set({ "i" }, "<C-K>", function()
      luasnip.expand()
    end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<C-L>", function()
      luasnip.jump(1)
    end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<C-J>", function()
      luasnip.jump(-1)
    end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<C-E>", function()
      if luasnip.choice_active() then
        luasnip.change_choice(1)
      end
    end, { silent = true })
  end,
}
