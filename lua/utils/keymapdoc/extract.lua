local M = {}

--- Matches all function calls; filter by name in Lua.
---@type vim.treesitter.Query
local QUERY = vim.treesitter.query.parse(
  "lua",
  [[
    (function_call
      name: (_) @fn
      arguments: (arguments) @args)
  ]]
)

--- Strip surrounding quotes from a string-literal node's text.
---@param node TSNode|nil Treesitter node or nil.
---@param buf integer|string Nvim buf index or nil; nil or 0 is current buf.
---@return string Full extract node string with filtering.
local function node_str(node, buf)
  if not node then
    return ""
  end
  local text = vim.treesitter.get_node_text(node, buf)
  return (text:gsub("^['\"]", ""):gsub("['\"]$", ""))
end

--- Read a mode arg: example like "n", or a table like {"n", "v"} -> "n, v".
---@param node TSNode|nil Treesitter node or nil.
---@param buf integer|string Nvim buf index or nil; nil or 0 is current buf.
---@return string Output from node_str
---@see node_str
local function read_mode(node, buf)
  if not node then
    return ""
  end

  if node:type() == "table_constructor" then
    local modes = {}
    for child in node:iter_children() do
      if child:type() == "field" then
        table.insert(modes, node_str(child:field("value")[1], buf))
      end
    end
    return table.concat(modes, ",")
  end
  return node_str(node, buf)
end

--- Scan an opts table_constructor for a `desc = "..."` field.
---@param opts_node TSNode|nil Treesitter node or nil
---@param buf integer|string Nvim buf index or nil; nil or 0 is current buf.
---@return string Description text if found, otherwise empty string.
---@see node_str
local function find_desc(opts_node, buf)
  if not opts_node or opts_node:type() ~= "table_constructor" then
    return ""
  end
  for child in opts_node:iter_children() do
    if child:type() == "field" then
      local name = child:field("name")[1]
      if name and vim.treesitter.get_node_text(name, buf) == "desc" then
        return node_str(child:field("value")[1], buf)
      end
    end
  end
  return ""
end

--- Pull one capture node out of an iter_matches result, handling both the older API (id -> node)
--- and the newer API (id -> { node, ... }).
---@param match table Match result from iter_matches.
---@param want_name string Name of the capture to extract.
---@return TSNode|nil Extracted node if found, otherwise nil.
local function capture_node(match, want_name)
  for id, nodes in pairs(match) do
    if QUERY.captures[id] == want_name then
      return type(nodes) == "table" and nodes[1] or nodes
    end
  end
  return nil
end

--- Extract keymap entries from buffer.
---@param buf integer|string Nvim buf index or nil; nil or 0 is current buf.
---@return KeymapEntry[] List of extracted keymap entries.
function M.extract(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf

  local ok, parser = pcall(vim.treesitter.get_parser, buf, "lua")
  if not ok or not parser then
    return {}
  end

  local root = parser:parse()[1]:root()

  local entries = {}
  for _, match in QUERY:iter_matches(root, buf, 0, -1) do
    local fn_node = capture_node(match, "fn")
    local args_node = capture_node(match, "args")

    if fn_node and args_node then
      local fn_text = vim.treesitter.get_node_text(fn_node, buf)
      if fn_text:match("keymap%.set$") or fn_text:match("nvim_set_keymap$") then
        local n = args_node:named_child_count()
        local mode_node = args_node:named_child(0)
        local lhs_node = args_node:named_child(1)
        local last = n > 0 and args_node:named_child(n - 1) or nil
        local opts_node = (last and last:type() == "table_constructor") and last or nil

        table.insert(entries, {
          mode = read_mode(mode_node, buf),
          lhs = node_str(lhs_node, buf),
          desc = find_desc(opts_node, buf),
        })
      end
    end
  end
  return entries
end

return M
