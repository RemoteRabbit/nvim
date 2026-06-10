-- docgen.lua - shared helpers for documentation generation scripts.
--
-- These helpers parse the Lua configuration using Neovim's bundled tree-sitter
-- Lua parser instead of regular expressions, so they understand the real syntax
-- of keymap calls and plugin specs (multi-line calls, tables, nested fields).
--
-- Intended to be used from scripts run with `nvim -l scripts/<name>.lua`.

local M = {}

-- Return the inner value of a tree-sitter `string` node (without quotes),
-- or nil if the node is not a plain string literal.
function M.string_value(node, src)
  if not node or node:type() ~= "string" then
    return nil
  end
  for child in node:iter_children() do
    if child:type() == "string_content" then
      return vim.treesitter.get_node_text(child, src)
    end
  end
  return "" -- empty string literal ("")
end

-- Parse Lua source and return the root tree-sitter node.
function M.parse(src)
  local parser = vim.treesitter.get_string_parser(src, "lua")
  return parser:parse()[1]:root()
end

-- Read a file and return its contents, or nil.
function M.read(path)
  local fd = io.open(path, "r")
  if not fd then
    return nil
  end
  local content = fd:read("*a")
  fd:close()
  return content
end

-- List Lua files (sorted) matching a glob pattern.
function M.lua_files(dir, pattern)
  local files = vim.fn.globpath(dir, pattern or "**/*.lua", false, true)
  table.sort(files)
  return files
end

-- Recursively search a node for a `field` named `key` and return its string
-- value, or nil. Used to find e.g. `desc = "..."` anywhere inside a call.
local function find_field_string(node, src, key)
  if node:type() == "field" then
    local name = node:field("name")[1]
    if name and vim.treesitter.get_node_text(name, src) == key then
      return M.string_value(node:field("value")[1], src)
    end
  end
  for child in node:iter_children() do
    local found = find_field_string(child, src, key)
    if found then
      return found
    end
  end
  return nil
end

-- Collect string values from a table_constructor / string node.
local function collect_strings(node, src)
  if not node then
    return {}
  end
  if node:type() == "string" then
    local v = M.string_value(node, src)
    return v and { v } or {}
  end
  local out = {}
  if node:type() == "table_constructor" then
    for child in node:iter_children() do
      if child:type() == "field" then
        local v = M.string_value(child:field("value")[1], src)
        if v then
          table.insert(out, v)
        end
      end
    end
  end
  return out
end

-- Extract keymaps from a Lua source string.
-- Returns a list of { mode, key, desc, line } for every `*.keymap.set(...)`
-- call that has a string key and a `desc`. A call with multiple modes yields
-- one entry per mode.
function M.extract_keymaps(src)
  local root = M.parse(src)
  local query = vim.treesitter.query.parse("lua", "(function_call) @call")
  local results = {}
  for _, node in query:iter_captures(root, src, 0, -1) do
    local name = node:field("name")[1]
    local fn = name and vim.treesitter.get_node_text(name, src) or ""
    if fn:match("keymap%.set$") then
      local args = node:field("arguments")[1]
      local arg_nodes = {}
      if args then
        for child in args:iter_children() do
          if child:named() then
            table.insert(arg_nodes, child)
          end
        end
      end
      local modes = collect_strings(arg_nodes[1], src)
      local key = M.string_value(arg_nodes[2], src)
      local desc = find_field_string(node, src, "desc")
      if key and desc and #modes > 0 then
        local line = node:range() + 1
        for _, mode in ipairs(modes) do
          table.insert(results, { mode = mode, key = key, desc = desc, line = line })
        end
      end
    end
  end
  return results
end

-- Extract the dependencies (owner/repo strings) declared in a plugin spec.
local function extract_dependencies(root, src)
  local query = vim.treesitter.query.parse("lua", "(field) @field")
  local deps = {}
  local seen = {}
  for _, node in query:iter_captures(root, src, 0, -1) do
    local name = node:field("name")[1]
    if name and vim.treesitter.get_node_text(name, src) == "dependencies" then
      for _, dep in ipairs(collect_strings(node:field("value")[1], src)) do
        if dep:match("^[%w%._%-]+/[%w%._%-]+$") and not seen[dep] then
          seen[dep] = true
          table.insert(deps, dep)
        end
      end
    end
  end
  table.sort(deps)
  return deps
end

-- Find the first `owner/repo` style string literal in a plugin spec.
function M.plugin_repo(root, src)
  local query = vim.treesitter.query.parse("lua", "(string) @s")
  for _, node in query:iter_captures(root, src, 0, -1) do
    local v = M.string_value(node, src)
    if v and v:match("^[%w%._%-]+/[%w%._%-]+$") then
      return v
    end
  end
  return nil
end

-- Title-case a plugin filename: "blink-cmp" -> "Blink Cmp".
local function title_case(name)
  return (name:gsub("%-", " "):gsub("(%w+)", function(w)
    return w:sub(1, 1):upper() .. w:sub(2)
  end))
end

-- Build a structured description of a plugin spec file.
function M.plugin_info(path)
  local src = M.read(path)
  if not src then
    return nil
  end
  local root = M.parse(src)
  local name = vim.fn.fnamemodify(path, ":t:r")
  return {
    title = title_case(name),
    repo = M.plugin_repo(root, src),
    dependencies = extract_dependencies(root, src),
    configured = src:find("setup(", 1, true) ~= nil,
    has_keymaps = src:find("keymap.set", 1, true) ~= nil,
  }
end

-- Categorize a plugin file by its filename, mirroring update-readme buckets.
function M.category(name)
  local rules = {
    { "🔧 Language & LSP", { "lsp", "mason", "language" } },
    { "📝 Git Integration", { "git", "fugitive" } },
    { "🔍 Navigation & Search", { "telescope", "search", "tree" } },
    { "🐛 Testing & Debugging", { "test", "debug", "dap" } },
    { "🎨 UI & Themes", { "ui", "theme", "color", "catppuccin", "bufferline", "lualine" } },
    { "🌳 Syntax & Parsing", { "treesitter", "syntax" } },
    { "💡 Completion", { "completion", "cmp", "snippet" } },
    { "✏️ Editing", { "editor", "autopair", "surround", "comment" } },
    { "📋 Productivity", { "productivity", "todo", "bookmark" } },
    { "💻 Terminal", { "terminal", "tmux" } },
  }
  for _, rule in ipairs(rules) do
    for _, kw in ipairs(rule[2]) do
      if name:find(kw, 1, true) then
        return rule[1]
      end
    end
  end
  return "🔌 Other Plugins"
end

-- Ordered list of categories for stable output.
M.category_order = {
  "🔧 Language & LSP",
  "🎨 UI & Themes",
  "🔍 Navigation & Search",
  "💡 Completion",
  "✏️ Editing",
  "📝 Git Integration",
  "🐛 Testing & Debugging",
  "📋 Productivity",
  "🌳 Syntax & Parsing",
  "💻 Terminal",
  "🔌 Other Plugins",
}

-- Write content to a file, creating parent dirs as needed.
function M.write(path, content)
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  local fd = assert(io.open(path, "w"))
  fd:write(content)
  fd:close()
end

return M
