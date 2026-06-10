-- update-readme.lua - refresh the auto-generated plugin list in README.md.
--
-- Run with: nvim -l scripts/update-readme.lua
--
-- Replaces the content between the AUTO-GENERATED PLUGIN LIST markers in place,
-- categorizing plugins by filename. If the markers are missing the section is
-- appended to the end of the file.

local script_dir = arg[0]:match("(.*[/\\])") or "./"
package.path = script_dir .. "lib/?.lua;" .. package.path
local docgen = require("docgen")

local START = "<!-- AUTO-GENERATED PLUGIN LIST START -->"
local STOP = "<!-- AUTO-GENERATED PLUGIN LIST END -->"
local README = "README.md"

-- Build the categorized plugin list.
local function build_section()
  local files = docgen.lua_files("lua/plugins", "*.lua")
  local by_cat = {}
  for _, file in ipairs(files) do
    local name = vim.fn.fnamemodify(file, ":t:r")
    local info = docgen.plugin_info(file)
    local repo = info and info.repo or name
    local cat = docgen.category(name)
    by_cat[cat] = by_cat[cat] or {}
    table.insert(by_cat[cat], repo)
  end

  local lines = { START, "", string.format("### Installed Plugins (%d total)", #files), "" }
  for _, cat in ipairs(docgen.category_order) do
    if by_cat[cat] then
      table.sort(by_cat[cat])
      table.insert(lines, "#### " .. cat)
      table.insert(lines, "")
      for _, repo in ipairs(by_cat[cat]) do
        table.insert(lines, string.format("- [%s](https://github.com/%s)", repo, repo))
      end
      table.insert(lines, "")
    end
  end
  table.insert(lines, STOP)
  return table.concat(lines, "\n")
end

local content = docgen.read(README)
if not content then
  error("README.md not found")
end

local section = build_section()
local start_idx = content:find(START, 1, true)
local stop_idx = content:find(STOP, 1, true)

local updated
if start_idx and stop_idx then
  updated = content:sub(1, start_idx - 1) .. section .. content:sub(stop_idx + #STOP)
else
  updated = content:gsub("%s*$", "") .. "\n\n" .. section .. "\n"
end

docgen.write(README, updated)
print("Updated plugin list in README.md")
