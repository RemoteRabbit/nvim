return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({})

    vim.keymap.set("n", "<leader>ha", function()
      harpoon:list():add()
    end, { desc = "Add to harpoon" })
    vim.keymap.set("n", "<leader>he", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon menu" })

    vim.keymap.set("n", "<leader>h1", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon 1" })
    vim.keymap.set("n", "<leader>h2", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon 2" })
    vim.keymap.set("n", "<leader>h3", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon 3" })
    vim.keymap.set("n", "<leader>h4", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon 4" })

    vim.keymap.set("n", "<C-S-P>", function()
      harpoon:list():prev()
    end, { desc = "Harpoon prev" })
    vim.keymap.set("n", "<C-S-N>", function()
      harpoon:list():next()
    end, { desc = "Harpoon next" })
  end,
}
