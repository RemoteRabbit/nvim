local M = {}

local START = "-- ===============================Keymaps Start================================="
local STOP = "-- =================================Keymaps End================================="

--- Build table of keymaps.
---@param entries table A list of keymap entries, each containing mode, lhs, and desc fields.
---@return table A table containing the formatted keymaps from the current file.
local function build_lines(entries)
  local lines = { START }
  if #entries == 0 then
    table.insert(lines, "-- (no keymaps found)")
  else
    local mode_w, lhs_w = 0, 0
    for _, e in ipairs(entries) do
      mode_w = math.max(mode_w, #e.mode)
      lhs_w = math.max(lhs_w, #e.lhs)
    end
    local fmt = "-- %-" .. mode_w .. "s %-" .. lhs_w .. "s %s"
    for _, e in ipairs(entries) do
      local line = string.format(fmt, e.mode, e.lhs, e.desc)
      table.insert(lines, (line:gsub("%s+$", "")))
    end
  end
  table.insert(lines, STOP)
  return lines
end

--- Inject keymap lines to top of current file between marker blocks.
---@param buf integer Neovim buffer number or nil; if nil, the current buffer is used.
---@param entries table A list of keymap entries to inject into the file.
function M.inject(buf, entries)
  buf = (buf == 0) and vim.api.nvim_get_current_buf() or buf

  local all = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local block = build_lines(entries)

  local start_idx, stop_idx
  for i, line in ipairs(all) do
    if line:find(START, 1, true) then
      start_idx = i - 1
    end
    if line:find(STOP, 1, true) then
      stop_idx = i
    end
  end

  if start_idx and stop_idx and stop_idx > start_idx then
    vim.api.nvim_buf_set_lines(buf, start_idx, stop_idx, false, block)
  else
    local prepend = vim.list_extend(vim.deepcopy(block), { "" })
    vim.api.nvim_buf_set_lines(buf, 0, 0, false, prepend)
  end
end

return M
