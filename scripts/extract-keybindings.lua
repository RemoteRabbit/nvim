-- extract-keybindings.lua - generate docs/KEYBINDINGS.md from the config.
--
-- Run with: nvim -l scripts/extract-keybindings.lua
--
-- Parses every Lua file with tree-sitter, collects `*.keymap.set` calls that
-- have a string key and a `desc`, and writes a markdown reference grouped by
-- mode with clickable source links.

local script_dir = arg[0]:match("(.*[/\\])") or "./"
package.path = script_dir .. "lib/?.lua;" .. package.path
local docgen = require("docgen")

local function escape(s)
  return (s:gsub("|", "\\|"))
end

local mode_names = {
  n = "Normal Mode",
  i = "Insert Mode",
  v = "Visual Mode",
  x = "Visual Block Mode",
  s = "Select Mode",
  o = "Operator-pending Mode",
  t = "Terminal Mode",
  c = "Command Mode",
  [""] = "Normal, Visual, Operator-pending",
}

local files = {}
vim.list_extend(files, docgen.lua_files("lua", "**/*.lua"))
vim.list_extend(files, docgen.lua_files(".", "*.lua"))
table.sort(files)

-- Collect keymaps grouped by mode.
local by_mode = {}
local total = 0
for _, file in ipairs(files) do
  local src = docgen.read(file)
  if src then
    local rel = file:gsub("^%./", "")
    for _, km in ipairs(docgen.extract_keymaps(src)) do
      by_mode[km.mode] = by_mode[km.mode] or {}
      table.insert(by_mode[km.mode], { key = km.key, desc = km.desc, src = rel, line = km.line })
      total = total + 1
    end
  end
end

local modes = vim.tbl_keys(by_mode)
table.sort(modes)

local out = {}
table.insert(out, "# Keybindings Reference")
table.insert(out, "")
table.insert(out, "_Auto-generated from configuration files. Do not edit manually._")
table.insert(out, "")

for _, mode in ipairs(modes) do
  table.insert(out, "## " .. (mode_names[mode] or ("Mode '" .. mode .. "'")))
  table.insert(out, "")
  table.insert(out, "| Key | Description | Source |")
  table.insert(out, "|-----|-------------|--------|")
  local rows = by_mode[mode]
  table.sort(rows, function(a, b)
    if a.key == b.key then
      return a.src < b.src
    end
    return a.key < b.key
  end)
  for _, r in ipairs(rows) do
    local source = string.format("[%s#L%d](%s#L%d)", r.src, r.line, r.src, r.line)
    table.insert(out, string.format("| `%s` | %s | %s |", escape(r.key), escape(r.desc), source))
  end
  table.insert(out, "")
end

docgen.write("docs/KEYBINDINGS.md", table.concat(out, "\n"))
print(string.format("Generated docs/KEYBINDINGS.md with %d keybindings", total))
