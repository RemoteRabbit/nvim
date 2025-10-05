return {
  {
    -- REST client
    "mistweaverco/kulala.nvim",
    config = function()
      require("kulala").setup({
        default_view = "body",
        default_env = "dev",
        debug = false,
      })

      -- Keymaps (using <leader>R for REST to avoid conflict with run/tasks)
      vim.keymap.set("n", "<leader>Rr", "<cmd>lua require('kulala').run()<cr>", { desc = "Run REST request" })
      vim.keymap.set("n", "<leader>Rp", "<cmd>lua require('kulala').preview()<cr>", { desc = "Preview REST request" })
      vim.keymap.set(
        "n",
        "<leader>Rl",
        "<cmd>lua require('kulala').replay()<cr>",
        { desc = "Replay last REST request" }
      )
      vim.keymap.set("n", "<leader>Ri", "<cmd>lua require('kulala').inspect()<cr>", { desc = "Inspect REST request" })
    end,
  },
}
