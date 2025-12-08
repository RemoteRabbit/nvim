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
        { "<leader>b", group = "Buffers" },
        { "<leader>c", group = "Code/LSP" },
        { "<leader>ca", group = "CodeCompanion" },
        { "<leader>co", group = "Coverage" },
        { "<leader>d", group = "Debug" },
        { "<leader>dp", group = "Debug Python" },
        { "<leader>D", group = "Database" },
        { "<leader>f", group = "File/Find" },

        -- Git ecosystem
        { "<leader>g", group = "Git" },
        { "<leader>gb", group = "Git Blame" },
        { "<leader>gd", group = "Git Diff" },
        { "<leader>gh", group = "Git History" },
        { "<leader>gI", group = "GitHub Issues" },
        { "<leader>gP", group = "GitHub/GitLab PRs" },
        { "<leader>gR", group = "GitHub Repos" },

        -- Go-specific
        { "<leader>G", group = "Go" },
        { "<leader>Gs", group = "Go Struct" },
        { "<leader>Gc", group = "Go Coverage" },

        { "<leader>h", group = "Harpoon" },
        { "<leader>i", group = "Inlay Hints" },
        { "<leader>j", group = "JQ/JSON" },
        { "<leader>l", group = "LSP Info" },
        { "<leader>m", group = "Markdown/Table" },
        { "<leader>n", group = "NPM/Neovim Tips" },
        { "<leader>nt", group = "Neovim Tips" },
        { "<leader>o", group = "Outline" },
        { "<leader>p", group = "Profile/Python" },

        -- Overseer/Tasks
        { "<leader>O", group = "Overseer/Tasks" },
        { "<leader>Os", group = "Security Scans" },

        -- Refactoring
        { "<leader>r", group = "Refactor" },
        { "<leader>R", group = "REST" },

        { "<leader>s", group = "Search/Screenshot" },

        -- Test/Terraform
        { "<leader>t", group = "Test/Terraform" },
        { "<leader>tm", group = "Terraform Modules" },
        { "<leader>tr", group = "Terraform Registry" },

        { "<leader>u", group = "UI/Toggle" },
        { "<leader>v", group = "Virtual Env/Review" },
        { "<leader>w", group = "Windows/Workspace" },
        { "<leader>x", group = "Diagnostics/Lint" },
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
