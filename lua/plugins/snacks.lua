return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bufferline = {
      style = "minimal",
    },
    -----
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
          { icon = "󰈞 ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
    -----
    lazygit = {
      win = {
        style = "float",
        width = 0.95,
        height = 0.95,
        border = "rounded",
      },
      throttle = {
        ms = 50,
      },
      focus = true,
      enter = true,
    },
    -----
    notifier = {
      timeout = 3000,
    },
    -----
    scratch = {
      name = "Scratch",
      ft = function()
        local current_ft = vim.bo.filetype
        return current_ft and current_ft ~= "" and current_ft or "markdown"
      end,
    },
  },
  keys = {
    {
      "<leader>.",
      function()
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
            Snacks.scratch({ ft = selected_ft })
          end
        end)
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>S",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select scratch buffer.",
    },
    {
      "<leader>sd",
      function()
        local items = Snacks.scratch.list()
        if #items == 0 then
          vim.notify("No scratch buffers found", vim.log.levels.INFO)
          return
        end

        vim.ui.select(items, {
          prompt = "Delete Scratch Buffer",
          format_item = function(item)
            local icon = item.icon or Snacks.util.icon(item.ft, "filetype") or "󰈔"
            return icon .. " " .. item.name .. (item.cwd and " (" .. vim.fn.fnamemodify(item.cwd, ":p:~") .. ")" or "")
          end,
        }, function(selected)
          if selected then
            -- Close any open buffers for this file
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf) == selected.file then
                vim.api.nvim_buf_delete(buf, { force = true })
              end
            end
            -- Delete the actual file
            vim.fn.delete(selected.file)
            vim.notify("Deleted scratch: " .. selected.name, vim.log.levels.INFO)
          end
        end)
      end,
      desc = "Delete scratch buffer",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss All Notifications",
    },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>gB",
      function()
        Snacks.git.blame_line()
      end,
      desc = "Git Blame Line",
    },
    {
      "<leader>gW",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse Web",
    },
    {
      "<leader>gf",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "Lazygit Current File History",
    },
    {
      "<leader>gl",
      function()
        Snacks.lazygit.log()
      end,
      desc = "Lazygit Log (cwd)",
    },
    {
      "<leader>cR",
      function()
        Snacks.rename()
      end,
      desc = "Rename File",
    },
    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next Reference",
    },
    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Prev Reference",
    },
    {
      "<leader>zm",
      function()
        Snacks.zen()
      end,
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd

        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle
          .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          :map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
      end,
    })
  end,
}
