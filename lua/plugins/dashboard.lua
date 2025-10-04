-- Project dashboard
return {
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
}
