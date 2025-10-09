return {
  "terrareg.nvim",
  dir = "/home/remoterabbit/repos/open/terrareg",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("terrareg").setup({
      providers = {
        "aws",
        "azure",
        "gcp",
      },
      debug = false,
    })
  end,
  ft = { "terraform", "hcl" },
}
