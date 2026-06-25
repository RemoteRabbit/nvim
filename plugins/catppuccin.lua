return {
  src = "https://github.com/catppuccin/nvim",
  config = function()
    require("catppuccin").setup({
      flavor = "mocha",
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false, -- disables setting the background color.
      float = {
        transparent = false, -- enable transparent floating windows
        solid = false, -- use solid styling for floating windows, see |winborder|
      },
      term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
      dim_inactive = {
        enabled = true, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.25, -- percentage of the shade to apply to the inactive window
      },
      styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = { "standout" },
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = { "italic" },
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
      },
      lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
        virtual_text = {
          errors = { "italic", "undercurl" },
          hints = { "italic" },
          warnings = { "italic", "undercurl" },
          information = { "italic" },
          ok = { "italic" },
        },
        underlines = {
          errors = { "undercurl" },
          hints = { "underline" },
          warnings = { "undercurl" },
          information = { "underline" },
          ok = { "underline" },
        },
        inlay_hints = {
          background = true,
        },
      },
      color_overrides = {},
      custom_highlights = {},
      default_integrations = true,
      auto_integrations = true,
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        lualine = true,
        notify = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        trouble = true,
        which_key = true,
      },
    })

    -- setup must be called before loading
    vim.cmd.colorscheme("catppuccin-nvim")
  end,
}
