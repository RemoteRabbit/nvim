-- File templates for different languages
return {
  {
    -- Template system
    "glepnir/template.nvim",
    config = function()
      require("template").setup({
        temp_dir = "~/.config/nvim/templates",
        author = "Remote Rabbit",
        email = "hello@remoterabbit.io",
      })

      -- Create template directory
      local template_dir = vim.fn.expand("~/.config/nvim/templates")
      if vim.fn.isdirectory(template_dir) == 0 then
        vim.fn.mkdir(template_dir, "p")
      end

      -- Setup telescope integration
      require("telescope").load_extension("find_template")

      -- Keybinding for quick template access
      vim.keymap.set(
        "n",
        "<leader>ft",
        ":Telescope find_template type=insert<CR>",
        { desc = "Find and insert template" }
      )
      vim.keymap.set("n", "<leader>fT", ":Telescope find_template<CR>", { desc = "Find template (all)" })
    end,
  },
}
