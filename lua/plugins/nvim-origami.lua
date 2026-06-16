return {
  "chrisgrieser/nvim-origami",
  event = "VeryLazy",
  keys = {
    { "z1", desc = "Fold level 1" },
    { "z2", desc = "Fold level 2" },
    { "z3", desc = "Fold level 3" },
    { "z4", desc = "Fold level 4" },
    { "z5", desc = "Fold level 5" },
    { "zP", desc = "Pick fold" },
  },
  init = function()
    -- disable vim's auto-folding (recommended by origami)
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  opts = {
    useLspFoldsWithTreesitterFallback = {
      enabled = true,
      foldmethodIfNeitherIsAvailable = "indent",
    },
    pauseFoldsOnSearch = true,
    foldtext = {
      enabled = true,
      padding = { character = " ", width = 3 },
      lineCount = {
        template = "  %d lines",
        hlgroup = "Comment",
      },
      diagnosticsCount = true,
      gitsignsCount = true,
    },
    autoFold = {
      enabled = true,
      kinds = { "comment", "imports" },
    },
    foldKeymaps = {
      setup = true, -- h/l/^/$ become fold-aware at line edges
      closeOnlyOnFirstColumn = false,
      scrollLeftOnCaret = false,
    },
  },
  config = function(_, opts)
    require("origami").setup(opts)

    -- Quick fold-level shortcuts: z1..z5 set foldlevel
    for i = 1, 5 do
      vim.keymap.set("n", "z" .. i, function()
        vim.o.foldlevel = i
      end, { desc = "Fold level " .. i })
    end

    -- Snacks picker: list every fold in the current buffer, jump on confirm
    vim.keymap.set("n", "zP", function()
      local ok, Snacks = pcall(require, "snacks")
      if not ok then
        vim.notify("snacks.nvim not available", vim.log.levels.WARN)
        return
      end

      local bufnr = vim.api.nvim_get_current_buf()
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local items = {}
      for lnum = 1, #lines do
        local fs = vim.fn.foldlevel(lnum)
        local prev = lnum > 1 and vim.fn.foldlevel(lnum - 1) or 0
        if fs > 0 and fs > prev then
          local text = lines[lnum]
          table.insert(items, {
            text = string.format("%4d  %s%s", lnum, string.rep("  ", fs - 1), text),
            file = vim.api.nvim_buf_get_name(bufnr),
            pos = { lnum, 0 },
          })
        end
      end

      if #items == 0 then
        vim.notify("No folds in buffer", vim.log.levels.INFO)
        return
      end

      Snacks.picker.pick({
        title = "Folds",
        items = items,
        format = "text",
        confirm = function(picker, item)
          picker:close()
          if item then
            vim.api.nvim_win_set_cursor(0, item.pos)
            vim.cmd("normal! zv")
          end
        end,
      })
    end, { desc = "Pick fold" })
  end,
}
