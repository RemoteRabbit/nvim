return {
  src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
  -- version = vim.version.range("*")
  config = function()
    require("tiny-inline-diagnostic").setup({
      options = {
        multilines = {
          enabled = true,
          always_show = true,
        },
        show_all_diags_on_cursorline = true,
      },
    })
  end,
}
