return {
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      require("dap-go").setup({
        delve = {
          -- Increase timeout for slow CI/large repos
          initialize_timeout_sec = 20,
        },
      })

      vim.keymap.set("n", "<leader>dgt", function()
        require("dap-go").debug_test()
      end, { desc = "Debug Go test" })
      vim.keymap.set("n", "<leader>dgl", function()
        require("dap-go").debug_last_test()
      end, { desc = "Debug last Go test" })
    end,
  },
}
