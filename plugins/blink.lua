-- ===============================Keymaps Start=================================
-- (no keymaps found)
-- =================================Keymaps End=================================

return {
  src = "https://github.com/saghen/blink.cmp",
  version = vim.version.range("1.*"),
  config = function()
    require("blink.cmp").setup({
      keymap = {
        preset = "default",
        -- Jump through snippet tabstops (LuaSnip). Falls back to normal
        -- Tab behaviour when not inside a snippet.
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          -- Rank LSP results above everything else, then snippets, then
          -- path, then plain buffer words. This is what makes the menu feel
          -- "smart" without any AI source.
          lsp = { score_offset = 10 },
          snippets = { score_offset = 8 },
          path = { score_offset = 5 },
          buffer = {
            -- Buffer words are the weakest signal, so only offer them once a
            -- few characters are typed (keeps short LSP matches at the top).
            min_keyword_length = 4,
            score_offset = 0,
            opts = {
              -- Pull words from every loaded normal-file buffer, not just the
              -- current one — handy when jumping between related files.
              get_bufnrs = function()
                return vim.tbl_filter(function(bufnr)
                  return vim.bo[bufnr].buftype == ""
                end, vim.api.nvim_list_bufs())
              end,
            },
          },
        },
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
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
      signature = {
        enabled = true,
        trigger = { show_on_insert = true },
        window = { border = "rounded" },
      },
      snippets = { preset = "luasnip" },
      fuzzy = { implementation = "prefer_rust" },
    })
  end,
}
