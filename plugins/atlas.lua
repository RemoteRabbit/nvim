return {
  src = "https://github.com/emrearmagan/atlas.nvim",
  config = function()
    require("atlas").setup({
      ui = {
        picker = "snacks",
      },
      providers = {
        github = {},
      },
      keymaps = {
        ui = {
          submit = "<M-s>",
        },
      },
    })
  end,
}
