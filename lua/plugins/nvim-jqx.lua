return {
  {
    "gennaro-tedesco/nvim-jqx",
    ft = { "json", "yaml" },
    config = function()
      vim.keymap.set("n", "<leader>jq", "<cmd>JqxList<cr>", { desc = "JQ query list" })
      vim.keymap.set("n", "<leader>jf", "<cmd>JqxQuery<cr>", { desc = "JQ query" })
    end,
  },
}
