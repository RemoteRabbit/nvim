return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  dependencies = {
    "saghen/blink.cmp",
  },
  config = function()
    require("nvim-autopairs").setup({
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
      enable_moveright = true,
      enable_afterquote = true,
      enable_check_bracket_line = false,
      enable_bracket_in_quote = true,
      enable_abbr = false,
      break_undo = true,
      map_bs = true,
      map_c_h = false,
      map_c_w = false,
    })
  end,
}
