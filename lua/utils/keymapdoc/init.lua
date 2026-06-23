local M = {}

--- Refresh the keymap docs comment for a buffer.
---@param buf integer|nil buffer handle (0 or nil = current buffer)
function M.run(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local entries = require("utils.keymapdoc.extract").extract(buf)
  require("utils.keymapdoc.render").inject(buf, entries)
end

--- Register the :Keymapdoc user command. Call once from main init.
function M.setup()
  vim.api.nvim_create_user_command("Keymapdoc", function()
    M.run(0)
  end, { desc = "Refresh keymap doc comment for current file." })
end

return M
