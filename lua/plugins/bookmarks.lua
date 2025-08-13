-- Smart bookmarks system
return {
  {
    -- Enhanced bookmarks with descriptions
    "MattesGroeger/vim-bookmarks",
    config = function()
      vim.g.bookmark_sign = "♥"
      vim.g.bookmark_annotation_sign = "♥"
      vim.g.bookmark_highlight_lines = 1
      vim.g.bookmark_auto_save = 1
      vim.g.bookmark_manage_per_buffer = 0
      vim.g.bookmark_save_per_working_dir = 1
      vim.g.bookmark_center = 1
      vim.g.bookmark_auto_close = 1
      vim.g.bookmark_location_list = 1

      -- Keymaps
      vim.keymap.set("n", "<leader>bt", "<cmd>BookmarkToggle<cr>", { desc = "Toggle bookmark" })
      vim.keymap.set("n", "<leader>ba", "<cmd>BookmarkAnnotate<cr>", { desc = "Annotate bookmark" })
      vim.keymap.set("n", "<leader>bs", "<cmd>BookmarkShowAll<cr>", { desc = "Show all bookmarks" })
      vim.keymap.set("n", "<leader>bn", "<cmd>BookmarkNext<cr>", { desc = "Next bookmark" })
      vim.keymap.set("n", "<leader>bp", "<cmd>BookmarkPrev<cr>", { desc = "Previous bookmark" })
      vim.keymap.set("n", "<leader>bc", "<cmd>BookmarkClear<cr>", { desc = "Clear bookmarks in buffer" })
      vim.keymap.set("n", "<leader>bx", "<cmd>BookmarkClearAll<cr>", { desc = "Clear all bookmarks" })
    end,
  },

  {
    -- Project-specific marks
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({})

      -- Keymaps
      vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Add to harpoon" })
      vim.keymap.set("n", "<leader>he", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })

      vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
      vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
      vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
      vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Harpoon prev" })
      vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Harpoon next" })
    end,
  },
}
