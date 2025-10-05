return {
  "ldelossa/litee.nvim",
  config = function()
    require("litee.lib").setup({
      tree = {
        icon_set = "codicons",
      },
      panel = {
        orientation = "bottom",
        panel_size = 10,
      },
    })
  end,
}
