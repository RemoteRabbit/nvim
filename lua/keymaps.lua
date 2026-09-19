-- =============================================================================
-- KEYMAPS (core / editor only)
--
-- Convention:
--   * This file holds ONLY built-in, plugin-agnostic keymaps.
--   * Plugin-specific keymaps live in that plugin's `config` function under
--     plugins/<plugin>.lua, so they load right after the plugin is set up and
--     travel with the plugin if it's ever removed.
--   * Keep maps grouped under the section headers below. Add new sections as
--     needed rather than appending to the bottom.
-- ============================================================================

---Thin wrapper so each mapping is a single readable line.
---@param mode string|string[] Array or single character to signify vim mode.
---@param lhs string Left hand side.
---@param rhs string|function Right hand side.
---@param desc string Description for keymap.
---@param opts? table Optional configuration table.
---@return nil
local function map(mode, lhs, rhs, desc, opts)
  opts = vim.tbl_extend("force", { desc = desc }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Insert ----------------------------------------------------------------------
map("i", "jk", "<ESC>", "Exit insert mode with jk")

-- Movement --------------------------------------------------------------------
map("n", "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, "Down (wrap-aware)", { expr = true, silent = true })
map("n", "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, "Up (wrap-aware)", { expr = true, silent = true })
map("n", "<C-d>", "<C-d>zz", "Half page down (centered)")
map("n", "<C-u>", "<C-u>zz", "Half page up (centered)")

-- Search ----------------------------------------------------------------------
map("n", "<C-c>", ":nohlsearch<CR>", "Clear search highlights")
map("n", "n", "nzzzv", "Next search result (centered)")
map("n", "N", "Nzzzv", "Previous search result (centered)")

-- Editing ---------------------------------------------------------------------
map("x", "<leader>p", '"_dP', "Paste without yanking")
map({ "n", "v" }, "<leader>d", '"_d', "Delete without yanking")
map("n", "<A-j>", ":m .+1<CR>==", "Move line down")
map("n", "<A-k>", ":m .-2<CR>==", "Move line up")
map("v", "<A-j>", ":m '>+1<CR>gv=gv", "Move selection down")
map("v", "<A-k>", ":m '<-2<CR>gv=gv", "Move selection up")
map("v", "<", "<gv", "Indent left and reselect")
map("v", ">", ">gv", "Indent right and reselect")
map("n", "J", "mzJ`z", "Join lines and keep cursor position")

-- Buffers ---------------------------------------------------------------------
map("n", "<leader>bn", ":bnext<CR>", "Next buffer")
map("n", "<leader>bp", ":bprevious<CR>", "Previous buffer")

-- Windows ---------------------------------------------------------------------
map("n", "<leader>sv", ":vsplit<CR>", "Split window vertically")
map("n", "<leader>sh", ":split<CR>", "Split window horizontally")
map("n", "<C-Up>", ":resize +2<CR>", "Increase window height")
map("n", "<C-Down>", ":resize -2<CR>", "Decrease window height")
map("n", "<C-Left>", ":vertical resize -2<CR>", "Decrease window width")
map("n", "<C-Right>", ":vertical resize +2<CR>", "Increase window width")

-- Utility / toggles -----------------------------------------------------------
local width = 80
---Build a banner divider using the current buffer's comment leader, padded with
---`=` out to `width` columns (e.g. `-- =====...`, `# =====...`, `// =====...`).
---@param width integer target line width (column to fill up to) [80]
---@return string the full banner line with comment start.
local function comment_banner(width)
  local cs = vim.bo.commentstring
  if cs == nil or cs == "" then
    cs = "# %s"
  end
  local prefix, suffix = cs:match("^(.-)%%s(.-)$")
  prefix = vim.trim(prefix or "#")
  suffix = vim.trim(suffix or "")
  local used = #prefix + 1 + (#suffix > 0 and #suffix + 1 or 0)
  local fill = math.max(width - used, 1)
  local line = prefix .. " " .. string.rep("=", fill)
  if #suffix > 0 then
    line = line .. " " .. suffix
  end
  return line
end
map("n", "<leader>cb", function() -- comment banner / section divider
  vim.api.nvim_set_current_line(comment_banner(width))
end, "Insert comment banner divider")

map("n", "<leader>pa", function() -- copy full file path
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("file:", path)
end, "Copy full file path")
map("n", "<leader>td", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, "Toggle diagnostics")

-- Vim Pack -------------------------------------------------------------------
map("n", "<leader>vu", ":lua vim.pack.update()<CR>", "Update plugins (no force)")
map("n", "<leader>vf", ":lua vim.pack.update(all,{force=true})<CR>", "Update plugins (FORCE)")
