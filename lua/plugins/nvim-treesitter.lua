return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  version = false,
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
  opts = {
    indent = { enable = true },
    highlight = { enable = true },
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "printf",
      "python",
      "query",
      "regex",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
  },
  config = function(_, opts)
    local ts = require("nvim-treesitter")

    if not ts.get_installed then
      vim.notify("Please restart Neovim and run `:TSUpdate`", vim.log.levels.ERROR)
      return
    end

    ts.setup(opts)

    -- Install missing parsers
    local installed = ts.get_installed()
    local installed_set = {}
    for _, lang in ipairs(installed) do
      installed_set[lang] = true
    end

    local to_install = vim.tbl_filter(function(lang)
      return not installed_set[lang]
    end, opts.ensure_installed or {})

    if #to_install > 0 then
      ts.install(to_install)
    end

    -- Enable treesitter-based highlighting and folding via FileType
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_setup", { clear = true }),
      callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
        local win = vim.api.nvim_get_current_win()
        if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == ev.buf then
          vim.wo[win].foldmethod = "expr"
          vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
      end,
    })
  end,
}
