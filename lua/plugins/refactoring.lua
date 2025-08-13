return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    {
      "<leader>re",
      function()
        require("refactoring").refactor("Extract Function")
      end,
      mode = "x",
      desc = "Extract Function",
    },
    {
      "<leader>rf",
      function()
        require("refactoring").refactor("Extract Function To File")
      end,
      mode = "x",
      desc = "Extract Function To File",
    },
    {
      "<leader>rv",
      function()
        require("refactoring").refactor("Extract Variable")
      end,
      mode = "x",
      desc = "Extract Variable",
    },
    {
      "<leader>ri",
      function()
        require("refactoring").refactor("Inline Variable")
      end,
      mode = { "n", "x" },
      desc = "Inline Variable",
    },
    {
      "<leader>rb",
      function()
        require("refactoring").refactor("Extract Block")
      end,
      mode = "x",
      desc = "Extract Block",
    },
    {
      "<leader>rbf",
      function()
        require("refactoring").refactor("Extract Block To File")
      end,
      mode = "x",
      desc = "Extract Block To File",
    },
    {
      "<leader>rr",
      function()
        require("refactoring").select_refactor()
      end,
      mode = { "n", "x" },
      desc = "Select Refactor",
    },
    {
      "<leader>rp",
      function()
        require("refactoring").debug.printf({ below = false })
      end,
      mode = "n",
      desc = "Debug Print",
    },
    {
      "<leader>rc",
      function()
        require("refactoring").debug.cleanup({})
      end,
      mode = "n",
      desc = "Debug Cleanup",
    },
  },
  opts = {
    prompt_func_return_type = {
      go = false,
      java = false,
      cpp = false,
      c = false,
      h = false,
      hpp = false,
      cxx = false,
    },
    prompt_func_param_type = {
      go = false,
      java = false,
      cpp = false,
      c = false,
      h = false,
      hpp = false,
      cxx = false,
    },
    printf_statements = {},
    print_var_statements = {},
    show_success_message = true, -- shows a message with information about the refactor on success
  },
  config = function(_, opts)
    require("refactoring").setup(opts)

    -- Load refactoring Telescope extension
    require("telescope").load_extension("refactoring")

    -- Telescope refactoring
    vim.keymap.set({ "n", "x" }, "<leader>rt", function()
      require("telescope").extensions.refactoring.refactors()
    end, { desc = "Telescope Refactoring" })

    -- Additional convenience mappings
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
  end,
}
