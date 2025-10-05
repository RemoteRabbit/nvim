return {
  "cappyzawa/telescope-terraform.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("telescope").load_extension("terraform")
  end,
  keys = {
    { "<leader>tr", "<cmd>Telescope terraform modules<cr>", desc = "Terraform Registry Modules" },
  },
}
