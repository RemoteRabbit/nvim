-- ============================================================================
-- AUTOCMDS
-- ============================================================================

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- OpenTofu files share Terraform/HCL syntax but Neovim doesn't detect them by
-- default. Map them to `terraform` so LSP, treesitter and the terraform
-- snippets all apply.
vim.filetype.add({
  extension = {
    tofu = "terraform",
    -- Go templates (gopls + treesitter `gotmpl`).
    gotmpl = "gotmpl",
    tmpl = "gotmpl",
  },
  pattern = {
    [".*%.tofu%.json"] = "json",
    -- Helm chart templates (treesitter `helm`); only inside a chart, so other
    -- templates/ dirs stay yaml.
    [".*/templates/.*%.ya?ml"] = function(path)
      return vim.fs.root(path, "Chart.yaml") and "helm" or nil
    end,
    [".*/templates/.*%.tpl"] = function(path)
      return vim.fs.root(path, "Chart.yaml") and "helm" or nil
    end,
  },
})

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  desc = "Restore last cursor position",
  callback = function()
    if vim.o.diff then -- except in diff mode
      return
    end

    local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
    local last_line = vim.api.nvim_buf_line_count(0)

    local row = last_pos[1]
    if row < 1 or row > last_line then
      return
    end

    pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
  end,
})

-- wrap, linebreak and spellcheck on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
  end,
})

local function complete_packages(match)
  return vim
    .iter(vim.pack.get())
    :map(function(pack)
      return pack.spec.name
    end)
    :filter(function(pack)
      return pack:find(match)
    end)
    :totable()
end

vim.api.nvim_create_user_command("PackUpdate", function(info)
  if #info.fargs ~= 0 then
    vim.pack.update(info.fargs, { force = info.bang })
  else
    vim.pack.update(nil, { force = info.bang })
  end
end, {
  desc = "Update packages",
  nargs = "*",
  bang = true,
  complete = complete_packages,
})

vim.api.nvim_create_user_command("PackDelete", function(info)
  vim.pack.del(info.fargs, { force = info.bang })
end, {
  desc = "Delete packages",
  nargs = "+",
  bang = true,
  complete = complete_packages,
})
