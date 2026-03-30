return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/trouble.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local open_with_trouble = require("trouble.sources.telescope").open

    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-t>"] = open_with_trouble,
          },
          n = {
            ["<C-t>"] = open_with_trouble,
          },
        },
      },
    })

    telescope.load_extension("fzf")

    -- File search keymaps moved to snacks.lua (using Snacks picker)
    -- Keeping telescope for help_tags and config files
    vim.keymap.set("n", "<leader>fh", function()
      require("telescope.builtin").help_tags({ hidden = true })
    end, { desc = "Help Tags" })

    vim.keymap.set("n", "<leader>fc", function()
      require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "Config Files" })
  end,
}
