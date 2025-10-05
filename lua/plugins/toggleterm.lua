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
        -- Add keymap to close terminal in normal mode
        vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = 0, desc = "Close terminal" })
      end

      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*",
        callback = function()
          if string.find(vim.fn.expand("<afile>"), "lazygit") == nil then
            set_terminal_keymaps()
          end
        end,
      })

      -- Terminal configurations
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = {
          border = "rounded",
          width = function()
            return math.floor(vim.o.columns * 0.95)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.95)
          end,
        },
        on_open = function(term)
          -- Don't set global terminal keymaps for lazygit
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "q", { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
          -- Focus and enter insert immediately
          vim.api.nvim_set_current_win(term.window)
          vim.cmd("startinsert!")
        end,
      })
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
}
