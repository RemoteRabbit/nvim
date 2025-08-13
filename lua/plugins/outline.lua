-- Document outline and symbol tree
return {
  {
    -- Symbols outline
    "hedyhli/outline.nvim",
    config = function()
      require("outline").setup({
        outline_window = {
          position = "right",
          width = 25,
          relative_width = true,
          auto_close = false,
          auto_jump = false,
          jump_highlight_duration = 300,
          center_on_jump = true,
          show_numbers = false,
          show_relative_numbers = false,
          wrap = false,
          show_cursorline = true,
          hide_cursor = false,
          focus_on_open = false,
          winhl = "",
        },
        outline_items = {
          show_symbol_details = true,
          show_symbol_lineno = false,
          highlight_hovered_item = true,
          auto_set_cursor = true,
          auto_update_events = {
            follow = { "CursorMoved" },
            items = { "InsertLeave", "WinEnter", "BufEnter", "BufWinEnter", "TabEnter", "BufWritePost" },
          },
        },
        guides = {
          enabled = true,
          markers = {
            bottom = "└",
            middle = "├",
            vertical = "│",
          },
        },
        symbol_folding = {
          autofold_depth = 1,
          auto_unfold = {
            hovered = true,
            only = true,
          },
          markers = { "", "" },
        },
        preview_window = {
          auto_preview = false,
          open_hover_on_preview = false,
          width = 50,
          min_width = 50,
          relative_width = true,
          border = "rounded",
          winhl = "NormalFloat:",
          winblend = 0,
          live = false,
        },
        keymaps = {
          show_help = "?",
          close = { "<Esc>", "q" },
          goto_location = "<Cr>",
          peek_location = "o",
          goto_and_close = "<S-Cr>",
          restore_location = "<C-g>",
          hover_symbol = "<C-space>",
          toggle_preview = "K",
          rename_symbol = "r",
          code_actions = "a",
          fold = "h",
          unfold = "l",
          fold_toggle = "<Tab>",
          fold_toggle_all = "<S-Tab>",
          fold_all = "W",
          unfold_all = "E",
          fold_reset = "R",
          down_and_jump = "<C-j>",
          up_and_jump = "<C-k>",
        },
        providers = {
          priority = { "lsp", "coc", "markdown", "norg" },
          lsp = {
            blacklist_clients = {},
          },
        },
        symbols = {
          filter = {
            default = {
              "String",
              "Number",
              "Boolean",
              "Array",
              "Object",
              "Key",
              "Null",
            },
            markdown = {
              "Interface",
              "Function",
              "Class",
              "Method",
              "Property",
              "Field",
              "Variable",
              "Constant",
              "String",
              "Number",
              "Boolean",
              "Array",
              "Object",
              "Key",
              "Null",
              "EnumMember",
              "Struct",
              "Event",
              "Operator",
              "TypeParameter",
            },
          },
          icon_fetcher = function(kind, bufnr)
            return ""
          end,
          icon_source = nil,
        },
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
    end,
  },
  {
    -- Enhanced call hierarchy
    "ldelossa/litee.nvim",
    config = function()
      require("litee.lib").setup({
        tree = {
          icon_set = "codicons",
        },
        panel = {
          orientation = "bottom",
          panel_size = 10,
        },
      })
    end,
  },
  {
    "ldelossa/litee-calltree.nvim",
    dependencies = "ldelossa/litee.nvim",
    config = function()
      require("litee.calltree").setup({
        resolve_symbols = true,
        jump_mode = "invoking",
        hide_cursor = false,
        keymaps = {
          expand = "o",
          collapse = "zc",
          collapse_all = "zM",
          jump = "<CR>",
          jump_split = "s",
          jump_vsplit = "v",
          jump_tab = "t",
          hover = "i",
          details = "d",
          close = "X",
          close_panel_pop_out = "<Esc>",
          help = "?",
          hide = "H",
          switch = "S",
          focus = "f",
        },
      })

      -- Keymaps for call hierarchy
      vim.keymap.set("n", "<leader>ci", "<cmd>LTOpenToCalltreeIncoming<cr>", { desc = "Incoming calls" })
      vim.keymap.set("n", "<leader>co", "<cmd>LTOpenToCalltreeOutgoing<cr>", { desc = "Outgoing calls" })
    end,
  },
}
