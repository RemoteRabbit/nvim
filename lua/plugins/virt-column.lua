return {
  "lukas-reineke/virt-column.nvim",
  config = function()
    require("virt-column").setup({
      virtcolumn = "80,120",
      char = "┃",
      highlight = { "NonText" },
    })
  end,
}
