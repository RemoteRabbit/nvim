-- Code quality & analysis: metrics, security, profiling, refactoring, dependencies
return {
  {
    -- Code metrics and complexity analysis
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        python = { "flake8", "mypy", "bandit" },
        javascript = { "eslint" },
        typescript = { "eslint" },
        go = { "golangcilint", "staticcheck" },
        terraform = { "tflint", "tfsec" },
        yaml = { "yamllint" },
        json = { "jsonlint" },
        lua = { "luacheck" },
        bash = { "shellcheck" },
        elixir = { "credo" },
      }

      -- Auto-run linting
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>cl", function()
        require("lint").try_lint()
      end, { desc = "Run linting" })
    end,
  },

  {
    -- Performance profiling for Lua
    "stevearc/profile.nvim",
    config = function()
      local should_profile = os.getenv("NVIM_PROFILE")
      if should_profile then
        require("profile").instrument_autocmds()
        if should_profile:lower():match("^start") then
          require("profile").start("*")
        else
          require("profile").instrument("*")
        end
      end

      local function toggle_profile()
        local prof = require("profile")
        if prof.is_recording() then
          prof.stop()
          vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
            if filename then
              prof.export(filename)
              vim.notify(string.format("Wrote %s", filename))
            end
          end)
        else
          prof.start("*")
        end
      end

      vim.keymap.set("n", "<leader>pp", toggle_profile, { desc = "Toggle profiling" })
    end,
  },
  {
    -- Advanced refactoring tools
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup({
        prompt_func_return_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        prompt_func_param_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        printf_statements = {},
        print_var_statements = {},
        show_success_message = true,
      })

      -- Keymaps
      vim.keymap.set(
        {"n", "x"},
        "<leader>rr",
        function() require('refactoring').select_refactor() end,
        { desc = "Refactoring menu" }
      )
      
      -- Extract function supports only visual mode
      vim.keymap.set("x", "<leader>re", ":Refactor extract ", { desc = "Extract function" })
      vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ", { desc = "Extract to file" })
      
      -- Extract variable supports only visual mode  
      vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ", { desc = "Extract variable" })
      
      -- Inline func supports only normal
      vim.keymap.set("n", "<leader>rI", ":Refactor inline_func", { desc = "Inline function" })
      
      -- Inline var supports both normal and visual mode
      vim.keymap.set({"n", "x"}, "<leader>ri", ":Refactor inline_var", { desc = "Inline variable" })
      
      -- Extract block supports only normal mode
      vim.keymap.set("n", "<leader>rb", ":Refactor extract_block", { desc = "Extract block" })
      vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file", { desc = "Extract block to file" })

      -- Debug helpers
      vim.keymap.set({"n", "x"}, "<leader>rp", function() require('refactoring').debug.printf({below = false}) end, { desc = "Debug print" })
      vim.keymap.set("n", "<leader>rpv", function() require('refactoring').debug.print_var({normal = true}) end, { desc = "Debug print variable" })
      vim.keymap.set("x", "<leader>rpv", function() require('refactoring').debug.print_var({}) end, { desc = "Debug print variable" })
      vim.keymap.set("n", "<leader>rpc", function() require('refactoring').debug.cleanup({}) end, { desc = "Debug cleanup" })
    end,
  },
  {
    -- Dependency analysis
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("package-info").setup({
        colors = {
          up_to_date = "#3C4048",
          outdated = "#d19a66",
        },
        icons = {
          enable = true,
          style = {
            up_to_date = "|  ",
            outdated = "|  ",
          },
        },
        autostart = true,
        hide_up_to_date = false,
        hide_unstable_versions = false,
        package_manager = "npm",
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>ns", require("package-info").show, { desc = "Show dependency versions", silent = true })
      vim.keymap.set("n", "<leader>nc", require("package-info").hide, { desc = "Hide dependency versions", silent = true })
      vim.keymap.set("n", "<leader>nt", require("package-info").toggle, { desc = "Toggle dependency versions", silent = true })
      vim.keymap.set("n", "<leader>nu", require("package-info").update, { desc = "Update dependency on line", silent = true })
      vim.keymap.set("n", "<leader>nd", require("package-info").delete, { desc = "Delete dependency on line", silent = true })
      vim.keymap.set("n", "<leader>ni", require("package-info").install, { desc = "Install new dependency", silent = true })
      vim.keymap.set("n", "<leader>np", require("package-info").change_version, { desc = "Change dependency version", silent = true })
    end,
  },
  {
    -- Code coverage heatmap
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("coverage").setup({
        commands = true,
        highlights = {
          covered = { fg = "#C3E88D" },
          uncovered = { fg = "#F07178" },
          partial = { fg = "#AA71FF" },
        },
        signs = {
          covered = { hl = "CoverageCovered", text = "▎" },
          uncovered = { hl = "CoverageUncovered", text = "▎" },
          partial = { hl = "CoveragePartial", text = "▎" },
        },
        summary = {
          min_coverage = 80.0,
        },
        lang = {
          python = {
            coverage_command = "coverage json --fail-under=0 -q -o -",
            coverage_file = "coverage.json",
          },
          go = {
            coverage_command = "go test -coverprofile=coverage.out ./... && go tool cover -func=coverage.out",
          },
          javascript = {
            coverage_command = "cat coverage/lcov-report/index.html | grep -o '\\\"decimal\\\">[^<]*' | head -n 4",
          },
        },
        auto_reload = true,
        load_coverage_cb = function(ftype)
          vim.notify("Loaded " .. ftype .. " coverage")
        end,
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>cov", "<cmd>Coverage<cr>", { desc = "Show coverage" })
      vim.keymap.set("n", "<leader>coh", "<cmd>CoverageHide<cr>", { desc = "Hide coverage" })
      vim.keymap.set("n", "<leader>cos", "<cmd>CoverageSummary<cr>", { desc = "Coverage summary" })
      vim.keymap.set("n", "<leader>cot", "<cmd>CoverageToggle<cr>", { desc = "Toggle coverage" })
      vim.keymap.set("n", "<leader>col", "<cmd>CoverageLoad<cr>", { desc = "Load coverage" })
    end,
  },
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
            win_opts = {}
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
            win_opts = {}
          },
        },
        commit_log_panel = {
          win_config = {
            win_opts = {},
          }
        },
        default_args = {
          DiffviewOpen = {},
          DiffviewFileHistory = {},
        },
        hooks = {},
        keymaps = {
          disable_defaults = false,
          view = {
            { "n", "<tab>",      "<cmd>DiffviewToggleFiles<cr>",   { desc = "Toggle file panel" } },
            { "n", "gf",         "<cmd>DiffviewToggleFiles<cr>",   { desc = "Toggle file panel" } },
            { "n", "<leader>e",  "<cmd>DiffviewToggleFiles<cr>",   { desc = "Toggle file panel" } },
            { "n", "g<C-x>",     "<cmd>DiffviewToggleFiles<cr>",   { desc = "Toggle file panel" } },
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
              { desc = "Obtain the diff hunk from the OURS version of the file" }
            },
            {
              "n",
              "3do",
              "<Cmd>diffget //3<CR>",
              { desc = "Obtain the diff hunk from the THEIRS version of the file" }
            },
            { "n", "g?", "<cmd>h diffview-maps-diff3<cr>", { desc = "Open help panel" } },
          },
          diff4 = {
            {
              "n",
              "1do",
              "<Cmd>diffget //1<CR>",
              { desc = "Obtain the diff hunk from the BASE version of the file" }
            },
            {
              "n",
              "2do",
              "<Cmd>diffget //2<CR>",
              { desc = "Obtain the diff hunk from the OURS version of the file" }
            },
            {
              "n",
              "3do",
              "<Cmd>diffget //3<CR>",
              { desc = "Obtain the diff hunk from the THEIRS version of the file" }
            },
            { "n", "g?", "<cmd>h diffview-maps-diff4<cr>", { desc = "Open help panel" } },
          },
          file_panel = {
            { "n", "j",             "j",                         { desc = "Next entry" } },
            { "n", "<down>",        "j",                         { desc = "Next entry" } },
            { "n", "k",             "k",                         { desc = "Prev entry" } },
            { "n", "<up>",          "k",                         { desc = "Prev entry" } },
            { "n", "<cr>",          "<cmd>DiffviewOpen<cr>",     { desc = "Open the diff for the selected entry" } },
            { "n", "o",             "<cmd>DiffviewOpen<cr>",     { desc = "Open the diff for the selected entry" } },
            { "n", "<2-LeftMouse>", "<cmd>DiffviewOpen<cr>",     { desc = "Open the diff for the selected entry" } },
            { "n", "-",             "<cmd>DiffviewToggleStage<cr>", { desc = "Stage / unstage the selected entry" } },
            { "n", "S",             "<cmd>DiffviewToggleStage<cr>", { desc = "Stage / unstage the selected entry" } },
            { "n", "U",             "<cmd>DiffviewRefresh<cr>",     { desc = "Update stats and entries in the file list" } },
            { "n", "X",             "<cmd>DiffviewRefresh<cr>",     { desc = "Update stats and entries in the file list" } },
            { "n", "R",             "<cmd>DiffviewRefresh<cr>",     { desc = "Update stats and entries in the file list" } },
            { "n", "<tab>",         "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
            { "n", "gf",            "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
            { "n", "<leader>e",     "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
            { "n", "g<C-x>",        "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
            { "n", "g?",            "<cmd>h diffview-maps-file-panel<cr>", { desc = "Open help panel" } },
          },
          file_history_panel = {
            { "n", "g!",            "<cmd>DiffviewRefresh<cr>",         { desc = "Update stats and entries in the file list" } },
            { "n", "<C-A-d>",       "<cmd>DiffviewOpen<cr>",           { desc = "Open the diff for the selected entry" } },
            { "n", "y",             "<cmd>DiffviewYankHash<cr>",       { desc = "Copy the commit hash of the entry under the cursor" } },
            { "n", "L",             "<cmd>DiffviewToggleFileFold<cr>", { desc = "Toggle fold for selected file" } },
            { "n", "zR",            "<cmd>DiffviewExpandAllFolds<cr>", { desc = "Expand all folds" } },
            { "n", "zM",            "<cmd>DiffviewCollapseAllFolds<cr>", { desc = "Collapse all folds" } },
            { "n", "j",             "j",                               { desc = "Next entry" } },
            { "n", "<down>",        "j",                               { desc = "Next entry" } },
            { "n", "k",             "k",                               { desc = "Prev entry" } },
            { "n", "<up>",          "k",                               { desc = "Prev entry" } },
            { "n", "<cr>",          "<cmd>DiffviewOpen<cr>",           { desc = "Open the diff for the selected entry" } },
            { "n", "o",             "<cmd>DiffviewOpen<cr>",           { desc = "Open the diff for the selected entry" } },
            { "n", "<2-LeftMouse>", "<cmd>DiffviewOpen<cr>",           { desc = "Open the diff for the selected entry" } },
            { "n", "<tab>",         "<cmd>DiffviewToggleFiles<cr>",    { desc = "Toggle file panel" } },
            { "n", "gf",            "<cmd>DiffviewToggleFiles<cr>",    { desc = "Toggle file panel" } },
            { "n", "<leader>e",     "<cmd>DiffviewToggleFiles<cr>",    { desc = "Toggle file panel" } },
            { "n", "g<C-x>",        "<cmd>DiffviewToggleFiles<cr>",    { desc = "Toggle file panel" } },
            { "n", "g?",            "<cmd>h diffview-maps-file-history-panel<cr>", { desc = "Open help panel" } },
          },
          option_panel = {
            { "n", "<tab>", "<cmd>DiffviewToggleOption<cr>", { desc = "Toggle the current option" } },
            { "n", "q",     "<cmd>DiffviewClose<cr>",        { desc = "Close diffview" } },
            { "n", "<esc>", "<cmd>DiffviewClose<cr>",        { desc = "Close diffview" } },
            { "n", "g?",    "<cmd>h diffview-maps-option-panel<cr>", { desc = "Open help panel" } },
          },
          help_panel = {
            { "n", "q",     "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
            { "n", "<esc>", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
            { "n", "g?",    "<cmd>h diffview-maps-help-panel<cr>", { desc = "Open help panel" } },
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
