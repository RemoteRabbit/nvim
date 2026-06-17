return {
  src = "https://github.com/saghen/blink.cmp",
  version = vim.version.range("1.*"),
  config = function()
    require("blink.cmp").setup({
      keymap = { preset = "default" },
      appearance = {
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          update_delay_ms = 50,
          window = {
            border = "rounded",
          },
        },
        ghost_text = { enabled = true },
        menu = {
          border = "rounded",
          auto_show = true,
          max_height = 10,
          scrolloff = 2,
          scrollbar = true,
          draw = {
            treesitter = { "lsp" },
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
          },
        },
      },
      signature = { enabled = true },
      fuzzy = { implementation = "prefer_rust" },
    })
  end,
}
