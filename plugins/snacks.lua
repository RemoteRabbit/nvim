return {
  src = "https://github.com/folke/snacks.nvim",
  version = "v2.31.0",
  config = function()
    require("snacks").setup({
      bigfile = { enabled = true }, -- disables heavy features on huge files
      dashboard = {
        enabled = true,
        width = 60,
        row = nil, -- dashboard position. nil for center
        col = nil, -- dashboard position. nil for center
        pane_gap = 4, -- empty columns between vertical panes
        preset = {
          ---@type fun(cmd:string, opts:table)|nil
          pick = "snacks",
          -- Used by the `keys` section to show keymaps.
          -- Set your custom keymaps here.
          -- When using a function, the `items` argument are the default keymaps.
          ---@type snacks.dashboard.Item[]
          keys = {
            {
              icon = " ",
              key = "f",
              desc = "Find File",
              action = ":lua Snacks.dashboard.pick('files')",
            },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            {
              icon = " ",
              key = "g",
              desc = "Find Text",
              action = ":lua Snacks.dashboard.pick('live_grep')",
            },
            {
              icon = " ",
              key = "r",
              desc = "Recent Files",
              action = ":lua Snacks.dashboard.pick('oldfiles')",
            },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            {
              icon = "󰒲 ",
              key = "L",
              desc = "Lazy",
              action = ":Lazy",
              enabled = package.loaded.lazy ~= nil,
            },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          -- Used by the `header` section
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
        },
        -- item field formatters
        formats = {
          icon = function(item)
            if item.file and item.icon == "file" or item.icon == "directory" then
              return Snacks.dashboard.icon(item.file, item.icon)
            end
            return { item.icon, width = 2, hl = "icon" }
          end,
          footer = { "%s", align = "center" },
          header = { "%s", align = "center" },
          file = function(item, ctx)
            local fname = vim.fn.fnamemodify(item.file, ":~")
            fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
            if #fname > ctx.width then
              local dir = vim.fn.fnamemodify(fname, ":h")
              local file = vim.fn.fnamemodify(fname, ":t")
              if dir and file then
                file = file:sub(-(ctx.width - #dir - 2))
                fname = dir .. "/…" .. file
              end
            end
            local dir, file = fname:match("^(.*)/(.+)$")
            return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
          end,
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
        },
      },
      explorer = { enabled = true, hidden = true, ignored = true }, -- file explorer (uses picker)
      indent = { enabled = true }, -- indent guides
      lazygit = { enabled = true },
      notifier = { enabled = true }, -- vim.notify replacement
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
      }, -- fuzzy finder (files, grep, buffers, ...)
      quickfile = { enabled = true }, -- render files before plugins load
      scroll = { enabled = true }, -- smooth scrolling
      statuscolumn = { enabled = true }, -- pretty status column
      terminal = { enabled = true }, -- toggleable terminal
      words = { enabled = true }, -- highlight/navigate references under cursor
    })
  end,
}
