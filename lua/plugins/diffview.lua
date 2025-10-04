-- Advanced git analysis
return {
  {
    -- Advanced git analysis
    "sindrets/diffview.nvim",
    config = function()
      require("diffview").setup({
        diff_binaries = false,
        enhanced_diff_hl = false,
        git_cmd = { "git" },
        use_icons = true,
        watch_index = true,
        icons = {
          folder_closed = "",
          folder_open = "",
        },
        signs = {
          fold_closed = "",
          fold_open = "",
          done = "✓",
        },
        view = {
          default = {
            layout = "diff2_horizontal",
            winbar_info = false,
          },
          merge_tool = {
            layout = "diff3_horizontal",
            disable_diagnostics = true,
            winbar_info = true,
          },
          file_history = {
            layout = "diff2_horizontal",
            winbar_info = false,
          },
        },
        file_panel = {
          listing_style = "tree",
          tree_options = {
            flatten_dirs = true,
            folder_statuses = "only_folded",
          },
          win_config = {
            position = "left",
            width = 35,
            win_opts = {},
          },
        },
        file_history_panel = {
          log_options = {
            git = {
              single_file = {
                diff_merges = "combined",
              },
              multi_file = {
                diff_merges = "first-parent",
              },
            },
          },
          win_config = {
            position = "bottom",
            height = 16,
            win_opts = {},
          },
        },
        commit_log_panel = {
          win_config = {
            win_opts = {},
          },
        },
        default_args = {
          DiffviewOpen = {},
          DiffviewFileHistory = {},
        },
        hooks = {},
        keymaps = {
          disable_defaults = false,
          view = {
            { "n", "<tab>", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
            { "n", "gf", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
            { "n", "<leader>e", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
            { "n", "g<C-x>", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
          },
          diff1 = {
            { "n", "g?", "<cmd>h diffview-maps-diff1<cr>", { desc = "Open help panel" } },
          },
          diff2 = {
            { "n", "g?", "<cmd>h diffview-maps-diff2<cr>", { desc = "Open help panel" } },
          },
          diff3 = {
            {
              "n",
              "2do",
              "<Cmd>diffget //2<CR>",
              { desc = "Obtain the diff hunk from the OURS version of the file" },
            },
            {
              "n",
              "3do",
              "<Cmd>diffget //3<CR>",
              { desc = "Obtain the diff hunk from the THEIRS version of the file" },
            },
            { "n", "g?", "<cmd>h diffview-maps-diff3<cr>", { desc = "Open help panel" } },
          },
          diff4 = {
            {
              "n",
              "1do",
              "<Cmd>diffget //1<CR>",
              { desc = "Obtain the diff hunk from the BASE version of the file" },
            },
            {
              "n",
              "2do",
              "<Cmd>diffget //2<CR>",
              { desc = "Obtain the diff hunk from the OURS version of the file" },
            },
            {
              "n",
              "3do",
              "<Cmd>diffget //3<CR>",
              { desc = "Obtain the diff hunk from the THEIRS version of the file" },
            },
            { "n", "g?", "<cmd>h diffview-maps-diff4<cr>", { desc = "Open help panel" } },
          },
          file_panel = {
            { "n", "j", "j", { desc = "Next entry" } },
            { "n", "<down>", "j", { desc = "Next entry" } },
            { "n", "k", "k", { desc = "Prev entry" } },
            { "n", "<up>", "k", { desc = "Prev entry" } },
            { "n", "<cr>", "<cmd>DiffviewOpen<cr>", { desc = "Open the diff for the selected entry" } },
            { "n", "o", "<cmd>DiffviewOpen<cr>", { desc = "Open the diff for the selected entry" } },
            { "n", "<2-LeftMouse>", "<cmd>DiffviewOpen<cr>", { desc = "Open the diff for the selected entry" } },
            { "n", "-", "<cmd>DiffviewToggleStage<cr>", { desc = "Stage / unstage the selected entry" } },
            { "n", "S", "<cmd>DiffviewToggleStage<cr>", { desc = "Stage / unstage the selected entry" } },
            {
              "n",
              "U",
              "<cmd>DiffviewRefresh<cr>",
              { desc = "Update stats and entries in the file list" },
            },
            {
              "n",
              "X",
              "<cmd>DiffviewRefresh<cr>",
              { desc = "Update stats and entries in the file list" },
            },
            {
              "n",
              "R",
              "<cmd>DiffviewRefresh<cr>",
              { desc = "Update stats and entries in the file list" },
            },
            { "n", "<tab>", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
            { "n", "gf", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
            { "n", "<leader>e", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
            { "n", "g<C-x>", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
            { "n", "g?", "<cmd>h diffview-maps-file-panel<cr>", { desc = "Open help panel" } },
          },
          file_history_panel = {
            {
              "n",
              "g!",
              "<cmd>DiffviewRefresh<cr>",
              { desc = "Update stats and entries in the file list" },
            },
            {
              "n",
              "<C-A-d>",
              "<cmd>DiffviewOpen<cr>",
              { desc = "Open the diff for the selected entry" },
            },
            {
              "n",
              "y",
              "<cmd>DiffviewYankHash<cr>",
              { desc = "Copy the commit hash of the entry under the cursor" },
            },
            { "n", "L", "<cmd>DiffviewToggleFileFold<cr>", { desc = "Toggle fold for selected file" } },
            { "n", "zR", "<cmd>DiffviewExpandAllFolds<cr>", { desc = "Expand all folds" } },
            { "n", "zM", "<cmd>DiffviewCollapseAllFolds<cr>", { desc = "Collapse all folds" } },
            { "n", "j", "j", { desc = "Next entry" } },
            { "n", "<down>", "j", { desc = "Next entry" } },
            { "n", "k", "k", { desc = "Prev entry" } },
            { "n", "<up>", "k", { desc = "Prev entry" } },
            {
              "n",
              "<cr>",
              "<cmd>DiffviewOpen<cr>",
              { desc = "Open the diff for the selected entry" },
            },
            {
              "n",
              "o",
              "<cmd>DiffviewOpen<cr>",
              { desc = "Open the diff for the selected entry" },
            },
            {
              "n",
              "<2-LeftMouse>",
              "<cmd>DiffviewOpen<cr>",
              { desc = "Open the diff for the selected entry" },
            },
            { "n", "<tab>", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
            { "n", "gf", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
            { "n", "<leader>e", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
            { "n", "g<C-x>", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
            { "n", "g?", "<cmd>h diffview-maps-file-history-panel<cr>", { desc = "Open help panel" } },
          },
          option_panel = {
            { "n", "<tab>", "<cmd>DiffviewToggleOption<cr>", { desc = "Toggle the current option" } },
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
            { "n", "<esc>", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
            { "n", "g?", "<cmd>h diffview-maps-option-panel<cr>", { desc = "Open help panel" } },
          },
          help_panel = {
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
            { "n", "<esc>", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
            { "n", "g?", "<cmd>h diffview-maps-help-panel<cr>", { desc = "Open help panel" } },
          },
        },
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open diffview" })
      vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" })
      vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "File history" })
      vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", { desc = "Current file history" })
    end,
  },
}
