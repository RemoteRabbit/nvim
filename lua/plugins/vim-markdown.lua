-- Enhanced markdown editing
return {
  "preservim/vim-markdown",
  dependencies = { "godlygeek/tabular" },
  config = function()
    vim.g.vim_markdown_folding_disabled = 1
    vim.g.vim_markdown_conceal = 0
    vim.g.vim_markdown_conceal_code_blocks = 0
    vim.g.vim_markdown_math = 1
    vim.g.vim_markdown_toml_frontmatter = 1
    vim.g.vim_markdown_frontmatter = 1
    vim.g.vim_markdown_strikethrough = 1
    vim.g.vim_markdown_autowrite = 1
    vim.g.vim_markdown_edit_url_in = "tab"
    vim.g.vim_markdown_follow_anchor = 1
  end,
}
