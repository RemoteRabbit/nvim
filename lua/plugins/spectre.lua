return {
  "nvim-pack/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Spectre",
  opts = { open_cmd = "noswapfile vnew" },
  keys = {
    { "<leader>fr", "<CMD>Spectre<CR>", desc = "Replace in files (Spectre)" },
  },
}
