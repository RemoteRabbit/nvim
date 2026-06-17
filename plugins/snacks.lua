return {
  src = "https://github.com/folke/snacks.nvim",
  version = "v2.31.0",
  config = function()
    require("snacks").setup({
      animate = { enabled = true },
      bigfile = { enabled = true },
      bufferline = { enabled = true },
      dashboard = {
        preset = {
          header = [[
     --------------------------------------------------------------------------------------------------------
        ██████╗ ███████╗███╗   ███╗ ██████╗ ████████╗███████╗██████╗  █████╗ ██████╗ ██████╗ ██╗████████╗
        ██╔══██╗██╔════╝████╗ ████║██╔═══██╗╚══██╔══╝██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║╚══██╔══╝
        ██████╔╝█████╗  ██╔████╔██║██║   ██║   ██║   █████╗  ██████╔╝███████║██████╔╝██████╔╝██║   ██║
        ██╔══██╗██╔══╝  ██║╚██╔╝██║██║   ██║   ██║   ██╔══╝  ██╔══██╗██╔══██║██╔══██╗██╔══██╗██║   ██║
        ██║  ██║███████╗██║ ╚═╝ ██║╚██████╔╝   ██║   ███████╗██║  ██║██║  ██║██████╔╝██████╔╝██║   ██║
        ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝ ╚═════╝    ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═════╝ ╚═╝   ╚═╝
     --------------------------------------------------------------------------------------------------------
]],
          keys = {
            { icon = "󰈞", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = "", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = "󰪶", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = "󱉶", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            {
              icon = "",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = "󰩈", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", title = "Keymaps", indent = 2, padding = 1 },
          {
            icon = " ",
            title = "Recent Files",
            section = "recent_files",
            indent = 2,
            padding = 1,
          },
          {
            icon = " ",
            title = "Projects",
            section = "projects",
            indent = 2,
            padding = 1,
          },
          {
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
        },
      },
      dim = { enabled = true },
      explorer = { enabled = true, trash = true, replace_netrw = true },
      git = { enabled = true },
      image = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      lazygit = { enabled = true },
      picker = {
        enabled = true,
        hidden = true,
        sources = {
          files = {
            exclude = {
              ".git",
              ".devenv",
              ".direnv",
              "node_modules",
            },
          },
        },
      },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      quickfile = { enabled = true },
      words = { enabled = true },
    })

    -- Keymaps
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { desc = desc })
    end

    map("n", "<leader>e", function()
      Snacks.explorer()
    end, "Snacks Explorer")

    map("n", "<leader>sk", function()
      Snacks.picker.keymaps()
    end, "Keymaps")

    map("n", "<leader>sb", function()
      Snacks.picker.buffers()
    end, "Buffer list")

    map("n", "<leader>ff", function()
      Snacks.picker.pick("files")
    end, "Snacks file picker")

    map("n", "<leader>gg", function()
      Snacks.lazygit()
    end, "Lazygit")
  end,
}
