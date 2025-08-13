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
        { "<leader><tab>", group = "tabs" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gI", group = "git issues" },
        { "<leader>gP", group = "git prs" },
        { "<leader>gR", group = "git repos" },
        { "<leader>gs", group = "go struct" },
        { "<leader>gc", group = "go coverage" },
        { "<leader>h", group = "harpoon/hunks" },
        { "<leader>j", group = "jq" },
        { "<leader>l", group = "lazy" },
        { "<leader>m", group = "markdown/minimap" },
        { "<leader>n", group = "neorg" },
        { "<leader>o", group = "outline" },
        { "<leader>p", group = "packages/profile" },
        { "<leader>r", group = "refactor/run/rest" },
        { "<leader>s", group = "screenshot" },
        { "<leader>t", group = "test/terminal/todo" },
        { "<leader>tc", group = "coverage" },
        { "<leader>u", group = "ui/toggle" },
        { "<leader>v", group = "venv" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "<leader>y", group = "yaml" },
        { "<leader>z", group = "zen mode" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        { "z", group = "fold" },
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
