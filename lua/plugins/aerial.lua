return {
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("aerial").setup({
        -- Priority list of preferred backends for aerial
        backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },

        -- Layout and positioning
        layout = {
          max_width = { 40, 0.2 }, -- 40 columns, or 20% of total width
          width = nil,
          min_width = 10,
          win_opts = {},
          default_direction = "prefer_right",
          placement = "window",
          preserve_equality = false,
        },

        -- Attach aerial to every buffer by default
        attach_mode = "window",

        -- Close aerial automatically when losing focus
        close_automatic_events = {},

        -- Keymaps in aerial window
        keymaps = {
          ["?"] = "actions.show_help",
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.jump",
          ["<2-LeftMouse>"] = "actions.jump",
          ["<C-v>"] = "actions.jump_vsplit",
          ["<C-s>"] = "actions.jump_split",
          ["p"] = "actions.scroll",
          ["<C-j>"] = "actions.down_and_scroll",
          ["<C-k>"] = "actions.up_and_scroll",
          ["{"] = "actions.prev",
          ["}"] = "actions.next",
          ["[["] = "actions.prev_up",
          ["]]"] = "actions.next_up",
          ["q"] = "actions.close",
          ["o"] = "actions.tree_toggle",
          ["za"] = "actions.tree_toggle",
          ["O"] = "actions.tree_toggle_recursive",
          ["zA"] = "actions.tree_toggle_recursive",
          ["l"] = "actions.tree_open",
          ["zo"] = "actions.tree_open",
          ["L"] = "actions.tree_open_recursive",
          ["zO"] = "actions.tree_open_recursive",
          ["h"] = "actions.tree_close",
          ["zc"] = "actions.tree_close",
          ["H"] = "actions.tree_close_recursive",
          ["zC"] = "actions.tree_close_recursive",
          ["zr"] = "actions.tree_increase_fold_level",
          ["zR"] = "actions.tree_open_all",
          ["zm"] = "actions.tree_decrease_fold_level",
          ["zM"] = "actions.tree_close_all",
          ["zx"] = "actions.tree_sync_folds",
          ["zX"] = "actions.tree_sync_folds",
        },

        -- Show box drawing characters for the tree hierarchy
        show_guides = true,

        -- Filter symbols to show only relevant ones for DevOps files
        filter_kind = {
          "Class",
          "Constructor",
          "Enum",
          "Function",
          "Interface",
          "Module",
          "Method",
          "Struct",
          "Variable",
          "Constant",
          "String",
          "Number",
          "Boolean",
          "Array",
          "Object",
          "Key",
          "Namespace",
          "Package",
          "Property",
          "Field",
        },

        -- Disable automatic opening for now (use manual toggle)
        open_automatic = false,

        -- Close behavior
        close_behavior = "persist",

        -- Configure icons
        icons = {},

        -- Ignore certain symbols for cleaner outline
        ignore = {
          -- Ignore by symbol kind
          kind_ignore = {},
          -- Ignore by name
          name_ignore = {},
          -- Ignore by treesitter node type
          buftypes_ignore = {
            "nofile",
            "terminal",
          },
          wintypes_ignore = {
            "autocmd",
            "command",
            "quickfix",
            "loclist",
          },
        },

        -- Highlight the closest symbol
        highlight_closest = true,
        highlight_on_hover = false,
        highlight_on_jump = 300,

        -- Options for telescope extension
        lsp = {
          diagnostics_trigger_update = true,
          update_when_errors = true,
        },

        treesitter = {
          update_delay = 300,
        },
      })

      -- Global keymaps
      vim.keymap.set("n", "<leader>oa", "<cmd>AerialToggle<CR>", { desc = "Toggle Aerial" })
      vim.keymap.set("n", "<leader>oA", "<cmd>AerialNavToggle<CR>", { desc = "Toggle Aerial Navigation" })
      vim.keymap.set("n", "[s", "<cmd>AerialPrev<CR>", { desc = "Previous symbol" })
      vim.keymap.set("n", "]s", "<cmd>AerialNext<CR>", { desc = "Next symbol" })
    end,
  },
}
