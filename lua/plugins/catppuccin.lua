return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,

  config = function()
    vim.g.catppuccin_flavour = "mocha"
    require("catppuccin").setup({
      transparent_background = true,
      term_colors = false,
      compile = {
        enabled = false,
        path = vim.fn.stdpath("cache") .. "/catppuccin",
      },
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      integrations = {
        alpha = true,
        cmp = true,
        gitsigns = true,
        nvimtree = {
          enabled = true,
          show_root = true,
        },
        telescope = {
          enabled = true,
        },
        treesitter = true,
        notify = true,
        semantic_tokens = true,
      },
      custom_highlights = function(colors)
        return {
          -- Enhanced semantic tokens using full Catppuccin palette
          ["@lsp.type.namespace"] = { fg = colors.rosewater, style = { "bold" } },
          ["@lsp.type.type"] = { fg = colors.yellow, style = { "bold" } },
          ["@lsp.type.class"] = { fg = colors.peach, style = { "bold" } },
          ["@lsp.type.enum"] = { fg = colors.flamingo, style = { "bold" } },
          ["@lsp.type.interface"] = { fg = colors.sapphire, style = { "bold" } },
          ["@lsp.type.struct"] = { fg = colors.yellow, style = { "italic" } },
          ["@lsp.type.parameter"] = { fg = colors.maroon, style = { "italic" } },
          ["@lsp.type.variable"] = { fg = colors.text },
          ["@lsp.type.property"] = { fg = colors.teal, style = { "italic" } },
          ["@lsp.type.enumMember"] = { fg = colors.sky, style = { "bold" } },
          ["@lsp.type.function"] = { fg = colors.blue, style = { "bold" } },
          ["@lsp.type.method"] = { fg = colors.sapphire, style = { "bold" } },
          ["@lsp.type.macro"] = { fg = colors.mauve, style = { "bold" } },
          ["@lsp.type.decorator"] = { fg = colors.pink, style = { "italic" } },
          ["@lsp.type.keyword"] = { fg = colors.mauve, style = { "bold" } },
          ["@lsp.type.string"] = { fg = colors.green, style = { "italic" } },
          ["@lsp.type.number"] = { fg = colors.peach },
          ["@lsp.type.regexp"] = { fg = colors.pink, style = { "bold" } },
          ["@lsp.type.operator"] = { fg = colors.sky },
          ["@lsp.type.comment"] = { fg = colors.overlay1, style = { "italic" } },

          -- Language-specific enhancements using Catppuccin palette
          
          -- Terraform
          ["@lsp.type.variable.terraform"] = { fg = colors.flamingo, style = { "bold" } },
          ["@lsp.type.property.terraform"] = { fg = colors.sapphire, style = { "italic" } },
          ["@lsp.type.string.terraform"] = { fg = colors.green, style = { "bold" } },
          ["@lsp.type.keyword.terraform"] = { fg = colors.mauve, style = { "bold" } },
          ["@lsp.type.function.terraform"] = { fg = colors.sky, style = { "bold" } },
          ["@lsp.type.type.terraform"] = { fg = colors.peach, style = { "bold" } },
          ["@lsp.type.parameter.terraform"] = { fg = colors.rosewater, style = { "italic" } },
          ["@lsp.type.namespace.terraform"] = { fg = colors.lavender, style = { "bold" } },
          ["@lsp.type.operator.terraform"] = { fg = colors.pink },
          ["@lsp.type.number.terraform"] = { fg = colors.peach, style = { "bold" } },

          -- Python  
          ["@lsp.type.class.python"] = { fg = colors.peach, style = { "bold" } },
          ["@lsp.type.function.python"] = { fg = colors.blue, style = { "bold" } },
          ["@lsp.type.method.python"] = { fg = colors.sapphire, style = { "bold" } },
          ["@lsp.type.decorator.python"] = { fg = colors.pink, style = { "italic" } },
          ["@lsp.type.variable.python"] = { fg = colors.text },
          ["@lsp.type.parameter.python"] = { fg = colors.maroon, style = { "italic" } },

          -- Go
          ["@lsp.type.type.go"] = { fg = colors.yellow, style = { "bold" } },
          ["@lsp.type.function.go"] = { fg = colors.blue, style = { "bold" } },
          ["@lsp.type.method.go"] = { fg = colors.sapphire, style = { "bold" } },
          ["@lsp.type.struct.go"] = { fg = colors.peach, style = { "bold" } },
          ["@lsp.type.interface.go"] = { fg = colors.flamingo, style = { "bold" } },

          -- Elixir
          ["@lsp.type.function.elixir"] = { fg = colors.blue, style = { "bold" } },
          ["@lsp.type.module.elixir"] = { fg = colors.rosewater, style = { "bold" } },
          ["@lsp.type.atom.elixir"] = { fg = colors.lavender, style = { "italic" } },
          ["@lsp.type.variable.elixir"] = { fg = colors.text },

          -- JSON/YAML
          ["@lsp.type.property.json"] = { fg = colors.sky, style = { "italic" } },
          ["@lsp.type.string.json"] = { fg = colors.green },
          ["@lsp.type.property.yaml"] = { fg = colors.teal, style = { "italic" } },
          ["@lsp.type.string.yaml"] = { fg = colors.green },

          -- Lua
          ["@lsp.type.function.lua"] = { fg = colors.blue, style = { "bold" } },
          ["@lsp.type.variable.lua"] = { fg = colors.text },
          ["@lsp.type.property.lua"] = { fg = colors.teal, style = { "italic" } },
        }
      end,
    })
    vim.cmd([[colorscheme catppuccin]])
  end,
}
