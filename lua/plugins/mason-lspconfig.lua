return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
  opts = {
    ensure_installed = {
      "codebook",
      "gopls",
      "lua_ls",
      "pyright",
      "terraformls",
      "tflint",
      "tofu_ls",
    },
  },
}
