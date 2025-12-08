local M = {}

-- Known intentional overrides (plugins extending built-in behavior)
-- These are not real conflicts
local IGNORED_PATTERNS = {
  -- Fold mappings (nvim-ufo extends these)
  "^z[mMrRaAcCoOnN]$",
  -- Diagnostic navigation (multiple plugins provide this)
  "^%[d$",
  "^%]d$",
  -- Buffer/tab navigation (bufferline, etc.)
  "^%[b$",
  "^%]b$",
  "^%[t$",
  "^%]t$",
  "^gt$",
  "^gT$",
  -- Quickfix/location list
  "^%[q$",
  "^%]q$",
  "^%[l$",
  "^%]l$",
  -- Argument list
  "^%[a$",
  "^%]a$",
  -- Comment mappings
  "^gc",
  "^gco$",
  "^gcO$",
  "^gcA$",
  -- Scroll mappings in visual mode (neoscroll)
  "^<C%-[bdfuey]>$",
  -- Center/top/bottom in visual mode
  "^z[ztb]$",
}

-- Modes where we expect lots of intentional overrides
local RELAXED_MODES = { "v", "x", "s", "o" }

local function get_all_keymaps()
  local keymaps = {}
  local modes = { "n", "i", "v", "x", "s", "o", "c", "t" }

  for _, mode in ipairs(modes) do
    local mode_maps = vim.api.nvim_get_keymap(mode)
    for _, map in ipairs(mode_maps) do
      table.insert(keymaps, {
        mode = mode,
        lhs = map.lhs,
        rhs = map.rhs or map.callback and "<callback>" or "",
        desc = map.desc or "",
        buffer = false,
      })
    end
  end

  return keymaps
end

local function normalize_key(key)
  -- Normalize special keys but preserve case for regular characters
  return key
    :gsub("<[Ll]eader>", vim.g.mapleader or "\\")
    :gsub("<CR>", "\r")
    :gsub("<Esc>", "\027")
    :gsub("<Tab>", "\t")
    :gsub("<Space>", " ")
    :gsub("<([Cc])%-", "<%1-") -- Normalize Ctrl
    :gsub("<([Ss])%-", "<%1-") -- Normalize Shift
    :gsub("<([Mm])%-", "<%1-") -- Normalize Meta/Alt
end

local function is_ignored(lhs, mode)
  -- Check if mode is relaxed (we expect overrides there)
  for _, m in ipairs(RELAXED_MODES) do
    if mode == m and not lhs:match("^<[Ll]eader>") then
      return true
    end
  end

  -- Check against ignored patterns
  for _, pattern in ipairs(IGNORED_PATTERNS) do
    if lhs:match(pattern) then
      return true
    end
  end

  return false
end

function M.find_conflicts(opts)
  opts = opts or {}
  local include_ignored = opts.include_ignored or false
  local leader_only = opts.leader_only or false

  local keymaps = get_all_keymaps()
  local conflicts = {}
  local seen = {}

  for _, map in ipairs(keymaps) do
    local should_process = true

    -- Skip if leader_only and not a leader mapping
    if leader_only and not map.lhs:match("^<[Ll]eader>") then
      should_process = false
    end

    -- Skip ignored patterns unless explicitly requested
    if should_process and not include_ignored and is_ignored(map.lhs, map.mode) then
      should_process = false
    end

    if should_process then
      local key = map.mode .. ":" .. normalize_key(map.lhs)

      if seen[key] then
        if not conflicts[key] then
          conflicts[key] = { seen[key] }
        end
        table.insert(conflicts[key], map)
      else
        seen[key] = map
      end
    end
  end

  return conflicts
end

function M.find_leader_duplicates()
  local keymaps = get_all_keymaps()
  local leader_maps = {}
  local duplicates = {}

  for _, map in ipairs(keymaps) do
    if map.lhs:match("^<[Ll]eader>") or map.lhs:match("^ ") then
      local key = map.mode .. ":" .. map.lhs
      if leader_maps[key] then
        if not duplicates[key] then
          duplicates[key] = { leader_maps[key] }
        end
        table.insert(duplicates[key], map)
      else
        leader_maps[key] = map
      end
    end
  end

  return duplicates
end

function M.check_conflicts()
  local conflicts = M.find_conflicts({ leader_only = true })
  local count = vim.tbl_count(conflicts)

  if count > 0 then
    print("CONFLICTS_FOUND:" .. count)
  else
    print("NO_CONFLICTS")
  end

  return conflicts
end

