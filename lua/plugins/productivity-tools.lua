-- Productivity tools: notes, TODO management, docs generator, screenshots, markdown
return {
  {
    -- Note-taking with linking
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.dirman"] = {
            config = {
              workspaces = {
                notes = "~/notes",
                work = "~/work-notes",
              },
              default_workspace = "notes",
            },
          },
          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },
          ["core.integrations.nvim-cmp"] = {},
          ["core.export"] = {},
          ["core.export.markdown"] = {},
          ["core.keybinds"] = {
            config = {
              default_keybinds = true,
              neorg_leader = "<leader>N",
            },
          },
        },
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>Ni", "<cmd>Neorg index<cr>", { desc = "Neorg index" })
      vim.keymap.set("n", "<leader>Nr", "<cmd>Neorg return<cr>", { desc = "Return to previous buffer" })
      vim.keymap.set("n", "<leader>Nw", "<cmd>Neorg workspace<cr>", { desc = "Select workspace" })
    end,
  },
  {
    -- TODO management
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({
        signs = true,
        sign_priority = 8,
        keywords = {
          FIX = {
            icon = " ",
            color = "error",
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
          },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
          TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
        gui_style = {
          fg = "NONE",
          bg = "BOLD",
        },
        merge_keywords = true,
        highlight = {
          error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
          warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
          info = { "DiagnosticInfo", "#2563EB" },
          hint = { "DiagnosticHint", "#10B981" },
          default = { "Identifier", "#7C3AED" },
          test = { "Identifier", "#FF006E" },
          multiline = true,
          multiline_pattern = "^.",
          multiline_context = 10,
          before = "",
          keyword = "wide",
          after = "fg",
          pattern = [[.*<(KEYWORDS)\s*:]],
          comments_only = true,
          max_line_len = 400,
          exclude = {},
        },
        search = {
          command = "rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
          },
          pattern = [[\b(KEYWORDS):]],
        },
      })

      -- Keymaps
      vim.keymap.set("n", "]t", function()
        require("todo-comments").jump_next()
      end, { desc = "Next todo comment" })
      vim.keymap.set("n", "[t", function()
        require("todo-comments").jump_prev()
      end, { desc = "Previous todo comment" })
      vim.keymap.set("n", "<leader>tt", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
      vim.keymap.set(
        "n",
        "<leader>tT",
        "<cmd>TodoTelescope keywords=TODO,FIX,FIXME,NOTE,WARN,WARNING<cr>",
        { desc = "Find todos/fix/notes/warnings" }
      )
      vim.keymap.set("n", "<leader>tl", "<cmd>TodoLocList<cr>", { desc = "Todo location list" })
      vim.keymap.set("n", "<leader>tq", "<cmd>TodoQuickFix<cr>", { desc = "Todo quickfix" })
    end,
  },
  {
    -- Documentation generator
    "kkoomen/vim-doge",
    build = ":call doge#install()",
    config = function()
      vim.g.doge_enable_mappings = 0
      vim.g.doge_doc_standard_python = "google"
      vim.g.doge_doc_standard_go = "godoc"
      vim.g.doge_doc_standard_javascript = "jsdoc"
      vim.g.doge_doc_standard_typescript = "jsdoc"
      vim.g.doge_buffer_mappings = 1
      vim.g.doge_comment_jump_modes = { "n", "s" }

      -- Keymaps
      vim.keymap.set("n", "<leader>dg", "<Plug>(doge-generate)", { desc = "Generate docs" })
      vim.keymap.set("n", "<leader>dc", "<Plug>(doge-comment-jump-forward)", { desc = "Jump to next comment" })
      vim.keymap.set("n", "<leader>dC", "<Plug>(doge-comment-jump-backward)", { desc = "Jump to prev comment" })
    end,
  },
  {
    -- Code screenshots
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    config = function()
      require("silicon").setup({
        font = "JetBrainsMono Nerd Font=34;Noto Color Emoji=34",
        theme = "Dracula",
        background = "#AAAAFF",
        shadow_color = "#555555",
        line_pad = 2,
        pad_horiz = 80,
        pad_vert = 100,
        shadow_blur_radius = 0,
        shadow_offset_x = 0,
        shadow_offset_y = 0,
        line_number = false, -- Use false to avoid --no-line-number flag
        round_corner = false, -- Use false to avoid --no-round-corner flag
        window_controls = false, -- Use false to avoid --no-window-controls flag
        output = function()
          return "~/Pictures/silicon-" .. os.date("%Y-%m-%d-%H%M%S") .. ".png"
        end,
        debug = false,
      })

      -- Keymaps
      vim.keymap.set("v", "<leader>sc", ":Silicon<cr>", { desc = "Screenshot code" })
      vim.keymap.set("n", "<leader>sc", ":Silicon<cr>", { desc = "Screenshot code" })
    end,
  },
  {
    -- Markdown preview
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_open_ip = ""
      vim.g.mkdp_browser = ""
      vim.g.mkdp_echo_preview_url = 0
      vim.g.mkdp_browserfunc = ""
      vim.g.mkdp_page_title = "「${name}」"
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_theme = "dark"
      vim.g.mkdp_combine_preview = 0
      vim.g.mkdp_combine_preview_auto_refresh = 1

      -- Keymaps
      vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<cr>", { desc = "Markdown preview" })
      vim.keymap.set("n", "<leader>mP", "<cmd>MarkdownPreviewStop<cr>", { desc = "Stop markdown preview" })
      vim.keymap.set("n", "<leader>mt", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Toggle markdown preview" })
    end,
  },
  {
    -- Project dashboard
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("dashboard").setup({
        theme = "hyper",
        config = {
          week_header = {
            enable = true,
          },
          shortcut = {
            { desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
            {
              icon = " ",
              icon_hl = "@variable",
              desc = "Files",
              group = "Label",
              action = "Telescope find_files",
              key = "f",
            },
            {
              desc = " Apps",
              group = "DiagnosticHint",
              action = "Telescope app",
              key = "a",
            },
            {
              desc = " dotfiles",
              group = "Number",
              action = "Telescope dotfiles",
              key = "d",
            },
          },
          packages = { enable = true },
          project = {
            enable = true,
            limit = 8,
            icon = "󰏓 ",
            label = " Recent Projects:",
            action = "Telescope find_files cwd=",
          },
          mru = {
            limit = 10,
            icon = " ",
            label = " Recent Files:",
            cwd_only = false,
          },
          footer = {
            "",
            "🚀 Sharp tools make good work.",
          },
        },
      })
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },
  {
    -- Enhanced markdown editing
    "preservim/vim-markdown",
    dependencies = { "godlygeek/tabular" },
    config = function()
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.vim_markdown_conceal = 0
      vim.g.vim_markdown_conceal_code_blocks = 0
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_toml_frontmatter = 1
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_strikethrough = 1
      vim.g.vim_markdown_autowrite = 1
      vim.g.vim_markdown_edit_url_in = "tab"
      vim.g.vim_markdown_follow_anchor = 1
    end,
  },
  {
    -- Table editing
    "dhruvasagar/vim-table-mode",
    config = function()
      vim.g.table_mode_corner = "|"
      vim.g.table_mode_align_char = ":"
      vim.g.table_mode_syntax = 1
      vim.g.table_mode_auto_align = 1

      -- Keymaps
      vim.keymap.set("n", "<leader>tm", "<cmd>TableModeToggle<cr>", { desc = "Toggle table mode" })
      vim.keymap.set("n", "<leader>tr", "<cmd>TableModeRealign<cr>", { desc = "Realign table" })
    end,
  },
}
