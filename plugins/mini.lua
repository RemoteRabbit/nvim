return {
  src = "https://github.com/nvim-mini/mini.nvim",
  version = "stable",
  config = function()
    require("mini.map").setup()
    require("mini.tabline").setup()
    require("mini.icons").setup()
  end,
}
