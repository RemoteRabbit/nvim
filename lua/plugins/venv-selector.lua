return {
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    ft = "python",
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select Python environment" },
      { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Select cached environment" },
    },
    opts = {
      search = {},
      options = {},
    },
  },
}
