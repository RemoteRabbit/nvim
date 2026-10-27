return {
  src = "https://github.com/rachartier/tiny-code-action.nvim",
  vim.keymap.set({ "n", "x" }, "<leader>Ca", function()
    require("tiny-code-action").code_action()
  end, { noremap = true, silent = true }),
}
