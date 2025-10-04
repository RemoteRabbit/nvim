return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  dependencies = {
    "saghen/blink.cmp",
  },
  config = function()
    local autopairs = require("nvim-autopairs")

    autopairs.setup({
      check_ts = true,
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
        java = false,
      },
    })

    -- blink.cmp integration
    local blink = require("blink.cmp")
    if blink and blink.setup then
      autopairs.setup({
        map_char = {
          all = "(",
          tex = "{",
        },
        enable_check_bracket_line = false,
        check_ts = true,
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
          java = false,
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        disable_in_macro = true,
        disable_in_visualblock = false,
        disable_in_replace_mode = true,
        ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
        enable_moveright = true,
        enable_afterquote = true,
        enable_bracket_in_quote = true,
        enable_abbr = false,
        break_undo = true,
        map_bs = true,
        map_c_h = false,
        map_c_w = false,
      })
    end
  end,
}
