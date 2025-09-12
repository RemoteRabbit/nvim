-- Enhanced LSP features: reference highlighting, signature help, etc.
return {
  {
    -- Reference highlighting and enhanced LSP features
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate").configure({
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
        delay = 100,
        filetype_overrides = {},
        filetypes_denylist = {
          "dirvish",
          "fugitive",
          "NvimTree",
          "Trouble",
        },
        filetypes_allowlist = {},
        modes_denylist = {},
        modes_allowlist = {},
        providers_regex_syntax_denylist = {},
        providers_regex_syntax_allowlist = {},
        under_cursor = true,
        large_file_cutoff = nil,
        large_file_overrides = nil,
        min_count_to_highlight = 1,
      })

      -- Keymaps for reference navigation
      vim.keymap.set("n", "<A-n>", function()
        require("illuminate").goto_next_reference()
      end, { desc = "Next reference" })
      vim.keymap.set("n", "<A-p>", function()
        require("illuminate").goto_prev_reference()
      end, { desc = "Previous reference" })
    end,
  },
  {
    -- Enhanced signature help
    "ray-x/lsp_signature.nvim",
    config = function()
      require("lsp_signature").setup({
        bind = true,
        doc_lines = 10,
        max_height = 12,
        max_width = 80,
        wrap = true,
        floating_window = true,
        floating_window_above_cur_line = true,
        floating_window_off_x = 1,
        floating_window_off_y = 0,
        close_timeout = 4000,
        fix_pos = false,
        hint_enable = true,
        hint_prefix = "🐼 ",
        hint_scheme = "String",
        hi_parameter = "LspSignatureActiveParameter",
        handler_opts = {
          border = "rounded",
        },
        always_trigger = false,
        auto_close_after = nil,
        extra_trigger_chars = {},
        zindex = 200,
        padding = " ",
        transparency = nil,
        shadow_blend = 36,
        shadow_guibg = "Black",
        timer_interval = 200,
        toggle_key = nil,
        select_signature_key = nil,
        move_cursor_key = nil,
        -- Filter out terminal buffers to prevent URI errors
        filter = function(bufnr)
          local buftype = vim.bo[bufnr].buftype
          local filetype = vim.bo[bufnr].filetype
          return buftype ~= "terminal" and filetype ~= "toggleterm"
        end,
      })
    end,
  },
  {
    -- Call hierarchy and type hierarchy
    "SmiteshP/nvim-navic",
    config = function()
      local navic = require("nvim-navic")
      navic.setup({
        icons = {
          File = "󰈙 ",
          Module = " ",
          Namespace = "󰌗 ",
          Package = " ",
          Class = "󰌗 ",
          Method = "󰆧 ",
          Property = " ",
          Field = " ",
          Constructor = " ",
          Enum = "󰕘",
          Interface = "󰕘",
          Function = "󰊕 ",
          Variable = "󰆧 ",
          Constant = "󰏿 ",
          String = "󰀬 ",
          Number = "󰎠 ",
          Boolean = "◩ ",
          Array = "󰅪 ",
          Object = "󰅩 ",
          Key = "󰌋 ",
          Null = "󰟢 ",
          EnumMember = " ",
          Struct = "󰌗 ",
          Event = " ",
          Operator = "󰆕 ",
          TypeParameter = "󰊄 ",
        },
        lsp = {
          auto_attach = true,
          preference = nil,
        },
        highlight = false,
        separator = " > ",
        depth_limit = 0,
        depth_limit_indicator = "..",
        safe_output = true,
        lazy_update_context = false,
        click = false,
      })

      -- Attach navic to LSP
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.server_capabilities.documentSymbolProvider then
            navic.attach(client, args.buf)
          end
        end,
      })

      -- Show breadcrumbs in winbar
      vim.api.nvim_create_autocmd({ "CursorMoved", "BufEnter" }, {
        callback = function()
          if navic.is_available() then
            vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
          end
        end,
      })
    end,
  },
}
