return {
  "warpaint9299/nvim-devdocs",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    ensure_installed = {
      "python-3.12",
      "python-3.13",
      "terraform",
    },
    float_win = {
      relative = "editor",
      height = 50,
      width = 200,
      border = "rounded",
    },
    hold_buf = true,
  },
}
