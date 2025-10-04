-- REST client
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

      -- Keymaps
      vim.keymap.set("n", "<leader>rr", "<cmd>lua require('kulala').run()<cr>", { desc = "Run REST request" })
      vim.keymap.set("n", "<leader>rp", "<cmd>lua require('kulala').preview()<cr>", { desc = "Preview REST request" })
      vim.keymap.set(
        "n",
        "<leader>rl",
        "<cmd>lua require('kulala').replay()<cr>",
        { desc = "Replay last REST request" }
      )
      vim.keymap.set("n", "<leader>ri", "<cmd>lua require('kulala').inspect()<cr>", { desc = "Inspect REST request" })
    end,
  },
}
