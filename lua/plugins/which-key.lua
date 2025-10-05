return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = function(ctx)
      return ctx.plugin and 0 or 200
    end,
    filter = function(mapping)
      return true
    end,
    spec = {
      {
        mode = { "n", "v" },
        -- Core groups
        { "<leader>b", group = "Buffers/Bookmarks" },
        { "<leader>c", group = "Code/LSP" },
        { "<leader>co", group = "Code Actions" },
        { "<leader>cov", group = "Coverage" }, -- Fixed: matches actual keybindings
        { "<leader>d", group = "Debug" },
        { "<leader>D", group = "Database" }, -- Added: missing DBUI
        { "<leader>f", group = "File/Find" },

        -- Git ecosystem (reorganized)
        { "<leader>g", group = "Git" },
        { "<leader>gb", group = "Git Blame" },
        { "<leader>gd", group = "Git Diff" },
        { "<leader>gh", group = "Git History" },
        { "<leader>gI", group = "GitHub Issues" },
        { "<leader>gP", group = "GitHub/GitLab PRs" },
        { "<leader>gR", group = "GitHub Repos" },

        -- Go-specific (moved from git namespace)
        { "<leader>G", group = "Go" }, -- Capital G to avoid conflict
        { "<leader>Gs", group = "Go Struct" },
        { "<leader>Gc", group = "Go Coverage" },

        { "<leader>h", group = "Harpoon/Hunks" },
        { "<leader>j", group = "JQ/JSON" },
        { "<leader>l", group = "Lazy" },
        { "<leader>m", group = "Markdown/Minimap" },
        { "<leader>n", group = "NPM/Packages" }, -- Added: missing package-info
        { "<leader>o", group = "Outline" },
        { "<leader>p", group = "Profile/Python" },

        -- Split the overloaded 'r' prefix
        { "<leader>r", group = "Run/Tasks" }, -- Overseer, refactoring
        { "<leader>R", group = "REST" }, -- Kulala REST client
        { "<leader>rs", group = "Security Scans" },

        { "<leader>s", group = "Search/Screenshot" },

        -- Terraform-specific
        { "<leader>t", group = "Test/Terminal/Terraform" },
        { "<leader>tg", group = "Terminal/LazyGit" },
        { "<leader>tm", group = "Terraform Modules" }, -- Added: missing
        { "<leader>tn", group = "Test Nearest" },
        { "<leader>tV", group = "Terraform Validation" }, -- Added: missing

        { "<leader>u", group = "UI/Toggle" },
        { "<leader>U", group = "Undotree" }, -- Added: missing
        { "<leader>v", group = "Virtual Env" },
        { "<leader>w", group = "Windows" },
        { "<leader>x", group = "Diagnostics/Quickfix" },
        { "<leader>y", group = "YAML" },
        { "<leader>z", group = "Zen Mode" },

        -- Navigation
        { "[", group = "Previous" },
        { "]", group = "Next" },
        { "g", group = "Goto" },
        { "gs", group = "Surround" },
        { "z", group = "Folds" },
      },
    },
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = "left",
    },
    show_help = true,
    show_keys = true,
    disable = {
      buftypes = {},
      filetypes = { "TelescopePrompt" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
