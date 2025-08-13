-- Development tools: terminal, task runner, debugger, REPL, docker, database
return {
  {
    -- Built-in terminal
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        persist_mode = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        auto_scroll = true,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })

      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
      end

      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

      -- Terminal configurations
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
      local htop = Terminal:new({ cmd = "htop", hidden = true, direction = "float" })
      local python = Terminal:new({ cmd = "python", hidden = true, direction = "horizontal" })

      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end

      function _HTOP_TOGGLE()
        htop:toggle()
      end

      function _PYTHON_TOGGLE()
        python:toggle()
      end

      -- Keymaps
      vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Float terminal" })
      vim.keymap.set(
        "n",
        "<leader>th",
        "<cmd>ToggleTerm size=10 direction=horizontal<cr>",
        { desc = "Horizontal terminal" }
      )
      vim.keymap.set(
        "n",
        "<leader>tv",
        "<cmd>ToggleTerm size=80 direction=vertical<cr>",
        { desc = "Vertical terminal" }
      )
      vim.keymap.set("n", "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { desc = "Lazygit" })
      vim.keymap.set("n", "<leader>tu", "<cmd>lua _HTOP_TOGGLE()<CR>", { desc = "Htop" })
      vim.keymap.set("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", { desc = "Python REPL" })
    end,
  },
  {
    -- Task runner
    "stevearc/overseer.nvim",
    config = function()
      require("overseer").setup({
        templates = { "builtin", "user.run_script", "user.make_build", "user.docker_build" },
        strategy = {
          "toggleterm",
          direction = "horizontal",
          autos_croll = true,
          quit_on_exit = "success",
        },
        component_aliases = {
          default = {
            { "display_duration", detail_level = 2 },
            "on_output_summarize",
            "on_exit_set_status",
            "on_complete_notify",
            "on_complete_dispose",
          },
        },
        bundles = {
          autostart_on_load = true,
          save_task_opts = {
            bundleable = true,
          },
        },
        task_list = {
          direction = "bottom",
          min_height = 25,
          max_height = 25,
          default_detail = 1,
          bindings = {
            ["?"] = "ShowHelp",
            ["g?"] = "ShowHelp",
            ["<CR>"] = "RunAction",
            ["<C-e>"] = "Edit",
            ["o"] = "Open",
            ["<C-v>"] = "OpenVsplit",
            ["<C-s>"] = "OpenSplit",
            ["<C-f>"] = "OpenFloat",
            ["<C-q>"] = "OpenQuickFix",
            ["p"] = "TogglePreview",
            ["<C-l>"] = "IncreaseDetail",
            ["<C-h>"] = "DecreaseDetail",
            ["L"] = "IncreaseAllDetail",
            ["H"] = "DecreaseAllDetail",
            ["["] = "DecreaseWidth",
            ["]"] = "IncreaseWidth",
            ["{"] = "PrevTask",
            ["}"] = "NextTask",
            ["<C-k>"] = "ScrollOutputUp",
            ["<C-j>"] = "ScrollOutputDown",
            ["q"] = "Close",
          },
        },
      })

      -- Task templates
      require("overseer").register_template({
        name = "run_script",
        builder = function()
          local file = vim.fn.expand("%:p")
          local cmd = { file }
          if vim.bo.filetype == "python" then
            cmd = { "python", file }
          elseif vim.bo.filetype == "sh" then
            cmd = { "bash", file }
          end
          return {
            cmd = cmd,
            components = { { "on_output_quickfix", open = true }, "default" },
          }
        end,
        condition = {
          filetype = { "sh", "python", "javascript" },
        },
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>rr", "<cmd>OverseerRun<cr>", { desc = "Run task" })
      vim.keymap.set("n", "<leader>rt", "<cmd>OverseerToggle<cr>", { desc = "Toggle task list" })
      vim.keymap.set("n", "<leader>ra", "<cmd>OverseerQuickAction<cr>", { desc = "Quick action" })
      vim.keymap.set("n", "<leader>rb", "<cmd>OverseerBuild<cr>", { desc = "Build task" })
      vim.keymap.set("n", "<leader>rc", "<cmd>OverseerClearCache<cr>", { desc = "Clear cache" })
    end,
  },
  {
    -- Debugger (DAP)
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
      "mfussenegger/nvim-dap-python",
      "leoluz/nvim-dap-go",
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      -- UI setup
      dapui.setup({
        icons = { expanded = "", collapsed = "", current_frame = "" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        expand_lines = vim.fn.has("nvim-0.7") == 1,
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25,
            position = "bottom",
          },
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil,
          max_value_lines = 100,
        },
      })

      -- Virtual text
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false,
        display_callback = function(variable, buf, stackframe, node, options)
          if options.virt_text_pos == "inline" then
            return " = " .. variable.value
          else
            return variable.name .. " = " .. variable.value
          end
        end,
        virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      })

      -- Auto open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Python
      require("dap-python").setup("python")

      -- Go
      require("dap-go").setup()

      -- Signs
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" }
      )
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticSignWarn", linehl = "Visual", numhl = "" })

      -- Telescope integration
      require("telescope").load_extension("dap")

      -- Keymaps
      vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<cr>", { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dB", "<cmd>DapSetBreakpoint<cr>", { desc = "Set Breakpoint" })
      vim.keymap.set(
        "n",
        "<leader>lp",
        "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
        { desc = "Log Point" }
      )
      vim.keymap.set("n", "<leader>dr", "<cmd>DapContinue<cr>", { desc = "Start/Continue" })
      vim.keymap.set(
        "n",
        "<leader>da",
        "<cmd>lua require('dap').continue({ before = get_args })<cr>",
        { desc = "Run with Args" }
      )
      vim.keymap.set("n", "<leader>dC", "<cmd>lua require('dap').run_to_cursor()<cr>", { desc = "Run to Cursor" })
      vim.keymap.set("n", "<leader>dg", "<cmd>lua require('dap').goto_()<cr>", { desc = "Go to line (no execute)" })
      vim.keymap.set("n", "<leader>di", "<cmd>DapStepInto<cr>", { desc = "Step Into" })
      vim.keymap.set("n", "<leader>dj", "<cmd>lua require('dap').down()<cr>", { desc = "Down" })
      vim.keymap.set("n", "<leader>dk", "<cmd>lua require('dap').up()<cr>", { desc = "Up" })
      vim.keymap.set("n", "<leader>dl", "<cmd>lua require('dap').run_last()<cr>", { desc = "Run Last" })
      vim.keymap.set("n", "<leader>do", "<cmd>DapStepOut<cr>", { desc = "Step Out" })
      vim.keymap.set("n", "<leader>dO", "<cmd>DapStepOver<cr>", { desc = "Step Over" })
      vim.keymap.set("n", "<leader>dp", "<cmd>lua require('dap').pause()<cr>", { desc = "Pause" })
      vim.keymap.set("n", "<leader>dr", "<cmd>lua require('dap').repl.toggle()<cr>", { desc = "Toggle REPL" })
      vim.keymap.set("n", "<leader>ds", "<cmd>lua require('dap').session()<cr>", { desc = "Session" })
      vim.keymap.set("n", "<leader>dt", "<cmd>lua require('dap').terminate()<cr>", { desc = "Terminate" })
      vim.keymap.set("n", "<leader>du", "<cmd>lua require('dapui').toggle()<cr>", { desc = "Toggle UI" })
      vim.keymap.set("n", "<leader>dw", "<cmd>lua require('dap.ui.widgets').hover()<cr>", { desc = "Widgets" })
    end,
  },
  {
    -- Docker integration
    "mgierada/lazydocker.nvim",
    dependencies = { "akinsho/toggleterm.nvim" },
    config = function()
      require("lazydocker").setup({})

      -- Keymap
      vim.keymap.set("n", "<leader>ld", "<cmd>LazyDocker<cr>", { desc = "LazyDocker" })
    end,
  },
  {
    -- Database browser
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_messages = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 40

      -- Keymaps
      vim.keymap.set("n", "<leader>Du", "<cmd>DBUIToggle<cr>", { desc = "Toggle DBUI" })
      vim.keymap.set("n", "<leader>Df", "<cmd>DBUIFindBuffer<cr>", { desc = "Find DB buffer" })
      vim.keymap.set("n", "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", { desc = "Rename DB buffer" })
      vim.keymap.set("n", "<leader>Dq", "<cmd>DBUILastQueryInfo<cr>", { desc = "Last query info" })
    end,
  },
  {
    -- HTTP Client (REST)
    "NTBBloodbath/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("rest-nvim").setup({
        result_split_horizontal = false,
        result_split_in_place = false,
        stay_in_current_window_after_split = true,
        skip_ssl_verification = false,
        encode_url = true,
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          show_url = true,
          show_curl_command = false,
          show_http_info = true,
          show_headers = true,
          formatters = {
            json = "jq",
            html = function(body)
              if vim.fn.executable("tidy") == 1 then
                return vim.fn.system({ "tidy", "-i", "-q", "--show-errors", "0" }, body):gsub("\n$", "")
              else
                return body
              end
            end,
          },
        },
        jump_to_request = false,
        env_file = ".env",
        custom_dynamic_variables = {},
        yank_dry_run = true,
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>Hr", "<Plug>RestNvim", { desc = "Run HTTP request" })
      vim.keymap.set("n", "<leader>Hp", "<Plug>RestNvimPreview", { desc = "Preview HTTP request" })
      vim.keymap.set("n", "<leader>Hl", "<Plug>RestNvimLast", { desc = "Re-run last HTTP request" })
    end,
  },
}
