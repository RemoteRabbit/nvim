return {
  {
    -- Python environment management
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    config = function()
      require("venv-selector").setup({
        name = {
          "venv",
          ".venv",
          "env",
          ".env",
        },
        auto_refresh = false,
        search = true,
        dap_enabled = true,
        parents = 0,
        path = nil,
        stay_on_this_version = true,
        anaconda_base_path = "~/anaconda3",
        anaconda_envs_path = "~/anaconda3/envs",
        pyenv_path = "~/.pyenv/versions",
        fd_binary_name = "fd",
      })

      vim.keymap.set("n", "<leader>vs", "<cmd>VenvSelect<cr>", { desc = "Select Python environment" })
      vim.keymap.set("n", "<leader>vc", "<cmd>VenvSelectCached<cr>", { desc = "Select cached environment" })
    end,
  },
}
