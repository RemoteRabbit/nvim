-- Enhanced JSON editing
return {
  {
    -- Enhanced JSON editing
    "gennaro-tedesco/nvim-jqx",
    ft = { "json", "yaml" },
    config = function()
      -- Keymaps
      vim.keymap.set("n", "<leader>jq", "<cmd>JqxList<cr>", { desc = "JQ query list" })
      vim.keymap.set("n", "<leader>jf", "<cmd>JqxQuery<cr>", { desc = "JQ query" })
    end,
  },
}
