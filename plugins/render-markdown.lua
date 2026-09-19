return {
  src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  config = function()
    require("render-markdown").setup({
      completions = {
        lsp = { enabled = true },
      },
      render_modes = true,
    })
  end,
}
