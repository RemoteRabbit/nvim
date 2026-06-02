return {
  "chrisgrieser/nvim-scissors",
  dependencies = { "nvim-telescope/telescope.nvim" },
  cmd = { "ScissorsAddNewSnippet", "ScissorsEditSnippet" },
  keys = {
    {
      "<leader>csa",
      function()
        require("scissors").addNewSnippet()
      end,
      mode = { "n", "x" },
      desc = "Add new snippet",
    },
    {
      "<leader>cse",
      function()
        require("scissors").editSnippet()
      end,
      desc = "Edit snippet",
    },
  },
  opts = {
    snippetDir = vim.fn.stdpath("config") .. "/snippets",
    editSnippetPopup = {
      height = 0.4,
      width = 0.6,
      border = "rounded",
      keymaps = {
        cancel = "q",
        saveChanges = "<CR>",
        goBackToSearch = "<BS>",
        deleteSnippet = "<C-BS>",
        duplicateSnippet = "<C-d>",
        openInFile = "<C-o>",
        insertNextToken = "<C-t>",
        jumpBetweenBodyAndPrefix = "<C-Tab>",
      },
    },
  },
}
