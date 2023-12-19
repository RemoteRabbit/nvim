return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
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
      masonry = true,
      nvimtree = {
        enabled = true,
        show_root = true,
      },
      telescope = {
        enabled = true,
      },
      treesitter = true,
      notify = true,
      whichkey = true,
    },
    color_overrides = {
      mocha = {
        base = "#000000",
      },
    },
    highlight_overrides = {
      mocha = function(mocha)
        return {
          NvimTreeNormal = { bg = mocha.none },
        }
      end,
    },
  },
  config = function()
    -- vim.cmd.colorscheme("catppuccin")
    vim.g.catppuccino_flavor = "latte"
    vim.cmd([[colorscheme catppuccin]])
  end,
}
