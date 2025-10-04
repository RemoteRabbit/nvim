return {
  "juliosueiras/vim-terraform-completion",
  ft = "terraform",
  config = function()
    vim.g.terraform_completion_keys = 1
    vim.g.terraform_registry_module_completion = 1
  end,
}
