-- UI/UX improvements: statusline, minimap, scrolling, focus mode, guides
return {
  {
    -- Enhanced statusline with LSP info, git, diagnostics
    "nvim-lualine/lualine.nvim",
    config = function()
      local function lsp_status()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then
          return "No LSP"
        end
        local names = {}
        for _, client in pairs(clients) do
          table.insert(names, client.name)
        end
        return " " .. table.concat(names, ", ")
      end

      local function python_env()
        if vim.bo.filetype == "python" then
          local venv = os.getenv("VIRTUAL_ENV")
          if venv then
            return " " .. vim.fn.fnamemodify(venv, ":t")
          end
        end
        return ""
      end

      local function diagnostics_count()
        local diagnostics = vim.diagnostic.get(0)
        local count = { errors = 0, warnings = 0, info = 0, hints = 0 }
        for _, diagnostic in ipairs(diagnostics) do
          if diagnostic.severity == vim.diagnostic.severity.ERROR then
            count.errors = count.errors + 1
          elseif diagnostic.severity == vim.diagnostic.severity.WARN then
            count.warnings = count.warnings + 1
          elseif diagnostic.severity == vim.diagnostic.severity.INFO then
            count.info = count.info + 1
          elseif diagnostic.severity == vim.diagnostic.severity.HINT then
            count.hints = count.hints + 1
          end
        end
        
        local result = ""
        if count.errors > 0 then
          result = result .. " " .. count.errors
        end
        if count.warnings > 0 then
          result = result .. " " .. count.warnings
        end
        if count.info > 0 then
          result = result .. " " .. count.info
        end
        if count.hints > 0 then
          result = result .. "󰌵 " .. count.hints
        end
        return result
      end

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = {
            { "filename", path = 1 },
            { python_env, color = { fg = "#98be65" } },
          },
          lualine_x = {
            { diagnostics_count, color = { fg = "#ff6c6b" } },
            { lsp_status, color = { fg = "#51afef" } },
            "encoding",
            "fileformat",
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      })
    end,
  },
  {
    -- Minimap
    "wfxr/minimap.vim",
    build = "cargo install --locked code-minimap",
    config = function()
      vim.g.minimap_width = 10
      vim.g.minimap_auto_start = 1
      vim.g.minimap_auto_start_win_enter = 1
      vim.g.minimap_block_filetypes = { "fugitive", "nerdtree", "tagbar", "NvimTree" }
      vim.g.minimap_close_filetypes = { "startify", "netrw", "vim-plug" }
      vim.g.minimap_highlight_range = 1
      vim.g.minimap_highlight_search = 1
      vim.g.minimap_git_colors = 1

      -- Keymaps
      vim.keymap.set("n", "<leader>mm", "<cmd>MinimapToggle<cr>", { desc = "Toggle minimap" })
      vim.keymap.set("n", "<leader>mr", "<cmd>MinimapRefresh<cr>", { desc = "Refresh minimap" })
      vim.keymap.set("n", "<leader>mc", "<cmd>MinimapClose<cr>", { desc = "Close minimap" })
    end,
  },
  {
    -- Smooth scrolling
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = nil,
        pre_hook = nil,
        post_hook = nil,
        performance_mode = false,
      })
    end,
  },

  {
    -- Color columns and line length guides
    "lukas-reineke/virt-column.nvim",
    config = function()
      require("virt-column").setup({
        virtcolumn = "80,120",
        char = "┃",
        highlight = { "NonText" },
      })
    end,
  },
  {
    -- Better tabline
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "none",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,
          indicator = {
            icon = "▎",
            style = "icon",
          },
          buffer_close_icon = "󰅖",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          max_name_length = 30,
          max_prefix_length = 30,
          truncate_names = true,
          tab_size = 21,
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "left",
              separator = true,
            },
          },
          color_icons = true,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          show_duplicate_prefix = true,
          persist_buffer_sort = true,
          separator_style = "slant",
          enforce_regular_tabs = true,
          always_show_bufferline = true,
          hover = {
            enabled = true,
            delay = 200,
            reveal = { "close" },
          },
          sort_by = "insert_after_current",
        },
      })

      -- Keymaps
      vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
      vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
      vim.keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
      vim.keymap.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
      vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Pin buffer" })
      vim.keymap.set("n", "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete non-pinned buffers" })
      vim.keymap.set("n", "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", { desc = "Delete other buffers" })
      vim.keymap.set("n", "<leader>br", "<Cmd>BufferLineCloseRight<CR>", { desc = "Delete buffers to the right" })
      vim.keymap.set("n", "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Delete buffers to the left" })
    end,
  },
}
