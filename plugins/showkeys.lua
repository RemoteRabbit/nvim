return {
  src = "https://github.com/nvzone/showkeys",
  config = function()
    require("showkeys").setup({
      maxkeys = 5,
      winopts = {
        border = "double",
        title = "Show Keys",
      },
    })
  end,
}
