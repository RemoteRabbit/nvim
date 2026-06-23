return {
  src = "https://github.com/folke/snacks.nvim",
  version = "v2.31.0",
  config = function()
    require("snacks").setup({
      ---@module 'snacks' Snacks
      animate = { enabled = true },
      bigfile = { enabled = true },
      bufferline = { enabled = true },
      dashboard = {
        preset = {
          header = [[
  ---------------------------------------------------------------------------------------------------
    ██████╗ ███████╗███╗   ███╗ ██████╗ ████████╗███████╗██████╗  █████╗ ██████╗ ██████╗ ██╗████████╗
    ██╔══██╗██╔════╝████╗ ████║██╔═══██╗╚══██╔══╝██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║╚══██╔══╝
  ██████╔╝█████╗  ██╔████╔██║██║   ██║   ██║   █████╗  ██████╔╝███████║██████╔╝██████╔╝██║   ██║
  ██╔══██╗██╔══╝  ██║╚██╔╝██║██║   ██║   ██║   ██╔══╝  ██╔══██╗██╔══██║██╔══██╗██╔══██╗██║   ██║
  ██║  ██║███████╗██║ ╚═╝ ██║╚██████╔╝   ██║   ███████╗██║  ██║██║  ██║██████╔╝██████╔╝██║   ██║
  ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝ ╚═════╝    ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═════╝ ╚═╝   ╚═╝
---------------------------------------------------------------------------------------------------
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
      scratch = {
        enabled = true,
      },
      statuscolumn = { enabled = true },
      quickfile = { enabled = true },
      words = { enabled = true },
    })

    ---@module 'Snacks' snacks
    Snacks = require("snacks")

    -- Keymaps
    Snacks.keymap.set("n", "<leader>e", function()
      Snacks.explorer()
    end, { desc = "Snack Explorer" })

    Snacks.keymap.set("n", "<leader>sk", function()
      Snacks.picker.keymaps()
    end, { desc = "Keymaps" })

    Snacks.keymap.set("n", "<leader>sb", function()
      Snacks.picker.buffers()
    end, { desc = "Buffer list" })

    Snacks.keymap.set("n", "<leader>ff", function()
      Snacks.picker.pick("files")
    end, { desc = "Snacks file picker" })

    Snacks.keymap.set("n", "<leader>gg", function()
      Snacks.lazygit()
    end, { desc = "Lazygit" })

    Snacks.keymap.set("n", "<leader>sn", function()
      Snacks.scratch.open({
        name = "Notes",
        ft = "markdown",
        filekey = {
          branch = false,
        },
      })
    end, { desc = "Load repo notes markdown scratchpad." })

    Snacks.keymap.set("n", "<leader>sN", function()
      local filetypes = {
        "markdown",
        "lua",
        "python",
        "bash",
        "text",
        "json",
        "yaml",
      }

      local current_ft = vim.bo.filetype
      if current_ft and current_ft ~= "" then
        local found = false
        for _, ft in ipairs(filetypes) do
          if ft == current_ft then
            found = true
            break
          end
        end
        if not found then
          table.insert(filetypes, 1, current_ft .. " (current)")
        end
      end

      vim.ui.select(filetypes, {
        prompt = "Select filetype: ",
        format_item = function(item)
          return item
        end,
      }, function(choice)
        if choice then
          local selected_ft = choice:gsub(" %(current%)", "")
          Snacks.scratch.open({
            ft = selected_ft,
            filekey = {
              branch = false,
            },
          })
        end
      end)
    end, { desc = "Create new scratch pad." })

    Snacks.keymap.set("n", "<leader>sl", function()
      local cwd = vim.fs.normalize(vim.uv.cwd())
      Snacks.picker.scratch({
        transform = function(item)
          return item.item and item.item.cwd == cwd
        end,
      })
    end, { desc = "Select scratch buffer." })
  end,
}
