--- Insert-mode overlay listing the fields a Go struct literal can still set.
---
--- While the cursor is inside `T{...}` (also `&T{...}` and elided `[]T{{...}}`),
--- a float at the window's right edge lists the fields not set yet, with their
--- types and the first sentence of their doc comments. The list comes from
--- gopls' completions at the literal's `{`, so it works on unsaved code,
--- embedded fields, imported and generic types; fields drop off as you set
--- them. Shown only while inlay hints are on (<leader>th).
---
--- Enabled per buffer from LspAttach when gopls attaches (plugins/lspconfig.lua).
local M = {}

local FIELD = vim.lsp.protocol.CompletionItemKind.Field
local MAX_HEIGHT = 12
local MAX_DOC = 50 -- characters of doc comment per field
local MAX_TYPE_ALIGN = 24 -- longer types (func signatures) are not padded
local ns = vim.api.nvim_create_namespace("gostructfields")
local timer = assert(vim.uv.new_timer())
local state = { win = nil, buf = nil, key = nil, seq = 0 }

local function close()
  state.key = nil
  state.seq = state.seq + 1 -- drop in-flight responses
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil
end

--- First sentence of a field's doc comment, without the leading field name
--- Go docs start with ("Addr optionally specifies ..." -> "optionally ...").
---@param doc? string|lsp.MarkupContent
---@param name string
---@return string
local function summary(doc, name)
  local text = type(doc) == "table" and doc.value or doc or ""
  text = vim.split(vim.trim(text), "\n")[1]
  text = text:match("^(.-%.)%s") or text
  if vim.startswith(text, name .. " ") then
    text = text:sub(#name + 2)
  end
  return vim.fn.strcharlen(text) > MAX_DOC and vim.fn.strcharpart(text, 0, MAX_DOC - 1) .. "…" or text
end

---@param title string
---@param fields string[][] { name, type, doc } triples
local function show(title, fields)
  if #fields == 0 then
    return close()
  end
  -- gopls ranks by relevance; sort for a stable list (exported fields first).
  table.sort(fields, function(a, b)
    return a[1] < b[1]
  end)

  -- Columns: name, type (aligned up to MAX_TYPE_ALIGN), `// doc`. The float
  -- takes at most 60% of the window; docs are shortened to fit, then dropped.
  local win = vim.api.nvim_get_current_win()
  local maxw = math.floor(vim.api.nvim_win_get_width(win) * 0.6)
  local namew, typew = 0, 0
  for _, f in ipairs(fields) do
    namew = math.max(namew, #f[1])
    typew = math.max(typew, math.min(#f[2], MAX_TYPE_ALIGN))
  end
  local shown = #fields > MAX_HEIGHT and MAX_HEIGHT - 1 or #fields
  local lines, docs = {}, {}
  for i = 1, shown do
    local name, typ, doc = unpack(fields[i])
    local line = (" %-" .. namew .. "s  %-" .. typew .. "s"):format(name, typ)
    local room = maxw - vim.fn.strdisplaywidth(line) - 6 -- "  // " and a trailing space
    if vim.fn.strcharlen(doc) > room then
      doc = room >= 10 and vim.fn.strcharpart(doc, 0, room - 1) .. "…" or ""
    end
    docs[i] = doc ~= "" and #line + 2 or nil -- byte column of `//`
    lines[i] = (doc ~= "" and line .. "  // " .. doc or line:gsub("%s+$", "")) .. " "
  end
  if shown < #fields then
    table.insert(lines, (" … %d more "):format(#fields - shown))
  end

  if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
    state.buf = vim.api.nvim_create_buf(false, true)
  end
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.api.nvim_buf_clear_namespace(state.buf, ns, 0, -1)
  for i = 1, shown do
    local type_start = 1 + namew + 2
    vim.hl.range(state.buf, ns, "@variable.member", { i - 1, 1 }, { i - 1, 1 + #fields[i][1] })
    vim.hl.range(state.buf, ns, "@type", { i - 1, type_start }, { i - 1, type_start + #fields[i][2] })
    if docs[i] then
      vim.hl.range(state.buf, ns, "Comment", { i - 1, docs[i] }, { i - 1, #lines[i] })
    end
  end
  if shown < #fields then
    vim.hl.range(state.buf, ns, "Comment", { shown, 0 }, { shown, #lines[#lines] })
  end

  -- Right edge of the window, below the cursor line (above if no room), so it
  -- stays clear of the completion menu and signature help at the cursor.
  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end
  width = math.min(width, maxw)
  local height = #lines
  local below = vim.fn.winline() + height + 2 <= vim.api.nvim_win_get_height(win)
  local config = {
    relative = "win",
    win = win,
    anchor = below and "NE" or "SE",
    row = below and vim.fn.winline() or vim.fn.winline() - 1,
    col = vim.api.nvim_win_get_width(win),
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = " " .. title .. " ",
    title_pos = "center",
    focusable = false,
    zindex = 45,
  }
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_set_config(state.win, config)
  else
    config.noautocmd = true
    state.win = vim.api.nvim_open_win(state.buf, false, config)
  end
end

---@param buf integer
local function update(buf)
  if
    buf ~= vim.api.nvim_get_current_buf()
    or vim.fn.mode() ~= "i"
    or not vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
  then
    return close()
  end
  local client = vim.lsp.get_clients({ bufnr = buf, name = "gopls" })[1]
  local ok, parser = pcall(vim.treesitter.get_parser, buf, "go")
  if not (client and ok and parser) then
    return close()
  end
  parser:parse()

  -- Innermost `{...}` around the cursor.
  local lit = vim.treesitter.get_node({ bufnr = buf, ignore_injections = true })
  while lit and lit:type() ~= "literal_value" do
    lit = lit:parent()
  end
  if not lit then
    return close()
  end

  local row, col = lit:start()
  local key = ("%d:%d:%d"):format(row, col, vim.b[buf].changedtick)
  if key == state.key then
    return
  end
  state.key = key
  state.seq = state.seq + 1
  local seq = state.seq

  local parent = lit:parent()
  local type_node = parent and parent:type() == "composite_literal" and parent:field("type")[1]
  local title = type_node and vim.treesitter.get_node_text(type_node, buf) or "fields"

  local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, true)[1]
  local params = {
    textDocument = { uri = vim.uri_from_bufnr(buf) },
    position = { line = row, character = vim.str_utfindex(line, client.offset_encoding, col + 1, false) },
    context = { triggerKind = vim.lsp.protocol.CompletionTriggerKind.Invoked },
  }
  client:request("textDocument/completion", params, function(err, result)
    vim.schedule(function()
      if seq ~= state.seq or err or not result or vim.fn.mode() ~= "i" then
        return
      end
      local fields, seen = {}, {}
      for _, item in ipairs(result.items or result) do
        -- Skip deep completions like `u.Name` (fields of in-scope variables).
        if item.kind == FIELD and not item.label:find(".", 1, true) and not seen[item.label] then
          seen[item.label] = true
          table.insert(fields, { item.label, item.detail or "", summary(item.documentation, item.label) })
        end
      end
      show(title, fields)
    end)
  end, buf)
end

--- Enable the overlay for a Go buffer.
---@param buf integer
function M.attach(buf)
  local group = vim.api.nvim_create_augroup("gostructfields_" .. buf, { clear = true })
  vim.api.nvim_create_autocmd({ "InsertEnter", "CursorMovedI", "TextChangedI" }, {
    group = group,
    buffer = buf,
    callback = function()
      timer:start(
        80,
        0,
        vim.schedule_wrap(function()
          update(buf)
        end)
      )
    end,
  })
  vim.api.nvim_create_autocmd({ "InsertLeave", "BufLeave" }, {
    group = group,
    buffer = buf,
    callback = function()
      timer:stop()
      close()
    end,
  })
end

return M
