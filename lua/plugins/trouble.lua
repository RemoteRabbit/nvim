return {
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({
        icons = {
          indent = {
            middle = "│ ",
            last = "└ ",
            top = "│ ",
            ws = "  ",
          },
          folder_closed = "",
          folder_open = "",
          kinds = {
            Array = "",
            Boolean = "󰨙",
            Class = "",
            Constant = "󰏿",
            Constructor = "",
            Enum = "",
            EnumMember = "",
            Event = "",
            Field = "",
            File = "󰈔",
            Function = "󰊕",
            Interface = "",
            Key = "",
            Method = "󰊕",
            Module = "",
            Namespace = "󰦮",
            Null = "",
            Number = "󰎠",
            Object = "",
            Operator = "󰆕",
            Package = "",
            Property = "",
            String = "",
            Struct = "󰆼",
            TypeParameter = "",
            Variable = "󰀫",
          },
        },
        signs = {
          error = "",
          warning = "",
          hint = "󰌵",
          information = "",
          other = "",
        },
        modes = {
          symbols = {
            win = { position = "right" },
          },
        },
      })

      -- Keymaps for trouble
      vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
      vim.keymap.set(
        "n",
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        { desc = "Buffer Diagnostics (Trouble)" }
      )
      vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
      vim.keymap.set(
        "n",
        "<leader>xl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        { desc = "LSP Definitions / references / ... (Trouble)" }
      )
      vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
      vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
    end,
  },
}
