--- Neogen — generates annotation/docstring skeletons for the function, class,
--- or type under the cursor using treesitter (see plugins/nvim-treesitter.lua).
---
--- Supports many languages and conventions (Python: google/numpy/reST,
--- Lua: emmylua/ldoc, JS/TS: jsdoc, Go: godoc, Rust, etc.).
---
--- Generated docstrings are emitted as LuaSnip snippets (see plugins/luasnip.lua),
--- so you Tab/S-Tab through the fields to fill them in.
---
--- Usage: place cursor in/above a function and press <leader>cd.
return {
  src = "https://github.com/danymat/neogen",
  config = function()
    require("neogen").setup({
      snippet_engine = "luasnip",
    })

    vim.keymap.set("n", "<leader>cd", function()
      require("neogen").generate()
    end, { desc = "Generate docstring" })
  end,
}
