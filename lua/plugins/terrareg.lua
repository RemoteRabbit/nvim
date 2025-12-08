return {
  "terrareg.nvim",
  dir = "/home/remoterabbit/repos/open/terrareg",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("terrareg").setup({
      debug = true,
      ensure_installed = { "aws" },
      keep_float_buffers = true,
    })
  end,
  -- ft = { "terraform", "hcl" },
}
