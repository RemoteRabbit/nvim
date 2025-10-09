return {
  {
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate").configure({
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
        delay = 100,
        filetype_overrides = {},
        filetypes_denylist = {
          "dirvish",
          "fugitive",
          "NvimTree",
          "Trouble",
        },
        filetypes_allowlist = {},
        modes_denylist = {},
        modes_allowlist = {},
        providers_regex_syntax_denylist = {},
        providers_regex_syntax_allowlist = {},
        under_cursor = true,
        large_file_cutoff = nil,
        large_file_overrides = nil,
        min_count_to_highlight = 1,
      })

      -- Keymaps for reference navigation
      vim.keymap.set("n", "<A-n>", function()
        require("illuminate").goto_next_reference()
      end, { desc = "Next reference" })
      vim.keymap.set("n", "<A-p>", function()
        require("illuminate").goto_prev_reference()
      end, { desc = "Previous reference" })
    end,
  },
}
