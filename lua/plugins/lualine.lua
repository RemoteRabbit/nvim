return {
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
}