function M.show_conflicts(opts)
  opts = opts or {}
  local show_all = opts.all or false

  local conflicts
  if show_all then
    conflicts = M.find_conflicts({ include_ignored = true })
  else
    conflicts = M.find_conflicts()
  end

  local lines = { "# Keymap Analysis", "" }

  if not show_all then
    table.insert(lines, "_Filtered view (use `:CheckKeymaps!` to show all)_")
    table.insert(lines, "")
  end

  -- Show conflicts
  local conflict_count = vim.tbl_count(conflicts)
  if conflict_count > 0 then
    table.insert(lines, "## ⚠ Conflicts Found: " .. conflict_count)
    table.insert(lines, "")

    -- Sort keys for consistent output
    local sorted_keys = {}
    for key in pairs(conflicts) do
      table.insert(sorted_keys, key)
    end
    table.sort(sorted_keys)

    for _, key in ipairs(sorted_keys) do
      local maps = conflicts[key]
      table.insert(lines, "### " .. key)
      for _, map in ipairs(maps) do
        local desc = map.desc ~= "" and (" - " .. map.desc) or ""
        local rhs = (map.rhs or "<callback>"):sub(1, 50)
        table.insert(lines, string.format("  - `%s` → `%s`%s", map.lhs, rhs, desc))
      end
      table.insert(lines, "")
    end
  else
    table.insert(lines, "## ✓ No keymap conflicts detected")
    table.insert(lines, "")
  end

  -- Show leader key summary
  table.insert(lines, "## Leader Key Summary")
  table.insert(lines, "")

  local leader_maps = {}
  local keymaps = get_all_keymaps()
  for _, map in ipairs(keymaps) do
    if map.lhs:match("^<[Ll]eader>") and map.mode == "n" then
      table.insert(leader_maps, map)
    end
  end

  table.sort(leader_maps, function(a, b)
    return a.lhs < b.lhs
  end)

  table.insert(lines, "| Key | Description |")
  table.insert(lines, "|-----|-------------|")
  for _, map in ipairs(leader_maps) do
    local desc = map.desc ~= "" and map.desc or (map.rhs or "<callback>")
    table.insert(lines, string.format("| `%s` | %s |", map.lhs, desc))
  end

  -- Display in a floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

  local width = math.min(100, vim.o.columns - 10)
  local height = math.min(#lines + 2, vim.o.lines - 10)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = "minimal",
    border = "rounded",
    title = " Keymap Check ",
    title_pos = "center",
  })

  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, nowait = true })

  vim.keymap.set("n", "<Esc>", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, nowait = true })
end

function M.export_keymaps(filepath)
  filepath = filepath or vim.fn.stdpath("config") .. "/keymaps_export.md"

  local keymaps = get_all_keymaps()
  local lines = { "# All Keymaps", "", "Generated: " .. os.date("%Y-%m-%d %H:%M:%S"), "" }

  local by_mode = {}
  for _, map in ipairs(keymaps) do
    if not by_mode[map.mode] then
      by_mode[map.mode] = {}
    end
    table.insert(by_mode[map.mode], map)
  end

  local mode_names = {
    n = "Normal",
    i = "Insert",
    v = "Visual",
    x = "Visual Block",
    s = "Select",
    o = "Operator",
    c = "Command",
    t = "Terminal",
  }

  for mode, maps in pairs(by_mode) do
    table.insert(lines, "## " .. (mode_names[mode] or mode) .. " Mode")
    table.insert(lines, "")
    table.insert(lines, "| Key | Action | Description |")
    table.insert(lines, "|-----|--------|-------------|")

    table.sort(maps, function(a, b)
      return a.lhs < b.lhs
    end)

    for _, map in ipairs(maps) do
      if map.lhs:match("^<[Ll]eader>") then
        local rhs = (map.rhs or "<callback>"):gsub("|", "\\|"):sub(1, 40)
        local desc = (map.desc or ""):gsub("|", "\\|")
        table.insert(lines, string.format("| `%s` | `%s` | %s |", map.lhs, rhs, desc))
      end
    end
    table.insert(lines, "")
  end

  local file = io.open(filepath, "w")
  if file then
    file:write(table.concat(lines, "\n"))
    file:close()
    vim.notify("Keymaps exported to: " .. filepath, vim.log.levels.INFO)
  else
    vim.notify("Failed to export keymaps", vim.log.levels.ERROR)
  end
end

-- Setup user commands
function M.setup()
  vim.api.nvim_create_user_command("CheckKeymaps", function(opts)
    M.show_conflicts({ all = opts.bang })
  end, { desc = "Check for keymap conflicts (use ! for all)", bang = true })

  vim.api.nvim_create_user_command("ExportKeymaps", function(opts)
    M.export_keymaps(opts.args ~= "" and opts.args or nil)
  end, { desc = "Export all keymaps to markdown", nargs = "?" })
end

return M
